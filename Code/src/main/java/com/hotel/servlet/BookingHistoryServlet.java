package com.hotel.servlet;

import com.hotel.dao.BookingDAO;
import com.hotel.model.Booking;
import com.hotel.model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/bookingHistory")
public class BookingHistoryServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Customer customer = (Customer) req.getSession().getAttribute("currentCustomer");
        List<Booking> bookings = bookingDAO.findByCustomer(customer.getId());
        req.setAttribute("bookings", bookings);
        req.getRequestDispatcher("/WEB-INF/views/customer/booking_history.jsp").forward(req, resp);
    }
}
