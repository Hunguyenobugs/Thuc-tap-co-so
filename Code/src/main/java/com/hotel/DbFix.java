package com.hotel;

import com.hotel.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;

public class DbFix {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            System.out.println("Cập nhật lại hash...");
            int updatedUser = stmt.executeUpdate("UPDATE tbl_user SET password_hash = '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2'");
            int updatedCust = stmt.executeUpdate("UPDATE tbl_customer SET password_hash = '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2' WHERE password_hash IS NOT NULL");
            System.out.println("Đã cập nhật tbl_user: " + updatedUser);
            System.out.println("Đã cập nhật tbl_customer: " + updatedCust);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
