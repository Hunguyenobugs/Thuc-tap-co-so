package com.hotel.dao;

import com.hotel.model.Booking;
import com.hotel.model.BookedRoom;
import com.hotel.util.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public Booking findById(int id) {
        String sql = "SELECT b.*, c.full_name AS customer_name, u.full_name AS staff_name, " +
                "br.check_in, br.check_out, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booking b " +
                "JOIN tbl_customer c ON b.customer_id=c.id " +
                "LEFT JOIN tbl_user u ON b.staff_id=u.id " +
                "LEFT JOIN tbl_booked_room br ON br.booking_id=b.id " +
                "LEFT JOIN tbl_room r ON br.room_id=r.id " +
                "LEFT JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE b.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRowFull(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Booking findByCode(String code) {
        String sql = "SELECT b.*, c.full_name AS customer_name FROM tbl_booking b JOIN tbl_customer c ON b.customer_id=c.id WHERE b.code=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRowBasic(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Booking> searchByCodeOrCustomer(String keyword) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name AS customer_name, br.check_in, br.check_out, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booking b JOIN tbl_customer c ON b.customer_id=c.id " +
                "LEFT JOIN tbl_booked_room br ON br.booking_id=b.id " +
                "LEFT JOIN tbl_room r ON br.room_id=r.id " +
                "LEFT JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE b.code LIKE ? OR c.full_name LIKE ? ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Booking> searchForCheckin(String keyword) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name AS customer_name, br.check_in, br.check_out, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booking b JOIN tbl_customer c ON b.customer_id=c.id " +
                "LEFT JOIN tbl_booked_room br ON br.booking_id=b.id " +
                "LEFT JOIN tbl_room r ON br.room_id=r.id " +
                "LEFT JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE b.status='Đã xác nhận' AND (b.code LIKE ? OR c.full_name LIKE ?) ORDER BY br.check_in";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Booking> searchForCheckout(String keyword) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name AS customer_name, br.check_in, br.check_out, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booking b JOIN tbl_customer c ON b.customer_id=c.id " +
                "LEFT JOIN tbl_booked_room br ON br.booking_id=b.id " +
                "LEFT JOIN tbl_room r ON br.room_id=r.id " +
                "LEFT JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE b.status='Đang lưu trú' AND (b.code LIKE ? OR c.full_name LIKE ?) ORDER BY br.check_out";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Booking> searchForService(String keyword) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name AS customer_name, br.check_in, br.check_out, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booking b JOIN tbl_customer c ON b.customer_id=c.id " +
                "LEFT JOIN tbl_booked_room br ON br.booking_id=b.id " +
                "LEFT JOIN tbl_room r ON br.room_id=r.id " +
                "LEFT JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE b.status='Đang lưu trú' AND (b.code LIKE ? OR r.room_number LIKE ?) ORDER BY r.room_number";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Booking> findByCustomer(int customerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name AS customer_name, br.check_in, br.check_out, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booking b JOIN tbl_customer c ON b.customer_id=c.id " +
                "LEFT JOIN tbl_booked_room br ON br.booking_id=b.id " +
                "LEFT JOIN tbl_room r ON br.room_id=r.id " +
                "LEFT JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE b.customer_id=? ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public String generateCode() {
        LocalDate now = LocalDate.now();
        String prefix = "PD" + now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String sql = "SELECT code FROM tbl_booking WHERE code LIKE ? ORDER BY code DESC LIMIT 1";
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

    public int insert(Booking b, BookedRoom br) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sql1 = "INSERT INTO tbl_booking (code,customer_id,staff_id,booking_date,deposit_amount,deposit_date,status,special_requests,note) VALUES (?,?,?,NOW(),?,?,?,?,?)";
            PreparedStatement ps1 = conn.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, b.getCode());
            ps1.setInt(2, b.getCustomerId());
            if (b.getStaffId() != null) ps1.setInt(3, b.getStaffId()); else ps1.setNull(3, Types.INTEGER);
            ps1.setBigDecimal(4, b.getDepositAmount() != null ? b.getDepositAmount() : BigDecimal.ZERO);
            ps1.setTimestamp(5, b.getDepositDate());
            ps1.setString(6, b.getStatus());
            ps1.setString(7, b.getSpecialRequests());
            ps1.setString(8, b.getNote());
            ps1.executeUpdate();
            ResultSet keys = ps1.getGeneratedKeys();
            int bookingId = 0;
            if (keys.next()) bookingId = keys.getInt(1);

            String sql2 = "INSERT INTO tbl_booked_room (booking_id,room_id,check_in,check_out,actual_price,is_checked_in) VALUES (?,?,?,?,?,FALSE)";
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, bookingId);
            ps2.setInt(2, br.getRoomId());
            ps2.setDate(3, br.getCheckIn());
            ps2.setDate(4, br.getCheckOut());
            ps2.setBigDecimal(5, br.getActualPrice());
            ps2.executeUpdate();

            conn.commit();
            return bookingId;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
        return -1;
    }

    public boolean cancel(int bookingId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement ps1 = conn.prepareStatement("UPDATE tbl_booking SET status='Đã hủy' WHERE id=?");
            ps1.setInt(1, bookingId);
            ps1.executeUpdate();

            PreparedStatement ps2 = conn.prepareStatement(
                "UPDATE tbl_room SET status='Trống' WHERE id IN (SELECT room_id FROM tbl_booked_room WHERE booking_id=?)");
            ps2.setInt(1, bookingId);
            ps2.executeUpdate();

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

    public boolean checkin(int bookingId, Timestamp actualCheckin) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            conn.prepareStatement("UPDATE tbl_booking SET status='Đang lưu trú' WHERE id=" + bookingId).executeUpdate();
            PreparedStatement ps2 = conn.prepareStatement("UPDATE tbl_booked_room SET actual_checkin=?, is_checked_in=TRUE WHERE booking_id=?");
            ps2.setTimestamp(1, actualCheckin);
            ps2.setInt(2, bookingId);
            ps2.executeUpdate();

            PreparedStatement ps3 = conn.prepareStatement(
                "UPDATE tbl_room SET status='Đang sử dụng' WHERE id IN (SELECT room_id FROM tbl_booked_room WHERE booking_id=?)");
            ps3.setInt(1, bookingId);
            ps3.executeUpdate();

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

    public boolean updateBookedRoom(int bookingId, int newRoomId, BigDecimal newPrice) {
        String sql = "UPDATE tbl_booked_room SET room_id=?, actual_price=? WHERE booking_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newRoomId);
            ps.setBigDecimal(2, newPrice);
            ps.setInt(3, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Booking mapRowBasic(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setCode(rs.getString("code"));
        b.setCustomerId(rs.getInt("customer_id"));
        int sid = rs.getInt("staff_id"); b.setStaffId(rs.wasNull() ? null : sid);
        b.setBookingDate(rs.getTimestamp("booking_date"));
        b.setDepositAmount(rs.getBigDecimal("deposit_amount"));
        b.setDepositDate(rs.getTimestamp("deposit_date"));
        b.setStatus(rs.getString("status"));
        b.setSpecialRequests(rs.getString("special_requests"));
        b.setNote(rs.getString("note"));
        try { b.setCustomerName(rs.getString("customer_name")); } catch (SQLException ignored) {}
        return b;
    }

    private Booking mapRowFull(ResultSet rs) throws SQLException {
        Booking b = mapRowBasic(rs);
        try { b.setCheckIn(rs.getString("check_in")); } catch (SQLException ignored) {}
        try { b.setCheckOut(rs.getString("check_out")); } catch (SQLException ignored) {}
        try { b.setRoomNumber(rs.getString("room_number")); } catch (SQLException ignored) {}
        try { b.setRoomTypeName(rs.getString("room_type_name")); } catch (SQLException ignored) {}
        try { b.setStaffName(rs.getString("staff_name")); } catch (SQLException ignored) {}
        return b;
    }
}
