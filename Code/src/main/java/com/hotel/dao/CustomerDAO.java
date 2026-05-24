package com.hotel.dao;

import com.hotel.model.Customer;
import com.hotel.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    static {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            boolean hasStatus = false;
            try (ResultSet rs = conn.getMetaData().getColumns(null, null, "tbl_customer", "status")) {
                if (rs.next()) {
                    hasStatus = true;
                }
            }
            if (!hasStatus) {
                stmt.executeUpdate("ALTER TABLE tbl_customer ADD COLUMN status VARCHAR(20) DEFAULT 'active'");
                System.out.println("Da tu dong them cot status vao bang tbl_customer");
            }
        } catch (Exception e) {
            System.err.println("Khong the check/them cot status vao tbl_customer: " + e.getMessage());
        }
    }

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

    public List<Customer> searchByKeyword(String keyword) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM tbl_customer WHERE id_card LIKE ? OR full_name LIKE ? OR phone LIKE ? ORDER BY SUBSTRING_INDEX(full_name, ' ', -1), full_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k);
            ps.setString(2, k);
            ps.setString(3, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Giữ lại tương thích ngược */
    public List<Customer> searchByIdCard(String keyword) {
        return searchByKeyword(keyword);
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

    public Customer findByEmailOrPhoneOrIdCard(String email, String phone, String idCard) {
        String sql = "SELECT * FROM tbl_customer WHERE email=? OR phone=? OR id_card=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, phone);
            ps.setString(3, idCard);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean existsByIdCard(String idCard) {
        String sql = "SELECT COUNT(*) FROM tbl_customer WHERE id_card=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idCard);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
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
        String sql = "INSERT INTO tbl_customer (id_card,id_type,full_name,nationality,birth_date,gender,phone,email,address,password_hash,status) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
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
            ps.setString(11, c.getStatus() != null ? c.getStatus() : "active");
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean update(Customer c) {
        String sql = "UPDATE tbl_customer SET id_card=?, id_type=?, full_name=?, nationality=?, birth_date=?, gender=?, phone=?, email=?, address=?, password_hash=?, status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
            ps.setString(11, c.getStatus() != null ? c.getStatus() : "active");
            ps.setInt(12, c.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsByIdCardExcludeId(String idCard, int id) {
        String sql = "SELECT COUNT(*) FROM tbl_customer WHERE id_card=? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idCard);
            ps.setInt(2, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsByEmailExcludeId(String email, int id) {
        String sql = "SELECT COUNT(*) FROM tbl_customer WHERE email=? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsByPhoneExcludeId(String phone, int id) {
        String sql = "SELECT COUNT(*) FROM tbl_customer WHERE phone=? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setInt(2, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) throws SQLException {
        String sql = "UPDATE tbl_customer SET status='inactive' WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean restore(int id) {
        String sql = "UPDATE tbl_customer SET status='active' WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
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
        c.setStatus(rs.getString("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        return c;
    }
}
