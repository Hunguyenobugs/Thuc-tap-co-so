package com.hotel.servlet;

import com.hotel.dao.BookingDAO;
import com.hotel.model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet("/staff/checkin")
public class CheckinServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "search";
        switch (action) {
            case "search":
                String q = req.getParameter("q");
                if (q != null && !q.trim().isEmpty()) {
                    req.setAttribute("results", bookingDAO.searchForCheckin(q));
                    req.setAttribute("keyword", q);
                }
                req.getRequestDispatcher("/WEB-INF/views/staff/search_checkin.jsp").forward(req, resp);
                break;
            case "confirm":
                req.setAttribute("booking", bookingDAO.findById(Integer.parseInt(req.getParameter("bookingId"))));
                req.getRequestDispatcher("/WEB-INF/views/staff/confirm_checkin.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/checkin?action=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("execute".equals(req.getParameter("action"))) {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            bookingDAO.checkin(bookingId, Timestamp.valueOf(LocalDateTime.now()));
            resp.sendRedirect(req.getContextPath() + "/staff/home?msg=checkin_success");
        }
    }
}
