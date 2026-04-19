package com.hotel.dao;

import com.hotel.model.Hotel;
import com.hotel.util.DBConnection;
import java.sql.*;

public class HotelDAO {

    public Hotel getHotelInfo() {
        String sql = "SELECT * FROM tbl_hotel LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(Hotel h) {
        String sql = "UPDATE tbl_hotel SET name=?, address=?, phone=?, email=?, description=?, star_rating=?, image_url=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, h.getName());
            ps.setString(2, h.getAddress());
            ps.setString(3, h.getPhone());
            ps.setString(4, h.getEmail());
            ps.setString(5, h.getDescription());
            ps.setInt(6, h.getStarRating());
            ps.setString(7, h.getImageUrl());
            ps.setInt(8, h.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Hotel mapRow(ResultSet rs) throws SQLException {
        Hotel h = new Hotel();
        h.setId(rs.getInt("id"));
        h.setName(rs.getString("name"));
        h.setAddress(rs.getString("address"));
        h.setPhone(rs.getString("phone"));
        h.setEmail(rs.getString("email"));
        h.setDescription(rs.getString("description"));
        h.setStarRating(rs.getInt("star_rating"));
        h.setImageUrl(rs.getString("image_url"));
        h.setCreatedAt(rs.getTimestamp("created_at"));
        h.setUpdatedAt(rs.getTimestamp("updated_at"));
        return h;
    }
}
