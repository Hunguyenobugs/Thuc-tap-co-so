package com.hotel.servlet;

import com.hotel.dao.RoomDAO;
import com.hotel.dao.RoomTypeDAO;
import com.hotel.model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/manager/room")
public class RoomServlet extends HttpServlet {
    private final RoomDAO roomDAO = new RoomDAO();
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "manage";

        switch (action) {
            case "add":
                req.setAttribute("roomTypes", roomTypeDAO.getAll());
                req.getRequestDispatcher("/WEB-INF/views/manager/add_room.jsp").forward(req, resp);
                break;
            case "search":
                String keyword = req.getParameter("keyword");
                if (keyword != null && !keyword.trim().isEmpty()) {
                    req.setAttribute("results", roomDAO.searchByNumber(keyword));
                    req.setAttribute("keyword", keyword);
                } else {
                    req.setAttribute("results", roomDAO.getAll());
                }
                req.getRequestDispatcher("/WEB-INF/views/manager/manage_room.jsp").forward(req, resp);
                break;
            case "edit":
                req.setAttribute("room", roomDAO.findById(Integer.parseInt(req.getParameter("id"))));
                req.setAttribute("roomTypes", roomTypeDAO.getAll());
                req.getRequestDispatcher("/WEB-INF/views/manager/edit_room.jsp").forward(req, resp);
                break;
            case "delete":
                int id = Integer.parseInt(req.getParameter("id"));
                if (roomDAO.hasActiveBooking(id)) {
                    resp.sendRedirect(req.getContextPath() + "/manager/room?action=search&keyword=&error=has_booking");
                } else {
                    roomDAO.delete(id);
                    resp.sendRedirect(req.getContextPath() + "/manager/room?msg=delete_success");
                }
                break;
            default:
                req.setAttribute("rooms", roomDAO.getAll());
                req.getRequestDispatcher("/WEB-INF/views/manager/manage_room.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("insert".equals(action)) {
            String roomNumber = req.getParameter("roomNumber");
            if (roomDAO.existsByNumber(roomNumber)) {
                req.setAttribute("error", "Tên phòng đã tồn tại, vui lòng chọn tên khác");
                req.setAttribute("roomTypes", roomTypeDAO.getAll());
                req.getRequestDispatcher("/WEB-INF/views/manager/add_room.jsp").forward(req, resp);
                return;
            }
            Room r = new Room();
            r.setRoomNumber(roomNumber);
            try { r.setFloor(Integer.parseInt(req.getParameter("floor"))); } catch (Exception e) { r.setFloor(1); }
            r.setStatus(req.getParameter("status"));
            r.setDescription(req.getParameter("description"));
            r.setRoomTypeId(Integer.parseInt(req.getParameter("roomTypeId")));
            roomDAO.insert(r);
            resp.sendRedirect(req.getContextPath() + "/manager/room?msg=add_success");
        } else if ("update".equals(action)) {
            Room r = new Room();
            r.setId(Integer.parseInt(req.getParameter("id")));
            r.setRoomNumber(req.getParameter("roomNumber"));
            try { r.setFloor(Integer.parseInt(req.getParameter("floor"))); } catch (Exception e) { r.setFloor(1); }
            r.setStatus(req.getParameter("status"));
            r.setDescription(req.getParameter("description"));
            r.setRoomTypeId(Integer.parseInt(req.getParameter("roomTypeId")));
            roomDAO.update(r);
            resp.sendRedirect(req.getContextPath() + "/manager/room?msg=update_success");
        }
    }
}
