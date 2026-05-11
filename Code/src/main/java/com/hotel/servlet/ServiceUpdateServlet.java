package com.hotel.servlet;

import com.hotel.dao.*;
import com.hotel.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/staff/serviceUpdate")
public class ServiceUpdateServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final BookedRoomDAO bookedRoomDAO = new BookedRoomDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final UsedServiceDAO usedServiceDAO = new UsedServiceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "search";

        switch (action) {
            case "search": {
                String q = req.getParameter("q");
                if (q == null) q = "";
                req.setAttribute("results", bookingDAO.searchForService(q));
                req.setAttribute("keyword", q);
                req.getRequestDispatcher("/WEB-INF/views/staff/search_booking_service.jsp").forward(req, resp);
                break;
            }
            case "load": {
                String bidStr = req.getParameter("bookingId");
                String brid = req.getParameter("bookedRoomId");
                if (bidStr == null || bidStr.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/staff/serviceUpdate?action=search");
                    return;
                }
                int bookingId = Integer.parseInt(bidStr);
                Booking booking = bookingDAO.findById(bookingId);
                req.setAttribute("booking", booking);

                // Nếu có bookedRoomId → hiển thị dịch vụ theo phòng cụ thể
                if (brid != null && !brid.isEmpty()) {
                    int bookedRoomId = Integer.parseInt(brid);
                    BookedRoom br = bookedRoomDAO.findById(bookedRoomId);
                    req.setAttribute("bookedRoom", br);
                    List<UsedService> services = usedServiceDAO.listByBookedRoom(bookedRoomId);
                    req.setAttribute("usedServices", services);
                    req.setAttribute("serviceTotal", usedServiceDAO.getTotalByBookedRoom(bookedRoomId));
                    req.setAttribute("bookedRoomId", bookedRoomId);
                } else {
                    // Không có phòng cụ thể → hiển thị tất cả DV của booking
                    req.setAttribute("usedServices", usedServiceDAO.listByBooking(bookingId));
                    req.setAttribute("serviceTotal", usedServiceDAO.getTotalByBooking(bookingId));
                }

                String kw = req.getParameter("keyword");
                if (kw != null && !kw.trim().isEmpty()) {
                    req.setAttribute("searchServices", serviceDAO.searchByName(kw));
                    req.setAttribute("keyword", kw);
                }
                req.getRequestDispatcher("/WEB-INF/views/staff/update_service.jsp").forward(req, resp);
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/serviceUpdate?action=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("addService".equals(req.getParameter("action"))) {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            String brid = req.getParameter("bookedRoomId");
            int serviceId = Integer.parseInt(req.getParameter("serviceId"));
            BigDecimal qty = new BigDecimal(req.getParameter("quantity"));
            Service svc = serviceDAO.findById(serviceId);

            UsedService us = new UsedService();
            us.setBookingId(bookingId);
            us.setServiceId(serviceId);
            us.setQuantity(qty);
            us.setUnitPrice(svc.getPrice());

            // Gắn bookedRoomId nếu có
            if (brid != null && !brid.isEmpty()) {
                us.setBookedRoomId(Integer.parseInt(brid));
            }
            usedServiceDAO.insert(us);

            String redirectUrl = req.getContextPath() + "/staff/serviceUpdate?action=load&bookingId=" + bookingId + "&msg=service_added";
            if (brid != null && !brid.isEmpty()) redirectUrl += "&bookedRoomId=" + brid;
            resp.sendRedirect(redirectUrl);
        }
    }
}
