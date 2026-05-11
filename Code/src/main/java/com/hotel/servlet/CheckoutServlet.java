package com.hotel.servlet;

import com.hotel.dao.*;
import com.hotel.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Check-out và tạo hóa đơn cho từng phòng riêng lẻ trong một booking.
 */
@WebServlet("/staff/checkout")
public class CheckoutServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final BookedRoomDAO bookedRoomDAO = new BookedRoomDAO();
    private final UsedServiceDAO usedServiceDAO = new UsedServiceDAO();
    private final InvoiceDAO invoiceDAO = new InvoiceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "search";

        switch (action) {
            case "search": {
                String q = req.getParameter("q");
                if (q == null) q = "";
                // Trả về List<Booking>, mỗi Booking đã gắn sẵn rooms đang check-in
                req.setAttribute("results", bookingDAO.searchForCheckout(q));
                req.setAttribute("keyword", q);
                req.getRequestDispatcher("/WEB-INF/views/staff/search_checkout.jsp").forward(req, resp);
                break;
            }
            case "detail": {
                String brid = req.getParameter("bookedRoomId");
                if (brid == null || brid.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/staff/checkout?action=search");
                    return;
                }
                int bookedRoomId = Integer.parseInt(brid);
                BookedRoom br = bookedRoomDAO.findById(bookedRoomId);
                Booking booking = bookingDAO.findById(br.getBookingId());

                // Dịch vụ của phòng này
                List<UsedService> services = usedServiceDAO.listByBookedRoom(bookedRoomId);
                BigDecimal serviceTotal = services.stream()
                        .map(UsedService::getSubtotal)
                        .reduce(BigDecimal.ZERO, BigDecimal::add);

                // Tính tiền phòng
                long nights = ChronoUnit.DAYS.between(
                        br.getCheckIn().toLocalDateTime().toLocalDate(),
                        br.getCheckOut().toLocalDateTime().toLocalDate());
                BigDecimal roomTotal = br.getActualPrice().multiply(BigDecimal.valueOf(nights));

                req.setAttribute("booking", booking);
                req.setAttribute("bookedRoom", br);
                req.setAttribute("usedServices", services);
                req.setAttribute("serviceTotal", serviceTotal);
                req.setAttribute("roomTotal", roomTotal);
                req.setAttribute("nights", nights);
                req.setAttribute("grandTotal", roomTotal.add(serviceTotal));
                req.getRequestDispatcher("/WEB-INF/views/staff/checkout_detail.jsp").forward(req, resp);
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/checkout?action=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("execute".equals(req.getParameter("action"))) {
            int bookedRoomId = Integer.parseInt(req.getParameter("bookedRoomId"));
            User staff = (User) req.getSession().getAttribute("currentUser");

            BookedRoom br = bookedRoomDAO.findById(bookedRoomId);

            BigDecimal roomTotal = new BigDecimal(req.getParameter("roomTotal"));
            BigDecimal serviceTotal = new BigDecimal(req.getParameter("serviceTotal"));
            BigDecimal surcharge = BigDecimal.ZERO;
            String surchargeStr = req.getParameter("surcharge");
            if (surchargeStr != null && !surchargeStr.isEmpty()) surcharge = new BigDecimal(surchargeStr);
            BigDecimal totalAmount = roomTotal.add(serviceTotal).add(surcharge);

            // 1. Cập nhật trạng thái phòng (checkout từng phòng)
            bookedRoomDAO.checkoutRoom(bookedRoomId, Timestamp.valueOf(LocalDateTime.now()));

            // 2. Tạo hóa đơn cho phòng này
            Invoice inv = new Invoice();
            inv.setCode(invoiceDAO.generateCode());
            inv.setBookingId(br.getBookingId());
            inv.setBookedRoomId(bookedRoomId);
            inv.setStaffId(staff.getId());
            inv.setRoomTotal(roomTotal);
            inv.setServiceTotal(serviceTotal);
            inv.setSurcharge(surcharge);
            inv.setTotalAmount(totalAmount);
            inv.setPaidAmount(totalAmount);
            inv.setPaymentMethod(req.getParameter("paymentMethod"));
            inv.setNote(req.getParameter("note"));

            invoiceDAO.createRoomInvoice(inv);

            resp.sendRedirect(req.getContextPath() + "/staff/home?msg=checkout_success&code=" + inv.getCode());
        }
    }
}
