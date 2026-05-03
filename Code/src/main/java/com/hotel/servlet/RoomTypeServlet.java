package com.hotel.servlet;

import com.hotel.dao.RoomTypeDAO;
import com.hotel.model.RoomType;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/manager/roomtype")
public class RoomTypeServlet extends HttpServlet {
    private final RoomTypeDAO dao = new RoomTypeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "manage";

        switch (action) {
            case "add":
                req.getRequestDispatcher("/WEB-INF/views/manager/add_roomtype.jsp").forward(req, resp);
                break;
            case "search":
                String keyword = req.getParameter("keyword");
                if (keyword != null && !keyword.trim().isEmpty()) {
                    req.setAttribute("results", dao.searchByName(keyword));
                    req.setAttribute("keyword", keyword);
                } else {
                    req.setAttribute("results", dao.getAll());
                }
                req.getRequestDispatcher("/WEB-INF/views/manager/manage_roomtype.jsp").forward(req, resp);
                break;
            case "edit":
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("roomType", dao.findById(id));
                req.getRequestDispatcher("/WEB-INF/views/manager/edit_roomtype.jsp").forward(req, resp);
                break;
            case "delete":
                handleDelete(req, resp);
                break;
            default:
                req.setAttribute("roomTypes", dao.getAll());
                req.getRequestDispatcher("/WEB-INF/views/manager/manage_roomtype.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("insert".equals(action)) {
            doInsert(req, resp);
        } else if ("update".equals(action)) {
            doUpdate(req, resp);
        }
    }

    private void doInsert(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String priceStr = req.getParameter("basePrice");
        if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
            req.getRequestDispatcher("/WEB-INF/views/manager/add_roomtype.jsp").forward(req, resp);
            return;
        }

        RoomType rt = new RoomType();
        rt.setName(name.trim());
        try { rt.setCapacity(Integer.parseInt(req.getParameter("capacity"))); } catch (Exception e) { rt.setCapacity(2); }
        rt.setArea(req.getParameter("area"));
        rt.setBasePrice(new BigDecimal(priceStr.trim()));
        rt.setAmenities(req.getParameter("amenities"));
        rt.setDescription(req.getParameter("description"));
        rt.setImageUrl(req.getParameter("imageUrl"));

        dao.insert(rt);
        resp.sendRedirect(req.getContextPath() + "/manager/roomtype?msg=add_success");
    }

    private void doUpdate(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RoomType rt = new RoomType();
        rt.setId(Integer.parseInt(req.getParameter("id")));
        rt.setName(req.getParameter("name"));
        try { rt.setCapacity(Integer.parseInt(req.getParameter("capacity"))); } catch (Exception e) { rt.setCapacity(2); }
        rt.setArea(req.getParameter("area"));
        rt.setBasePrice(new BigDecimal(req.getParameter("basePrice")));
        rt.setAmenities(req.getParameter("amenities"));
        rt.setDescription(req.getParameter("description"));
        rt.setImageUrl(req.getParameter("imageUrl"));

        dao.update(rt);
        resp.sendRedirect(req.getContextPath() + "/manager/roomtype?msg=update_success");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        if (dao.hasRooms(id)) {
            resp.sendRedirect(req.getContextPath() + "/manager/roomtype?action=search&keyword=&error=has_rooms");
        } else {
            dao.delete(id);
            resp.sendRedirect(req.getContextPath() + "/manager/roomtype?msg=delete_success");
        }
    }
}
