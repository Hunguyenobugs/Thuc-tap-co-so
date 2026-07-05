-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                         DỮ LIỆU CŨ (ĐÃ COMMENT)                          ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

/*
-- Dữ liệu khách sạn
INSERT INTO tbl_hotel (name, address, phone, email, description, star_rating, image_url)
VALUES (
    'Aurora Hotel',
    '123 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',
    '024.3826.1234',
    'info@grandlotus.vn',
    'Grand Lotus Hotel là khách sạn 4 sao nằm tại trung tâm Hà Nội, mang đến trải nghiệm lưu trú sang trọng với dịch vụ đẳng cấp quốc tế.',
    4,
    '/images/hotel/hotel_main.jpg'
);

-- Loại phòng
INSERT INTO tbl_room_type (id, name, capacity, area, base_price, amenities, description, image_url) VALUES
(1, 'Standard',          2, '22m²',  800000.00,  'TV, điều hòa, wifi',                              'Phòng tiêu chuẩn, thoải mái',                      '/images/rooms/standard.jpg'),
(2, 'Deluxe',            2, '28m²',  1500000.00, 'TV, minibar, điều hòa, wifi',                     'View hồ bơi',                                       '/images/rooms/deluxe.jpg'),
(3, 'Superior',          2, '32m²',  1800000.00, 'TV, minibar, điều hòa, wifi, bồn tắm',            'Phòng cao cấp, tầm nhìn đẹp',                      '/images/rooms/superior.jpg'),
(4, 'Family',            4, '45m²',  2200000.00, 'TV, minibar, điều hòa, wifi, bồn tắm, bếp nhỏ',  'Phòng gia đình, rộng rãi',                          '/images/rooms/family.jpg'),
(5, 'Deluxe Suite',      3, '50m²',  2500000.00, 'TV, minibar, điều hòa, wifi, bồn tắm, phòng khách riêng', 'View biển, tầng cao',                 '/images/rooms/deluxe_suite.jpg'),
(6, 'Presidential Suite',4, '80m²',  5000000.00, 'TV, minibar, điều hòa, wifi, bồn sục, phòng khách, bàn làm việc', 'Suite tổng thống, đẳng cấp nhất', '/images/rooms/presidential.jpg');

-- Phòng (trạng thái khớp với dữ liệu booking bên dưới)
INSERT INTO tbl_room (id, room_number, floor, status, description, room_type_id) VALUES
(1,  '101',  1, 'Trống',        'Phòng standard, tầng 1',                1),
(2,  '102',  1, 'Đang sử dụng', 'Phòng standard, tầng 1',                1),
(3,  '103',  1, 'Trống',        'Phòng standard, tầng 1, gần thang máy', 1),
(4,  '201',  2, 'Đang sử dụng', 'Phòng standard, tầng 2',                1),
(5,  '202',  2, 'Trống',        'Phòng standard, tầng 2',                1),
(6,  '203',  2, 'Bảo trì',      'Phòng Deluxe, hỏng điều hòa',           2),
(7,  '204',  2, 'Trống',        'Phòng Deluxe, tầng 2',                  2),
(8,  '305',  3, 'Đang sử dụng', 'Phòng góc, view thành phố',             2),
(9,  '306',  3, 'Trống',        'Phòng Deluxe, tầng 3',                  2),
(10, '305A', 3, 'Trống',        'Deluxe Suite, view biển',                5),
(11, '401',  4, 'Trống',        'Phòng Superior, tầng 4',                3),
(12, '412',  4, 'Đang sử dụng', 'View hồ bơi',                           2),
(13, '501',  5, 'Trống',        'Phòng gia đình, tầng 5',                4),
(14, '502',  5, 'Trống',        'Phòng gia đình, tầng 5',                4),
(15, '601',  6, 'Trống',        'Suite tổng thống',                       6);

-- Nhân viên
INSERT INTO tbl_user (id, employee_code, username, password_hash, full_name, email, phone, role, join_date, status, description) VALUES
(1, 'NV001', 'admin',     '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2', 'Trần Quốc Admin',   'admin@hotel.com',     '0901000001', 'ADMIN',   '2023-01-01', 'active', 'Quản trị hệ thống'),
(2, 'NV002', 'manager01', '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2', 'Lê Văn Manager',    'manager@hotel.com',   '0901000002', 'MANAGER', '2023-01-15', 'active', 'Quản lý khách sạn'),
(3, 'NV003', 'a.nguyen',  '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2', 'Nguyễn Văn A',      'a.nguyen@hotel.com',  '0901000003', 'STAFF',   '2023-06-01', 'active', 'Nhân viên lễ tân'),
(4, 'NV004', 'b.tran',    '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2', 'Trần Thị B',        'b.tran@hotel.com',    '0901000004', 'STAFF',   '2023-07-15', 'active', 'Nhân viên lễ tân');

-- Khách hàng
INSERT INTO tbl_customer (id, id_card, id_type, full_name, nationality, birth_date, gender, phone, email, address, password_hash) VALUES
(1,  '045099000001', 'CCCD', 'Phạm Minh Tuấn',   'Việt Nam', '1988-05-20', 'Nam',  '0911111111', 'tuan.pham@gmail.com',   'Hà Nội',           NULL),
(2,  '045099000002', 'CCCD', 'Hoàng Thị Lan',     'Việt Nam', '1992-11-08', 'Nữ',   '0911111112', 'lan.hoang@gmail.com',   'Hải Phòng',        NULL),
(3,  '045099000003', 'CCCD', 'Vũ Đức Anh',        'Việt Nam', '1985-03-14', 'Nam',  '0911111113', 'anh.vu@gmail.com',      'Đà Nẵng',          NULL),
(4,  '045099000004', 'CCCD', 'Ngô Thị Hương',     'Việt Nam', '1990-07-22', 'Nữ',   '0911111114', 'huong.ngo@gmail.com',   'TP. Hồ Chí Minh',  NULL),
(5,  '045099000005', 'CCCD', 'Đỗ Quang Huy',      'Việt Nam', '1995-01-30', 'Nam',  '0911111115', 'huy.do@gmail.com',      'Hà Nội',           NULL),
(6,  '045099001234', 'CCCD', 'Nguyễn Văn B',      'Việt Nam', '1990-04-15', 'Nam',  '0912345678', 'b@gmail.com',           'Hà Nội',           NULL),
(7,  '045099005678', 'CCCD', 'Lê Thị C',          'Việt Nam', '1995-03-15', 'Nữ',   '0923456789', 'c.le@gmail.com',        'TP. Hồ Chí Minh',  '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2'),
(8,  '045099006789', 'CCCD', 'Lê Văn D',          'Việt Nam', '1993-08-25', 'Nam',  '0934567890', 'd.le@gmail.com',        'Đà Nẵng',          '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2');

-- Dịch vụ
INSERT INTO tbl_service (id, name, category, unit, price, description) VALUES
(1,  'Buffet sáng',           'Ăn uống',    'phần',  200000.00, 'Buffet sáng tại nhà hàng tầng 1'),
(2,  'Set lunch',             'Ăn uống',    'phần',  350000.00, 'Bữa trưa set menu'),
(3,  'Minibar',               'Ăn uống',    'lần',   150000.00, 'Đồ uống và snack trong minibar'),
(4,  'Giặt ủi quần áo',      'Giặt ủi',    'kg',    60000.00,  'Giặt và ủi quần áo trong ngày'),
(5,  'Giặt khô đồ vest',     'Giặt ủi',    'bộ',    150000.00, 'Giặt khô chuyên nghiệp cho vest'),
(6,  'Spa trị liệu',          'Spa',        'lần',   500000.00, 'Massage và trị liệu toàn thân 60 phút'),
(7,  'Thuê xe đạp',           'Vận chuyển', 'giờ',   50000.00,  'Thuê xe đạp dạo phố'),
(8,  'Đưa đón sân bay',       'Vận chuyển', 'lượt',  400000.00, 'Xe sedan đưa đón sân bay Nội Bài'),
(9,  'Dịch vụ giữ hành lý',  'Tiện ích',   'ngày',  30000.00,  'Giữ hành lý sau check-out'),
(10, 'Phòng gym',             'Giải trí',   'lần',   100000.00, 'Sử dụng phòng tập gym');

-- Booking
INSERT INTO tbl_booking (id, code, customer_id, staff_id, booking_date, deposit_amount, deposit_date, status, note) VALUES
-- Đã trả phòng (lịch sử tháng 4)
(1, 'PD2026040001', 1, 3, '2026-04-10 09:00:00', 800000.00,  '2026-04-10 09:30:00', 'Đã trả phòng', NULL),
(2, 'PD2026040002', 2, 3, '2026-04-15 10:00:00', 1500000.00, '2026-04-15 10:30:00', 'Đã trả phòng', 'Cần phòng yên tĩnh'),
(3, 'PD2026040003', 3, 4, '2026-04-20 11:00:00', 2500000.00, '2026-04-20 11:30:00', 'Đã trả phòng', NULL),
-- Đã trả phòng (tháng 5)
(4, 'PD2026050001', 4, 3, '2026-05-01 09:00:00', 2000000.00, '2026-05-01 09:30:00', 'Đã trả phòng', 'Phòng tầng cao'),
(5, 'PD2026050002', 5, 4, '2026-05-03 14:00:00', 1500000.00, '2026-05-03 14:30:00', 'Đã trả phòng', NULL),
-- Booking nhiều phòng đang lưu trú (booking 6 có 2 phòng)
(6, 'PD2026050006', 6, 3, '2026-05-06 08:00:00', 1000000.00, '2026-05-06 08:15:00', 'Đang lưu trú', 'Yêu cầu thêm gối'),
(7, 'PD2026050007', 7, 3, '2026-05-06 09:00:00', 500000.00,  '2026-05-06 09:10:00', 'Đang lưu trú', NULL),
(8, 'PD2026050008', 8, 4, '2026-05-07 10:00:00', 1500000.00, '2026-05-07 10:20:00', 'Đang lưu trú', 'Chuẩn bị phòng tắm'),
-- Tương lai
(9, 'PD2026050009', 1, 3, '2026-05-08 12:00:00', 800000.00,  '2026-05-08 12:05:00', 'Chưa nhận phòng',  'Đến muộn'),
(10,'PD2026050010', 2, NULL, '2026-05-08 15:00:00', 0, NULL, 'Chưa nhận phòng', 'Vui lòng gọi lại xác nhận');

-- Booked Room (id cột có giá trị tường minh để dùng trong FK)
INSERT INTO tbl_booked_room (id, booking_id, room_id, check_in, check_out, actual_checkin, actual_checkout, actual_price, is_checked_in, room_status) VALUES
-- Đã trả phòng
(1,  1,  1,  '2026-04-11 14:00:00', '2026-04-13 12:00:00', '2026-04-11 14:00:00', '2026-04-13 11:00:00', 800000.00,  TRUE,  'Đã check-out'),
(2,  2,  8,  '2026-04-16 14:00:00', '2026-04-19 12:00:00', '2026-04-16 15:00:00', '2026-04-19 10:30:00', 1500000.00, TRUE,  'Đã check-out'),
(3,  3,  10, '2026-04-21 14:00:00', '2026-04-24 12:00:00', '2026-04-21 14:30:00', '2026-04-24 11:00:00', 2500000.00, TRUE,  'Đã check-out'),
(4,  4,  12, '2026-05-02 14:00:00', '2026-05-05 12:00:00', '2026-05-02 14:00:00', '2026-05-05 11:00:00', 1500000.00, TRUE,  'Đã check-out'),
(5,  5,  13, '2026-05-04 14:00:00', '2026-05-06 12:00:00', '2026-05-04 15:00:00', '2026-05-06 12:00:00', 2200000.00, TRUE,  'Đã check-out'),
-- Đang lưu trú - booking 6 có 2 phòng (102 và 201)
(6,  6,  2,  '2026-05-06 14:00:00', '2026-05-10 12:00:00', '2026-05-06 14:00:00', NULL, 800000.00,  TRUE,  'Đã check-in'),  -- phòng 102
(7,  6,  4,  '2026-05-06 14:00:00', '2026-05-09 12:00:00', '2026-05-06 14:30:00', NULL, 800000.00,  TRUE,  'Đã check-in'),  -- phòng 201
-- booking 7 - phòng 305
(8,  7,  8,  '2026-05-07 14:00:00', '2026-05-12 12:00:00', '2026-05-07 15:00:00', NULL, 1500000.00, TRUE,  'Đã check-in'),
-- booking 8 - phòng 412
(9,  8,  12, '2026-05-08 14:00:00', '2026-05-11 12:00:00', '2026-05-08 14:00:00', NULL, 1500000.00, TRUE,  'Đã check-in'),
-- Tương lai
(10, 9,  1,  '2026-05-12 14:00:00', '2026-05-15 12:00:00', NULL, NULL, 800000.00,  FALSE, 'Chờ check in'),
(11, 10, 7,  '2026-05-15 14:00:00', '2026-05-20 12:00:00', NULL, NULL, 1500000.00, FALSE, 'Chờ check in');

-- Used Services (thêm booked_room_id để liên kết với phòng cụ thể)
INSERT INTO tbl_used_service (booking_id, booked_room_id, service_id, quantity, unit_price, used_date) VALUES
(2, 2,  6, 1, 500000.00, '2026-04-17 15:00:00'),   -- Spa cho phòng trong booking 2
(3, 3,  3, 2, 150000.00, '2026-04-22 20:00:00'),   -- Minibar
(3, 3,  4, 1, 60000.00,  '2026-04-23 08:00:00'),   -- Giặt ủi
(4, 4,  1, 5, 200000.00, '2026-05-03 07:00:00'),   -- Buffet sáng
(4, 4,  8, 1, 400000.00, '2026-05-05 06:00:00'),   -- Đưa đón sân bay
(6, 6,  3, 1, 150000.00, '2026-05-07 20:00:00'),   -- Minibar phòng 102 (booking 6)
(7, 8,  1, 2, 200000.00, '2026-05-08 07:30:00');   -- Buffet sáng phòng 305 (booking 7)

-- Invoices (gắn với booked_room_id cụ thể)
INSERT INTO tbl_invoice (id, code, booking_id, booked_room_id, staff_id, issue_date, room_total, service_total, surcharge, total_amount, paid_amount, payment_method, note) VALUES
(1, 'HD2026041301', 1, 1, 3, '2026-04-13 11:30:00', 1600000.00, 0,          0, 1600000.00, 1600000.00, 'Tiền mặt',    NULL),
(2, 'HD2026041901', 2, 2, 3, '2026-04-19 11:00:00', 4500000.00, 500000.00,  0, 5000000.00, 5000000.00, 'Thẻ tín dụng',NULL),
(3, 'HD2026042401', 3, 3, 4, '2026-04-24 11:30:00', 7500000.00, 360000.00,  0, 7860000.00, 7860000.00, 'Chuyển khoản',NULL),
(4, 'HD2026050501', 4, 4, 3, '2026-05-05 11:30:00', 4500000.00, 1400000.00, 0, 5900000.00, 5900000.00, 'Tiền mặt',    NULL),
(5, 'HD2026050601', 5, 5, 4, '2026-05-06 12:00:00', 4400000.00, 0,          0, 4400000.00, 4400000.00, 'Thẻ tín dụng',NULL);
*/


-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                         DỮ LIỆU MỚI (16/06/2026)                          ║
-- ║  18 booking | 12 khách hàng | 5 nhân viên | Đủ 6 trạng thái booking       ║
-- ║  Tính toán: room_total = actual_price × số đêm                             ║
-- ║             service_total khớp tổng used_service                           ║
-- ║             room.status khớp booking đang lưu trú                          ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. KHÁCH SẠN
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO tbl_hotel (name, address, phone, email, description, star_rating, image_url)
VALUES (
    'Aurora Hotel',
    '123 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',
    '024.3826.1234',
    'info@aurorahotel.vn',
    'Aurora Hotel là khách sạn 4 sao nằm tại trung tâm Hà Nội, mang đến trải nghiệm lưu trú sang trọng với dịch vụ đẳng cấp quốc tế.',
    4,
    '/images/hotel/hotel_main.jpg'
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- 2. LOẠI PHÒNG (6 loại)
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO tbl_room_type (id, name, capacity, area, base_price, amenities, description, image_url) VALUES
(1, 'Standard',           2, '22m²',  800000.00,  'TV, điều hòa, wifi',                                                   'Phòng tiêu chuẩn, thoải mái',        '/images/rooms/standard.jpg'),
(2, 'Deluxe',             2, '28m²',  1500000.00, 'TV, minibar, điều hòa, wifi',                                           'View hồ bơi',                         '/images/rooms/deluxe.jpg'),
(3, 'Superior',           2, '32m²',  1800000.00, 'TV, minibar, điều hòa, wifi, bồn tắm',                                  'Phòng cao cấp, tầm nhìn đẹp',        '/images/rooms/superior.jpg'),
(4, 'Family',             4, '45m²',  2200000.00, 'TV, minibar, điều hòa, wifi, bồn tắm, bếp nhỏ',                         'Phòng gia đình, rộng rãi',            '/images/rooms/family.jpg'),
(5, 'Deluxe Suite',       3, '50m²',  2500000.00, 'TV, minibar, điều hòa, wifi, bồn tắm, phòng khách riêng',               'View biển, tầng cao',                 '/images/rooms/deluxe_suite.jpg'),
(6, 'Presidential Suite', 4, '80m²',  5000000.00, 'TV, minibar, điều hòa, wifi, bồn sục, phòng khách, bàn làm việc',       'Suite tổng thống, đẳng cấp nhất',     '/images/rooms/presidential.jpg');

-- ═══════════════════════════════════════════════════════════════════════════════
-- 3. PHÒNG (15 phòng – trạng thái khớp với booking đang lưu trú bên dưới)
--    Phòng đang sử dụng: 102(id=2), 201(id=4), 305(id=8), 412(id=12)
--    Phòng bảo trì:      203(id=6)
--    Phòng trống:         còn lại
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO tbl_room (id, room_number, floor, status, description, room_type_id) VALUES
(1,  '101',  1, 'Trống',         'Phòng Standard, tầng 1',                 1),
(2,  '102',  1, 'Đang sử dụng',  'Phòng Standard, tầng 1',                 1),
(3,  '103',  1, 'Trống',         'Phòng Standard, tầng 1, gần thang máy',  1),
(4,  '201',  2, 'Đang sử dụng',  'Phòng Standard, tầng 2',                 1),
(5,  '202',  2, 'Trống',         'Phòng Standard, tầng 2',                  1),
(6,  '203',  2, 'Bảo trì',       'Phòng Deluxe, hỏng điều hòa',            2),
(7,  '204',  2, 'Trống',         'Phòng Deluxe, tầng 2',                    2),
(8,  '305',  3, 'Đang sử dụng',  'Phòng Deluxe, góc view thành phố',       2),
(9,  '306',  3, 'Trống',         'Phòng Deluxe, tầng 3',                    2),
(10, '305A', 3, 'Trống',         'Deluxe Suite, view biển',                  5),
(11, '401',  4, 'Trống',         'Phòng Superior, tầng 4',                  3),
(12, '412',  4, 'Đang sử dụng',  'Phòng Deluxe, view hồ bơi',              2),
(13, '501',  5, 'Trống',         'Phòng gia đình, tầng 5',                  4),
(14, '502',  5, 'Trống',         'Phòng gia đình, tầng 5',                  4),
(15, '601',  6, 'Trống',         'Suite tổng thống, tầng 6',                6);

-- ═══════════════════════════════════════════════════════════════════════════════
-- 4. NHÂN VIÊN (5 người – password: 123456)
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO tbl_user (id, employee_code, username, password_hash, full_name, email, phone, role, join_date, status, description) VALUES
(1, 'NV001', 'admin',     '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2', 'Trần Quốc A',   'admin@hotel.com',     '0901000001', 'ADMIN',   '2023-01-01', 'active', 'Quản trị hệ thống'),
(2, 'NV002', 'manager01', '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2', 'Lê Văn M',    'manager@hotel.com',   '0901000002', 'MANAGER', '2023-01-15', 'active', 'Quản lý khách sạn'),
(3, 'NV003', 'a.nguyen',  '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2', 'Nguyễn Văn A',      'a.nguyen@hotel.com',  '0901000003', 'STAFF',   '2023-06-01', 'active', 'Nhân viên lễ tân ca sáng'),
(4, 'NV004', 'b.tran',    '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2', 'Trần Thị B',        'b.tran@hotel.com',    '0901000004', 'STAFF',   '2023-07-15', 'active', 'Nhân viên lễ tân ca chiều'),
(5, 'NV005', 'c.pham',    '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2', 'Phạm Văn C',        'c.pham@hotel.com',    '0901000005', 'STAFF',   '2024-03-01', 'active', 'Nhân viên lễ tân mới');

-- ═══════════════════════════════════════════════════════════════════════════════
-- 5. KHÁCH HÀNG (12 người)
--    Khách 7,8,9 có password_hash → đăng nhập online (password: 123456)
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO tbl_customer (id, id_card, id_type, full_name, nationality, birth_date, gender, phone, email, address, password_hash) VALUES
(1,  '045099000001', 'CCCD',      'Phạm Minh Tuấn',    'Việt Nam',  '1988-05-20', 'Nam',  '0911111111', 'tuan.pham@gmail.com',     'Số 5 Lý Thường Kiệt, Hoàn Kiếm, Hà Nội',           NULL),
(2,  '045099000002', 'CCCD',      'Hoàng Thị Lan',      'Việt Nam',  '1992-11-08', 'Nữ',   '0911111112', 'lan.hoang@gmail.com',     'Ngô Quyền, Hải An, Hải Phòng',                       NULL),
(3,  '045099000003', 'CCCD',      'Vũ Đức Anh',         'Việt Nam',  '1985-03-14', 'Nam',  '0911111113', 'anh.vu@gmail.com',        '28 Bạch Đằng, Hải Châu, Đà Nẵng',                    NULL),
(4,  '045099000004', 'CCCD',      'Ngô Thị Hương',      'Việt Nam',  '1990-07-22', 'Nữ',   '0911111114', 'huong.ngo@gmail.com',     '100 Nguyễn Huệ, Q.1, TP. Hồ Chí Minh',               NULL),
(5,  '045099000005', 'CCCD',      'Đỗ Quang Huy',       'Việt Nam',  '1995-01-30', 'Nam',  '0911111115', 'huy.do@gmail.com',        '15 Trần Phú, Ba Đình, Hà Nội',                       NULL),
(6,  '045099001234', 'CCCD',      'Nguyễn Văn Bình',    'Việt Nam',  '1990-04-15', 'Nam',  '0912345678', 'binh.nv@gmail.com',       '22 Phan Đình Phùng, Ba Đình, Hà Nội',                NULL),
(7,  '045099005678', 'CCCD',      'Lê Thị Cẩm',         'Việt Nam',  '1995-03-15', 'Nữ',   '0923456789', 'cam.le@gmail.com',        '55 Lê Lợi, Q.1, TP. Hồ Chí Minh',                    '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2'),
(8,  '045099006789', 'CCCD',      'Lê Văn Đức',         'Việt Nam',  '1993-08-25', 'Nam',  '0934567890', 'duc.le@gmail.com',        '10 Nguyễn Văn Linh, Hải Châu, Đà Nẵng',              '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2'),
(9,  '045099007890', 'CCCD',      'Trương Công Minh',   'Việt Nam',  '1987-09-10', 'Nam',  '0945678901', 'minh.truong@gmail.com',   '8 Trần Hưng Đạo, Ninh Kiều, Cần Thơ',                '$2a$12$QB.lYCvM8ljOc5.qodmPyuespwm5HQKB542hejwSJNhZXE70zwST2'),
(10, '045099008901', 'CCCD',      'Bùi Thị Ngọc Ánh',   'Việt Nam',  '1994-12-05', 'Nữ',   '0956789012', 'anh.bui@gmail.com',       '33 Lê Lợi, TP. Huế',                                 NULL),
(11, '045099009012', 'CCCD',      'Phan Thanh Long',     'Việt Nam',  '1991-06-18', 'Nam',  '0967890123', 'long.phan@gmail.com',     '72 Trần Phú, Nha Trang, Khánh Hòa',                  NULL),
(12, 'P12345678',    'Hộ chiếu',  'Lý Mỹ Ngân',         'Đài Loan',  '1989-02-28', 'Nữ',   '0978901234', 'ngan.ly@gmail.com',       'Đài Bắc, Đài Loan',                                  NULL);

-- ═══════════════════════════════════════════════════════════════════════════════
-- 6. DỊCH VỤ (10 dịch vụ)
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO tbl_service (id, name, category, unit, price, description) VALUES
(1,  'Buffet sáng',           'Ăn uống',    'phần',  200000.00, 'Buffet sáng quốc tế tại nhà hàng tầng 1'),
(2,  'Set lunch',             'Ăn uống',    'phần',  350000.00, 'Bữa trưa set menu Á - Âu'),
(3,  'Minibar',               'Ăn uống',    'lần',   150000.00, 'Đồ uống và snack trong minibar phòng'),
(4,  'Giặt ủi quần áo',      'Giặt ủi',    'kg',    60000.00,  'Giặt và ủi quần áo trong ngày'),
(5,  'Giặt khô đồ vest',     'Giặt ủi',    'bộ',    150000.00, 'Giặt khô chuyên nghiệp cho vest, áo dài'),
(6,  'Spa trị liệu',         'Spa',        'lần',   500000.00, 'Massage và trị liệu toàn thân 60 phút'),
(7,  'Thuê xe đạp',          'Vận chuyển', 'giờ',   50000.00,  'Thuê xe đạp dạo phố cổ'),
(8,  'Đưa đón sân bay',      'Vận chuyển', 'lượt',  400000.00, 'Xe sedan đưa đón sân bay Nội Bài'),
(9,  'Dịch vụ giữ hành lý',  'Tiện ích',   'ngày',  30000.00,  'Giữ hành lý an toàn sau check-out'),
(10, 'Phòng gym',             'Giải trí',   'lần',   100000.00, 'Sử dụng phòng tập gym hiện đại');

-- ═══════════════════════════════════════════════════════════════════════════════
-- 7. BOOKING (18 phiếu đặt – đủ 6 trạng thái)
--    Tháng 3/2026: 2 booking đã trả phòng
--    Tháng 4/2026: 4 booking đã trả phòng (1 booking 2 phòng)
--    Tháng 5/2026: 3 booking đã trả phòng + 1 đã hủy
--    Tháng 6/2026: 2 đã trả + 2 đang lưu trú + 1 lưu trú một phần
--                  + 2 chưa nhận phòng + 1 chờ xác nhận (online)
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO tbl_booking (id, code, customer_id, staff_id, booking_date, deposit_amount, deposit_date, status, note) VALUES
-- ── Tháng 3/2026 – Đã trả phòng ─────────────────────────────────────────────
(1,  'PD2026030001', 1,  3,    '2026-03-05 09:00:00', 800000.00,   '2026-03-05 09:15:00', 'Đã trả phòng',     NULL),
(2,  'PD2026030002', 2,  4,    '2026-03-15 10:30:00', 1500000.00,  '2026-03-15 10:45:00', 'Đã trả phòng',     'Cần phòng yên tĩnh, tầng cao'),
-- ── Tháng 4/2026 – Đã trả phòng ─────────────────────────────────────────────
(3,  'PD2026040001', 3,  3,    '2026-04-01 08:30:00', 1800000.00,  '2026-04-01 08:45:00', 'Đã trả phòng',     NULL),
(4,  'PD2026040002', 4,  3,    '2026-04-10 09:00:00', 2200000.00,  '2026-04-10 09:20:00', 'Đã trả phòng',     'Gia đình 4 người, cần giường phụ'),
(5,  'PD2026040003', 5,  4,    '2026-04-20 14:00:00', 800000.00,   '2026-04-20 14:15:00', 'Đã trả phòng',     NULL),
(6,  'PD2026040004', 6,  3,    '2026-04-25 08:00:00', 2000000.00,  '2026-04-25 08:20:00', 'Đã trả phòng',     'Đặt 2 phòng cho nhóm công tác'),
-- ── Tháng 5/2026 – Đã trả phòng + 1 Đã hủy ─────────────────────────────────
(7,  'PD2026050001', 7,  4,    '2026-05-05 09:00:00', 2500000.00,  '2026-05-05 09:15:00', 'Đã trả phòng',     'Kỷ niệm ngày cưới'),
(8,  'PD2026050002', 8,  3,    '2026-05-10 10:00:00', 1500000.00,  '2026-05-10 10:10:00', 'Đã trả phòng',     NULL),
(9,  'PD2026050003', 9,  NULL, '2026-05-15 15:00:00', 0,           NULL,                  'Đã hủy',           'Khách hủy do thay đổi lịch trình'),
(10, 'PD2026050004', 10, 3,    '2026-05-20 09:30:00', 800000.00,   '2026-05-20 09:45:00', 'Đã trả phòng',     'Khách công tác'),
-- ── Tháng 6/2026 – Đã trả phòng ─────────────────────────────────────────────
(11, 'PD2026060001', 1,  4,    '2026-06-01 08:00:00', 1500000.00,  '2026-06-01 08:10:00', 'Đã trả phòng',     'Khách VIP quay lại'),
(12, 'PD2026060002', 3,  3,    '2026-06-05 09:00:00', 2200000.00,  '2026-06-05 09:20:00', 'Đã trả phòng',     'Nghỉ cùng gia đình'),
-- ── Tháng 6/2026 – Đang lưu trú (đang ở, tính đến 16/06) ───────────────────
(13, 'PD2026060003', 5,  3,    '2026-06-13 08:00:00', 1500000.00,  '2026-06-13 08:15:00', 'Đang lưu trú',     'Đặt 2 phòng, yêu cầu thêm gối'),
(14, 'PD2026060004', 2,  4,    '2026-06-14 09:00:00', 800000.00,   '2026-06-14 09:10:00', 'Đang lưu trú',     NULL),
-- ── Tháng 6/2026 – Lưu trú một phần (1 phòng đã check-in, 1 phòng chờ) ─────
(15, 'PD2026060005', 11, 3,    '2026-06-14 10:00:00', 2000000.00,  '2026-06-14 10:15:00', 'Lưu trú một phần', 'Phòng 501 nhận ngày 17/06'),
-- ── Tháng 6/2026 – Chưa nhận phòng (tương lai) ─────────────────────────────
(16, 'PD2026060006', 4,  3,    '2026-06-15 11:00:00', 5000000.00,  '2026-06-15 11:15:00', 'Chưa nhận phòng',  'Khách VIP, chuẩn bị hoa tươi'),
(17, 'PD2026060007', 12, 4,    '2026-06-16 08:00:00', 1500000.00,  '2026-06-16 08:10:00', 'Chưa nhận phòng',  'Khách quốc tế'),
-- ── Tháng 6/2026 – Chờ xác nhận (đặt online, chưa đặt cọc) ─────────────────
(18, 'PD2026060008', 7,  NULL, '2026-06-16 07:30:00', 0,           NULL,                  'Chờ xác nhận',     'Đặt online, chờ xác nhận từ khách sạn');

-- ═══════════════════════════════════════════════════════════════════════════════
-- 8. BOOKED ROOM (21 bản ghi – phòng cụ thể trong từng booking)
--
--    Tính tiền phòng: room_total = actual_price × số đêm
--    actual_price = base_price của room_type (giá mỗi đêm)
--
--    ID | Booking | Room    | Nights | actual_price | room_total
--    ---|---------|---------|--------|--------------|----------
--     1 |   1     | 101(S)  |   2    |   800,000    |  1,600,000
--     2 |   2     | 305(D)  |   3    | 1,500,000    |  4,500,000
--     3 |   3     | 401(Sup)|   3    | 1,800,000    |  5,400,000
--     4 |   4     | 501(F)  |   3    | 2,200,000    |  6,600,000
--     5 |   5     | 102(S)  |   2    |   800,000    |  1,600,000
--     6 |   6     | 201(S)  |   3    |   800,000    |  2,400,000
--     7 |   6     | 204(D)  |   3    | 1,500,000    |  4,500,000
--     8 |   7     | 305A(DS)|   3    | 2,500,000    |  7,500,000
--     9 |   8     | 306(D)  |   3    | 1,500,000    |  4,500,000
--    10 |   9     | 601(P)  |   3    | 5,000,000    | (hủy)
--    11 |  10     | 103(S)  |   3    |   800,000    |  2,400,000
--    12 |  11     | 412(D)  |   3    | 1,500,000    |  4,500,000
--    13 |  12     | 502(F)  |   3    | 2,200,000    |  6,600,000
--    14 |  13     | 102(S)  |   4    |   800,000    | (đang ở)
--    15 |  13     | 305(D)  |   4    | 1,500,000    | (đang ở)
--    16 |  14     | 201(S)  |   4    |   800,000    | (đang ở)
--    17 |  15     | 412(D)  |   5    | 1,500,000    | (đang ở)
--    18 |  15     | 501(F)  |   3    | 2,200,000    | (chờ CI)
--    19 |  16     | 601(P)  |   3    | 5,000,000    | (chờ CI)
--    20 |  17     | 306(D)  |   3    | 1,500,000    | (chờ CI)
--    21 |  18     | 401(Sup)|   3    | 1,800,000    | (chờ XN)
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO tbl_booked_room (id, booking_id, room_id, check_in, check_out, actual_checkin, actual_checkout, actual_price, is_checked_in, room_status) VALUES
-- ── Đã trả phòng (tháng 3) ──────────────────────────────────────────────────
(1,  1,  1,  '2026-03-06 14:00:00', '2026-03-08 12:00:00', '2026-03-06 14:10:00', '2026-03-08 11:30:00', 800000.00,   TRUE,  'Đã check-out'),   -- 101, 2 đêm
(2,  2,  8,  '2026-03-16 14:00:00', '2026-03-19 12:00:00', '2026-03-16 15:00:00', '2026-03-19 10:30:00', 1500000.00,  TRUE,  'Đã check-out'),   -- 305, 3 đêm
-- ── Đã trả phòng (tháng 4) ──────────────────────────────────────────────────
(3,  3,  11, '2026-04-02 14:00:00', '2026-04-05 12:00:00', '2026-04-02 14:20:00', '2026-04-05 11:00:00', 1800000.00,  TRUE,  'Đã check-out'),   -- 401, 3 đêm
(4,  4,  13, '2026-04-11 14:00:00', '2026-04-14 12:00:00', '2026-04-11 13:30:00', '2026-04-14 11:30:00', 2200000.00,  TRUE,  'Đã check-out'),   -- 501, 3 đêm
(5,  5,  2,  '2026-04-21 14:00:00', '2026-04-23 12:00:00', '2026-04-21 14:00:00', '2026-04-23 12:00:00', 800000.00,   TRUE,  'Đã check-out'),   -- 102, 2 đêm
(6,  6,  4,  '2026-04-26 14:00:00', '2026-04-29 12:00:00', '2026-04-26 14:15:00', '2026-04-29 11:00:00', 800000.00,   TRUE,  'Đã check-out'),   -- 201, 3 đêm
(7,  6,  7,  '2026-04-26 14:00:00', '2026-04-29 12:00:00', '2026-04-26 14:15:00', '2026-04-29 11:15:00', 1500000.00,  TRUE,  'Đã check-out'),   -- 204, 3 đêm
-- ── Đã trả phòng (tháng 5) ──────────────────────────────────────────────────
(8,  7,  10, '2026-05-06 14:00:00', '2026-05-09 12:00:00', '2026-05-06 14:00:00', '2026-05-09 13:00:00', 2500000.00,  TRUE,  'Đã check-out'),   -- 305A, 3 đêm
(9,  8,  9,  '2026-05-11 14:00:00', '2026-05-14 12:00:00', '2026-05-11 14:30:00', '2026-05-14 11:30:00', 1500000.00,  TRUE,  'Đã check-out'),   -- 306, 3 đêm
-- ── Đã hủy (tháng 5) ────────────────────────────────────────────────────────
(10, 9,  15, '2026-05-20 14:00:00', '2026-05-23 12:00:00', NULL,                  NULL,                  5000000.00,  FALSE, 'Đã hủy'),         -- 601, hủy
-- ── Đã trả phòng (tháng 5 cuối) ─────────────────────────────────────────────
(11, 10, 3,  '2026-05-21 14:00:00', '2026-05-24 12:00:00', '2026-05-21 14:00:00', '2026-05-24 12:00:00', 800000.00,   TRUE,  'Đã check-out'),   -- 103, 3 đêm
-- ── Đã trả phòng (tháng 6 đầu) ──────────────────────────────────────────────
(12, 11, 12, '2026-06-02 14:00:00', '2026-06-05 12:00:00', '2026-06-02 14:00:00', '2026-06-05 11:30:00', 1500000.00,  TRUE,  'Đã check-out'),   -- 412, 3 đêm
(13, 12, 14, '2026-06-06 14:00:00', '2026-06-09 12:00:00', '2026-06-06 14:30:00', '2026-06-09 12:00:00', 2200000.00,  TRUE,  'Đã check-out'),   -- 502, 3 đêm
-- ── Đang lưu trú – booking 13: 2 phòng (102 + 305) ─────────────────────────
(14, 13, 2,  '2026-06-14 14:00:00', '2026-06-18 12:00:00', '2026-06-14 14:15:00', NULL,                  800000.00,   TRUE,  'Đã check-in'),    -- 102, 4 đêm
(15, 13, 8,  '2026-06-14 14:00:00', '2026-06-18 12:00:00', '2026-06-14 15:00:00', NULL,                  1500000.00,  TRUE,  'Đã check-in'),    -- 305, 4 đêm
-- ── Đang lưu trú – booking 14: 1 phòng (201) ───────────────────────────────
(16, 14, 4,  '2026-06-15 14:00:00', '2026-06-19 12:00:00', '2026-06-15 14:30:00', NULL,                  800000.00,   TRUE,  'Đã check-in'),    -- 201, 4 đêm
-- ── Lưu trú một phần – booking 15: 412 đã CI, 501 chờ CI (17/06) ───────────
(17, 15, 12, '2026-06-15 14:00:00', '2026-06-20 12:00:00', '2026-06-15 14:00:00', NULL,                  1500000.00,  TRUE,  'Đã check-in'),    -- 412, 5 đêm
(18, 15, 13, '2026-06-17 14:00:00', '2026-06-20 12:00:00', NULL,                  NULL,                  2200000.00,  FALSE, 'Chờ check in'),   -- 501, 3 đêm (chờ)
-- ── Chưa nhận phòng (tương lai) ─────────────────────────────────────────────
(19, 16, 15, '2026-06-20 14:00:00', '2026-06-23 12:00:00', NULL,                  NULL,                  5000000.00,  FALSE, 'Chờ check in'),   -- 601, 3 đêm
(20, 17, 9,  '2026-06-22 14:00:00', '2026-06-25 12:00:00', NULL,                  NULL,                  1500000.00,  FALSE, 'Chờ check in'),   -- 306, 3 đêm
-- ── Chờ xác nhận (online) ───────────────────────────────────────────────────
(21, 18, 11, '2026-06-25 14:00:00', '2026-06-28 12:00:00', NULL,                  NULL,                  1800000.00,  FALSE, 'Chờ check in');   -- 401, 3 đêm

-- ═══════════════════════════════════════════════════════════════════════════════
-- 9. DỊCH VỤ ĐÃ SỬ DỤNG
--    Mỗi dòng: booking_id, booked_room_id, service_id, quantity, unit_price
--
--    Tổng service_total theo booked_room:
--    BR 2  (booking 2):  500,000 + 400,000               = 900,000
--    BR 3  (booking 3):  300,000 + 60,000                 = 360,000
--    BR 4  (booking 4):  800,000 + 400,000                = 1,200,000
--    BR 6  (booking 6):  150,000                          = 150,000
--    BR 7  (booking 6):  700,000                          = 700,000
--    BR 8  (booking 7):  500,000 + 200,000                = 700,000
--    BR 9  (booking 8):  150,000 + 150,000                = 300,000
--    BR 12 (booking 11): 600,000 + 30,000                 = 630,000
--    BR 13 (booking 12): 1,050,000 + 800,000              = 1,850,000
--    BR 14 (booking 13): 150,000                          = 150,000   (đang ở)
--    BR 15 (booking 13): 400,000                          = 400,000   (đang ở)
--    BR 16 (booking 14): 500,000                          = 500,000   (đang ở)
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO tbl_used_service (booking_id, booked_room_id, service_id, quantity, unit_price, used_date) VALUES
-- Booking 2 – phòng 305 (BR 2): Spa + Buffet sáng
(2,  2,  6, 1, 500000.00, '2026-03-17 15:00:00'),   -- Spa trị liệu
(2,  2,  1, 2, 200000.00, '2026-03-18 07:00:00'),   -- Buffet sáng ×2 phần

-- Booking 3 – phòng 401 (BR 3): Minibar + Giặt ủi
(3,  3,  3, 2, 150000.00, '2026-04-03 20:00:00'),   -- Minibar ×2
(3,  3,  4, 1, 60000.00,  '2026-04-04 08:00:00'),   -- Giặt ủi 1kg

-- Booking 4 – phòng 501 (BR 4): Buffet sáng + Đưa đón sân bay
(4,  4,  1, 4, 200000.00, '2026-04-12 07:00:00'),   -- Buffet sáng ×4 phần
(4,  4,  8, 1, 400000.00, '2026-04-14 06:00:00'),   -- Đưa đón sân bay

-- Booking 6 – phòng 201 (BR 6): Minibar
(6,  6,  3, 1, 150000.00, '2026-04-27 20:00:00'),   -- Minibar ×1

-- Booking 6 – phòng 204 (BR 7): Set lunch
(6,  7,  2, 2, 350000.00, '2026-04-27 12:00:00'),   -- Set lunch ×2 phần

-- Booking 7 – phòng 305A (BR 8): Spa + Gym
(7,  8,  6, 1, 500000.00, '2026-05-07 15:00:00'),   -- Spa trị liệu
(7,  8,  10,2, 100000.00, '2026-05-08 08:00:00'),   -- Phòng gym ×2 lần

-- Booking 8 – phòng 306 (BR 9): Giặt khô + Thuê xe đạp
(8,  9,  5, 1, 150000.00, '2026-05-12 09:00:00'),   -- Giặt khô đồ vest
(8,  9,  7, 3, 50000.00,  '2026-05-13 14:00:00'),   -- Thuê xe đạp 3 giờ

-- Booking 11 – phòng 412 (BR 12): Buffet sáng + Giữ hành lý
(11, 12, 1, 3, 200000.00, '2026-06-03 07:00:00'),   -- Buffet sáng ×3 phần
(11, 12, 9, 1, 30000.00,  '2026-06-05 13:00:00'),   -- Giữ hành lý 1 ngày

-- Booking 12 – phòng 502 (BR 13): Set lunch + Đưa đón sân bay
(12, 13, 2, 3, 350000.00, '2026-06-07 12:00:00'),   -- Set lunch ×3 phần
(12, 13, 8, 2, 400000.00, '2026-06-09 06:00:00'),   -- Đưa đón sân bay ×2 lượt

-- Booking 13 – phòng 102 (BR 14): Minibar   [đang lưu trú]
(13, 14, 3, 1, 150000.00, '2026-06-15 20:00:00'),   -- Minibar ×1

-- Booking 13 – phòng 305 (BR 15): Buffet sáng   [đang lưu trú]
(13, 15, 1, 2, 200000.00, '2026-06-15 07:30:00'),   -- Buffet sáng ×2 phần

-- Booking 14 – phòng 201 (BR 16): Spa   [đang lưu trú]
(14, 16, 6, 1, 500000.00, '2026-06-16 10:00:00');   -- Spa trị liệu

-- ═══════════════════════════════════════════════════════════════════════════════
-- 10. HÓA ĐƠN (12 hóa đơn – chỉ cho booking đã trả phòng)
--
--     Công thức:  total_amount = room_total + service_total + surcharge
--                 paid_amount  = total_amount (đã thanh toán đủ)
--
--     ID | Code           | BK | BR | room_total | svc_total | sur     | total
--     ---|----------------|----|----|------------|-----------|---------|----------
--      1 | HD2026030801   |  1 |  1 | 1,600,000  |         0 |       0 | 1,600,000
--      2 | HD2026031901   |  2 |  2 | 4,500,000  |   900,000 |       0 | 5,400,000
--      3 | HD2026040501   |  3 |  3 | 5,400,000  |   360,000 |       0 | 5,760,000
--      4 | HD2026041401   |  4 |  4 | 6,600,000  | 1,200,000 | 200,000 | 8,000,000
--      5 | HD2026042301   |  5 |  5 | 1,600,000  |         0 |       0 | 1,600,000
--      6 | HD2026042901   |  6 |  6 | 2,400,000  |   150,000 |       0 | 2,550,000
--      7 | HD2026042902   |  6 |  7 | 4,500,000  |   700,000 |       0 | 5,200,000
--      8 | HD2026050901   |  7 |  8 | 7,500,000  |   700,000 | 300,000 | 8,500,000
--      9 | HD2026051401   |  8 |  9 | 4,500,000  |   300,000 |       0 | 4,800,000
--     10 | HD2026052401   | 10 | 11 | 2,400,000  |         0 |       0 | 2,400,000
--     11 | HD2026060501   | 11 | 12 | 4,500,000  |   630,000 |       0 | 5,130,000
--     12 | HD2026060901   | 12 | 13 | 6,600,000  | 1,850,000 |       0 | 8,450,000
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO tbl_invoice (id, code, booking_id, booked_room_id, staff_id, issue_date, room_total, service_total, surcharge, total_amount, paid_amount, payment_method, note) VALUES
-- Tháng 3/2026
(1,  'HD2026030801', 1,  1,  3, '2026-03-08 11:30:00', 1600000.00,  0,          0,          1600000.00,  1600000.00,  'Tiền mặt',     NULL),
(2,  'HD2026031901', 2,  2,  4, '2026-03-19 11:00:00', 4500000.00,  900000.00,  0,          5400000.00,  5400000.00,  'Thẻ tín dụng', NULL),
-- Tháng 4/2026
(3,  'HD2026040501', 3,  3,  3, '2026-04-05 11:30:00', 5400000.00,  360000.00,  0,          5760000.00,  5760000.00,  'Chuyển khoản',  NULL),
(4,  'HD2026041401', 4,  4,  3, '2026-04-14 11:30:00', 6600000.00,  1200000.00, 200000.00,  8000000.00,  8000000.00,  'Tiền mặt',      'Phụ thu check-in sớm 30 phút'),
(5,  'HD2026042301', 5,  5,  4, '2026-04-23 12:00:00', 1600000.00,  0,          0,          1600000.00,  1600000.00,  'Thẻ tín dụng',  NULL),
(6,  'HD2026042901', 6,  6,  3, '2026-04-29 11:00:00', 2400000.00,  150000.00,  0,          2550000.00,  2550000.00,  'Tiền mặt',      NULL),
(7,  'HD2026042902', 6,  7,  3, '2026-04-29 11:15:00', 4500000.00,  700000.00,  0,          5200000.00,  5200000.00,  'Tiền mặt',      NULL),
-- Tháng 5/2026
(8,  'HD2026050901', 7,  8,  4, '2026-05-09 13:00:00', 7500000.00,  700000.00,  300000.00,  8500000.00,  8500000.00,  'Chuyển khoản',  'Phụ thu trả phòng muộn 1 giờ'),
(9,  'HD2026051401', 8,  9,  3, '2026-05-14 11:30:00', 4500000.00,  300000.00,  0,          4800000.00,  4800000.00,  'Thẻ tín dụng',  NULL),
(10, 'HD2026052401', 10, 11, 3, '2026-05-24 12:00:00', 2400000.00,  0,          0,          2400000.00,  2400000.00,  'Tiền mặt',      NULL),
-- Tháng 6/2026
(11, 'HD2026060501', 11, 12, 4, '2026-06-05 11:30:00', 4500000.00,  630000.00,  0,          5130000.00,  5130000.00,  'Chuyển khoản',  NULL),
(12, 'HD2026060901', 12, 13, 3, '2026-06-09 12:00:00', 6600000.00,  1850000.00, 0,          8450000.00,  8450000.00,  'Thẻ tín dụng',  NULL);
