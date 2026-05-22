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
            case "confirm":
                String bridStr = req.getParameter("bookedRoomId");
                if (bridStr == null || bridStr.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/staff/cancel?action=search");
                    return;
                }
                int bookedRoomId = Integer.parseInt(bridStr);
                BookedRoom bookedRoom = bookedRoomDAO.findById(bookedRoomId);
                Booking booking = bookingDAO.findById(bookedRoom.getBookingId());
                
                req.setAttribute("bookedRoom", bookedRoom);
                req.setAttribute("booking", booking);
                req.getRequestDispatcher("/WEB-INF/views/staff/confirm_cancel.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/cancel?action=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("execute".equals(req.getParameter("action"))) {
            int bookedRoomId = Integer.parseInt(req.getParameter("bookedRoomId"));
            bookedRoomDAO.cancelRoom(bookedRoomId);
            resp.sendRedirect(req.getContextPath() + "/staff/cancel?action=search&msg=cancel_success");
        }
    }
}
