package com.hotel.servlet;

import com.hotel.dao.*;
import com.hotel.model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/staff/manageBooking")
public class ManageBookingServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final BookedRoomDAO bookedRoomDAO = new BookedRoomDAO();
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "search";
        switch (action) {
            case "search":
                String q = req.getParameter("q");
                if (q == null) q = "";
                req.setAttribute("results", bookingDAO.searchByCodeOrCustomer(q));
                req.setAttribute("keyword", q);
                req.getRequestDispatcher("/WEB-INF/views/staff/search_booking.jsp").forward(req, resp);
                break;
            case "view":
                String bidStr = req.getParameter("bookingId");
                if (bidStr == null || bidStr.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/staff/manageBooking?action=search");
                    return;
                }
                int bid = Integer.parseInt(bidStr);
                Booking b = bookingDAO.findById(bid);
                req.setAttribute("booking", b);
                req.setAttribute("bookedRooms", bookedRoomDAO.findByBookingId(bid));
                req.getRequestDispatcher("/WEB-INF/views/staff/view_booking.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/manageBooking?action=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("approve".equals(req.getParameter("action"))) {
            String bidStr = req.getParameter("bookingId");
            if (bidStr == null || bidStr.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/staff/manageBooking?action=search");
                return;
            }
            int bookingId = Integer.parseInt(bidStr);
            com.hotel.model.User staff = (com.hotel.model.User) req.getSession().getAttribute("currentUser");
            bookingDAO.approveBooking(bookingId, staff.getId());
            resp.sendRedirect(req.getContextPath() + "/staff/manageBooking?msg=booking_approved");
        }
    }
}
