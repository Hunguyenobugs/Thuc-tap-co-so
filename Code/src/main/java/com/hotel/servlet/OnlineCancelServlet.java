package com.hotel.servlet;

import com.hotel.dao.BookingDAO;
import com.hotel.model.Booking;
import com.hotel.model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/onlineCancel")
public class OnlineCancelServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        Booking b = bookingDAO.findById(bookingId);
        Customer customer = (Customer) req.getSession().getAttribute("currentCustomer");
        if (b == null || b.getCustomerId() != customer.getId()) {
            resp.sendRedirect(req.getContextPath() + "/bookingHistory?error=not_found");
            return;
        }
        req.setAttribute("booking", b);
        req.getRequestDispatcher("/WEB-INF/views/customer/confirm_online_cancel.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Customer customer = (Customer) req.getSession().getAttribute("currentCustomer");
        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/customerAuth?action=loginPage");
            return;
        }

        String bookedRoomIdStr = req.getParameter("bookedRoomId");
        if (bookedRoomIdStr != null && !bookedRoomIdStr.isEmpty()) {
            int bookedRoomId = Integer.parseInt(bookedRoomIdStr);
            boolean success = bookingDAO.cancelBookedRoom(bookedRoomId, customer.getId());
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/bookingHistory?msg=cancel_room_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/bookingHistory?error=cancel_failed");
            }
        } else {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            Booking b = bookingDAO.findById(bookingId);
            if (b != null && b.getCustomerId() == customer.getId()) {
                bookingDAO.cancel(bookingId);
                resp.sendRedirect(req.getContextPath() + "/bookingHistory?msg=cancel_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/bookingHistory?error=not_found");
            }
        }
    }
}
