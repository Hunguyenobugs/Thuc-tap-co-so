package com.hotel.servlet;

import com.hotel.dao.RoomTypeDAO;
import com.hotel.model.RoomType;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.io.File;
import java.nio.file.Paths;
import java.util.UUID;
import jakarta.servlet.annotation.MultipartConfig;

@WebServlet("/manager/roomtype")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 20   // 20 MB
)
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

    private String handleFileUpload(HttpServletRequest req) {
        try {
            java.util.List<String> urls = new java.util.ArrayList<>();
            for (jakarta.servlet.http.Part filePart : req.getParts()) {
                if (("imageFile".equals(filePart.getName()) || "imageFiles".equals(filePart.getName())) && filePart.getSize() > 0) {
                    String fileName = java.util.UUID.randomUUID().toString() + "_" + java.nio.file.Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String uploadPath = req.getServletContext().getRealPath("") + java.io.File.separator + "images" + java.io.File.separator + "rooms";
                    
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    
                    filePart.write(uploadPath + java.io.File.separator + fileName);
                    urls.add("/images/rooms/" + fileName);
                }
            }
            if (!urls.isEmpty()) return String.join(",", urls);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
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
        
        String uploadedUrl = handleFileUpload(req);
        String oldUrls = req.getParameter("imageUrl");
        if (uploadedUrl != null && oldUrls != null && !oldUrls.trim().isEmpty()) {
            rt.setImageUrl(oldUrls + "," + uploadedUrl);
        } else if (uploadedUrl != null) {
            rt.setImageUrl(uploadedUrl);
        } else {
            rt.setImageUrl(oldUrls);
        }

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
        
        String uploadedUrl = handleFileUpload(req);
        String oldUrls = req.getParameter("imageUrl");
        if (uploadedUrl != null && oldUrls != null && !oldUrls.trim().isEmpty()) {
            rt.setImageUrl(oldUrls + "," + uploadedUrl);
        } else if (uploadedUrl != null) {
            rt.setImageUrl(uploadedUrl);
        } else {
            rt.setImageUrl(oldUrls);
        }

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
