package com.hotel.servlet;

import com.hotel.dao.*;
import com.hotel.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/onlineBooking")
public class OnlineBookingServlet extends HttpServlet {
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @SuppressWarnings("unchecked")
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "searchRoom";
        HttpSession session = req.getSession();

        switch (action) {
            // ── Bước 1: Tìm phòng trống & quản lý giỏ ──────────────────────────
            case "searchRoom": {
                // Xóa giỏ cũ khi bắt đầu phiên đặt phòng mới
                String reset = req.getParameter("reset");
                if ("true".equals(reset)) {
                    session.removeAttribute("onlineBookCart");
                }

                req.setAttribute("roomTypes", roomTypeDAO.getAll());

                String ci = req.getParameter("checkIn");
                String co = req.getParameter("checkOut");
                String rtId = req.getParameter("roomTypeId");
                if (rtId != null && !rtId.isEmpty()) {
                    req.setAttribute("selectedType", rtId);
                }
                if (ci != null && co != null && rtId != null && !rtId.isEmpty()) {
                    try {
                        LocalDate ciDate = LocalDate.parse(ci);
                        LocalDate coDate = LocalDate.parse(co);
                        if (ciDate.isBefore(LocalDate.now())) {
                            req.setAttribute("error", "Không thể chọn ngày trong quá khứ.");
                        } else if (!coDate.isAfter(ciDate)) {
                            req.setAttribute("error", "Ngày trả phòng phải sau ngày nhận phòng.");
                        } else {
                            // Lọc ra những phòng đã có trong giỏ để không hiện lại
                            List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("onlineBookCart");
                            int rtIdInt = Integer.parseInt(rtId);
                            List<Room> freeRooms = roomDAO.searchFreeRooms(ci, co, rtIdInt);
                            if (cart != null) {
                                freeRooms.removeIf(r -> cart.stream().anyMatch(item -> item.getRoomId() == r.getId()));
                            }
                            req.setAttribute("rooms", freeRooms);
                            req.setAttribute("checkIn", ci);
                            req.setAttribute("checkOut", co);
                            req.setAttribute("selectedType", rtId);
                            // Truyền thông tin loại phòng đang chọn & số đêm
                            RoomType selectedRT = roomTypeDAO.findById(rtIdInt);
                            req.setAttribute("selectedRoomType", selectedRT);
                            long nights = ChronoUnit.DAYS.between(ciDate, coDate);
                            req.setAttribute("nights", nights);
                        }
                    } catch (Exception e) {
                        req.setAttribute("error", "Định dạng ngày không hợp lệ.");
                    }
                }

                List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("onlineBookCart");
                req.setAttribute("cart", cart != null ? cart : new ArrayList<>());
                req.getRequestDispatcher("/WEB-INF/views/customer/online_search_room.jsp").forward(req, resp);
                break;
            }

            // ── Bước 2: Xem giỏ & xác nhận ────────────────────────────────────
            case "confirm": {
                List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("onlineBookCart");
                if (cart == null || cart.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/onlineBooking?action=searchRoom");
                    return;
                }
                Customer customer = (Customer) session.getAttribute("currentCustomer");
                req.setAttribute("customer", customer);
                req.setAttribute("cart", cart);
                BigDecimal total = cart.stream().map(BookingCartItem::getSubtotal)
                        .reduce(BigDecimal.ZERO, BigDecimal::add);
                req.setAttribute("totalEstimate", total);
                req.getRequestDispatcher("/WEB-INF/views/customer/confirm_online_booking.jsp").forward(req, resp);
                break;
            }

            // ── Xóa một phòng khỏi giỏ ────────────────────────────────────────
            case "removeRoom": {
                String roomIdStr = req.getParameter("roomId");
                if (roomIdStr != null && !roomIdStr.isEmpty()) {
                    int roomId = Integer.parseInt(roomIdStr);
                    List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("onlineBookCart");
                    if (cart != null) cart.removeIf(item -> item.getRoomId() == roomId);
                }
                resp.sendRedirect(req.getContextPath() + "/onlineBooking?action=searchRoom");
                break;
            }

            default:
                resp.sendRedirect(req.getContextPath() + "/onlineBooking?action=searchRoom&reset=true");
        }
    }

    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");

        // ── Thêm phòng vào giỏ ──────────────────────────────────────────────
        if ("addToCart".equals(action)) {
            int roomId = Integer.parseInt(req.getParameter("roomId"));
            String checkIn = req.getParameter("checkIn");
            String checkOut = req.getParameter("checkOut");

            try {
                LocalDate ciDate = LocalDate.parse(checkIn);
                LocalDate coDate = LocalDate.parse(checkOut);

                if (ciDate.isBefore(LocalDate.now())) {
                    resp.sendRedirect(req.getContextPath() + "/onlineBooking?action=searchRoom"
                            + "&error=past_date&checkIn=" + checkIn + "&checkOut=" + checkOut
                            + "&roomTypeId=" + req.getParameter("roomTypeId"));
                    return;
                }
                if (!coDate.isAfter(ciDate)) {
                    resp.sendRedirect(req.getContextPath() + "/onlineBooking?action=searchRoom"
                            + "&error=invalid_dates&checkIn=" + checkIn + "&checkOut=" + checkOut
                            + "&roomTypeId=" + req.getParameter("roomTypeId"));
                    return;
                }

                Room room = roomDAO.findById(roomId);
                RoomType rt = roomTypeDAO.findById(room.getRoomTypeId());
                long nights = ChronoUnit.DAYS.between(ciDate, coDate);

                List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("onlineBookCart");
                if (cart == null) cart = new ArrayList<>();

                // Không thêm trùng
                final int fRoomId = roomId;
                if (cart.stream().noneMatch(i -> i.getRoomId() == fRoomId)) {
                    cart.add(new BookingCartItem(roomId, room.getRoomNumber(), rt.getName(),
                            checkIn, checkOut, nights, rt.getBasePrice()));
                }
                session.setAttribute("onlineBookCart", cart);
                resp.sendRedirect(req.getContextPath() + "/onlineBooking?action=searchRoom"
                        + "&checkIn=" + checkIn + "&checkOut=" + checkOut + "&roomTypeId=" + room.getRoomTypeId());
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/onlineBooking?action=searchRoom&error=invalid_format");
            }

        // ── Đặt phòng (tạo booking) ─────────────────────────────────────────
        } else if ("insert".equals(action)) {
            List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("onlineBookCart");

            if (cart == null || cart.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/onlineBooking?action=searchRoom");
                return;
            }

            Booking b = new Booking();
            b.setCode(bookingDAO.generateCode());
            b.setCustomerId(customer.getId());
            b.setStaffId(null);  // Khách đặt online, không có nhân viên
            b.setStatus("Chưa nhận phòng");
            b.setNote(req.getParameter("note"));

            List<BookedRoom> bookedRooms = new ArrayList<>();
            for (BookingCartItem item : cart) {
                LocalDate ciDate = LocalDate.parse(item.getCheckIn());
                LocalDate coDate = LocalDate.parse(item.getCheckOut());

                // Đảm bảo checkOut phải sau checkIn (an toàn kép)
                if (!coDate.isAfter(ciDate)) {
                    resp.sendRedirect(req.getContextPath() + "/onlineBooking?action=confirm&error=invalid_dates");
                    return;
                }

                BookedRoom br = new BookedRoom();
                br.setRoomId(item.getRoomId());
                // check_in: 14:00 ngày nhận phòng; check_out: 12:00 ngày trả phòng
                br.setCheckIn(java.sql.Timestamp.valueOf(item.getCheckIn() + " 14:00:00"));
                br.setCheckOut(java.sql.Timestamp.valueOf(item.getCheckOut() + " 12:00:00"));
                br.setActualPrice(item.getPricePerNight());
                bookedRooms.add(br);
            }

            int bookingId = bookingDAO.insertMultiple(b, bookedRooms);

            // Dọn session
            session.removeAttribute("onlineBookCart");

            Booking created = bookingDAO.findById(bookingId);
            resp.sendRedirect(req.getContextPath() + "/bookingHistory?msg=booking_success&code="
                    + (created != null ? created.getCode() : ""));
        }
    }
}
