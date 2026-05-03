package com.hotel.dao;

import com.hotel.model.User;
import com.hotel.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM tbl_user ORDER BY role, full_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public User findById(int id) {
        String sql = "SELECT * FROM tbl_user WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public User findByUsername(String username) {
        String sql = "SELECT * FROM tbl_user WHERE username=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<User> searchByUsernameOrCode(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM tbl_user WHERE username LIKE ? OR employee_code LIKE ? OR full_name LIKE ? ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k); ps.setString(3, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM tbl_user WHERE username=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsByEmployeeCode(String employeeCode) {
        String sql = "SELECT COUNT(*) FROM tbl_user WHERE employee_code=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, employeeCode);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsByEmployeeCodeExcludeId(String employeeCode, int id) {
        String sql = "SELECT COUNT(*) FROM tbl_user WHERE employee_code=? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, employeeCode);
            ps.setInt(2, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM tbl_user WHERE email=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsByEmailExcludeId(String email, int id) {
        String sql = "SELECT COUNT(*) FROM tbl_user WHERE email=? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsByPhone(String phone) {
        String sql = "SELECT COUNT(*) FROM tbl_user WHERE phone=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsByPhoneExcludeId(String phone, int id) {
        String sql = "SELECT COUNT(*) FROM tbl_user WHERE phone=? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setInt(2, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsByUsernameExcludeId(String username, int id) {
        String sql = "SELECT COUNT(*) FROM tbl_user WHERE username=? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean insert(User u) {
        String sql = "INSERT INTO tbl_user (employee_code,username,password_hash,full_name,email,phone,role,join_date,status,description,avatar_url) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getEmployeeCode());
            ps.setString(2, u.getUsername());
            ps.setString(3, u.getPasswordHash());
            ps.setString(4, u.getFullName());
            ps.setString(5, u.getEmail());
            ps.setString(6, u.getPhone());
            ps.setString(7, u.getRole());
            ps.setDate(8, u.getJoinDate());
            ps.setString(9, u.getStatus() != null ? u.getStatus() : "active");
            ps.setString(10, u.getDescription());
            ps.setString(11, u.getAvatarUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(User u) {
        String sql = "UPDATE tbl_user SET username=?,password_hash=?,full_name=?,email=?,phone=?,role=?,join_date=?,status=?,description=?,avatar_url=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPasswordHash());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getPhone());
            ps.setString(6, u.getRole());
            ps.setDate(7, u.getJoinDate());
            ps.setString(8, u.getStatus());
            ps.setString(9, u.getDescription());
            ps.setString(10, u.getAvatarUrl());
            ps.setInt(11, u.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "UPDATE tbl_user SET status='inactive' WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean restore(int id) {
        String sql = "UPDATE tbl_user SET status='active' WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updatePassword(int userId, String newHash) {
        String sql = "UPDATE tbl_user SET password_hash=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean hasRelatedData(int userId) {
        String sql = "SELECT (SELECT COUNT(*) FROM tbl_booking WHERE staff_id=?) + (SELECT COUNT(*) FROM tbl_invoice WHERE staff_id=?) AS total";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total") > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setEmployeeCode(rs.getString("employee_code"));
        u.setUsername(rs.getString("username"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setJoinDate(rs.getDate("join_date"));
        u.setStatus(rs.getString("status"));
        u.setDescription(rs.getString("description"));
        u.setAvatarUrl(rs.getString("avatar_url"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));
        return u;
    }
}
