package com.hotel.servlet;

import com.hotel.dao.*;
import com.hotel.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Check-in từng phòng riêng lẻ trong một booking nhiều phòng.
 */
@WebServlet("/staff/checkin")
public class CheckinServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final BookedRoomDAO bookedRoomDAO = new BookedRoomDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "search";

        switch (action) {
            case "search": {
                String q = req.getParameter("q");
                if (q == null) q = "";
                // Trả về List<Booking>, mỗi Booking đã gắn sẵn rooms chờ check-in
                req.setAttribute("results", bookingDAO.searchForCheckin(q));
                req.setAttribute("keyword", q);
                req.getRequestDispatcher("/WEB-INF/views/staff/search_checkin.jsp").forward(req, resp);
                break;
            }
            case "confirm": {
                String brid = req.getParameter("bookedRoomId");
                if (brid == null || brid.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/staff/checkin?action=search");
                    return;
                }
                BookedRoom br = bookedRoomDAO.findById(Integer.parseInt(brid));
                Booking booking = bookingDAO.findById(br.getBookingId());
                req.setAttribute("bookedRoom", br);
                req.setAttribute("booking", booking);
                req.getRequestDispatcher("/WEB-INF/views/staff/confirm_checkin.jsp").forward(req, resp);
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/checkin?action=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("execute".equals(req.getParameter("action"))) {
            String brid = req.getParameter("bookedRoomId");
            if (brid != null && !brid.isEmpty()) {
                bookedRoomDAO.checkinRoom(Integer.parseInt(brid), Timestamp.valueOf(LocalDateTime.now()));
            }
            resp.sendRedirect(req.getContextPath() + "/staff/checkin?action=search&msg=checkin_success");
        }
    }

    /** Bổ sung thông tin booking, customer vào mỗi BookedRoom để hiển thị */
    private List<BookedRoom> enrichWithBookingInfo(List<BookedRoom> rooms) {
        // BookedRoom đã có roomNumber, roomTypeName từ JOIN trong DAO
        // Thông tin booking/customer sẽ được load trong JSP qua bookingId
        return rooms;
    }
}
