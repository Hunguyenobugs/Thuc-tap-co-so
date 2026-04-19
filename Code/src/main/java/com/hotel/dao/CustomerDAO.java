package com.hotel.dao;

import com.hotel.model.Customer;
import com.hotel.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    public Customer findById(int id) {
        String sql = "SELECT * FROM tbl_customer WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Customer> searchByIdCard(String idCard) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM tbl_customer WHERE id_card LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + idCard + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Customer> searchByPhone(String phone) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM tbl_customer WHERE phone LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + phone + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Customer findByEmailOrPhone(String input) {
        String sql = "SELECT * FROM tbl_customer WHERE email=? OR phone=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, input);
            ps.setString(2, input);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM tbl_customer WHERE email=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsByPhone(String phone) {
        String sql = "SELECT COUNT(*) FROM tbl_customer WHERE phone=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int insert(Customer c) {
        String sql = "INSERT INTO tbl_customer (id_card,id_type,full_name,nationality,birth_date,gender,phone,email,address,password_hash) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getIdCard());
            ps.setString(2, c.getIdType());
            ps.setString(3, c.getFullName());
            ps.setString(4, c.getNationality());
            ps.setDate(5, c.getBirthDate());
            ps.setString(6, c.getGender());
            ps.setString(7, c.getPhone());
            ps.setString(8, c.getEmail());
            ps.setString(9, c.getAddress());
            ps.setString(10, c.getPasswordHash());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    private Customer mapRow(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setId(rs.getInt("id"));
        c.setIdCard(rs.getString("id_card"));
        c.setIdType(rs.getString("id_type"));
        c.setFullName(rs.getString("full_name"));
        c.setNationality(rs.getString("nationality"));
        c.setBirthDate(rs.getDate("birth_date"));
        c.setGender(rs.getString("gender"));
        c.setPhone(rs.getString("phone"));
        c.setEmail(rs.getString("email"));
        c.setAddress(rs.getString("address"));
        c.setPasswordHash(rs.getString("password_hash"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        return c;
    }
}
