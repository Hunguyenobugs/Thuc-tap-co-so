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
                if (q != null && !q.trim().isEmpty()) {
                    req.setAttribute("results", bookingDAO.searchByCodeOrCustomer(q));
                    req.setAttribute("keyword", q);
                }
                req.getRequestDispatcher("/WEB-INF/views/staff/search_booking.jsp").forward(req, resp);
                break;
            case "edit":
                int bid = Integer.parseInt(req.getParameter("bookingId"));
                Booking b = bookingDAO.findById(bid);
                req.setAttribute("booking", b);
                req.setAttribute("bookedRooms", bookedRoomDAO.findByBookingId(bid));
                if (b.getCheckIn() != null && b.getCheckOut() != null) {
                    int rtId = roomDAO.findById(bookedRoomDAO.findByBookingId(bid).get(0).getRoomId()).getRoomTypeId();
                    req.setAttribute("freeRooms", roomDAO.searchFreeRooms(b.getCheckIn(), b.getCheckOut(), rtId));
                }
                req.getRequestDispatcher("/WEB-INF/views/staff/edit_booking.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/manageBooking?action=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("update".equals(req.getParameter("action"))) {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            int newRoomId = Integer.parseInt(req.getParameter("roomId"));
            BigDecimal price = roomTypeDAO.findById(roomDAO.findById(newRoomId).getRoomTypeId()).getBasePrice();
            bookingDAO.updateBookedRoom(bookingId, newRoomId, price);
            resp.sendRedirect(req.getContextPath() + "/staff/home?msg=booking_updated");
        }
    }
}
