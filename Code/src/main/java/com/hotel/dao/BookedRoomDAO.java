package com.hotel.dao;

import com.hotel.model.BookedRoom;
import com.hotel.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookedRoomDAO {

    public List<BookedRoom> findByBookingId(int bookingId) {
        List<BookedRoom> list = new ArrayList<>();
        String sql = "SELECT br.*, r.room_number, rt.name AS room_type_name FROM tbl_booked_room br " +
                "JOIN tbl_room r ON br.room_id=r.id JOIN tbl_room_type rt ON r.room_type_id=rt.id WHERE br.booking_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateCheckout(int bookingId, Timestamp actualCheckout) {
        String sql = "UPDATE tbl_booked_room SET actual_checkout=? WHERE booking_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, actualCheckout);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private BookedRoom mapRow(ResultSet rs) throws SQLException {
        BookedRoom br = new BookedRoom();
        br.setId(rs.getInt("id"));
        br.setBookingId(rs.getInt("booking_id"));
        br.setRoomId(rs.getInt("room_id"));
        br.setCheckIn(rs.getDate("check_in"));
        br.setCheckOut(rs.getDate("check_out"));
        br.setActualCheckin(rs.getTimestamp("actual_checkin"));
        br.setActualCheckout(rs.getTimestamp("actual_checkout"));
        br.setActualPrice(rs.getBigDecimal("actual_price"));
        br.setCheckedIn(rs.getBoolean("is_checked_in"));
        try { br.setRoomNumber(rs.getString("room_number")); } catch (SQLException ignored) {}
        try { br.setRoomTypeName(rs.getString("room_type_name")); } catch (SQLException ignored) {}
        return br;
    }
}
