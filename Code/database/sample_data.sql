USE hotel_management;

INSERT INTO tbl_hotel (name, address, phone, email, description, star_rating, image_url)
VALUES (
    'Grand Lotus Hotel',
    '123 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',
    '024.3826.1234',
    'info@grandlotus.vn',
    'Grand Lotus Hotel là khách sạn 4 sao nằm tại trung tâm Hà Nội, mang đến trải nghiệm lưu trú sang trọng với dịch vụ đẳng cấp quốc tế.',
    4,
    '/images/hotel/hotel_main.jpg'
);

INSERT INTO tbl_room_type (id, name, capacity, area, base_price, amenities, description, image_url) VALUES
(1, 'Standard',     2, '22m²',  800000.00,  'TV, điều hòa, wifi',                              'Phòng tiêu chuẩn, thoải mái',                     '/images/rooms/standard.jpg'),
(2, 'Deluxe',       2, '28m²',  1500000.00, 'TV, minibar, điều hòa, wifi',                     'View hồ bơi',                                      '/images/rooms/deluxe.jpg'),
(3, 'Superior',     2, '32m²',  1800000.00, 'TV, minibar, điều hòa, wifi, bồn tắm',           'Phòng cao cấp, tầm nhìn đẹp',                     '/images/rooms/superior.jpg'),
(4, 'Family',       4, '45m²',  2200000.00, 'TV, minibar, điều hòa, wifi, bồn tắm, bếp nhỏ', 'Phòng gia đình, rộng rãi',                         '/images/rooms/family.jpg'),
(5, 'Deluxe Suite', 3, '50m²',  2500000.00, 'TV, minibar, điều hòa, wifi, bồn tắm, phòng khách riêng', 'View biển, tầng cao',                  '/images/rooms/deluxe_suite.jpg'),
(6, 'Presidential Suite', 4, '80m²', 5000000.00, 'TV, minibar, điều hòa, wifi, bồn sục, phòng khách, bàn làm việc', 'Suite tổng thống, đẳng cấp nhất', '/images/rooms/presidential.jpg');

INSERT INTO tbl_room (id, room_number, floor, status, description, room_type_id) VALUES
(1,  '101', 1, 'Trống',         'Phòng standard, tầng 1',                1),
(2,  '102', 1, 'Trống',         'Phòng standard, tầng 1',                1),
(3,  '103', 1, 'Trống',         'Phòng standard, tầng 1, gần thang máy', 1),
(4,  '201', 2, 'Trống',         'Phòng standard, tầng 2',                1),
(5,  '202', 2, 'Trống',         'Phòng standard, tầng 2',                1),
(6,  '203', 2, 'Trống',         'Phòng Deluxe, tầng 2',                  2),
(7,  '204', 2, 'Trống',         'Phòng Deluxe, tầng 2',                  2),
(8,  '305', 3, 'Trống',         'Phòng góc, view thành phố',             2),
(9,  '306', 3, 'Trống',         'Phòng Deluxe, tầng 3',                  2),
(10, '305A',3, 'Trống',         'Deluxe Suite, view biển',                5),
(11, '401', 4, 'Trống',         'Phòng Superior, tầng 4',                3),
(12, '412', 4, 'Trống',         'View hồ bơi',                           2),
(13, '501', 5, 'Trống',         'Phòng gia đình, tầng 5',                4),
(14, '502', 5, 'Trống',         'Phòng gia đình, tầng 5',                4),
(15, '601', 6, 'Trống',         'Suite tổng thống',                       6);

INSERT INTO tbl_user (id, employee_code, username, password_hash, full_name, email, phone, role, join_date, status, description) VALUES
(1, 'NV001', 'admin',     SHA2('@Hotel2025', 256), 'Trần Quốc Admin',   'admin@hotel.com',     '0901000001', 'ADMIN',   '2023-01-01', 'active', 'Quản trị hệ thống'),
(2, 'NV002', 'manager01', SHA2('@Hotel2025', 256), 'Lê Văn Manager',    'manager@hotel.com',   '0901000002', 'MANAGER', '2023-01-15', 'active', 'Quản lý khách sạn'),
(3, 'NV003', 'a.nguyen',  SHA2('@Hotel2025', 256), 'Nguyễn Văn A',      'a.nguyen@hotel.com',  '0901000003', 'STAFF',   '2023-06-01', 'active', 'Nhân viên lễ tân'),
(4, 'NV004', 'b.tran',    SHA2('@Hotel2025', 256), 'Trần Thị B',        'b.tran@hotel.com',    '0901000004', 'STAFF',   '2023-07-15', 'active', 'Nhân viên lễ tân'),
(5, 'NV005', 'd.tran',    SHA2('@Hotel2025', 256), 'Trần Văn D',        'd.tran@hotel.com',    '0901000005', 'STAFF',   '2024-01-10', 'active', 'Nhân viên đã nghỉ việc - chờ xóa'),
(6, 'NV006', 'e.pham',    SHA2('@Hotel2025', 256), 'Phạm Thị E',        'e.pham@hotel.com',    '0901000006', 'STAFF',   '2024-03-01', 'active', 'Nhân viên phục vụ phòng');

INSERT INTO tbl_customer (id, id_card, id_type, full_name, nationality, birth_date, gender, phone, email, address, password_hash) VALUES
(1,  '045099000001', 'CCCD', 'Phạm Minh Tuấn',   'Việt Nam', '1988-05-20', 'Nam',  '0911111111', 'tuan.pham@gmail.com',   'Hà Nội',             NULL),
(2,  '045099000002', 'CCCD', 'Hoàng Thị Lan',     'Việt Nam', '1992-11-08', 'Nữ',   '0911111112', 'lan.hoang@gmail.com',   'Hải Phòng',          NULL),
(3,  '045099000003', 'CCCD', 'Vũ Đức Anh',        'Việt Nam', '1985-03-14', 'Nam',  '0911111113', 'anh.vu@gmail.com',      'Đà Nẵng',            NULL),
(4,  '045099000004', 'CCCD', 'Ngô Thị Hương',     'Việt Nam', '1990-07-22', 'Nữ',   '0911111114', 'huong.ngo@gmail.com',   'TP. Hồ Chí Minh',    NULL),
(5,  '045099000005', 'CCCD', 'Đỗ Quang Huy',      'Việt Nam', '1995-01-30', 'Nam',  '0911111115', 'huy.do@gmail.com',      'Hà Nội',             NULL),
(12, '045099001234', 'CCCD', 'Nguyễn Văn B',      'Việt Nam', '1990-04-15', 'Nam',  '0912345678', 'b@gmail.com',           'Hà Nội',             NULL),
(13, '045099005678', 'CCCD', 'Lê Thị C',          'Việt Nam', '1995-03-15', 'Nữ',   '0923456789', 'c.le@gmail.com',        'TP. Hồ Chí Minh',   SHA2('@KhachHang2025', 256)),
(14, '045099006789', 'CCCD', 'Lê Văn D',          'Việt Nam', '1993-08-25', 'Nam',  '0934567890', 'd.le@gmail.com',        'Đà Nẵng',            SHA2('@KhachHang2025', 256));

INSERT INTO tbl_service (id, name, category, unit, price, description) VALUES
(1, 'Buffet sáng',             'Ăn uống',    'phần',   200000.00,  'Buffet sáng tại nhà hàng tầng 1'),
(2, 'Set lunch',               'Ăn uống',    'phần',   350000.00,  'Bữa trưa set menu'),
(3, 'Minibar',                 'Ăn uống',    'lần',    150000.00,  'Đồ uống và snack trong minibar'),
(4, 'Giặt ủi quần áo',        'Giặt ủi',    'kg',     60000.00,   'Giặt và ủi quần áo trong ngày'),
(5, 'Giặt khô đồ vest',       'Giặt ủi',    'bộ',     150000.00,  'Giặt khô chuyên nghiệp cho vest'),
(6, 'Spa trị liệu',           'Spa',        'lần',    500000.00,  'Massage và trị liệu toàn thân 60 phút'),
(7, 'Thuê xe đạp',            'Vận chuyển', 'giờ',    50000.00,   'Thuê xe đạp dạo phố'),
(8, 'Đưa đón sân bay',        'Vận chuyển', 'lượt',   400000.00,  'Xe sedan đưa đón sân bay Nội Bài'),
(9, 'Dịch vụ giữ hành lý',   'Tiện ích',   'ngày',   30000.00,   'Giữ hành lý sau check-out'),
(10,'Phòng gym',               'Giải trí',   'lần',    100000.00,  'Sử dụng phòng tập gym');

INSERT INTO tbl_booking (id, code, customer_id, staff_id, booking_date, deposit_amount, deposit_date, status, special_requests) VALUES
(1,  'PD2025050001', 1,  3, '2025-05-01 09:00:00', 800000.00,  '2025-05-01 09:30:00', 'Đã trả phòng', NULL),
(2,  'PD2025050002', 2,  3, '2025-05-05 10:00:00', 1500000.00, '2025-05-05 10:30:00', 'Đã trả phòng', 'Cần phòng yên tĩnh'),
(3,  'PD2025050003', 3,  4, '2025-05-10 11:00:00', 2500000.00, '2025-05-10 11:30:00', 'Đã trả phòng', NULL),
(10, 'PD2025060312', 12, 3, '2025-06-03 14:00:00', 1500000.00, '2025-06-03 14:30:00', 'Đã xác nhận',  NULL),
(11, 'PD2025061001', 4,  3, '2025-06-08 09:00:00', 2000000.00, '2025-06-08 09:30:00', 'Đã trả phòng', 'Phòng tầng cao'),
(20, 'PD2025070901', 13, NULL, '2025-07-09 20:00:00', 0, NULL, 'Chờ xác nhận', 'Cần thêm gối');

INSERT INTO tbl_booked_room (booking_id, room_id, check_in, check_out, actual_checkin, actual_checkout, actual_price, is_checked_in) VALUES
(1,  1, '2025-05-02', '2025-05-04', '2025-05-02 14:00:00', '2025-05-04 11:00:00', 800000.00, TRUE),
(2,  8, '2025-05-06', '2025-05-09', '2025-05-06 15:00:00', '2025-05-09 10:30:00', 1500000.00, TRUE),
(3,  10, '2025-05-11', '2025-05-14', '2025-05-11 14:30:00', '2025-05-14 11:00:00', 2500000.00, TRUE),
(10, 8, '2025-06-10', '2025-06-13', NULL, NULL, 1500000.00, FALSE),
(11, 12, '2025-06-10', '2025-06-15', '2025-06-10 14:00:00', '2025-06-15 11:00:00', 1500000.00, TRUE),
(20, 6, '2025-07-20', '2025-07-23', NULL, NULL, 1500000.00, FALSE);

INSERT INTO tbl_used_service (booking_id, service_id, quantity, unit_price, used_date) VALUES
(2, 6, 1, 500000.00, '2025-05-07 15:00:00'),
(3, 3, 2, 150000.00, '2025-05-12 20:00:00'),
(3, 4, 1, 60000.00,  '2025-05-13 08:00:00'),
(11, 1, 5, 200000.00, '2025-06-11 07:00:00'),
(11, 8, 1, 400000.00, '2025-06-15 06:00:00');

INSERT INTO tbl_invoice (id, code, booking_id, staff_id, issue_date, room_total, service_total, surcharge, total_amount, paid_amount, payment_method, note) VALUES
(1, 'HD2025050401', 1, 3, '2025-05-04 11:30:00', 1600000.00, 0, 0, 1600000.00, 1600000.00, 'Tiền mặt', NULL),
(2, 'HD2025050901', 2, 3, '2025-05-09 11:00:00', 4500000.00, 500000.00, 0, 5000000.00, 5000000.00, 'Thẻ tín dụng', NULL),
(3, 'HD2025051401', 3, 4, '2025-05-14 11:30:00', 7500000.00, 360000.00, 0, 7860000.00, 7860000.00, 'Chuyển khoản', NULL),
(4, 'HD2025061501', 11, 3, '2025-06-15 11:30:00', 7500000.00, 1400000.00, 0, 8900000.00, 8900000.00, 'Tiền mặt', NULL);

SELECT '--- KIỂM TRA DỮ LIỆU MẪU ---' AS '';
SELECT 'Khách sạn:' AS '', COUNT(*) AS so_ban_ghi FROM tbl_hotel;
SELECT 'Loại phòng:' AS '', COUNT(*) AS so_ban_ghi FROM tbl_room_type;
SELECT 'Phòng:' AS '', COUNT(*) AS so_ban_ghi FROM tbl_room;
SELECT 'Người dùng:' AS '', COUNT(*) AS so_ban_ghi FROM tbl_user;
SELECT 'Khách hàng:' AS '', COUNT(*) AS so_ban_ghi FROM tbl_customer;
SELECT 'Dịch vụ:' AS '', COUNT(*) AS so_ban_ghi FROM tbl_service;
SELECT 'Phiếu đặt:' AS '', COUNT(*) AS so_ban_ghi FROM tbl_booking;
SELECT 'Phòng đặt:' AS '', COUNT(*) AS so_ban_ghi FROM tbl_booked_room;
SELECT 'DV đã dùng:' AS '', COUNT(*) AS so_ban_ghi FROM tbl_used_service;
SELECT 'Hóa đơn:' AS '', COUNT(*) AS so_ban_ghi FROM tbl_invoice;
