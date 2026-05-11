package com.hotel.dao;

import com.hotel.model.BookedRoom;
import com.hotel.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookedRoomDAO {

    public List<BookedRoom> findByBookingId(int bookingId) {
        List<BookedRoom> list = new ArrayList<>();
        String sql = "SELECT br.*, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booked_room br " +
                "JOIN tbl_room r ON br.room_id=r.id " +
                "JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE br.booking_id=? ORDER BY br.check_in";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public BookedRoom findById(int id) {
        String sql = "SELECT br.*, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booked_room br " +
                "JOIN tbl_room r ON br.room_id=r.id " +
                "JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE br.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /** Check-in một phòng cụ thể (theo booked_room.id) */
    public boolean checkinRoom(int bookedRoomId, Timestamp actualCheckin) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Cập nhật booked_room
            PreparedStatement ps1 = conn.prepareStatement(
                "UPDATE tbl_booked_room SET actual_checkin=?, is_checked_in=TRUE, room_status='Đã check-in' WHERE id=?");
            ps1.setTimestamp(1, actualCheckin);
            ps1.setInt(2, bookedRoomId);
            ps1.executeUpdate();

            // Cập nhật trạng thái phòng thực tế
            PreparedStatement ps2 = conn.prepareStatement(
                "UPDATE tbl_room SET status='Đang sử dụng' WHERE id=(SELECT room_id FROM tbl_booked_room WHERE id=?)");
            ps2.setInt(1, bookedRoomId);
            ps2.executeUpdate();

            // Cập nhật trạng thái booking nếu chưa là 'Đang lưu trú'
            PreparedStatement ps3 = conn.prepareStatement(
                "UPDATE tbl_booking SET status='Đang lưu trú' WHERE id=(SELECT booking_id FROM tbl_booked_room WHERE id=?) AND status='Đã xác nhận'");
            ps3.setInt(1, bookedRoomId);
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

    /** Check-out một phòng cụ thể (theo booked_room.id) - trả về TRUE nếu đây là phòng cuối cùng */
    public boolean checkoutRoom(int bookedRoomId, Timestamp actualCheckout) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Cập nhật booked_room
            PreparedStatement ps1 = conn.prepareStatement(
                "UPDATE tbl_booked_room SET actual_checkout=?, room_status='Đã check-out' WHERE id=?");
            ps1.setTimestamp(1, actualCheckout);
            ps1.setInt(2, bookedRoomId);
            ps1.executeUpdate();

            // Trả phòng về trạng thái Trống
            PreparedStatement ps2 = conn.prepareStatement(
                "UPDATE tbl_room SET status='Trống' WHERE id=(SELECT room_id FROM tbl_booked_room WHERE id=?)");
            ps2.setInt(1, bookedRoomId);
            ps2.executeUpdate();

            // Kiểm tra xem tất cả phòng đã check-out chưa
            PreparedStatement ps3 = conn.prepareStatement(
                "SELECT COUNT(*) FROM tbl_booked_room " +
                "WHERE booking_id=(SELECT booking_id FROM tbl_booked_room WHERE id=?) " +
                "AND room_status != 'Đã check-out' AND room_status != 'Đã hủy'");
            ps3.setInt(1, bookedRoomId);
            ResultSet rs = ps3.executeQuery();
            boolean allCheckedOut = rs.next() && rs.getInt(1) == 0;

            // Nếu tất cả phòng đã check-out → cập nhật booking thành 'Đã trả phòng'
            if (allCheckedOut) {
                PreparedStatement ps4 = conn.prepareStatement(
                    "UPDATE tbl_booking SET status='Đã trả phòng' WHERE id=(SELECT booking_id FROM tbl_booked_room WHERE id=?)");
                ps4.setInt(1, bookedRoomId);
                ps4.executeUpdate();
            }

            conn.commit();
            return allCheckedOut;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
        return false;
    }

    /** Tìm các phòng có thể check-in (booking đã xác nhận, phòng chưa check-in) */
    public List<BookedRoom> findReadyForCheckin(String keyword) {
        List<BookedRoom> list = new ArrayList<>();
        String sql = "SELECT br.*, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booked_room br " +
                "JOIN tbl_room r ON br.room_id=r.id " +
                "JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "JOIN tbl_booking b ON br.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id " +
                "WHERE b.status IN ('Đã xác nhận','Đang lưu trú') " +
                "AND br.room_status='Chờ' " +
                "AND (b.code LIKE ? OR c.full_name LIKE ? OR r.room_number LIKE ?) " +
                "ORDER BY br.check_in";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k); ps.setString(3, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookedRoom br = mapRow(rs);
                // Thêm thông tin booking/customer vào note tạm
                list.add(br);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Tìm các phòng có thể check-out (đang lưu trú) */
    public List<BookedRoom> findReadyForCheckout(String keyword) {
        List<BookedRoom> list = new ArrayList<>();
        String sql = "SELECT br.*, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booked_room br " +
                "JOIN tbl_room r ON br.room_id=r.id " +
                "JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "JOIN tbl_booking b ON br.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id " +
                "WHERE br.room_status='Đã check-in' " +
                "AND (b.code LIKE ? OR c.full_name LIKE ? OR r.room_number LIKE ?) " +
                "ORDER BY br.check_out";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k); ps.setString(3, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private BookedRoom mapRow(ResultSet rs) throws SQLException {
        BookedRoom br = new BookedRoom();
        br.setId(rs.getInt("id"));
        br.setBookingId(rs.getInt("booking_id"));
        br.setRoomId(rs.getInt("room_id"));
        br.setCheckIn(rs.getTimestamp("check_in"));
        br.setCheckOut(rs.getTimestamp("check_out"));
        br.setActualCheckin(rs.getTimestamp("actual_checkin"));
        br.setActualCheckout(rs.getTimestamp("actual_checkout"));
        br.setActualPrice(rs.getBigDecimal("actual_price"));
        br.setCheckedIn(rs.getBoolean("is_checked_in"));
        br.setRoomStatus(rs.getString("room_status"));
        try { br.setRoomNumber(rs.getString("room_number")); } catch (SQLException ignored) {}
        try { br.setRoomTypeName(rs.getString("room_type_name")); } catch (SQLException ignored) {}
        return br;
    }
}
