-- Tạo cơ sở dữ liệu
CREATE DATABASE motel1;
USE motel1;

-- Tạo bảng tài khoản người dùng
CREATE TABLE dbo.accounts(
    account_id INT PRIMARY KEY IDENTITY(1,1),
    active BIT NOT NULL DEFAULT 1,
    avatar VARCHAR(255),
    citizen_id VARCHAR(255),
    create_date DATE DEFAULT GETDATE(),
    dob DATE,
    email VARCHAR(255) UNIQUE NOT NULL,
    fullname NVARCHAR(255),
    gender BIT,
    [password] VARCHAR(255) NOT NULL,
    phone VARCHAR(255) UNIQUE,
    [role] VARCHAR(50) DEFAULT 'user',
    approved BIT DEFAULT 0
);

-- Tạo bảng nhà trọ
CREATE TABLE dbo.motels(
    motel_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
    descriptions NVARCHAR(MAX),
    detail_address NVARCHAR(255),
    district NVARCHAR(255),
    district_id VARCHAR(255),
    image VARCHAR(255),
    province NVARCHAR(255),
    province_id VARCHAR(255),
    status BIT NOT NULL,
    ward NVARCHAR(255),
    account_id INT,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id)
);

-- Tạo bảng danh mục phòng
CREATE TABLE dbo.category_room(
    category_room_id INT PRIMARY KEY IDENTITY(1,1),
    descriptions NVARCHAR(255),
    quantity INT,
    status BIT NOT NULL
);

-- Tạo bảng phòng trọ
CREATE TABLE dbo.motel_room(
    motel_room_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
    descriptions NVARCHAR(255),
    length FLOAT CHECK (length >= 1),
    width FLOAT CHECK (width >= 1),
    status BIT NOT NULL,
    video VARCHAR(255),
    category_room_id INT,
    motel_id INT,
    room_status NVARCHAR(255),
    FOREIGN KEY (category_room_id) REFERENCES dbo.category_room(category_room_id),
    FOREIGN KEY (motel_id) REFERENCES dbo.motels(motel_id)
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

-- Tạo bảng bài đăng
CREATE TABLE dbo.posts(
    post_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
    status BIT NOT NULL,
    title NVARCHAR(255),
    motel_id INT,
    FOREIGN KEY (motel_id) REFERENCES dbo.motels(motel_id)
);

-- Tạo bảng bài đăng yêu thích
CREATE TABLE dbo.favorite_post(
    favorite_post_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
    status BIT NOT NULL,
    account_id INT,
    post_id INT,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id),
    FOREIGN KEY (post_id) REFERENCES dbo.posts(post_id)
);

-- Tạo bảng thẻ (tag) cho bài đăng
CREATE TABLE dbo.tag(
    tag_id INT PRIMARY KEY IDENTITY(1,1),
    status BIT NOT NULL,
    title NVARCHAR(255)
);

-- Tạo bảng bài viết blog
CREATE TABLE dbo.blog(
    blog_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATETIME2(7) DEFAULT GETDATE(),
    descriptions NVARCHAR(MAX),
    image VARCHAR(255),
    status BIT NOT NULL,
    title NVARCHAR(255),
    account_id INT,
    tag_id INT,
    FOREIGN KEY (tag_id) REFERENCES dbo.tag(tag_id),
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id)
);

-- Tạo bảng giá phòng và tiện ích
CREATE TABLE dbo.room_cash(
    room_cash_id INT PRIMARY KEY IDENTITY(1,1),
    create_date DATE DEFAULT GETDATE(),
    room_price FLOAT,
    electricity_price FLOAT,
    water_price FLOAT,
    wifi_price FLOAT,
    motel_room_id INT,
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id)
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

-- Tạo bảng đánh giá
CREATE TABLE dbo.review (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    review_text NVARCHAR(MAX) NOT NULL,
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

-- Tạo người dùng quản trị mặc định
INSERT dbo.accounts (active, avatar, citizen_id, email, fullname, gender, [password], phone, [role], approved) VALUES 
(1, NULL, NULL, 'admin@gmail.com', 'ADMIN', 0, '$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', NULL, 'admin', 1);
