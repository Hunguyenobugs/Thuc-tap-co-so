package com.hotel.servlet;

import com.hotel.dao.*;
import com.hotel.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/staff/serviceUpdate")
public class ServiceUpdateServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final UsedServiceDAO usedServiceDAO = new UsedServiceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "search";
        switch (action) {
            case "search":
                String q = req.getParameter("q");
                if (q != null && !q.trim().isEmpty()) {
                    req.setAttribute("results", bookingDAO.searchForService(q));
                    req.setAttribute("keyword", q);
                }
                req.getRequestDispatcher("/WEB-INF/views/staff/search_booking_service.jsp").forward(req, resp);
                break;
            case "load":
                int bid = Integer.parseInt(req.getParameter("bookingId"));
                req.setAttribute("booking", bookingDAO.findById(bid));
                req.setAttribute("usedServices", usedServiceDAO.listByBooking(bid));
                req.setAttribute("serviceTotal", usedServiceDAO.getTotalByBooking(bid));
                String kw = req.getParameter("keyword");
                if (kw != null && !kw.trim().isEmpty()) {
                    req.setAttribute("searchServices", serviceDAO.searchByName(kw));
                    req.setAttribute("keyword", kw);
                }
                req.getRequestDispatcher("/WEB-INF/views/staff/update_service.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/serviceUpdate?action=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("addService".equals(req.getParameter("action"))) {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            int serviceId = Integer.parseInt(req.getParameter("serviceId"));
            BigDecimal qty = new BigDecimal(req.getParameter("quantity"));
            Service svc = serviceDAO.findById(serviceId);
            UsedService us = new UsedService();
            us.setBookingId(bookingId); us.setServiceId(serviceId);
            us.setQuantity(qty); us.setUnitPrice(svc.getPrice());
            usedServiceDAO.insert(us);
            resp.sendRedirect(req.getContextPath() + "/staff/serviceUpdate?action=load&bookingId=" + bookingId + "&msg=service_added");
        }
    }
}
