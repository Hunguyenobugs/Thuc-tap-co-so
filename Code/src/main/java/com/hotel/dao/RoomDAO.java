package com.hotel.dao;

import com.hotel.model.Room;
import com.hotel.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public List<Room> getAll() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS room_type_name FROM tbl_room r JOIN tbl_room_type rt ON r.room_type_id=rt.id ORDER BY r.room_number";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Room findById(int id) {
        String sql = "SELECT r.*, rt.name AS room_type_name FROM tbl_room r JOIN tbl_room_type rt ON r.room_type_id=rt.id WHERE r.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Room> searchByNumber(String keyword) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS room_type_name FROM tbl_room r JOIN tbl_room_type rt ON r.room_type_id=rt.id WHERE r.room_number LIKE ? ORDER BY r.room_number";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean existsByNumber(String roomNumber) {
        String sql = "SELECT COUNT(*) FROM tbl_room WHERE room_number=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roomNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean insert(Room r) {
        String sql = "INSERT INTO tbl_room (room_number, floor, status, description, room_type_id) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getRoomNumber());
            ps.setInt(2, r.getFloor());
            ps.setString(3, r.getStatus());
            ps.setString(4, r.getDescription());
            ps.setInt(5, r.getRoomTypeId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Room r) {
        String sql = "UPDATE tbl_room SET room_number=?, floor=?, status=?, description=?, room_type_id=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getRoomNumber());
            ps.setInt(2, r.getFloor());
            ps.setString(3, r.getStatus());
            ps.setString(4, r.getDescription());
            ps.setInt(5, r.getRoomTypeId());
            ps.setInt(6, r.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM tbl_room WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean hasActiveBooking(int roomId) {
        String sql = "SELECT COUNT(*) FROM tbl_booked_room br JOIN tbl_booking b ON br.booking_id=b.id WHERE br.room_id=? AND b.status NOT IN ('Đã hủy','Đã trả phòng')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Room> searchFreeRooms(String checkIn, String checkOut, int roomTypeId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS room_type_name, rt.base_price FROM tbl_room r " +
                "JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE r.room_type_id=? AND r.id NOT IN (" +
                "  SELECT br.room_id FROM tbl_booked_room br " +
                "  JOIN tbl_booking b ON br.booking_id=b.id " +
                "  WHERE b.status NOT IN ('Đã hủy','Đã trả phòng') " +
                "  AND br.check_in < ? AND br.check_out > ?" +
                ") ORDER BY r.room_number";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.setString(2, checkOut);
            ps.setString(3, checkIn);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Room room = mapRow(rs);
                room.setBasePrice(rs.getString("base_price"));
                list.add(room);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public void updateStatus(int roomId, String status) {
        String sql = "UPDATE tbl_room SET status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, roomId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private Room mapRow(ResultSet rs) throws SQLException {
        Room r = new Room();
        r.setId(rs.getInt("id"));
        r.setRoomNumber(rs.getString("room_number"));
        r.setFloor(rs.getInt("floor"));
        r.setStatus(rs.getString("status"));
        r.setDescription(rs.getString("description"));
        r.setRoomTypeId(rs.getInt("room_type_id"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        r.setUpdatedAt(rs.getTimestamp("updated_at"));
        try { r.setRoomTypeName(rs.getString("room_type_name")); } catch (SQLException ignored) {}
        return r;
    }
}
