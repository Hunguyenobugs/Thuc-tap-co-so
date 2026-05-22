package com.hotel.dao;

import com.hotel.model.Booking;
import com.hotel.model.BookedRoom;
import com.hotel.util.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public Booking findById(int id) {
        String sql = "SELECT b.*, c.full_name AS customer_name, c.id_card AS customer_id_card, c.phone AS customer_phone, " +
                "u.full_name AS staff_name, u.employee_code AS staff_code, " +
                "br.check_in, br.check_out, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booking b " +
                "JOIN tbl_customer c ON b.customer_id=c.id " +
                "LEFT JOIN tbl_user u ON b.staff_id=u.id " +
                "LEFT JOIN tbl_booked_room br ON br.booking_id=b.id " +
                "LEFT JOIN tbl_room r ON br.room_id=r.id " +
                "LEFT JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE b.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRowFull(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Booking findByCode(String code) {
        String sql = "SELECT b.*, c.full_name AS customer_name FROM tbl_booking b JOIN tbl_customer c ON b.customer_id=c.id WHERE b.code=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRowBasic(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Booking> searchByCodeOrCustomer(String keyword) {
        List<Booking> list = new ArrayList<>();
        // Trả về từng booking (không nhân bản theo phòng), thêm số phòng
        String sql = "SELECT b.*, c.full_name AS customer_name, c.id_card AS customer_id_card, c.phone AS customer_phone, " +
                "u.full_name AS staff_name, u.employee_code AS staff_code, " +
                "COUNT(br.id) AS room_count " +
                "FROM tbl_booking b JOIN tbl_customer c ON b.customer_id=c.id " +
                "LEFT JOIN tbl_user u ON b.staff_id=u.id " +
                "LEFT JOIN tbl_booked_room br ON br.booking_id=b.id " +
                "WHERE b.code LIKE ? OR c.full_name LIKE ? " +
                "GROUP BY b.id ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = mapRowBasic(rs);
                b.setRoomCount(rs.getInt("room_count"));
                try { b.setStaffName(rs.getString("staff_name")); } catch (SQLException ignored) {}
                try { b.setStaffCode(rs.getString("staff_code")); } catch (SQLException ignored) {}
                try { b.setCustomerIdCard(rs.getString("customer_id_card")); } catch (SQLException ignored) {}
                try { b.setCustomerPhone(rs.getString("customer_phone")); } catch (SQLException ignored) {}
                list.add(b);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Check-in: Trả về bookings ('Chưa nhận phòng' HOẶC 'Lưu trú một phần' HOẶC 'Đang lưu trú') có ít nhất 1 phòng còn chờ check-in */
    public List<Booking> searchForCheckin(String keyword) {
        return searchBookingsWithRooms(
            "WHERE b.status IN ('Chưa nhận phòng','Lưu trú một phần','Đang lưu trú') " +
            "AND EXISTS (SELECT 1 FROM tbl_booked_room brx WHERE brx.booking_id=b.id AND brx.room_status='Chờ check in') " +
            "AND (b.code LIKE ? OR c.full_name LIKE ?)",
            // room filter: chỉ lấy phòng đang chờ check-in
            "AND br.room_status='Chờ check in'",
            keyword);
    }

    /** Check-out: Trả về bookings Đang lưu trú có ít nhất 1 phòng đã check-in */
    public List<Booking> searchForCheckout(String keyword) {
        return searchBookingsWithRooms(
            "WHERE b.status IN ('Lưu trú một phần','Đang lưu trú') " +
            "AND EXISTS (SELECT 1 FROM tbl_booked_room brx WHERE brx.booking_id=b.id AND brx.room_status='Đã check-in') " +
            "AND (b.code LIKE ? OR c.full_name LIKE ?)",
            "AND br.room_status='Đã check-in'",
            keyword);
    }

    /** Dịch vụ: Trả về bookings Đang lưu trú kèm tất cả phòng đang ở */
    public List<Booking> searchForService(String keyword) {
        return searchBookingsWithRooms(
            "WHERE b.status IN ('Lưu trú một phần','Đang lưu trú') " +
            "AND EXISTS (SELECT 1 FROM tbl_booked_room brx WHERE brx.booking_id=b.id AND brx.room_status='Đã check-in') " +
            "AND (b.code LIKE ? OR c.full_name LIKE ?)",
            "AND br.room_status='Đã check-in'",
            keyword);
    }

    /** Hủy: Trả về bookings có ít nhất 1 phòng 'Chờ check in' có thể hủy */
    public List<Booking> searchForCancel(String keyword) {
        return searchBookingsWithRooms(
            "WHERE b.status IN ('Chờ xác nhận','Chưa nhận phòng','Lưu trú một phần') " +
            "AND EXISTS (SELECT 1 FROM tbl_booked_room brx WHERE brx.booking_id=b.id AND brx.room_status='Chờ check in') " +
            "AND (b.code LIKE ? OR c.full_name LIKE ?)",
            // Chỉ hiện phòng đang 'Chờ check in' (chưa check-in, chưa hủy)
            "AND br.room_status='Chờ check in'",
            keyword);
    }

    /**
     * Hàm chung: trả về danh sách Booking, mỗi Booking gắn sẵn List<BookedRoom> rooms.
     * @param bookingWhere  điều kiện lọc booking (có ? cho keyword x2)
     * @param roomFilter    điều kiện lọc phòng con (AND ...)
     * @param keyword       từ khóa tìm kiếm
     */
    private List<Booking> searchBookingsWithRooms(String bookingWhere, String roomFilter, String keyword) {
        List<Booking> bookings = new ArrayList<>();
        // 1. Lấy danh sách booking distinct
        String sqlB = "SELECT b.*, c.full_name AS customer_name, c.phone AS customer_phone, c.id_card AS customer_id_card, " +
                "u.full_name AS staff_name, u.employee_code AS staff_code " +
                "FROM tbl_booking b JOIN tbl_customer c ON b.customer_id=c.id " +
                "LEFT JOIN tbl_user u ON b.staff_id=u.id " +
                bookingWhere +
                " ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlB)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = mapRowBasic(rs);
                try { b.setCustomerPhone(rs.getString("customer_phone")); } catch (SQLException ignored) {}
                try { b.setCustomerIdCard(rs.getString("customer_id_card")); } catch (SQLException ignored) {}
                try { b.setStaffName(rs.getString("staff_name")); } catch (SQLException ignored) {}
                try { b.setStaffCode(rs.getString("staff_code")); } catch (SQLException ignored) {}
                bookings.add(b);
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // 2. Với mỗi booking, lấy danh sách phòng con
        String sqlR = "SELECT br.*, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booked_room br " +
                "JOIN tbl_room r ON br.room_id=r.id " +
                "JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE br.booking_id=? " + roomFilter +
                " ORDER BY br.check_in";
        for (Booking b : bookings) {
            List<BookedRoom> rooms = new ArrayList<>();
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sqlR)) {
                ps.setInt(1, b.getId());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
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
                    br.setRoomNumber(rs.getString("room_number"));
                    br.setRoomTypeName(rs.getString("room_type_name"));
                    rooms.add(br);
                }
            } catch (SQLException e) { e.printStackTrace(); }
            b.setRooms(rooms);
            b.setRoomCount(rooms.size());
        }
        return bookings;
    }


    public List<Booking> findByCustomer(int customerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name AS customer_name, br.check_in, br.check_out, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booking b JOIN tbl_customer c ON b.customer_id=c.id " +
                "LEFT JOIN tbl_booked_room br ON br.booking_id=b.id " +
                "LEFT JOIN tbl_room r ON br.room_id=r.id " +
                "LEFT JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE b.customer_id=? ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Trả về danh sách booking của khách hàng, mỗi booking gắn List<BookedRoom> rooms */
    public List<Booking> findByCustomerGrouped(int customerId) {
        List<Booking> bookings = new ArrayList<>();
        // 1. Lấy danh sách booking
        String sqlB = "SELECT b.*, c.full_name AS customer_name, c.phone AS customer_phone, c.id_card AS customer_id_card " +
                "FROM tbl_booking b JOIN tbl_customer c ON b.customer_id=c.id " +
                "WHERE b.customer_id=? ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlB)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = mapRowBasic(rs);
                try { b.setCustomerPhone(rs.getString("customer_phone")); } catch (SQLException ignored) {}
                try { b.setCustomerIdCard(rs.getString("customer_id_card")); } catch (SQLException ignored) {}
                bookings.add(b);
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // 2. Với mỗi booking, lấy danh sách phòng
        String sqlR = "SELECT br.*, r.room_number, rt.name AS room_type_name " +
                "FROM tbl_booked_room br " +
                "JOIN tbl_room r ON br.room_id=r.id " +
                "JOIN tbl_room_type rt ON r.room_type_id=rt.id " +
                "WHERE br.booking_id=? ORDER BY br.check_in";
        for (Booking b : bookings) {
            List<BookedRoom> rooms = new ArrayList<>();
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sqlR)) {
                ps.setInt(1, b.getId());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
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
                    br.setRoomNumber(rs.getString("room_number"));
                    br.setRoomTypeName(rs.getString("room_type_name"));
                    rooms.add(br);
                }
            } catch (SQLException e) { e.printStackTrace(); }
            b.setRooms(rooms);
            b.setRoomCount(rooms.size());
        }
        return bookings;
    }

    public String generateCode() {
        LocalDate now = LocalDate.now();
        String prefix = "PD" + now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String sql = "SELECT code FROM tbl_booking WHERE code LIKE ? ORDER BY code DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String last = rs.getString("code");
                int seq = Integer.parseInt(last.substring(prefix.length())) + 1;
                return prefix + String.format("%02d", seq);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return prefix + "01";
    }

    public int insert(Booking b, BookedRoom br) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sql1 = "INSERT INTO tbl_booking (code,customer_id,staff_id,booking_date,deposit_amount,deposit_date,status,note) VALUES (?,?,?,NOW(),?,?,?,?)";
            PreparedStatement ps1 = conn.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, b.getCode());
            ps1.setInt(2, b.getCustomerId());
            if (b.getStaffId() != null) ps1.setInt(3, b.getStaffId()); else ps1.setNull(3, Types.INTEGER);
            ps1.setBigDecimal(4, b.getDepositAmount() != null ? b.getDepositAmount() : BigDecimal.ZERO);
            ps1.setTimestamp(5, b.getDepositDate());
            ps1.setString(6, b.getStatus());
            ps1.setString(7, b.getNote());
            ps1.executeUpdate();
            ResultSet keys = ps1.getGeneratedKeys();
            int bookingId = 0;
            if (keys.next()) bookingId = keys.getInt(1);

            String sql2 = "INSERT INTO tbl_booked_room (booking_id,room_id,check_in,check_out,actual_price,is_checked_in,room_status) VALUES (?,?,?,?,?,FALSE,'Chờ check in')";
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, bookingId);
            ps2.setInt(2, br.getRoomId());
            ps2.setTimestamp(3, br.getCheckIn());
            ps2.setTimestamp(4, br.getCheckOut());
            ps2.setBigDecimal(5, br.getActualPrice());
            ps2.executeUpdate();

            conn.commit();
            return bookingId;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
        return -1;
    }

    public int insertMultiple(Booking b, List<BookedRoom> rooms) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sql1 = "INSERT INTO tbl_booking (code,customer_id,staff_id,booking_date,deposit_amount,deposit_date,status,note) VALUES (?,?,?,NOW(),?,?,?,?)";
            PreparedStatement ps1 = conn.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, b.getCode());
            ps1.setInt(2, b.getCustomerId());
            if (b.getStaffId() != null) ps1.setInt(3, b.getStaffId()); else ps1.setNull(3, Types.INTEGER);
            ps1.setBigDecimal(4, b.getDepositAmount() != null ? b.getDepositAmount() : BigDecimal.ZERO);
            ps1.setTimestamp(5, b.getDepositDate());
            ps1.setString(6, b.getStatus());
            ps1.setString(7, b.getNote());
            ps1.executeUpdate();
            ResultSet keys = ps1.getGeneratedKeys();
            int bookingId = 0;
            if (keys.next()) bookingId = keys.getInt(1);

            String sql2 = "INSERT INTO tbl_booked_room (booking_id,room_id,check_in,check_out,actual_price,is_checked_in,room_status) VALUES (?,?,?,?,?,FALSE,'Chờ check in')";
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            for (BookedRoom br : rooms) {
                ps2.setInt(1, bookingId);
                ps2.setInt(2, br.getRoomId());
                ps2.setTimestamp(3, br.getCheckIn());
                ps2.setTimestamp(4, br.getCheckOut());
                ps2.setBigDecimal(5, br.getActualPrice());
                ps2.addBatch();
            }
            ps2.executeBatch();

            conn.commit();
            return bookingId;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
        return -1;
    }


    public boolean cancel(int bookingId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Cập nhật trạng thái của cả phiếu đặt
            try (PreparedStatement ps1 = conn.prepareStatement("UPDATE tbl_booking SET status='Đã hủy' WHERE id=?")) {
                ps1.setInt(1, bookingId);
                ps1.executeUpdate();
            }

            // 2. Giải phóng các phòng trong tbl_room (những phòng thuộc booking này và đang ở trạng thái 'Chờ check in')
            String sqlReleaseRooms = "UPDATE tbl_room SET status='Trống' WHERE id IN (" +
                                     "SELECT room_id FROM tbl_booked_room WHERE booking_id=? AND room_status='Chờ check in')";
            try (PreparedStatement ps2 = conn.prepareStatement(sqlReleaseRooms)) {
                ps2.setInt(1, bookingId);
                ps2.executeUpdate();
            }

            // 3. Cập nhật trạng thái các phòng trong tbl_booked_room thành 'Đã hủy' (chỉ những phòng đang 'Chờ check in')
            try (PreparedStatement ps3 = conn.prepareStatement("UPDATE tbl_booked_room SET room_status='Đã hủy' WHERE booking_id=? AND room_status='Chờ check in'")) {
                ps3.setInt(1, bookingId);
                ps3.executeUpdate();
            }

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

    public boolean cancelBookedRoom(int bookedRoomId, int customerId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Lấy thông tin booking_id của booked_room này và kiểm tra khách hàng sở hữu
            int bookingId = 0;
            int roomId = 0;
            String sqlCheck = "SELECT br.booking_id, br.room_id FROM tbl_booked_room br " +
                              "JOIN tbl_booking b ON br.booking_id = b.id " +
                              "WHERE br.id=? AND b.customer_id=?";
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, bookedRoomId);
                ps.setInt(2, customerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        bookingId = rs.getInt("booking_id");
                        roomId = rs.getInt("room_id");
                    }
                }
            }

            if (bookingId == 0) {
                conn.rollback();
                return false;
            }

            // Kiểm tra trạng thái xem phòng đã được check-in chưa
            String sqlStatusCheck = "SELECT room_status FROM tbl_booked_room WHERE id=?";
            try (PreparedStatement ps = conn.prepareStatement(sqlStatusCheck)) {
                ps.setInt(1, bookedRoomId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String currentStatus = rs.getString("room_status");
                        if (!"Chờ check in".equals(currentStatus)) {
                            // Chỉ cho phép hủy khi trạng thái là 'Chờ check in'
                            conn.rollback();
                            return false;
                        }
                    }
                }
            }

            // 2. Cập nhật trạng thái phòng của booked_room thành 'Đã hủy'
            try (PreparedStatement ps = conn.prepareStatement("UPDATE tbl_booked_room SET room_status='Đã hủy' WHERE id=?")) {
                ps.setInt(1, bookedRoomId);
                ps.executeUpdate();
            }

            // 3. Cập nhật trạng thái phòng trong tbl_room thành 'Trống'
            try (PreparedStatement ps = conn.prepareStatement("UPDATE tbl_room SET status='Trống' WHERE id=?")) {
                ps.setInt(1, roomId);
                ps.executeUpdate();
            }

            // 4. Kiểm tra xem toàn bộ các phòng trong booking đã bị hủy chưa
            boolean allCancelled = true;
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM tbl_booked_room WHERE booking_id=? AND room_status != 'Đã hủy'")) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        allCancelled = rs.getInt(1) == 0;
                    }
                }
            }

            // 5. Nếu tất cả phòng bị hủy, cập nhật trạng thái booking thành 'Đã hủy'
            if (allCancelled) {
                try (PreparedStatement ps = conn.prepareStatement("UPDATE tbl_booking SET status='Đã hủy' WHERE id=?")) {
                    ps.setInt(1, bookingId);
                    ps.executeUpdate();
                }
            }

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

    public boolean approveBooking(int bookingId, int staffId) {
        String sql = "UPDATE tbl_booking SET status='Chưa nhận phòng', staff_id=? WHERE id=?";
        try (java.sql.Connection conn = DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (java.sql.SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean checkin(int bookingId, Timestamp actualCheckin) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            conn.prepareStatement("UPDATE tbl_booking SET status='Đang lưu trú' WHERE id=" + bookingId).executeUpdate();
            PreparedStatement ps2 = conn.prepareStatement("UPDATE tbl_booked_room SET actual_checkin=?, is_checked_in=TRUE WHERE booking_id=?");
            ps2.setTimestamp(1, actualCheckin);
            ps2.setInt(2, bookingId);
            ps2.executeUpdate();

            PreparedStatement ps3 = conn.prepareStatement(
                "UPDATE tbl_room SET status='Đang sử dụng' WHERE id IN (SELECT room_id FROM tbl_booked_room WHERE booking_id=?)");
            ps3.setInt(1, bookingId);
            ps3.executeUpdate();

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

    public boolean updateBookedRoom(int bookingId, int newRoomId, BigDecimal newPrice) {
        String sql = "UPDATE tbl_booked_room SET room_id=?, actual_price=? WHERE booking_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newRoomId);
            ps.setBigDecimal(2, newPrice);
            ps.setInt(3, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Booking mapRowBasic(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setCode(rs.getString("code"));
        b.setCustomerId(rs.getInt("customer_id"));
        int sid = rs.getInt("staff_id"); b.setStaffId(rs.wasNull() ? null : sid);
        b.setBookingDate(rs.getTimestamp("booking_date"));
        b.setStatus(rs.getString("status"));
        b.setNote(rs.getString("note"));
        try { b.setCustomerName(rs.getString("customer_name")); } catch (SQLException ignored) {}
        try { b.setStaffName(rs.getString("staff_name")); } catch (SQLException ignored) {}
        try { b.setStaffCode(rs.getString("staff_code")); } catch (SQLException ignored) {}
        return b;
    }

    private Booking mapRowFull(ResultSet rs) throws SQLException {
        Booking b = mapRowBasic(rs);
        try { b.setCheckIn(rs.getString("check_in")); } catch (SQLException ignored) {}
        try { b.setCheckOut(rs.getString("check_out")); } catch (SQLException ignored) {}
        try { b.setRoomNumber(rs.getString("room_number")); } catch (SQLException ignored) {}
        try { b.setRoomTypeName(rs.getString("room_type_name")); } catch (SQLException ignored) {}
        try { b.setStaffName(rs.getString("staff_name")); } catch (SQLException ignored) {}
        try { b.setCustomerIdCard(rs.getString("customer_id_card")); } catch (SQLException ignored) {}
        try { b.setCustomerPhone(rs.getString("customer_phone")); } catch (SQLException ignored) {}
        return b;
    }
}
