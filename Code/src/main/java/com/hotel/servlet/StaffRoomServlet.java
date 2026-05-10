package com.hotel.servlet;

import com.hotel.dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/staff/roomMap")
public class StaffRoomServlet extends HttpServlet {
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy tất cả phòng để hiển thị sơ đồ (Room Rack)
        req.setAttribute("rooms", roomDAO.getAll());
        req.getRequestDispatcher("/WEB-INF/views/staff/room_map.jsp").forward(req, resp);
    }
}
