package com.hotel.servlet;

import com.hotel.dao.BookingDAO;
import com.hotel.dao.BookedRoomDAO;
import com.hotel.model.Booking;
import com.hotel.model.BookedRoom;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/cancel")
public class CancelServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final BookedRoomDAO bookedRoomDAO = new BookedRoomDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "search";
        switch (action) {
            case "search":
                String q = req.getParameter("q");
                if (q == null) q = "";
                // Sử dụng searchForCancel để lấy phiếu và danh sách phòng có thể hủy
                List<Booking> results = bookingDAO.searchForCancel(q);
                req.setAttribute("results", results);
                req.setAttribute("keyword", q);
                req.getRequestDispatcher("/WEB-INF/views/staff/search_booking_cancel.jsp").forward(req, resp);
                break;

            case "confirmBooking":
                String bIdStr = req.getParameter("bookingId");
                if (bIdStr == null || bIdStr.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/staff/cancel?action=search");
                    return;
                }
                int bId = Integer.parseInt(bIdStr);
                Booking b = bookingDAO.findById(bId);
                req.setAttribute("booking", b);
                req.getRequestDispatcher("/WEB-INF/views/staff/confirm_cancel_booking.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/cancel?action=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        if ("execute".equals(action)) {
            int bookedRoomId = Integer.parseInt(req.getParameter("bookedRoomId"));
            bookedRoomDAO.cancelRoom(bookedRoomId);
            resp.sendRedirect(req.getContextPath() + "/staff/cancel?action=search&msg=cancel_success");
        } else if ("executeBooking".equals(action)) {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            bookingDAO.cancel(bookingId);
            resp.sendRedirect(req.getContextPath() + "/staff/cancel?action=search&msg=cancel_booking_success");
        }
    }
}
