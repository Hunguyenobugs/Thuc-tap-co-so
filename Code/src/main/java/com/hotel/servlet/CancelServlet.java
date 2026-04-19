package com.hotel.servlet;

import com.hotel.dao.BookingDAO;
import com.hotel.model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/cancel")
public class CancelServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "search";
        switch (action) {
            case "search":
                String q = req.getParameter("q");
                if (q != null && !q.trim().isEmpty()) {
                    List<Booking> results = bookingDAO.searchByCodeOrCustomer(q);
                    results.removeIf(b -> "Đã hủy".equals(b.getStatus()) || "Đã trả phòng".equals(b.getStatus()));
                    req.setAttribute("results", results);
                    req.setAttribute("keyword", q);
                }
                req.getRequestDispatcher("/WEB-INF/views/staff/search_booking_cancel.jsp").forward(req, resp);
                break;
            case "confirm":
                req.setAttribute("booking", bookingDAO.findById(Integer.parseInt(req.getParameter("bookingId"))));
                req.getRequestDispatcher("/WEB-INF/views/staff/confirm_cancel.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/cancel?action=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("execute".equals(req.getParameter("action"))) {
            bookingDAO.cancel(Integer.parseInt(req.getParameter("bookingId")));
            resp.sendRedirect(req.getContextPath() + "/staff/home?msg=cancel_success");
        }
    }
}
