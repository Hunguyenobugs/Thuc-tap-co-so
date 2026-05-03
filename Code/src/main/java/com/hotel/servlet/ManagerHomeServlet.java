package com.hotel.servlet;

import com.hotel.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/manager/home")
public class ManagerHomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection conn = DBConnection.getConnection()) {

            // 1. Số phòng đang được thuê (status = 'Đang sử dụng')
            PreparedStatement ps1 = conn.prepareStatement(
                "SELECT COUNT(*) AS cnt FROM tbl_room WHERE status = 'Đang sử dụng'");
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) req.setAttribute("rentedRooms", rs1.getInt("cnt"));

            // 2. Tổng số phòng
            PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM tbl_room");
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) req.setAttribute("totalRooms", rs2.getInt("cnt"));

            // 3. Số đặt phòng đang chờ xử lý
            PreparedStatement ps3 = conn.prepareStatement(
                "SELECT COUNT(*) AS cnt FROM tbl_booking WHERE status IN ('Chờ xác nhận','Đã xác nhận')");
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) req.setAttribute("pendingBookings", rs3.getInt("cnt"));

            // 4. Tổng doanh thu tháng này
            PreparedStatement ps4 = conn.prepareStatement(
                "SELECT COALESCE(SUM(total_amount),0) AS total FROM tbl_invoice WHERE DATE_FORMAT(issue_date,'%Y-%m') = DATE_FORMAT(NOW(),'%Y-%m')");
            ResultSet rs4 = ps4.executeQuery();
            if (rs4.next()) req.setAttribute("monthRevenue", rs4.getBigDecimal("total"));

            // 5. Số hóa đơn hôm nay
            PreparedStatement ps5 = conn.prepareStatement(
                "SELECT COUNT(*) AS cnt FROM tbl_invoice WHERE DATE(issue_date) = CURDATE()");
            ResultSet rs5 = ps5.executeQuery();
            if (rs5.next()) req.setAttribute("todayInvoices", rs5.getInt("cnt"));

            // 6. Top 5 phòng được thuê nhiều nhất
            PreparedStatement ps6 = conn.prepareStatement(
                "SELECT r.room_number, rt.name AS type_name, COUNT(br.id) AS booking_count " +
                "FROM tbl_booked_room br " +
                "JOIN tbl_room r ON br.room_id = r.id " +
                "JOIN tbl_room_type rt ON r.room_type_id = rt.id " +
                "GROUP BY r.id, r.room_number, rt.name " +
                "ORDER BY booking_count DESC LIMIT 5");
            ResultSet rs6 = ps6.executeQuery();
            List<Map<String,Object>> topRooms = new ArrayList<>();
            while (rs6.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("roomNumber", rs6.getString("room_number"));
                m.put("typeName", rs6.getString("type_name"));
                m.put("count", rs6.getInt("booking_count"));
                topRooms.add(m);
            }
            req.setAttribute("topRooms", topRooms);

            // 7. Doanh thu 7 ngày gần nhất (cho biểu đồ)
            PreparedStatement ps7 = conn.prepareStatement(
                "SELECT DATE(issue_date) AS day, COALESCE(SUM(total_amount),0) AS rev " +
                "FROM tbl_invoice WHERE issue_date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) " +
                "GROUP BY DATE(issue_date) ORDER BY day ASC");
            ResultSet rs7 = ps7.executeQuery();
            List<String> chartLabels = new ArrayList<>();
            List<Long> chartData = new ArrayList<>();
            while (rs7.next()) {
                chartLabels.add(rs7.getString("day"));
                chartData.add(rs7.getBigDecimal("rev").longValue());
            }
            req.setAttribute("chartLabels", chartLabels);
            req.setAttribute("chartData", chartData);

        } catch (SQLException e) { e.printStackTrace(); }

        req.getRequestDispatcher("/WEB-INF/views/manager/manager_home.jsp").forward(req, resp);
    }
}
