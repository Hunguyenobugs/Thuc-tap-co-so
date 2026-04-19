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
                    rev.put("totalGuests", rs1.getInt("total_guests"));
                    rev.put("totalRoomNights", rs1.getInt("total_room_nights"));
                    rev.put("roomRevenue", rs1.getBigDecimal("room_revenue"));
                    rev.put("serviceRevenue", rs1.getBigDecimal("service_revenue"));
                    rev.put("totalRevenue", rs1.getBigDecimal("total_revenue"));
                    req.setAttribute("revenue", rev);
                }

                PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM v_room_stat WHERE period=?");
                ps2.setString(1, period);
                ResultSet rs2 = ps2.executeQuery();
                List<Map<String, Object>> roomStats = new ArrayList<>();
                while (rs2.next()) {
                    Map<String, Object> rs = new HashMap<>();
                    rs.put("roomTypeName", rs2.getString("room_type_name"));
                    rs.put("totalRooms", rs2.getInt("total_rooms"));
                    rs.put("rentedRooms", rs2.getInt("rented_rooms"));
                    rs.put("occupancyRate", rs2.getBigDecimal("occupancy_rate"));
                    roomStats.add(rs);
                }
                req.setAttribute("roomStats", roomStats);
            } catch (SQLException e) { e.printStackTrace(); }
            req.setAttribute("period", period);
        }
        req.getRequestDispatcher("/WEB-INF/views/manager/report_revenue.jsp").forward(req, resp);
    }
}
