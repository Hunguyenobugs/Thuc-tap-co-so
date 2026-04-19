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
            case "search":
                String q = req.getParameter("q");
                if (q != null && !q.trim().isEmpty()) {
                    req.setAttribute("results", bookingDAO.searchForCheckout(q));
                    req.setAttribute("keyword", q);
                }
                req.getRequestDispatcher("/WEB-INF/views/staff/search_checkout.jsp").forward(req, resp);
                break;
            case "detail":
                int bid = Integer.parseInt(req.getParameter("bookingId"));
                Booking b = bookingDAO.findById(bid);
                List<BookedRoom> rooms = bookedRoomDAO.findByBookingId(bid);
                List<UsedService> services = usedServiceDAO.listByBooking(bid);
                BigDecimal serviceTotal = usedServiceDAO.getTotalByBooking(bid);
                BookedRoom br = rooms.isEmpty() ? null : rooms.get(0);
                long nights = 0;
                BigDecimal roomTotal = BigDecimal.ZERO;
                if (br != null) {
                    nights = ChronoUnit.DAYS.between(br.getCheckIn().toLocalDate(), br.getCheckOut().toLocalDate());
                    roomTotal = br.getActualPrice().multiply(BigDecimal.valueOf(nights));
                }
                req.setAttribute("booking", b); req.setAttribute("bookedRoom", br);
                req.setAttribute("usedServices", services); req.setAttribute("serviceTotal", serviceTotal);
                req.setAttribute("roomTotal", roomTotal); req.setAttribute("nights", nights);
                req.setAttribute("grandTotal", roomTotal.add(serviceTotal));
                req.getRequestDispatcher("/WEB-INF/views/staff/checkout_detail.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/checkout?action=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("execute".equals(req.getParameter("action"))) {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            User staff = (User) req.getSession().getAttribute("currentUser");

            BigDecimal roomTotal = new BigDecimal(req.getParameter("roomTotal"));
            BigDecimal serviceTotal = new BigDecimal(req.getParameter("serviceTotal"));
            BigDecimal surcharge = BigDecimal.ZERO;
            String surchargeStr = req.getParameter("surcharge");
            if (surchargeStr != null && !surchargeStr.isEmpty()) surcharge = new BigDecimal(surchargeStr);
            BigDecimal totalAmount = roomTotal.add(serviceTotal).add(surcharge);

            bookedRoomDAO.updateCheckout(bookingId, Timestamp.valueOf(LocalDateTime.now()));

            Invoice inv = new Invoice();
            inv.setCode(invoiceDAO.generateCode());
            inv.setBookingId(bookingId);
            inv.setStaffId(staff.getId());
            inv.setRoomTotal(roomTotal);
            inv.setServiceTotal(serviceTotal);
            inv.setSurcharge(surcharge);
            inv.setTotalAmount(totalAmount);
            inv.setPaidAmount(totalAmount);
            inv.setPaymentMethod(req.getParameter("paymentMethod"));
            inv.setNote(req.getParameter("note"));

            invoiceDAO.createCheckoutInvoice(inv, bookingId);
            resp.sendRedirect(req.getContextPath() + "/staff/home?msg=checkout_success&code=" + inv.getCode());
        }
    }
}
