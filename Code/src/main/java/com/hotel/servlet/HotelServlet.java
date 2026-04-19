package com.hotel.servlet;

import com.hotel.dao.HotelDAO;
import com.hotel.model.Hotel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/manager/hotel")
public class HotelServlet extends HttpServlet {
    private final HotelDAO hotelDAO = new HotelDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("hotel", hotelDAO.getHotelInfo());
        req.getRequestDispatcher("/WEB-INF/views/manager/manage_hotel_info.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Tên khách sạn không được để trống");
            req.setAttribute("hotel", hotelDAO.getHotelInfo());
            req.getRequestDispatcher("/WEB-INF/views/manager/manage_hotel_info.jsp").forward(req, resp);
            return;
        }

        Hotel h = hotelDAO.getHotelInfo();
        h.setName(name.trim());
        h.setAddress(req.getParameter("address"));
        h.setPhone(req.getParameter("phone"));
        h.setEmail(req.getParameter("email"));
        h.setDescription(req.getParameter("description"));
        try { h.setStarRating(Integer.parseInt(req.getParameter("starRating"))); } catch (Exception ignored) {}

        hotelDAO.update(h);
        resp.sendRedirect(req.getContextPath() + "/manager/hotel?msg=update_success");
    }
}
