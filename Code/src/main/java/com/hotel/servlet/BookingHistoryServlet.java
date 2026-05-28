package com.hotel.servlet;

import com.hotel.dao.BookingDAO;
import com.hotel.dao.InvoiceDAO;
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
    private final InvoiceDAO invoiceDAO = new InvoiceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Customer customer = (Customer) req.getSession().getAttribute("currentCustomer");
        List<Booking> bookings = bookingDAO.findByCustomerGrouped(customer.getId());
        
        // Nạp hóa đơn cho từng phòng con nếu phòng đó đã check-out
        for (Booking b : bookings) {
            if (b.getRooms() != null) {
                for (com.hotel.model.BookedRoom br : b.getRooms()) {
                    if ("Đã check-out".equals(br.getRoomStatus())) {
                        br.setInvoice(invoiceDAO.findByBookedRoomId(br.getId()));
                    }
                }
            }
        }
        
        req.setAttribute("bookings", bookings);
        req.getRequestDispatcher("/WEB-INF/views/customer/booking_history.jsp").forward(req, resp);
    }
}
