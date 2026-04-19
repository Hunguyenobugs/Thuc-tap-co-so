package com.hotel.servlet;

import com.hotel.dao.*;
import com.hotel.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

@WebServlet("/staff/booking")
public class BookingServlet extends HttpServlet {
    private final RoomDAO roomDAO = new RoomDAO();
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "searchRoom";
        switch (action) {
            case "searchRoom":
                req.setAttribute("roomTypes", roomTypeDAO.getAll());
                String ci = req.getParameter("checkIn"), co = req.getParameter("checkOut"), rtId = req.getParameter("roomTypeId");
                if (ci != null && co != null && rtId != null) {
                    req.setAttribute("rooms", roomDAO.searchFreeRooms(ci, co, Integer.parseInt(rtId)));
                    req.setAttribute("checkIn", ci); req.setAttribute("checkOut", co); req.setAttribute("selectedType", rtId);
                }
                req.getRequestDispatcher("/WEB-INF/views/staff/search_free_room.jsp").forward(req, resp); break;
            case "searchCustomer":
                req.getSession().setAttribute("bookRoomId", req.getParameter("roomId"));
                String q = req.getParameter("q");
                if (q != null && !q.trim().isEmpty()) {
                    req.setAttribute("customers", customerDAO.searchByIdCard(q));
                    req.setAttribute("keyword", q);
                }
                req.getRequestDispatcher("/WEB-INF/views/staff/search_customer.jsp").forward(req, resp); break;
            case "addCustomer":
                req.getRequestDispatcher("/WEB-INF/views/staff/add_customer.jsp").forward(req, resp); break;
            case "confirm":
                HttpSession s = req.getSession();
                int roomId = Integer.parseInt((String) s.getAttribute("bookRoomId"));
                int custId = Integer.parseInt(req.getParameter("customerId"));
                Room room = roomDAO.findById(roomId);
                Customer cust = customerDAO.findById(custId);
                req.setAttribute("room", room); req.setAttribute("customer", cust);
                req.setAttribute("checkIn", s.getAttribute("bookCheckIn")); req.setAttribute("checkOut", s.getAttribute("bookCheckOut"));
                RoomType rt = roomTypeDAO.findById(room.getRoomTypeId());
                req.setAttribute("roomType", rt);
                long nights = (Date.valueOf((String) s.getAttribute("bookCheckOut")).getTime() - Date.valueOf((String) s.getAttribute("bookCheckIn")).getTime()) / 86400000;
                req.setAttribute("nights", nights);
                req.setAttribute("totalEstimate", rt.getBasePrice().multiply(BigDecimal.valueOf(nights)));
                req.getRequestDispatcher("/WEB-INF/views/staff/confirm_booking.jsp").forward(req, resp); break;
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchRoom");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("saveCheckIn".equals(action)) {
            HttpSession s = req.getSession();
            s.setAttribute("bookCheckIn", req.getParameter("checkIn"));
            s.setAttribute("bookCheckOut", req.getParameter("checkOut"));
            resp.sendRedirect(req.getContextPath() + "/staff/booking?action=searchCustomer&roomId=" + req.getParameter("roomId"));
        } else if ("insertCustomer".equals(action)) {
            Customer c = new Customer();
            c.setFullName(req.getParameter("fullName")); c.setIdCard(req.getParameter("idCard")); c.setIdType("CCCD");
            c.setPhone(req.getParameter("phone")); c.setEmail(req.getParameter("email")); c.setAddress(req.getParameter("address"));
            String bd = req.getParameter("birthDate");
            if (bd != null && !bd.isEmpty()) c.setBirthDate(Date.valueOf(bd));
            c.setGender(req.getParameter("gender"));
            int newId = customerDAO.insert(c);
            resp.sendRedirect(req.getContextPath() + "/staff/booking?action=confirm&customerId=" + newId);
        } else if ("insert".equals(action)) {
            HttpSession s = req.getSession();
            User staff = (User) s.getAttribute("currentUser");
            Booking b = new Booking();
            b.setCode(bookingDAO.generateCode());
            b.setCustomerId(Integer.parseInt(req.getParameter("customerId")));
            b.setStaffId(staff.getId());
            b.setStatus("Đã xác nhận");
            b.setSpecialRequests(req.getParameter("specialRequests"));
            BookedRoom br = new BookedRoom();
            br.setRoomId(Integer.parseInt((String) s.getAttribute("bookRoomId")));
            br.setCheckIn(Date.valueOf((String) s.getAttribute("bookCheckIn")));
            br.setCheckOut(Date.valueOf((String) s.getAttribute("bookCheckOut")));
            RoomType rt = roomTypeDAO.findById(roomDAO.findById(br.getRoomId()).getRoomTypeId());
            br.setActualPrice(rt.getBasePrice());
            int bookingId = bookingDAO.insert(b, br);
            s.removeAttribute("bookRoomId"); s.removeAttribute("bookCheckIn"); s.removeAttribute("bookCheckOut");
            Booking created = bookingDAO.findById(bookingId);
            resp.sendRedirect(req.getContextPath() + "/staff/home?msg=booking_success&code=" + created.getCode());
        }
    }
}
