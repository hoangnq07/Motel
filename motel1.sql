﻿-- Tạo cơ sở dữ liệu
CREATE DATABASE motel7;
USE motel7;

-- Tạo bảng tài khoản người dùng
CREATE TABLE accounts(
    account_id INT PRIMARY KEY IDENTITY(1,1),
    active BIT NOT NULL DEFAULT 1,
    avatar VARCHAR(255),
    citizen_id VARCHAR(255),
    create_date DATE DEFAULT GETDATE(),
    dob DATE,
    email VARCHAR(255) UNIQUE NOT NULL,
    fullname NVARCHAR(255),
    gender BIT,
    [password] VARCHAR(255),
    phone VARCHAR(255) NULL,
    [role] VARCHAR(50) DEFAULT 'user',
);

-- Tạo bảng nhà trọ
CREATE TABLE dbo.motels(
    motel_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
    descriptions NVARCHAR(MAX),
	[name] NVARCHAR(255),
    detail_address NVARCHAR(255),
    district NVARCHAR(255),
    district_id VARCHAR(255),
    image VARCHAR(255),
    province NVARCHAR(255),
    province_id VARCHAR(255),
    status BIT NOT NULL DEFAULT 1,
    ward NVARCHAR(255),
    account_id INT,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id)
);

-- Tạo bảng danh mục phòng
CREATE TABLE dbo.category_room(
    category_room_id INT PRIMARY KEY IDENTITY(1,1),
    descriptions NVARCHAR(255),
    quantity INT,
    status BIT NOT NULL DEFAULT 1
);

-- Tạo bảng phòng trọ
CREATE TABLE dbo.motel_room(
    motel_room_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
	[name] NVARCHAR(255),
    descriptions NVARCHAR(255),
    length FLOAT CHECK (length >= 1),
    width FLOAT CHECK (width >= 1),
	room_price FLOAT,
    electricity_price FLOAT,
    water_price FLOAT,
    wifi_price FLOAT,
    room_status BIT NOT NULL DEFAULT 0,
    category_room_id INT,
    motel_id INT,
	account_id INT,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id),
    FOREIGN KEY (category_room_id) REFERENCES dbo.category_room(category_room_id),
    FOREIGN KEY (motel_id) REFERENCES dbo.motels(motel_id)
);

CREATE TABLE dbo.image(
    image_id [int] PRIMARY KEY IDENTITY(1,1),
    name [varchar](255) NULL,
    motel_room_id [int] NULL,
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room (motel_room_id)
    );


-- Tạo bảng người thuê
CREATE TABLE dbo.renter(
    renter_id INT PRIMARY KEY,
    change_room_date DATE,
    check_out_date DATE,
    renter_date DATE,
    motel_room_id INT,
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id),
    FOREIGN KEY (renter_id) REFERENCES dbo.accounts(account_id)
);

-- Tạo bảng hóa đơn
CREATE TABLE dbo.invoice(
    invoice_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
    end_date DATE,
    total_price FLOAT,
    invoice_status NVARCHAR(255),
    renter_id INT,
    motel_room_id INT,
    FOREIGN KEY (renter_id) REFERENCES dbo.renter(renter_id),
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id)
);

-- Tạo bảng chỉ số điện
CREATE TABLE dbo.electricity(
    electricity_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
    electricity_index FLOAT,
    invoice_id INT,
    FOREIGN KEY (invoice_id) REFERENCES dbo.invoice(invoice_id)
);

-- Tạo bảng chỉ số nước
CREATE TABLE dbo.water(
    water_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
    water_index FLOAT,
    invoice_id INT,
    FOREIGN KEY (invoice_id) REFERENCES dbo.invoice(invoice_id)
);


CREATE TABLE dbo.request_authority(
    request_authority_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    [image] [varchar](255) NULL,
    createdate [date] NULL,
    descriptions [nvarchar](255) NULL,
    respdescriptions [nvarchar](255) NULL,
    responsedate [date] NULL,
    account_id [int] NULL,
    request_authority_status [nvarchar](255) NULL,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts (account_id));

CREATE TABLE notifications (
 notification_id INT PRIMARY KEY IDENTITY(1,1),
 message NVARCHAR(MAX) NULL,
 create_date DATETIME DEFAULT GETDATE(),
);
CREATE TABLE account_notifications (
    account_notification_id INT PRIMARY KEY IDENTITY(1,1),
    account_id INT,
    notification_id INT,
    create_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (notification_id) REFERENCES notifications(notification_id)
);
-- Tạo bảng đánh giá
CREATE TABLE dbo.rating (
    rating_id INT PRIMARY KEY IDENTITY(1,1),
    rating_value INT NOT NULL CHECK (rating_value BETWEEN 1 AND 5),
    create_date DATETIME DEFAULT GETDATE(),
    account_id INT,
    motel_id INT,
    motel_room_id INT,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id),
    FOREIGN KEY (motel_id) REFERENCES dbo.motels(motel_id),
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id)
);


-- Tạo bảng phản hồi
CREATE TABLE dbo.feedback (
    feedback_id INT PRIMARY KEY IDENTITY(1,1),
    feedback_text NVARCHAR(MAX) NOT NULL,
    create_date DATETIME DEFAULT GETDATE(),
    account_id INT,
    motel_id INT,
    motel_room_id INT,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id),
    FOREIGN KEY (motel_id) REFERENCES dbo.motels(motel_id),
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id)
);

-- Tạo người dùng quản trị mặc định pass 123456789
INSERT dbo.accounts (active, avatar, citizen_id, email, fullname, gender, [password], phone, [role]) VALUES 
(1, NULL, NULL, 'admin@gmail.com', 'ADMIN', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', NULL, 'admin');

-- Thêm dữ liệu mẫu vào bảng accounts
INSERT dbo.accounts (active, avatar, citizen_id, email, fullname, gender, [password], phone, [role]) VALUES
(1, 'avatar1.jpg', '123456789', 'user1@gmail.com', N'Nguyễn Văn A', 1, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0912345678', 'user'),
(1, 'avatar2.jpg', '987654321', 'user2@gmail.com', N'Lê Thị B', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0987654321', 'user'),
(1, 'avatar3.jpg', '123123123', 'user3@gmail.com', N'Trần Văn C', 1, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0909090909', 'user'),
(1, 'avatar4.jpg', '321321321', 'user4@gmail.com', N'Phạm Thị D', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0912121212', 'user'),
(1, 'avatar5.jpg', '456456456', 'user5@gmail.com', N'Hoàng Văn E', 1, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0939393939', 'user'),
(1, 'avatar6.jpg', '654654654', 'user6@gmail.com', N'Bùi Thị F', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0948484848', 'user'),
(1, 'avatar7.jpg', '789789789', 'user7@gmail.com', N'Ngô Văn G', 1, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0959595959', 'owner'),
(1, 'avatar8.jpg', '987987987', 'user8@gmail.com', N'Đỗ Thị H', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0960606060', 'owner'),
(1, 'avatar9.jpg', '147258369', 'user9@gmail.com', N'Phan Văn I', 1, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0970707070', 'owner'),
(1, 'avatar10.jpg', '369258147', 'user10@gmail.com', N'Lý Thị K', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0980808080', 'owner'),
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078965', 'hoangnqde170007@fpt.edu.vn', N'Nguyễn Quốc Hoàng', 1, '$2a$10$Tg.wEKSRXgnHl5ADulf3tOBpO1d1waDYB.8uAC8RJp7SXpqENtvvO', '0375447944', 'owner');
-- Thêm dữ liệu mẫu vào bảng motels
INSERT INTO dbo.motels (create_date, descriptions, detail_address, district, district_id, image, province, province_id, status, ward, account_id) VALUES
(GETDATE(), N'Nhà trọ gần trung tâm thành phố', N'123 Đường ABC', N'Quận 1', '001', 'motel1.jpg', N'TP. Hồ Chí Minh', '01', 1, N'Phường 1', 12),
(GETDATE(), N'Nhà trọ tiện nghi, giá rẻ', N'456 Đường DEF', N'Quận 2', '002', 'motel2.jpg', N'TP. Hồ Chí Minh', '01', 1, N'Phường 2', 2),
(GETDATE(), N'Nhà trọ an ninh tốt', N'789 Đường GHI', N'Quận 3', '003', 'motel3.jpg', N'TP. Hồ Chí Minh', '01', 1, N'Phường 3', 3),
(GETDATE(), N'Nhà trọ gần trường đại học', N'101 Đường JKL', N'Quận 4', '004', 'motel4.jpg', N'TP. Hồ Chí Minh', '01', 1, N'Phường 4', 4),
(GETDATE(), N'Nhà trọ sạch sẽ, thoáng mát', N'102 Đường MNO', N'Quận 5', '005', 'motel5.jpg', N'TP. Hồ Chí Minh', '01', 1, N'Phường 5', 5),
(GETDATE(), N'Nhà trọ gần chợ', N'103 Đường PQR', N'Quận 6', '006', 'motel6.jpg', N'TP. Hồ Chí Minh', '01', 1, N'Phường 6', 6),
(GETDATE(), N'Nhà trọ mới xây', N'104 Đường STU', N'Quận 7', '007', 'motel7.jpg', N'TP. Hồ Chí Minh', '01', 1, N'Phường 7', 7),
(GETDATE(), N'Nhà trọ khu dân cư yên tĩnh', N'105 Đường VWX', N'Quận 8', '008', 'motel8.jpg', N'TP. Hồ Chí Minh', '01', 1, N'Phường 8', 8),
(GETDATE(), N'Nhà trọ có sân vườn', N'106 Đường YZ', N'Quận 9', '009', 'motel9.jpg', N'TP. Hồ Chí Minh', '01', 1, N'Phường 9', 9),
(GETDATE(), N'Nhà trọ giá sinh viên', N'107 Đường ABCD', N'Quận 10', '010', 'motel10.jpg', N'TP. Hồ Chí Minh', '01', 1, N'Phường 10', 12);

INSERT INTO dbo.category_room (descriptions, quantity, status) VALUES
('Single Room', 1, 1),
('Double Room', 2, 1);

-- Thêm dữ liệu mẫu vào bảng motel_room
INSERT INTO dbo.motel_room (create_date, descriptions, length, width, room_price, electricity_price, water_price, wifi_price, room_status, category_room_id, motel_id, account_id) VALUES
(GETDATE(), N'Phòng rộng rãi, đầy đủ tiện nghi', 4.0, 5.0, 3000000, 3500, 15000, 200000, 0, 1, 1, 12),
(GETDATE(), N'Phòng sạch sẽ, thoáng mát', 3.5, 4.5, 2500000, 3500, 15000, 200000, 0, 2, 1, 12),
(GETDATE(), N'Phòng giá rẻ, tiện nghi', 3.0, 4.0, 2000000, 3500, 15000, 200000, 0, 1, 1, 12),
(GETDATE(), N'Phòng gần trung tâm', 4.5, 5.5, 3500000, 3500, 15000, 200000, 0, 2, 1, 12),
(GETDATE(), N'Phòng có view đẹp', 5.0, 6.0, 4000000, 3500, 15000, 200000, 0, 1, 1, 5),
(GETDATE(), N'Phòng an ninh tốt', 3.8, 4.8, 2800000, 3500, 15000, 200000, 0, 1, 6, 6),
(GETDATE(), N'Phòng gần trường học', 3.6, 4.6, 2600000, 3500, 15000, 200000, 0, 2, 7, 7),
(GETDATE(), N'Phòng rộng, thoáng', 4.2, 5.2, 3200000, 3500, 15000, 200000, 0, 1, 8, 8),
(GETDATE(), N'Phòng đẹp, tiện nghi', 4.8, 5.8, 3700000, 3500, 15000, 200000, 0, 2, 9, 9),
(GETDATE(), N'Phòng cao cấp', 5.2, 6.2, 4200000, 3500, 15000, 200000, 0, 1, 10, 10);


-- Thêm dữ liệu mẫu vào bảng request_authority
INSERT INTO dbo.request_authority (image, createdate, descriptions, respdescriptions, responsedate, account_id, request_authority_status) VALUES
('image1.jpg', '2024-01-01', N'Yêu cầu nâng cấp quyền', NULL, NULL, 1, N'Chưa xử lý');

DECLARE @i INT = 1;

WHILE @i <= 32
BEGIN
    INSERT INTO dbo.image (name, motel_room_id)
    VALUES ('room1_img1.jpg', @i),
           ('img1.jpg', @i),
           ('img2.jpg', @i),
           ('img3.jpg', @i);

    SET @i = @i + 1;
END


-- Tạo bảng favourite_room
CREATE TABLE dbo.favourite_room(
    favourite_room_id INT PRIMARY KEY IDENTITY(1,1),
    account_id INT,
    motel_room_id INT,
    create_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id),
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id)
);

-- Thêm dữ liệu mẫu vào bảng favourite_room
INSERT INTO dbo.favourite_room (account_id, motel_room_id)
VALUES
(2, 1), -- Giả sử tài khoản với account_id = 1 yêu thích phòng với motel_room_id = 1
(2, 2), -- Giả sử tài khoản với account_id = 1 yêu thích phòng với motel_room_id = 2
(3, 1); -- Giả sử tài khoản với account_id = 2 yêu thích phòng với motel_room_id = 1

-- Lấy danh sách favourite rooms của một tài khoản cụ thể
SELECT fr.favourite_room_id, mr.descriptions, mr.room_price
FROM dbo.favourite_room fr
JOIN dbo.motel_room mr ON fr.motel_room_id = mr.motel_room_id
WHERE fr.account_id = 1; -- Thay đổi account_id này để xem danh sách yêu thích của tài khoản khác