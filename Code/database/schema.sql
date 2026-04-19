DROP DATABASE IF EXISTS hotel_management;
CREATE DATABASE hotel_management
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE hotel_management;

CREATE TABLE tbl_hotel (
    id          INT             AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(200)    NOT NULL,
    address     VARCHAR(500)    DEFAULT NULL,
    phone       VARCHAR(20)     DEFAULT NULL,
    email       VARCHAR(100)    DEFAULT NULL,
    description TEXT            DEFAULT NULL,
    star_rating TINYINT         DEFAULT 0,
    image_url   VARCHAR(500)    DEFAULT NULL,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_star_rating CHECK (star_rating BETWEEN 0 AND 5)
) ENGINE=InnoDB;

CREATE TABLE tbl_room_type (
    id          INT             AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)    NOT NULL,
    capacity    INT             DEFAULT 2,
    area        VARCHAR(20)     DEFAULT NULL,
    base_price  DECIMAL(15,2)   NOT NULL,
    amenities   TEXT            DEFAULT NULL,
    description TEXT            DEFAULT NULL,
    image_url   VARCHAR(500)    DEFAULT NULL,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_capacity CHECK (capacity > 0),
    CONSTRAINT chk_base_price CHECK (base_price >= 0)
) ENGINE=InnoDB;

CREATE TABLE tbl_room (
    id            INT             AUTO_INCREMENT PRIMARY KEY,
    room_number   VARCHAR(20)     NOT NULL UNIQUE,
    floor         INT             DEFAULT 1,
    status        ENUM('Trống','Đang sử dụng','Cần dọn dẹp','Bảo trì')
                                  DEFAULT 'Trống',
    description   TEXT            DEFAULT NULL,
    room_type_id  INT             NOT NULL,
    created_at    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_room_roomtype FOREIGN KEY (room_type_id)
        REFERENCES tbl_room_type(id) ON UPDATE CASCADE ON DELETE RESTRICT,

    INDEX idx_room_status (status),
    INDEX idx_room_type (room_type_id)
) ENGINE=InnoDB;

CREATE TABLE tbl_customer (
    id            INT             AUTO_INCREMENT PRIMARY KEY,
    id_card       VARCHAR(20)     DEFAULT NULL UNIQUE,
    id_type       ENUM('CCCD','Hộ chiếu') DEFAULT 'CCCD',
    full_name     VARCHAR(150)    NOT NULL,
    nationality   VARCHAR(50)     DEFAULT 'Việt Nam',
    birth_date    DATE            DEFAULT NULL,
    gender        ENUM('Nam','Nữ','Khác') DEFAULT NULL,
    phone         VARCHAR(15)     DEFAULT NULL,
    email         VARCHAR(100)    DEFAULT NULL UNIQUE,
    address       VARCHAR(300)    DEFAULT NULL,
    password_hash VARCHAR(255)    DEFAULT NULL,
    created_at    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_customer_idcard (id_card),
    INDEX idx_customer_phone (phone),
    INDEX idx_customer_email (email)
) ENGINE=InnoDB;

CREATE TABLE tbl_user (
    id            INT             AUTO_INCREMENT PRIMARY KEY,
    employee_code VARCHAR(20)     DEFAULT NULL UNIQUE,
    username      VARCHAR(50)     NOT NULL UNIQUE,
    password_hash VARCHAR(255)    NOT NULL,
    full_name     VARCHAR(150)    NOT NULL,
    email         VARCHAR(100)    DEFAULT NULL UNIQUE,
    phone         VARCHAR(15)     DEFAULT NULL,
    role          ENUM('STAFF','MANAGER','ADMIN')
                                  NOT NULL DEFAULT 'STAFF',
    join_date     DATE            DEFAULT NULL,
    status        ENUM('active','inactive')
                                  DEFAULT 'active',
    description   TEXT            DEFAULT NULL,
    created_at    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_user_role (role),
    INDEX idx_user_status (status)
) ENGINE=InnoDB;

CREATE TABLE tbl_booking (
    id                INT             AUTO_INCREMENT PRIMARY KEY,
    code              VARCHAR(20)     NOT NULL UNIQUE,
    customer_id       INT             NOT NULL,
    staff_id          INT             DEFAULT NULL,
    booking_date      DATETIME        DEFAULT CURRENT_TIMESTAMP,
    deposit_amount    DECIMAL(15,2)   DEFAULT 0,
    deposit_date      DATETIME        DEFAULT NULL,
    status            ENUM('Chờ xác nhận','Đã xác nhận','Đang lưu trú','Đã trả phòng','Đã hủy')
                                      DEFAULT 'Chờ xác nhận',
    special_requests  TEXT            DEFAULT NULL,
    note              TEXT            DEFAULT NULL,
    created_at        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_booking_customer FOREIGN KEY (customer_id)
        REFERENCES tbl_customer(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_booking_staff FOREIGN KEY (staff_id)
        REFERENCES tbl_user(id) ON UPDATE CASCADE ON DELETE SET NULL,

    INDEX idx_booking_code (code),
    INDEX idx_booking_customer (customer_id),
    INDEX idx_booking_status (status),
    INDEX idx_booking_date (booking_date)
) ENGINE=InnoDB;

CREATE TABLE tbl_booked_room (
    id              INT             AUTO_INCREMENT PRIMARY KEY,
    booking_id      INT             NOT NULL,
    room_id         INT             NOT NULL,
    check_in        DATE            NOT NULL,
    check_out       DATE            NOT NULL,
    actual_checkin   DATETIME       DEFAULT NULL,
    actual_checkout  DATETIME       DEFAULT NULL,
    actual_price    DECIMAL(15,2)   DEFAULT NULL,
    is_checked_in   BOOLEAN         DEFAULT FALSE,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_bookedroom_booking FOREIGN KEY (booking_id)
        REFERENCES tbl_booking(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_bookedroom_room FOREIGN KEY (room_id)
        REFERENCES tbl_room(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_checkout_after_checkin CHECK (check_out > check_in),

    INDEX idx_br_booking (booking_id),
    INDEX idx_br_room (room_id),
    INDEX idx_br_dates (check_in, check_out)
) ENGINE=InnoDB;

CREATE TABLE tbl_service (
    id          INT             AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(200)    NOT NULL,
    category    VARCHAR(100)    DEFAULT NULL,
    unit        VARCHAR(50)     DEFAULT NULL,
    price       DECIMAL(15,2)   NOT NULL,
    description TEXT            DEFAULT NULL,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_service_price CHECK (price >= 0),
    INDEX idx_service_name (name),
    INDEX idx_service_category (category)
) ENGINE=InnoDB;

CREATE TABLE tbl_used_service (
    id          INT             AUTO_INCREMENT PRIMARY KEY,
    booking_id  INT             NOT NULL,
    service_id  INT             NOT NULL,
    quantity    DECIMAL(10,2)   NOT NULL DEFAULT 1,
    unit_price  DECIMAL(15,2)   NOT NULL,
    used_date   DATETIME        DEFAULT CURRENT_TIMESTAMP,
    note        VARCHAR(300)    DEFAULT NULL,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usedservice_booking FOREIGN KEY (booking_id)
        REFERENCES tbl_booking(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_usedservice_service FOREIGN KEY (service_id)
        REFERENCES tbl_service(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_us_quantity CHECK (quantity > 0),
    CONSTRAINT chk_us_unitprice CHECK (unit_price >= 0),

    INDEX idx_us_booking (booking_id),
    INDEX idx_us_service (service_id)
) ENGINE=InnoDB;

CREATE TABLE tbl_invoice (
    id              INT             AUTO_INCREMENT PRIMARY KEY,
    code            VARCHAR(20)     NOT NULL UNIQUE,
    booking_id      INT             NOT NULL UNIQUE,
    staff_id        INT             DEFAULT NULL,
    issue_date      DATETIME        DEFAULT CURRENT_TIMESTAMP,
    room_total      DECIMAL(15,2)   DEFAULT 0,
    service_total   DECIMAL(15,2)   DEFAULT 0,
    surcharge       DECIMAL(15,2)   DEFAULT 0,
    total_amount    DECIMAL(15,2)   DEFAULT 0,
    paid_amount     DECIMAL(15,2)   DEFAULT 0,
    payment_method  ENUM('Tiền mặt','Chuyển khoản','Thẻ tín dụng','Thẻ ghi nợ','Khác')
                                    DEFAULT 'Tiền mặt',
    note            TEXT            DEFAULT NULL,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_invoice_booking FOREIGN KEY (booking_id)
        REFERENCES tbl_booking(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_invoice_staff FOREIGN KEY (staff_id)
        REFERENCES tbl_user(id) ON UPDATE CASCADE ON DELETE SET NULL,

    INDEX idx_invoice_code (code),
    INDEX idx_invoice_booking (booking_id),
    INDEX idx_invoice_date (issue_date)
) ENGINE=InnoDB;

CREATE VIEW v_revenue_stat AS
SELECT
    DATE_FORMAT(i.issue_date, '%Y-%m')                          AS period,
    COUNT(DISTINCT b.customer_id)                               AS total_guests,
    SUM(DATEDIFF(br.check_out, br.check_in))                    AS total_room_nights,
    SUM(i.room_total)                                           AS room_revenue,
    SUM(i.service_total)                                        AS service_revenue,
    SUM(i.total_amount)                                         AS total_revenue
FROM tbl_invoice i
    JOIN tbl_booking b      ON i.booking_id = b.id
    JOIN tbl_booked_room br ON br.booking_id = b.id
WHERE b.status = 'Đã trả phòng'
GROUP BY DATE_FORMAT(i.issue_date, '%Y-%m');

CREATE VIEW v_room_stat AS
SELECT
    DATE_FORMAT(br.check_in, '%Y-%m')   AS period,
    rt.name                             AS room_type_name,
    COUNT(DISTINCT r.id)                AS total_rooms,
    COUNT(DISTINCT CASE
        WHEN b.status IN ('Đang lưu trú','Đã trả phòng')
        THEN br.room_id END)            AS rented_rooms,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN b.status IN ('Đang lưu trú','Đã trả phòng')
            THEN br.room_id END)
        * 100.0
        / NULLIF(COUNT(DISTINCT r.id), 0)
    , 2)                                AS occupancy_rate
FROM tbl_room_type rt
    LEFT JOIN tbl_room r            ON r.room_type_id = rt.id
    LEFT JOIN tbl_booked_room br    ON br.room_id = r.id
    LEFT JOIN tbl_booking b         ON br.booking_id = b.id
GROUP BY DATE_FORMAT(br.check_in, '%Y-%m'), rt.name, rt.id;
