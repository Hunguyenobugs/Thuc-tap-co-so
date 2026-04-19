package com.hotel.dao;

import com.hotel.model.UsedService;
import com.hotel.util.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsedServiceDAO {

    public List<UsedService> listByBooking(int bookingId) {
        List<UsedService> list = new ArrayList<>();
        String sql = "SELECT us.*, s.name AS service_name, s.unit AS service_unit FROM tbl_used_service us " +
                "JOIN tbl_service s ON us.service_id=s.id WHERE us.booking_id=? ORDER BY us.used_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(UsedService us) {
        String sql = "INSERT INTO tbl_used_service (booking_id,service_id,quantity,unit_price,used_date,note) VALUES (?,?,?,?,NOW(),?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, us.getBookingId());
            ps.setInt(2, us.getServiceId());
            ps.setBigDecimal(3, us.getQuantity());
            ps.setBigDecimal(4, us.getUnitPrice());
            ps.setString(5, us.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public BigDecimal getTotalByBooking(int bookingId) {
        String sql = "SELECT COALESCE(SUM(quantity * unit_price), 0) AS total FROM tbl_used_service WHERE booking_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBigDecimal("total");
        } catch (SQLException e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    private UsedService mapRow(ResultSet rs) throws SQLException {
        UsedService us = new UsedService();
        us.setId(rs.getInt("id"));
        us.setBookingId(rs.getInt("booking_id"));
        us.setServiceId(rs.getInt("service_id"));
        us.setQuantity(rs.getBigDecimal("quantity"));
        us.setUnitPrice(rs.getBigDecimal("unit_price"));
        us.setUsedDate(rs.getTimestamp("used_date"));
        us.setNote(rs.getString("note"));
        try { us.setServiceName(rs.getString("service_name")); } catch (SQLException ignored) {}
        try { us.setServiceUnit(rs.getString("service_unit")); } catch (SQLException ignored) {}
        return us;
    }
}
