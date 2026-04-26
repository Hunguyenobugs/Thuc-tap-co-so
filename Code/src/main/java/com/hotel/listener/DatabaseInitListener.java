package com.hotel.listener;

import com.hotel.util.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Statement;
import java.util.Scanner;

@WebListener
public class DatabaseInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("========== BẮT ĐẦU RESET DATABASE ==========");
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // Đọc và chạy schema.sql
            String schemaSql = readSqlFile("/database/schema.sql");
            if (schemaSql != null) {
                System.out.println("Đang thực thi schema.sql...");
                stmt.execute(schemaSql);
            }

            // Đọc và chạy sample_data.sql
            String dataSql = readSqlFile("/database/sample_data.sql");
            if (dataSql != null) {
                System.out.println("Đang thực thi sample_data.sql...");
                stmt.execute(dataSql);
            }

            System.out.println("========== RESET DATABASE THÀNH CÔNG ==========");
        } catch (Exception e) {
            System.err.println("Lỗi khi reset database: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private String readSqlFile(String filePath) {
        try (InputStream is = getClass().getResourceAsStream(filePath)) {
            if (is == null) {
                System.err.println("Không tìm thấy file: " + filePath);
                return null;
            }
            try (Scanner scanner = new Scanner(is, StandardCharsets.UTF_8.name())) {
                return scanner.useDelimiter("\\A").next();
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi đọc file " + filePath + ": " + e.getMessage());
            return null;
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Do nothing on shutdown
    }
}
