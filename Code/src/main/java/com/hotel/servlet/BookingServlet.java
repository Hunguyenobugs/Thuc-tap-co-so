package com.hotel.servlet;

import com.hotel.dao.*;
import com.hotel.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/staff/booking")
public class BookingServlet extends HttpServlet {
    private final RoomDAO roomDAO = new RoomDAO();
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @SuppressWarnings("unchecked")
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "searchCustomer";
        HttpSession session = req.getSession();

        switch (action) {
            // ── Bước 1: Tìm khách hàng ──────────────────────────────────────────
            case "searchCustomer": {
                // Xóa giỏ cũ khi bắt đầu phiên đặt phòng mới
                String reset = req.getParameter("reset");
                if ("true".equals(reset)) {
                    session.removeAttribute("bookCart");
                    session.removeAttribute("bookCustomerId");
                }
                String q = req.getParameter("q");
                if (q == null) q = "";
                req.setAttribute("customers", customerDAO.searchByKeyword(q));
                req.setAttribute("keyword", q);
                req.getRequestDispatcher("/WEB-INF/views/staff/search_customer.jsp").forward(req, resp);
                break;
            }

            // ── Bước 1b: Thêm khách hàng mới ───────────────────────────────────
            case "addCustomer":
                req.getRequestDispatcher("/WEB-INF/views/staff/add_customer.jsp").forward(req, resp);
                break;

            // ── Bước 2: Tìm phòng trống & quản lý giỏ ──────────────────────────
            case "searchRoom": {
                String customerIdStr = req.getParameter("customerId");
                Integer customerId = null;
                if (customerIdStr != null && !customerIdStr.isEmpty()) {
                    customerId = Integer.parseInt(customerIdStr);
                    session.setAttribute("bookCustomerId", customerId);
                } else {
                    customerId = (Integer) session.getAttribute("bookCustomerId");
                }
                if (customerId == null) {
                    resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchCustomer");
                    return;
                }

                req.setAttribute("customer", customerDAO.findById(customerId));
                req.setAttribute("roomTypes", roomTypeDAO.getAll());

                String ci = req.getParameter("checkIn");
                String co = req.getParameter("checkOut");
                String rtId = req.getParameter("roomTypeId");
                if (ci != null && co != null && rtId != null && !rtId.isEmpty()) {
                    try {
                        java.time.LocalDate ciDate = java.time.LocalDate.parse(ci);
                        java.time.LocalDate coDate = java.time.LocalDate.parse(co);
                        if (ciDate.isBefore(java.time.LocalDate.now())) {
                            req.setAttribute("error", "Không thể chọn ngày trong quá khứ.");
                        } else if (!coDate.isAfter(ciDate)) {
                            req.setAttribute("error", "Ngày trả phòng phải sau ngày nhận phòng.");
                        } else {
                            // Lọc ra những phòng đã có trong giỏ để không hiện lại
                            List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("bookCart");
                            List<Room> freeRooms = roomDAO.searchFreeRooms(ci, co, Integer.parseInt(rtId));
                            if (cart != null) {
                                freeRooms.removeIf(r -> cart.stream().anyMatch(item -> item.getRoomId() == r.getId()));
                            }
                            req.setAttribute("rooms", freeRooms);
                            req.setAttribute("checkIn", ci);
                            req.setAttribute("checkOut", co);
                            req.setAttribute("selectedType", rtId);
                        }
                    } catch (Exception e) {
                        req.setAttribute("error", "Định dạng ngày không hợp lệ.");
                    }
                }

                List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("bookCart");
                req.setAttribute("cart", cart != null ? cart : new ArrayList<>());
                req.getRequestDispatcher("/WEB-INF/views/staff/search_free_room.jsp").forward(req, resp);
                break;
            }

            // ── Bước 2b: Xem giỏ & xác nhận ────────────────────────────────────
            case "confirm": {
                Integer custId = (Integer) session.getAttribute("bookCustomerId");
                if (custId == null) {
                    resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchCustomer");
                    return;
                }
                List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("bookCart");
                if (cart == null || cart.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchRoom&customerId=" + custId);
                    return;
                }
                req.setAttribute("customer", customerDAO.findById(custId));
                req.setAttribute("cart", cart);
                BigDecimal total = cart.stream().map(BookingCartItem::getSubtotal)
                        .reduce(BigDecimal.ZERO, BigDecimal::add);
                req.setAttribute("totalEstimate", total);
                req.getRequestDispatcher("/WEB-INF/views/staff/confirm_booking.jsp").forward(req, resp);
                break;
            }

            // ── Bước 2c: Xóa một phòng khỏi giỏ ────────────────────────────────
            case "removeRoom": {
                String roomIdStr = req.getParameter("roomId");
                if (roomIdStr != null && !roomIdStr.isEmpty()) {
                    int roomId = Integer.parseInt(roomIdStr);
                    List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("bookCart");
                    if (cart != null) cart.removeIf(item -> item.getRoomId() == roomId);
                }
                resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchRoom");
                break;
            }

            default:
                resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchCustomer&reset=true");
        }
    }

    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        // ── Thêm khách hàng mới ──────────────────────────────────────────────
        if ("insertCustomer".equals(action)) {
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            String idCard = req.getParameter("idCard");

            // Validate trùng lặp
            if (phone != null && !phone.isEmpty() && customerDAO.existsByPhone(phone)) {
                resp.sendRedirect(req.getContextPath() + "/staff/booking?action=addCustomer&error=phone_exists"
                    + "&fullName=" + java.net.URLEncoder.encode(req.getParameter("fullName"), "UTF-8")
                    + "&idCard=" + java.net.URLEncoder.encode(idCard, "UTF-8")
                    + "&phone=" + java.net.URLEncoder.encode(phone, "UTF-8")
                    + "&email=" + java.net.URLEncoder.encode(email != null ? email : "", "UTF-8"));
                return;
            }
            if (email != null && !email.isEmpty() && customerDAO.existsByEmail(email)) {
                resp.sendRedirect(req.getContextPath() + "/staff/booking?action=addCustomer&error=email_exists"
                    + "&fullName=" + java.net.URLEncoder.encode(req.getParameter("fullName"), "UTF-8")
                    + "&idCard=" + java.net.URLEncoder.encode(idCard, "UTF-8")
                    + "&phone=" + java.net.URLEncoder.encode(phone != null ? phone : "", "UTF-8")
                    + "&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                return;
            }

            Customer c = new Customer();
            c.setFullName(req.getParameter("fullName"));
            c.setIdCard(idCard);
            c.setIdType("CCCD");
            c.setPhone(phone);
            c.setEmail(email);
            c.setAddress(req.getParameter("address"));
            String bd = req.getParameter("birthDate");
            if (bd != null && !bd.isEmpty()) c.setBirthDate(Date.valueOf(bd));
            c.setGender(req.getParameter("gender"));
            int newId = customerDAO.insert(c);
            if (newId > 0) {
                session.setAttribute("bookCustomerId", newId);
                resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchRoom&customerId=" + newId);
            } else {
                resp.sendRedirect(req.getContextPath() + "/staff/booking?action=addCustomer&error=insert_failed");
            }


        // ── Thêm phòng vào giỏ ──────────────────────────────────────────────
        } else if ("addToCart".equals(action)) {
            int roomId = Integer.parseInt(req.getParameter("roomId"));
            String checkIn = req.getParameter("checkIn");
            String checkOut = req.getParameter("checkOut");
            int customerId = Integer.parseInt(req.getParameter("customerId"));

            try {
                // Validate: checkOut phải sau checkIn ít nhất 1 ngày và không trong quá khứ
                java.time.LocalDate ciDate = java.time.LocalDate.parse(checkIn);
                java.time.LocalDate coDate = java.time.LocalDate.parse(checkOut);
                
                if (ciDate.isBefore(java.time.LocalDate.now())) {
                    resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchRoom&customerId=" + customerId
                            + "&error=past_date&checkIn=" + checkIn + "&checkOut=" + checkOut
                            + "&roomTypeId=" + req.getParameter("roomTypeId"));
                    return;
                }
                if (!coDate.isAfter(ciDate)) {
                    resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchRoom&customerId=" + customerId
                            + "&error=invalid_dates&checkIn=" + checkIn + "&checkOut=" + checkOut
                            + "&roomTypeId=" + req.getParameter("roomTypeId"));
                    return;
                }

                Room room = roomDAO.findById(roomId);
                RoomType rt = roomTypeDAO.findById(room.getRoomTypeId());
                long nights = java.time.temporal.ChronoUnit.DAYS.between(ciDate, coDate);

                List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("bookCart");
                if (cart == null) cart = new ArrayList<>();

                // Không thêm trùng
                final int fRoomId = roomId;
                if (cart.stream().noneMatch(i -> i.getRoomId() == fRoomId)) {
                    cart.add(new BookingCartItem(roomId, room.getRoomNumber(), rt.getName(),
                            checkIn, checkOut, nights, rt.getBasePrice()));
                }
                session.setAttribute("bookCart", cart);
                resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchRoom&customerId=" + customerId
                        + "&checkIn=" + checkIn + "&checkOut=" + checkOut + "&roomTypeId=" + room.getRoomTypeId());
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchRoom&customerId=" + customerId
                        + "&error=invalid_format");
            }

        // ── Đặt phòng (tạo booking) ─────────────────────────────────────────
        } else if ("insert".equals(action)) {
            User staff = (User) session.getAttribute("currentUser");
            Integer customerId = (Integer) session.getAttribute("bookCustomerId");
            List<BookingCartItem> cart = (List<BookingCartItem>) session.getAttribute("bookCart");

            if (customerId == null || cart == null || cart.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchCustomer");
                return;
            }

            Booking b = new Booking();
            b.setCode(bookingDAO.generateCode());
            b.setCustomerId(customerId);
            b.setStaffId(staff.getId());
            b.setStatus("Chưa nhận phòng");
            b.setNote(req.getParameter("note"));

            List<BookedRoom> bookedRooms = new ArrayList<>();
            for (BookingCartItem item : cart) {
                LocalDate ciDate = LocalDate.parse(item.getCheckIn());
                LocalDate coDate = LocalDate.parse(item.getCheckOut());

                // Đảm bảo checkOut phải sau checkIn (an toàn kép)
                if (!coDate.isAfter(ciDate)) {
                    resp.sendRedirect(req.getContextPath() + "/staff/booking?action=confirm&error=invalid_dates");
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
            session.removeAttribute("bookCart");
            session.removeAttribute("bookCustomerId");

            Booking created = bookingDAO.findById(bookingId);
            resp.sendRedirect(req.getContextPath() + "/staff/home?msg=booking_success&code="
                    + (created != null ? created.getCode() : ""));
        }
    }
}
