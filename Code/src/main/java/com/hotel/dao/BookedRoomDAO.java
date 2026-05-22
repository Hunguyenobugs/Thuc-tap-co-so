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

    private void updateBookingStatus(Connection conn, int bookingId) throws SQLException {
        // Lấy số lượng từng loại trạng thái phòng
        PreparedStatement ps = conn.prepareStatement(
            "SELECT room_status, COUNT(*) FROM tbl_booked_room WHERE booking_id=? GROUP BY room_status"
        );
        ps.setInt(1, bookingId);
        ResultSet rs = ps.executeQuery();
        
        int total = 0;
        int countCho = 0;
        int countCheckin = 0;
        int countCheckout = 0;
        int countHuy = 0;
        
        while (rs.next()) {
            String status = rs.getString(1);
            int count = rs.getInt(2);
            total += count;
            if ("Chờ check in".equals(status)) countCho += count;
            else if ("Đã check-in".equals(status)) countCheckin += count;
            else if ("Đã check-out".equals(status)) countCheckout += count;
            else if ("Đã hủy".equals(status)) countHuy += count;
        }
        
        int totalActive = total - countHuy; // Số phòng không bị hủy
        
        String newStatus;
        if (totalActive == 0) {
            newStatus = "Đã hủy";
        } else if (countCheckout == totalActive) {
            newStatus = "Đã trả phòng";
        } else if (countCheckin == totalActive) {
            newStatus = "Đang lưu trú";
        } else if (countCho == totalActive) {
            // Không nên overwrite 'Chờ xác nhận' nếu nó chưa được duyệt
            // Ta lấy status hiện tại để kiểm tra
            PreparedStatement ps2 = conn.prepareStatement("SELECT status FROM tbl_booking WHERE id=?");
            ps2.setInt(1, bookingId);
            ResultSet rs2 = ps2.executeQuery();
            String currentStatus = "";
            if (rs2.next()) currentStatus = rs2.getString(1);
            
            if ("Chờ xác nhận".equals(currentStatus)) {
                newStatus = "Chờ xác nhận";
            } else {
                newStatus = "Chưa nhận phòng";
            }
        } else {
            newStatus = "Lưu trú một phần";
        }
        
        PreparedStatement psUpdate = conn.prepareStatement("UPDATE tbl_booking SET status=? WHERE id=?");
        psUpdate.setString(1, newStatus);
        psUpdate.setInt(2, bookingId);
        psUpdate.executeUpdate();
    }

    /** Check-in một phòng cụ thể (theo booked_room.id) */
    public boolean checkinRoom(int bookedRoomId, Timestamp actualCheckin) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Lấy booking_id
            int bookingId = 0;
            PreparedStatement ps0 = conn.prepareStatement("SELECT booking_id FROM tbl_booked_room WHERE id=?");
            ps0.setInt(1, bookedRoomId);
            ResultSet rs0 = ps0.executeQuery();
            if (rs0.next()) bookingId = rs0.getInt(1);

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

            // Cập nhật trạng thái booking
            if (bookingId > 0) updateBookingStatus(conn, bookingId);

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
        boolean isLastRoom = false;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int bookingId = 0;
            PreparedStatement ps0 = conn.prepareStatement("SELECT booking_id FROM tbl_booked_room WHERE id=?");
            ps0.setInt(1, bookedRoomId);
            ResultSet rs0 = ps0.executeQuery();
            if (rs0.next()) bookingId = rs0.getInt(1);

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

            // Cập nhật trạng thái booking
            if (bookingId > 0) {
                updateBookingStatus(conn, bookingId);
                
                // Kiểm tra xem có phải phòng cuối không để return
                PreparedStatement ps3 = conn.prepareStatement(
                    "SELECT COUNT(*) FROM tbl_booked_room WHERE booking_id=? AND room_status != 'Đã check-out' AND room_status != 'Đã hủy'");
                ps3.setInt(1, bookingId);
                ResultSet rs3 = ps3.executeQuery();
                if (rs3.next() && rs3.getInt(1) == 0) {
                    isLastRoom = true;
                }
            }

            conn.commit();
            return isLastRoom;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
        return false;
    }
    /** Tìm các phòng có thể check-in (booking chưa nhận phòng, phòng chờ check in) */
    public List<BookedRoom> findReadyForCheckin(String keyword) {
        List<BookedRoom> list = new ArrayList<>();
        String sql = "SELECT br.*, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booked_room br " +
                "JOIN tbl_room r ON br.room_id=r.id " +
                "JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "JOIN tbl_booking b ON br.booking_id=b.id " +
                "JOIN tbl_customer c ON b.customer_id=c.id " +
                "WHERE b.status IN ('Chưa nhận phòng','Lưu trú một phần','Đang lưu trú') " +
                "AND br.room_status='Chờ check in' " +
                "AND (b.code LIKE ? OR c.full_name LIKE ? OR r.room_number LIKE ?) " +
                "ORDER BY br.check_in";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k); ps.setString(3, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookedRoom br = mapRow(rs);
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

    /**
     * Hủy 1 phòng cụ thể (chỉ áp dụng cho phòng đang ở trạng thái 'Chờ check in').
     * Cập nhật trạng thái booking dựa theo status mới nhất.
     */
    public boolean cancelRoom(int bookedRoomId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int bookingId = 0;
            PreparedStatement ps0 = conn.prepareStatement("SELECT booking_id FROM tbl_booked_room WHERE id=?");
            ps0.setInt(1, bookedRoomId);
            ResultSet rs0 = ps0.executeQuery();
            if (rs0.next()) bookingId = rs0.getInt(1);

            // Hủy phòng này
            PreparedStatement ps1 = conn.prepareStatement(
                "UPDATE tbl_booked_room SET room_status='Đã hủy' WHERE id=? AND room_status='Chờ check in'");
            ps1.setInt(1, bookedRoomId);
            int affected = ps1.executeUpdate();
            if (affected == 0) {
                conn.rollback();
                return false; // phòng không ở trạng thái 'Chờ check in'
            }

            // Trả phòng về trạng thái Trống
            PreparedStatement ps2 = conn.prepareStatement(
                "UPDATE tbl_room SET status='Trống' WHERE id=(SELECT room_id FROM tbl_booked_room WHERE id=?)");
            ps2.setInt(1, bookedRoomId);
            ps2.executeUpdate();

            // Cập nhật trạng thái booking
            if (bookingId > 0) updateBookingStatus(conn, bookingId);

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
