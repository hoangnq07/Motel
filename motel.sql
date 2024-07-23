-- Tạo cơ sở dữ liệu
CREATE DATABASE motel;
USE motel;

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
    ward_id NVARCHAR(255),
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
	post_request_status NVARCHAR(50),
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
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room (motel_room_id) ON DELETE CASCADE
);

-- Tạo bảng người thuê
CREATE TABLE dbo.renter(
    renter_id INT PRIMARY KEY,
    change_room_date DATE,
    check_out_date DATE,
    renter_date DATE,
    motel_room_id INT,
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id) ON DELETE SET NULL,
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
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id) ON DELETE SET NULL
);

-- Tạo bảng chỉ số điện
CREATE TABLE dbo.electricity(
    electricity_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
    electricity_index FLOAT,
    invoice_id INT,
    FOREIGN KEY (invoice_id) REFERENCES dbo.invoice(invoice_id) ON DELETE CASCADE
);

-- Tạo bảng chỉ số nước
CREATE TABLE dbo.water(
    water_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
    water_index FLOAT,
    invoice_id INT,
    FOREIGN KEY (invoice_id) REFERENCES dbo.invoice(invoice_id) ON DELETE CASCADE
);

CREATE TABLE dbo.request_authority(
    request_authority_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    createdate [date] NULL,
    descriptions [nvarchar](255) NULL,
    respdescriptions [nvarchar](255) NULL,
    responsedate [date] NULL,
    account_id [int] NULL,
    request_authority_status [nvarchar](255) NULL,
	[imageidcard] [varchar](255) NULL,
	[imagedoc] [varchar](255) NULL,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts (account_id)
);

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
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ,
    FOREIGN KEY (notification_id) REFERENCES notifications(notification_id)
	);



-- Tạo bảng phản hồi
CREATE TABLE dbo.feedback (
    feedback_id INT PRIMARY KEY IDENTITY(1,1),
    feedback_text NVARCHAR(MAX) NOT NULL,
    create_date DATETIME DEFAULT GETDATE(),
    account_id INT,
    motel_id INT,
    motel_room_id INT,
	[to_user_id] [int] NULL,
	[tag] [varchar](50) NULL,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id) ,
    FOREIGN KEY (motel_id) REFERENCES dbo.motels(motel_id) ,
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id) ON DELETE CASCADE
);

-- Tạo bảng favourite_room
CREATE TABLE dbo.favourite_room(
    favourite_room_id INT PRIMARY KEY IDENTITY(1,1),
    account_id INT,
    motel_room_id INT,
    create_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id),
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id) ON DELETE CASCADE
);

-- Tạo người dùng quản trị mặc định pass 123456789
INSERT dbo.accounts (active, avatar, citizen_id, email, fullname, gender, [password], phone, [role]) VALUES 
(1, NULL, NULL, 'admin@gmail.com', 'ADMIN', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', NULL, 'admin');

-- Thêm dữ liệu mẫu vào bảng accounts
INSERT dbo.accounts (active, avatar, citizen_id, email, fullname, gender, [password], phone, [role]) VALUES
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078961', 'user1@gmail.com', N'Nguyễn Văn A', 1, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0912345678', 'user'),
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078962', 'user2@gmail.com', N'Lê Thị B', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0987654321', 'user'),
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078963', 'user3@gmail.com', N'Trần Văn C', 1, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0909090909', 'user'),
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078964', 'user4@gmail.com', N'Phạm Thị D', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0912121212', 'user'),
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078966', 'user5@gmail.com', N'Hoàng Văn E', 1, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0939393939', 'user'),
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078967', 'user6@gmail.com', N'Bùi Thị F', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0948484848', 'user'),
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078968', 'user7@gmail.com', N'Ngô Văn G', 1, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0959595959', 'owner'),
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078969', 'user8@gmail.com', N'Đỗ Thị H', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0960606060', 'owner'),
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078960', 'user9@gmail.com', N'Phan Văn I', 1, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0970707070', 'owner'),
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078980', 'user10@gmail.com', N'Lý Thị K', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', '0980808080', 'owner'),
(1, '7d3cacfe-8933-464d-ae1b-31d2deae2016_anh1.jpg', '040203078965', 'hoangnqde170007@fpt.edu.vn', N'Nguyễn Quốc Hoàng', 1, '$2a$10$Tg.wEKSRXgnHl5ADulf3tOBpO1d1waDYB.8uAC8RJp7SXpqENtvvO', '0375447944', 'owner');
-- Thêm dữ liệu mẫu vào bảng motels
INSERT INTO dbo.motels (create_date, name, descriptions, detail_address, district, district_id, image, province, province_id, status, ward, ward_id, account_id) VALUES
(GETDATE(), N'Nhà trọ 1',N'Nhà trọ tiện nghi, giá rẻ', N'107 Đường Hùng Vương', N'Huyện Sơn Động', '220', 'motel1.jpg', N'Tỉnh Bắc Giang', '24', 1, N'Xã Vĩnh An', 7648, 12),
(GETDATE(), N'Student House',N'Nhà trọ tiện nghi, giá rẻ', N'21 Huỳnh Văn Nghệ', N'Quận Ngũ Hành Sơn', '494', 'motel2.jpg', N'Thành phố Đà Nẵng', '48', 1, N'Pường Hoà Hải', 20290,2);

INSERT INTO dbo.category_room (descriptions, quantity, status) VALUES
('Single Room', 1, 1),
('Double Room', 2, 1);

-- Thêm dữ liệu mẫu vào bảng motel_room
INSERT INTO dbo.motel_room (create_date, name, descriptions, length, width, room_price, electricity_price, water_price, wifi_price, room_status, category_room_id, motel_id, account_id) VALUES
(GETDATE(),N'P101', N'Phòng rộng rãi, đầy đủ tiện nghi', 4.0, 5.0, 3000000, 3500, 15000, 200000, 0, 1, 1, 12),
(GETDATE(),N'P102', N'Phòng sạch sẽ, thoáng mát', 3.5, 4.5, 2500000, 3500, 15000, 200000, 0, 2, 1, 12),
(GETDATE(),N'P103', N'Phòng giá rẻ, tiện nghi', 3.0, 4.0, 2000000, 3500, 15000, 200000, 0, 1, 1, 12),
(GETDATE(),N'P104', N'Phòng gần trung tâm', 4.5, 5.5, 3500000, 3500, 15000, 200000, 0, 2, 1, 12),
(GETDATE(),N'P101', N'Phòng có view đẹp', 5.0, 6.0, 4000000, 3500, 15000, 200000, 0, 1, 2, 2),
(GETDATE(),N'P102', N'Phòng an ninh tốt', 3.8, 4.8, 2800000, 3500, 15000, 200000, 0, 1, 2, 2),
(GETDATE(),N'P103', N'Phòng gần trường học', 3.6, 4.6, 2600000, 3500, 15000, 200000, 0, 2, 2, 2),
(GETDATE(),N'P104', N'Phòng rộng, thoáng', 4.2, 5.2, 3200000, 3500, 15000, 200000, 0, 1, 2, 2),
(GETDATE(),N'P105', N'Phòng đẹp, tiện nghi', 4.8, 5.8, 3700000, 3500, 15000, 200000, 0, 2, 1, 12),
(GETDATE(),N'P1016', N'Phòng cao cấp', 5.2, 6.2, 4200000, 3500, 15000, 200000, 0, 1, 1, 12);


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

