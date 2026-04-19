package com.hotel.dao;

import com.hotel.model.RoomType;
import com.hotel.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeDAO {

    public List<RoomType> getAll() {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM tbl_room_type ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public RoomType findById(int id) {
        String sql = "SELECT * FROM tbl_room_type WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<RoomType> searchByName(String keyword) {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM tbl_room_type WHERE name LIKE ? ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(RoomType rt) {
        String sql = "INSERT INTO tbl_room_type (name, capacity, area, base_price, amenities, description, image_url) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rt.getName());
            ps.setInt(2, rt.getCapacity());
            ps.setString(3, rt.getArea());
            ps.setBigDecimal(4, rt.getBasePrice());
            ps.setString(5, rt.getAmenities());
            ps.setString(6, rt.getDescription());
            ps.setString(7, rt.getImageUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(RoomType rt) {
        String sql = "UPDATE tbl_room_type SET name=?, capacity=?, area=?, base_price=?, amenities=?, description=?, image_url=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rt.getName());
            ps.setInt(2, rt.getCapacity());
            ps.setString(3, rt.getArea());
            ps.setBigDecimal(4, rt.getBasePrice());
            ps.setString(5, rt.getAmenities());
            ps.setString(6, rt.getDescription());
            ps.setString(7, rt.getImageUrl());
            ps.setInt(8, rt.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM tbl_room_type WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean hasRooms(int roomTypeId) {
        String sql = "SELECT COUNT(*) FROM tbl_room WHERE room_type_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<RoomType> searchAvailable(String checkIn, String checkOut, int guestCount) {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT DISTINCT rt.* FROM tbl_room_type rt " +
                "JOIN tbl_room r ON r.room_type_id = rt.id " +
                "WHERE rt.capacity >= ? AND r.id NOT IN (" +
                "  SELECT br.room_id FROM tbl_booked_room br " +
                "  JOIN tbl_booking b ON br.booking_id = b.id " +
                "  WHERE b.status NOT IN ('Đã hủy','Đã trả phòng') " +
                "  AND br.check_in < ? AND br.check_out > ?" +
                ") ORDER BY rt.base_price";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guestCount);
            ps.setString(2, checkOut);
            ps.setString(3, checkIn);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private RoomType mapRow(ResultSet rs) throws SQLException {
        RoomType rt = new RoomType();
        rt.setId(rs.getInt("id"));
        rt.setName(rs.getString("name"));
        rt.setCapacity(rs.getInt("capacity"));
        rt.setArea(rs.getString("area"));
        rt.setBasePrice(rs.getBigDecimal("base_price"));
        rt.setAmenities(rs.getString("amenities"));
        rt.setDescription(rs.getString("description"));
        rt.setImageUrl(rs.getString("image_url"));
        rt.setCreatedAt(rs.getTimestamp("created_at"));
        rt.setUpdatedAt(rs.getTimestamp("updated_at"));
        return rt;
    }
}
