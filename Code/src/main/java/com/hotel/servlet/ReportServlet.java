package com.hotel.servlet;

import com.hotel.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/manager/report")
public class ReportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String period = req.getParameter("period");
        if (period != null && !period.isEmpty()) {
            try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement ps1 = conn.prepareStatement("SELECT * FROM v_revenue_stat WHERE period=?");
                ps1.setString(1, period);
                ResultSet rs1 = ps1.executeQuery();
                if (rs1.next()) {
                    Map<String, Object> rev = new HashMap<>();
                    rev.put("period", rs1.getString("period"));
                    rev.put("totalBookings", rs1.getInt("total_bookings"));
                    rev.put("rentedRoomsCount", rs1.getInt("rented_rooms_count"));
                    rev.put("totalRoomsCount", rs1.getInt("total_rooms_count"));
                    rev.put("roomRevenue", rs1.getBigDecimal("room_revenue"));
                    rev.put("serviceRevenue", rs1.getBigDecimal("service_revenue"));
                    rev.put("totalRevenue", rs1.getBigDecimal("total_revenue"));
                    req.setAttribute("revenue", rev);
                }

                PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM v_room_revenue_stat WHERE period=? ORDER BY total_revenue DESC");
                ps2.setString(1, period);
                ResultSet rs2 = ps2.executeQuery();
                List<Map<String, Object>> roomStats = new ArrayList<>();
                while (rs2.next()) {
                    Map<String, Object> rs = new HashMap<>();
                    rs.put("roomNumber", rs2.getString("room_number"));
                    rs.put("roomTypeName", rs2.getString("room_type_name"));
                    rs.put("occupiedDays", rs2.getInt("occupied_days"));
                    rs.put("totalRevenue", rs2.getBigDecimal("total_revenue"));
                    roomStats.add(rs);
                }
                req.setAttribute("roomStats", roomStats);

                PreparedStatement ps3 = conn.prepareStatement("SELECT * FROM v_service_revenue_stat WHERE period=? ORDER BY total_revenue DESC");
                ps3.setString(1, period);
                ResultSet rs3 = ps3.executeQuery();
                List<Map<String, Object>> serviceStats = new ArrayList<>();
                while (rs3.next()) {
                    Map<String, Object> ss = new HashMap<>();
                    ss.put("serviceName", rs3.getString("service_name"));
                    ss.put("category", rs3.getString("category"));
                    ss.put("unit", rs3.getString("unit"));
                    ss.put("totalQuantity", rs3.getBigDecimal("total_quantity"));
                    ss.put("totalRevenue", rs3.getBigDecimal("total_revenue"));
                    serviceStats.add(ss);
                }
                req.setAttribute("serviceStats", serviceStats);
            } catch (SQLException e) { e.printStackTrace(); }
            req.setAttribute("period", period);
        }
        req.getRequestDispatcher("/WEB-INF/views/manager/report_revenue.jsp").forward(req, resp);
    }
}
