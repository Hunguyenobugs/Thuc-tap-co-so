package com.hotel.servlet;

import com.hotel.dao.HotelDAO;
import com.hotel.model.Hotel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/manager/hotel")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 20   // 20 MB
)
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

        String uploadedUrl = handleFileUpload(req);
        String oldUrls = req.getParameter("imageUrl");
        if (uploadedUrl != null && oldUrls != null && !oldUrls.trim().isEmpty()) {
            h.setImageUrl(oldUrls + "," + uploadedUrl);
        } else if (uploadedUrl != null) {
            h.setImageUrl(uploadedUrl);
        } else {
            h.setImageUrl(oldUrls);
        }

        hotelDAO.update(h);
        req.getServletContext().setAttribute("hotelInfo", h);
        resp.sendRedirect(req.getContextPath() + "/manager/hotel?msg=update_success");
    }

    private String handleFileUpload(HttpServletRequest req) {
        try {
            List<String> urls = new ArrayList<>();
            for (Part filePart : req.getParts()) {
                if (("imageFile".equals(filePart.getName()) || "imageFiles".equals(filePart.getName())) && filePart.getSize() > 0) {
                    String fileName = UUID.randomUUID().toString() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String uploadPath = req.getServletContext().getRealPath("") + File.separator + "images" + File.separator + "hotel";
                    
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    
                    // Ghi vao thu muc deploy
                    filePart.write(uploadPath + File.separator + fileName);
                    
                    // Copy sang thu muc ma nguon goc
                    try {
                        String sourceCodePath = "d:\\Dai hoc\\Thuc tap co so\\Code\\src\\main\\webapp\\images\\hotel";
                        File sourceCodeDir = new File(sourceCodePath);
                        if (!sourceCodeDir.exists()) sourceCodeDir.mkdirs();
                        
                        File uploadedFile = new File(uploadPath + File.separator + fileName);
                        File sourceCodeFile = new File(sourceCodeDir, fileName);
                        
                        Files.copy(uploadedFile.toPath(), sourceCodeFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    } catch (Exception err) {
                        System.err.println("Khong the copy anh khach san sang source code dir: " + err.getMessage());
                    }
                    
                    urls.add("/images/hotel/" + fileName);
                }
            }
            if (!urls.isEmpty()) return String.join(",", urls);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
