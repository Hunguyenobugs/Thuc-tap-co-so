package com.hotel.dao;

import com.hotel.model.Invoice;
import com.hotel.util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    public Invoice findById(int id) {
        String sql = "SELECT i.*, b.code AS booking_code, c.full_name AS customer_name, u.full_name AS staff_name " +
                "FROM tbl_invoice i JOIN tbl_booking b ON i.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id LEFT JOIN tbl_user u ON i.staff_id=u.id WHERE i.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Invoice findByBookingId(int bookingId) {
        String sql = "SELECT i.*, b.code AS booking_code, c.full_name AS customer_name, u.full_name AS staff_name " +
                "FROM tbl_invoice i JOIN tbl_booking b ON i.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id LEFT JOIN tbl_user u ON i.staff_id=u.id WHERE i.booking_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Invoice> filter(String from, String to) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.*, b.code AS booking_code, c.full_name AS customer_name, u.full_name AS staff_name " +
                "FROM tbl_invoice i JOIN tbl_booking b ON i.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id LEFT JOIN tbl_user u ON i.staff_id=u.id " +
                "WHERE DATE(i.issue_date) BETWEEN ? AND ? ORDER BY i.issue_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, from);
            ps.setString(2, to);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Invoice> searchByCode(String keyword) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.*, b.code AS booking_code, c.full_name AS customer_name, u.full_name AS staff_name " +
                "FROM tbl_invoice i JOIN tbl_booking b ON i.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id LEFT JOIN tbl_user u ON i.staff_id=u.id " +
                "WHERE i.code LIKE ? ORDER BY i.issue_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public String generateCode() {
        LocalDate now = LocalDate.now();
        String prefix = "HD" + now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String sql = "SELECT code FROM tbl_invoice WHERE code LIKE ? ORDER BY code DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String last = rs.getString("code");
                int seq = Integer.parseInt(last.substring(prefix.length())) + 1;
                return prefix + String.format("%02d", seq);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return prefix + "01";
    }

    public boolean insert(Invoice inv) {
        String sql = "INSERT INTO tbl_invoice (code,booking_id,staff_id,issue_date,room_total,service_total,surcharge,total_amount,paid_amount,payment_method,note) VALUES (?,?,?,NOW(),?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, inv.getCode());
            ps.setInt(2, inv.getBookingId());
            if (inv.getStaffId() != null) ps.setInt(3, inv.getStaffId()); else ps.setNull(3, Types.INTEGER);
            ps.setBigDecimal(4, inv.getRoomTotal());
            ps.setBigDecimal(5, inv.getServiceTotal());
            ps.setBigDecimal(6, inv.getSurcharge());
            ps.setBigDecimal(7, inv.getTotalAmount());
            ps.setBigDecimal(8, inv.getPaidAmount());
            ps.setString(9, inv.getPaymentMethod());
            ps.setString(10, inv.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Invoice inv) {
        String sql = "UPDATE tbl_invoice SET paid_amount=?,payment_method=?,note=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, inv.getPaidAmount());
            ps.setString(2, inv.getPaymentMethod());
            ps.setString(3, inv.getNote());
            ps.setInt(4, inv.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean createCheckoutInvoice(Invoice inv, int bookingId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sql1 = "INSERT INTO tbl_invoice (code,booking_id,staff_id,issue_date,room_total,service_total,surcharge,total_amount,paid_amount,payment_method,note) VALUES (?,?,?,NOW(),?,?,?,?,?,?,?)";
            PreparedStatement ps1 = conn.prepareStatement(sql1);
            ps1.setString(1, inv.getCode());
            ps1.setInt(2, inv.getBookingId());
            if (inv.getStaffId() != null) ps1.setInt(3, inv.getStaffId()); else ps1.setNull(3, Types.INTEGER);
            ps1.setBigDecimal(4, inv.getRoomTotal());
            ps1.setBigDecimal(5, inv.getServiceTotal());
            ps1.setBigDecimal(6, inv.getSurcharge());
            ps1.setBigDecimal(7, inv.getTotalAmount());
            ps1.setBigDecimal(8, inv.getPaidAmount());
            ps1.setString(9, inv.getPaymentMethod());
            ps1.setString(10, inv.getNote());
            ps1.executeUpdate();

            conn.prepareStatement("UPDATE tbl_booking SET status='Đã trả phòng' WHERE id=" + bookingId).executeUpdate();
            conn.prepareStatement("UPDATE tbl_room SET status='Cần dọn dẹp' WHERE id IN (SELECT room_id FROM tbl_booked_room WHERE booking_id=" + bookingId + ")").executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
        return false;
    }

    private Invoice mapRow(ResultSet rs) throws SQLException {
        Invoice inv = new Invoice();
        inv.setId(rs.getInt("id"));
        inv.setCode(rs.getString("code"));
        inv.setBookingId(rs.getInt("booking_id"));
        int sid = rs.getInt("staff_id"); inv.setStaffId(rs.wasNull() ? null : sid);
        inv.setIssueDate(rs.getTimestamp("issue_date"));
        inv.setRoomTotal(rs.getBigDecimal("room_total"));
        inv.setServiceTotal(rs.getBigDecimal("service_total"));
        inv.setSurcharge(rs.getBigDecimal("surcharge"));
        inv.setTotalAmount(rs.getBigDecimal("total_amount"));
        inv.setPaidAmount(rs.getBigDecimal("paid_amount"));
        inv.setPaymentMethod(rs.getString("payment_method"));
        inv.setNote(rs.getString("note"));
        try { inv.setCustomerName(rs.getString("customer_name")); } catch (SQLException ignored) {}
        try { inv.setStaffName(rs.getString("staff_name")); } catch (SQLException ignored) {}
        try { inv.setBookingCode(rs.getString("booking_code")); } catch (SQLException ignored) {}
        return inv;
    }
}
