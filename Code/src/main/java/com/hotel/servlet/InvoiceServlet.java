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
    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "list":
                String from = req.getParameter("from"), to = req.getParameter("to");
                String kw = req.getParameter("keyword");
                java.util.List<Invoice> rawInvoices;
                if (from != null && to != null && !from.isEmpty() && !to.isEmpty()) {
                    rawInvoices = invoiceDAO.filter(from, to);
                    req.setAttribute("from", from); req.setAttribute("to", to);
                } else if (kw != null && !kw.isEmpty()) {
                    rawInvoices = invoiceDAO.searchByCode(kw); req.setAttribute("keyword", kw);
                } else {
                    rawInvoices = invoiceDAO.getAll();
                }

                java.util.Map<Integer, com.hotel.model.InvoiceGroup> groups = new java.util.LinkedHashMap<>();
                for (Invoice inv : rawInvoices) {
                    if (!groups.containsKey(inv.getBookingId())) {
                        groups.put(inv.getBookingId(), new com.hotel.model.InvoiceGroup(inv));
                    } else {
                        groups.get(inv.getBookingId()).addInvoice(inv);
                    }
                }

                for (com.hotel.model.InvoiceGroup ig : groups.values()) {
                    int count = 0;
                    for (com.hotel.model.BookedRoom br : bookedRoomDAO.findByBookingId(ig.getBookingId())) {
                        if (!"Đã check-out".equals(br.getRoomStatus()) && !"Đã hủy".equals(br.getRoomStatus())) {
                            count++;
                        }
                    }
                    ig.setNotCheckedOutCount(count);
                }

                req.setAttribute("invoiceGroups", groups.values());
                req.getRequestDispatcher("/WEB-INF/views/manager/invoice_list.jsp").forward(req, resp);
                break;
            case "detail":
                String bIdStr = req.getParameter("bookingId");
                String idStr = req.getParameter("id");
                
                if (idStr != null && !idStr.isEmpty()) {
                    int id = Integer.parseInt(idStr);
                    Invoice inv = invoiceDAO.findById(id);
                    req.setAttribute("invoice", inv);
                    
                    // Lấy thông tin khách hàng đầy đủ
                    com.hotel.model.Booking booking = bookingDAO.findById(inv.getBookingId());
                    if (booking != null) {
                        req.setAttribute("customer", customerDAO.findById(booking.getCustomerId()));
                    }
                    
                    if (inv.getBookedRoomId() != null) {
                        req.setAttribute("usedServices", usedServiceDAO.listByBookedRoom(inv.getBookedRoomId()));
                    } else {
                        req.setAttribute("usedServices", usedServiceDAO.listByBooking(inv.getBookingId()));
                    }
                    req.setAttribute("bookedRooms", bookedRoomDAO.findByBookingId(inv.getBookingId()));
                    req.getRequestDispatcher("/WEB-INF/views/manager/invoice_detail.jsp").forward(req, resp);
                } else if (bIdStr != null && !bIdStr.isEmpty()) {
                    int bookingId = Integer.parseInt(bIdStr);
                    java.util.List<Invoice> invs = invoiceDAO.findByBookingId(bookingId);
                    if (invs.isEmpty()) {
                        resp.sendRedirect(req.getContextPath() + "/manager/invoice?action=list");
                        return;
                    }
                    
                    Invoice merged = new Invoice();
                    merged.setCode("GỘP");
                    merged.setBookingId(bookingId);
                    merged.setBookingCode(invs.get(0).getBookingCode());
                    merged.setCustomerName(invs.get(0).getCustomerName());
                    merged.setStaffName(invs.get(0).getStaffName());
                    merged.setIssueDate(invs.get(invs.size() - 1).getIssueDate());
                    merged.setPaymentMethod(invs.get(invs.size() - 1).getPaymentMethod());
                    
                    java.math.BigDecimal rTotal = java.math.BigDecimal.ZERO;
                    java.math.BigDecimal sTotal = java.math.BigDecimal.ZERO;
                    java.math.BigDecimal surTotal = java.math.BigDecimal.ZERO;
                    java.math.BigDecimal tTotal = java.math.BigDecimal.ZERO;
                    java.math.BigDecimal pTotal = java.math.BigDecimal.ZERO;
                    
                    for (Invoice i : invs) {
                        if (i.getRoomTotal() != null) rTotal = rTotal.add(i.getRoomTotal());
                        if (i.getServiceTotal() != null) sTotal = sTotal.add(i.getServiceTotal());
                        if (i.getSurcharge() != null) surTotal = surTotal.add(i.getSurcharge());
                        if (i.getTotalAmount() != null) tTotal = tTotal.add(i.getTotalAmount());
                        if (i.getPaidAmount() != null) pTotal = pTotal.add(i.getPaidAmount());
                    }
                    merged.setRoomTotal(rTotal);
                    merged.setServiceTotal(sTotal);
                    merged.setSurcharge(surTotal);
                    merged.setTotalAmount(tTotal);
                    merged.setPaidAmount(pTotal);

                    // Lấy thông tin khách hàng cho hóa đơn gộp
                    com.hotel.model.Booking booking = bookingDAO.findById(bookingId);
                    if (booking != null) {
                        req.setAttribute("customer", customerDAO.findById(booking.getCustomerId()));
                    }
 
                    req.setAttribute("invoice", merged);
                    req.setAttribute("usedServices", usedServiceDAO.listByBooking(bookingId));
                    req.setAttribute("bookedRooms", bookedRoomDAO.findByBookingId(bookingId));
                    req.getRequestDispatcher("/WEB-INF/views/manager/invoice_detail.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/manager/invoice?action=list");
                }
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
