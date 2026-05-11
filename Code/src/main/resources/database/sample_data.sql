-- Dữ liệu khách sạn
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
(9, 'PD2026050009', 1, 3, '2026-05-08 12:00:00', 800000.00,  '2026-05-08 12:05:00', 'Đã xác nhận',  'Đến muộn'),
(10,'PD2026050010', 2, NULL, '2026-05-08 15:00:00', 0, NULL, 'Chờ xác nhận', 'Vui lòng gọi lại xác nhận');

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
(10, 9,  1,  '2026-05-12 14:00:00', '2026-05-15 12:00:00', NULL, NULL, 800000.00,  FALSE, 'Chờ'),
(11, 10, 7,  '2026-05-15 14:00:00', '2026-05-20 12:00:00', NULL, NULL, 1500000.00, FALSE, 'Chờ');

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
