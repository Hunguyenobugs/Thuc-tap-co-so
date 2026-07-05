// package com.hotel.listener;

// import com.hotel.util.DBConnection;
// import jakarta.servlet.ServletContextEvent;
// import jakarta.servlet.ServletContextListener;
// import jakarta.servlet.annotation.WebListener;
// import java.io.InputStream;
// import java.nio.charset.StandardCharsets;
// import java.sql.Connection;
// import java.sql.Statement;
// import java.util.Scanner;

// @WebListener
// public class DatabaseInitListener implements ServletContextListener {

//     @Override
//     public void contextInitialized(ServletContextEvent sce) {
//         System.out.println("========== BẮT ĐẦU RESET DATABASE ==========");
//         try (Connection conn = DBConnection.getConnection();
//              Statement stmt = conn.createStatement()) {

//             // Đọc và chạy schema.sql
//             String schemaSql = readSqlFile("/database/schema.sql");
//             if (schemaSql != null) {
//                 System.out.println("Đang thực thi schema.sql...");
//                 stmt.execute(schemaSql);
//             }

//             // Đọc và chạy sample_data.sql
//             String dataSql = readSqlFile("/database/sample_data.sql");
//             if (dataSql != null) {
//                 System.out.println("Đang thực thi sample_data.sql...");
//                 stmt.execute(dataSql);
//             }

//             System.out.println("========== RESET DATABASE THÀNH CÔNG ==========");
            
//             // Dọn dẹp ảnh trong thư mục rooms và hotel (cả deploy và source code)
//             System.out.println("Đang dọn dẹp hình ảnh trong rooms và hotel...");
//             clearFolder(sce.getServletContext().getRealPath("/images/rooms"));
//             clearFolder("d:\\Dai hoc\\Thuc tap co so\\Code\\src\\main\\webapp\\images\\rooms");
//             clearFolder(sce.getServletContext().getRealPath("/images/hotel"));
//             clearFolder("d:\\Dai hoc\\Thuc tap co so\\Code\\src\\main\\webapp\\images\\hotel");
//             System.out.println("Dọn dẹp hình ảnh thành công!");
//         } catch (Exception e) {
//             System.err.println("Lỗi khi reset database: " + e.getMessage());
//             e.printStackTrace();
//         }
//     }

//     private void clearFolder(String path) {
//         if (path == null) return;
//         java.io.File folder = new java.io.File(path);
//         if (folder.exists() && folder.isDirectory()) {
//             java.io.File[] files = folder.listFiles();
//             if (files != null) {
//                 for (java.io.File f : files) {
//                     if (f.isFile()) {
//                         f.delete();
//                     }
//                 }
//             }
//         }
//     }

//     private String readSqlFile(String filePath) {
//         try (InputStream is = getClass().getResourceAsStream(filePath)) {
//             if (is == null) {
//                 System.err.println("Không tìm thấy file: " + filePath);
//                 return null;
//             }
//             try (Scanner scanner = new Scanner(is, StandardCharsets.UTF_8.name())) {
//                 return scanner.useDelimiter("\\A").next();
//             }
//         } catch (Exception e) {
//             System.err.println("Lỗi khi đọc file " + filePath + ": " + e.getMessage());
//             return null;
//         }
//     }

//     @Override
//     public void contextDestroyed(ServletContextEvent sce) {
//         // Do nothing on shutdown
//     }
// }
