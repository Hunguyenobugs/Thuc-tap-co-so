package com.hotel.dao;

import com.hotel.model.Invoice;
import com.hotel.util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    public List<Invoice> getAll() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.*, b.code AS booking_code, c.full_name AS customer_name, u.full_name AS staff_name, r.room_number " +
                "FROM tbl_invoice i JOIN tbl_booking b ON i.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id LEFT JOIN tbl_user u ON i.staff_id=u.id " +
                "LEFT JOIN tbl_booked_room br ON i.booked_room_id=br.id LEFT JOIN tbl_room r ON br.room_id=r.id " +
                "ORDER BY i.issue_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Invoice findById(int id) {
        String sql = "SELECT i.*, b.code AS booking_code, c.full_name AS customer_name, u.full_name AS staff_name, r.room_number " +
                "FROM tbl_invoice i JOIN tbl_booking b ON i.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id LEFT JOIN tbl_user u ON i.staff_id=u.id " +
                "LEFT JOIN tbl_booked_room br ON i.booked_room_id=br.id LEFT JOIN tbl_room r ON br.room_id=r.id WHERE i.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /** Lấy hóa đơn đầu tiên của booking (backward compatibility) */
    public Invoice findFirstByBookingId(int bookingId) {
        String sql = "SELECT i.*, b.code AS booking_code, c.full_name AS customer_name, u.full_name AS staff_name, r.room_number " +
                "FROM tbl_invoice i JOIN tbl_booking b ON i.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id LEFT JOIN tbl_user u ON i.staff_id=u.id " +
                "LEFT JOIN tbl_booked_room br ON i.booked_room_id=br.id LEFT JOIN tbl_room r ON br.room_id=r.id WHERE i.booking_id=? LIMIT 1";
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
        String sql = "SELECT i.*, b.code AS booking_code, c.full_name AS customer_name, u.full_name AS staff_name, r.room_number " +
                "FROM tbl_invoice i JOIN tbl_booking b ON i.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id LEFT JOIN tbl_user u ON i.staff_id=u.id " +
                "LEFT JOIN tbl_booked_room br ON i.booked_room_id=br.id LEFT JOIN tbl_room r ON br.room_id=r.id " +
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
        String sql = "SELECT i.*, b.code AS booking_code, c.full_name AS customer_name, u.full_name AS staff_name, r.room_number " +
                "FROM tbl_invoice i JOIN tbl_booking b ON i.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id LEFT JOIN tbl_user u ON i.staff_id=u.id " +
                "LEFT JOIN tbl_booked_room br ON i.booked_room_id=br.id LEFT JOIN tbl_room r ON br.room_id=r.id " +
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
        String sql = "INSERT INTO tbl_invoice (code,booking_id,booked_room_id,staff_id,issue_date,room_total,service_total,surcharge,total_amount,paid_amount,payment_method,note) VALUES (?,?,?,?,NOW(),?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, inv.getCode());
            ps.setInt(2, inv.getBookingId());
            if (inv.getBookedRoomId() != null) ps.setInt(3, inv.getBookedRoomId()); else ps.setNull(3, Types.INTEGER);
            if (inv.getStaffId() != null) ps.setInt(4, inv.getStaffId()); else ps.setNull(4, Types.INTEGER);
            ps.setBigDecimal(5, inv.getRoomTotal());
            ps.setBigDecimal(6, inv.getServiceTotal());
            ps.setBigDecimal(7, inv.getSurcharge());
            ps.setBigDecimal(8, inv.getTotalAmount());
            ps.setBigDecimal(9, inv.getPaidAmount());
            ps.setString(10, inv.getPaymentMethod());
            ps.setString(11, inv.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public Invoice findByBookedRoomId(int bookedRoomId) {
        String sql = "SELECT i.*, b.code AS booking_code, c.full_name AS customer_name, u.full_name AS staff_name, r.room_number " +
                "FROM tbl_invoice i JOIN tbl_booking b ON i.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id LEFT JOIN tbl_user u ON i.staff_id=u.id " +
                "LEFT JOIN tbl_booked_room br ON i.booked_room_id=br.id LEFT JOIN tbl_room r ON br.room_id=r.id WHERE i.booked_room_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookedRoomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Invoice> findByBookingId(int bookingId) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.*, b.code AS booking_code, c.full_name AS customer_name, u.full_name AS staff_name, r.room_number " +
                "FROM tbl_invoice i JOIN tbl_booking b ON i.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id LEFT JOIN tbl_user u ON i.staff_id=u.id " +
                "LEFT JOIN tbl_booked_room br ON i.booked_room_id=br.id LEFT JOIN tbl_room r ON br.room_id=r.id " +
                "WHERE i.booking_id=? ORDER BY i.issue_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
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

    /** Tạo hóa đơn cho từng phòng (booked_room) khi checkout */
    public boolean createRoomInvoice(Invoice inv) {
        String sql = "INSERT INTO tbl_invoice (code,booking_id,booked_room_id,staff_id,issue_date,room_total,service_total,surcharge,total_amount,paid_amount,payment_method,note) VALUES (?,?,?,?,NOW(),?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, inv.getCode());
            ps.setInt(2, inv.getBookingId());
            if (inv.getBookedRoomId() != null) ps.setInt(3, inv.getBookedRoomId()); else ps.setNull(3, Types.INTEGER);
            if (inv.getStaffId() != null) ps.setInt(4, inv.getStaffId()); else ps.setNull(4, Types.INTEGER);
            ps.setBigDecimal(5, inv.getRoomTotal());
            ps.setBigDecimal(6, inv.getServiceTotal());
            ps.setBigDecimal(7, inv.getSurcharge());
            ps.setBigDecimal(8, inv.getTotalAmount());
            ps.setBigDecimal(9, inv.getPaidAmount());
            ps.setString(10, inv.getPaymentMethod());
            ps.setString(11, inv.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Invoice mapRow(ResultSet rs) throws SQLException {
        Invoice inv = new Invoice();
        inv.setId(rs.getInt("id"));
        inv.setCode(rs.getString("code"));
        inv.setBookingId(rs.getInt("booking_id"));
        int brid = rs.getInt("booked_room_id"); inv.setBookedRoomId(rs.wasNull() ? null : brid);
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
        try { inv.setRoomNumber(rs.getString("room_number")); } catch (SQLException ignored) {}
        return inv;
    }
}
