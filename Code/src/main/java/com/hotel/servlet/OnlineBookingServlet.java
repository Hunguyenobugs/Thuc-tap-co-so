package com.hotel.servlet;

import com.hotel.dao.*;
import com.hotel.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

@WebServlet("/onlineBooking")
public class OnlineBookingServlet extends HttpServlet {
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String ci = req.getParameter("checkIn"), co = req.getParameter("checkOut");
        int rtId = Integer.parseInt(req.getParameter("roomTypeId"));
        RoomType rt = roomTypeDAO.findById(rtId);
        req.setAttribute("roomType", rt); req.setAttribute("checkIn", ci); req.setAttribute("checkOut", co);
        long nights = (Date.valueOf(co).getTime() - Date.valueOf(ci).getTime()) / 86400000;
        req.setAttribute("nights", nights);
        req.setAttribute("totalEstimate", rt.getBasePrice().multiply(BigDecimal.valueOf(nights)));
        req.getRequestDispatcher("/WEB-INF/views/customer/confirm_online_booking.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Customer customer = (Customer) req.getSession().getAttribute("currentCustomer");
        int rtId = Integer.parseInt(req.getParameter("roomTypeId"));
        String ci = req.getParameter("checkIn"), co = req.getParameter("checkOut");

        var freeRooms = roomDAO.searchFreeRooms(ci, co, rtId);
        if (freeRooms.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/search?checkIn=" + ci + "&checkOut=" + co + "&guests=1&error=no_room");
            return;
        }
        int roomId = freeRooms.get(0).getId();

        Booking b = new Booking();
        b.setCode(bookingDAO.generateCode());
        b.setCustomerId(customer.getId());
        b.setStaffId(null);
        b.setStatus("Chờ xác nhận");
        b.setSpecialRequests(req.getParameter("specialRequests"));

        BookedRoom br = new BookedRoom();
        br.setRoomId(roomId);
        br.setCheckIn(Date.valueOf(ci)); br.setCheckOut(Date.valueOf(co));
        br.setActualPrice(roomTypeDAO.findById(rtId).getBasePrice());

        bookingDAO.insert(b, br);
        resp.sendRedirect(req.getContextPath() + "/bookingHistory?msg=booking_success");
    }
}
