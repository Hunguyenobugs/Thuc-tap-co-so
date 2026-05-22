package com.hotel.servlet;

import com.hotel.dao.RoomTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String ci = req.getParameter("checkIn"), co = req.getParameter("checkOut"), guestStr = req.getParameter("guests");
        if (ci != null && co != null && guestStr != null) {
            try {
                java.time.LocalDate ciDate = java.time.LocalDate.parse(ci);
                java.time.LocalDate coDate = java.time.LocalDate.parse(co);
                if (ciDate.isBefore(java.time.LocalDate.now())) {
                    req.setAttribute("error", "Không thể chọn ngày nhận phòng trong quá khứ.");
                } else if (!coDate.isAfter(ciDate)) {
                    req.setAttribute("error", "Ngày trả phòng phải sau ngày nhận phòng ít nhất 1 ngày.");
                } else {
                    int guests = Integer.parseInt(guestStr);
                    req.setAttribute("results", roomTypeDAO.searchAvailable(ci, co, guests));
                    req.setAttribute("checkIn", ci); req.setAttribute("checkOut", co); req.setAttribute("guests", guests);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Định dạng ngày không hợp lệ.");
            }
        }
        req.getRequestDispatcher("/WEB-INF/views/customer/search_room.jsp").forward(req, resp);
    }
}
