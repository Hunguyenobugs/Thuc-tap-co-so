package com.hotel.servlet;

import com.hotel.dao.*;
import com.hotel.model.Invoice;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/manager/invoice")
public class InvoiceServlet extends HttpServlet {
    private final InvoiceDAO invoiceDAO = new InvoiceDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final UsedServiceDAO usedServiceDAO = new UsedServiceDAO();
    private final BookedRoomDAO bookedRoomDAO = new BookedRoomDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "list":
                String from = req.getParameter("from"), to = req.getParameter("to");
                String kw = req.getParameter("keyword");
                if (from != null && to != null && !from.isEmpty() && !to.isEmpty()) {
                    req.setAttribute("invoices", invoiceDAO.filter(from, to));
                    req.setAttribute("from", from); req.setAttribute("to", to);
                } else if (kw != null && !kw.isEmpty()) {
                    req.setAttribute("invoices", invoiceDAO.searchByCode(kw)); req.setAttribute("keyword", kw);
                } else {
                    req.setAttribute("invoices", invoiceDAO.getAll());
                }
                req.getRequestDispatcher("/WEB-INF/views/manager/invoice_list.jsp").forward(req, resp);
                break;
            case "detail":
                int id = Integer.parseInt(req.getParameter("id"));
                Invoice inv = invoiceDAO.findById(id);
                req.setAttribute("invoice", inv);
                req.setAttribute("usedServices", usedServiceDAO.listByBooking(inv.getBookingId()));
                req.setAttribute("bookedRooms", bookedRoomDAO.findByBookingId(inv.getBookingId()));
                req.getRequestDispatcher("/WEB-INF/views/manager/invoice_detail.jsp").forward(req, resp);
                break;
            case "add":
                req.getRequestDispatcher("/WEB-INF/views/manager/add_invoice.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/manager/invoice?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("insert".equals(action)) {
            String bookingCode = req.getParameter("bookingCode");
            var booking = bookingDAO.findByCode(bookingCode);
            if (booking == null) {
                req.setAttribute("error", "Không tìm thấy phiếu đặt phòng với mã này");
                req.getRequestDispatcher("/WEB-INF/views/manager/add_invoice.jsp").forward(req, resp); return;
            }
            var staff = (com.hotel.model.User) req.getSession().getAttribute("currentUser");
            Invoice inv = new Invoice();
            inv.setCode(invoiceDAO.generateCode()); inv.setBookingId(booking.getId()); inv.setStaffId(staff.getId());
            inv.setRoomTotal(new BigDecimal(req.getParameter("roomTotal")));
            inv.setServiceTotal(new BigDecimal(req.getParameter("serviceTotal")));
            inv.setSurcharge(BigDecimal.ZERO);
            inv.setTotalAmount(new BigDecimal(req.getParameter("totalAmount")));
            inv.setPaidAmount(new BigDecimal(req.getParameter("totalAmount")));
            inv.setPaymentMethod(req.getParameter("paymentMethod")); inv.setNote(req.getParameter("note"));
            invoiceDAO.insert(inv);
            resp.sendRedirect(req.getContextPath() + "/manager/invoice?action=list&msg=add_success");
        }
    }
}
