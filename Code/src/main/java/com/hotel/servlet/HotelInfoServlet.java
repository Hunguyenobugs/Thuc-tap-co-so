package com.hotel.servlet;

import com.hotel.dao.HotelDAO;
import com.hotel.dao.RoomTypeDAO;
import com.hotel.model.Hotel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/home")
public class HotelInfoServlet extends HttpServlet {
    private final HotelDAO hotelDAO = new HotelDAO();
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("roomTypeDetail".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("roomType", roomTypeDAO.findById(id));
            req.getRequestDispatcher("/WEB-INF/views/customer/room_type_detail.jsp").forward(req, resp);
        } else {
            req.setAttribute("hotel", hotelDAO.getHotelInfo());
            req.setAttribute("roomTypes", roomTypeDAO.getAll());
            req.getRequestDispatcher("/WEB-INF/views/customer/index.jsp").forward(req, resp);
        }
    }
}
