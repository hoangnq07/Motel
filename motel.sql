CREATE DATABASE motel2
USE motel2

CREATE TABLE accounts(
    account_id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    avatar VARCHAR(255) NULL,
    citizen_id VARCHAR(255) NULL,
    create_date DATE NULL DEFAULT GETDATE(),
    dob DATE NULL,
    email VARCHAR(255) NULL,
    fullname NVARCHAR(255) NULL,
    gender BIT NOT NULL,
    [password] VARCHAR(255) NULL,
    phone VARCHAR(255) NULL,
    [role] VARCHAR(50) DEFAULT 'user'
);

CREATE TABLE dbo.tag(
    tag_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    status [bit] NOT NULL,
    title [nvarchar](255) NULL
    );

CREATE TABLE dbo.blog(
    blog_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    create_date [datetime2](7) NULL,
    descriptions [nvarchar](max) NULL,
    image [varchar](255) NULL,
    status [bit] NOT NULL,
    title [nvarchar](255) NULL,
    account_id [int] NULL,
    tag_id [int] NULL,
    FOREIGN KEY (tag_id) REFERENCES dbo.tag (tag_id),
    FOREIGN KEY (account_id) REFERENCES dbo.accounts (account_id)
    );

CREATE TABLE dbo.category_room(
    category_room_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    descriptions [nvarchar](255) NULL,
    quantity [int] NULL,
    status [bit] NOT NULL
    );


CREATE TABLE dbo.motels(
    motel_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    create_date [date] NULL,
    descriptions [nvarchar](255) NULL,
    detail_address [nvarchar](255) NULL,
    district [nvarchar](255) NULL,
    districtid [varchar](255) NULL,
    image [varchar](255) NULL,
    province [nvarchar](255) NULL,
    provinceid [varchar](255) NULL,
    status [bit] NOT NULL,
    ward [nvarchar](255) NULL,
    account_id [int] NULL,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts (account_id)
    );


CREATE TABLE dbo.motel_room(
    motel_room_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    create_date [date] NULL,
    descriptions [nvarchar](255) NULL,
    length [float] NOT NULL,
    status [bit] NOT NULL,
    video [varchar](255) NULL,
    width [float] NOT NULL,
    category_room_id [int] NULL,
    motel_id [int] NULL,
    room_status [nvarchar](255) NULL,
    FOREIGN KEY (category_room_id) REFERENCES dbo.category_room (category_room_id),
    FOREIGN KEY (motel_id) REFERENCES dbo.motels (motel_id),
    CONSTRAINT CK_motel_room_length CHECK (length >= 1),
    CONSTRAINT CK_motel_room_width CHECK (width >= 1)
    );


CREATE TABLE dbo.favorite_room(
    favorite_room_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    create_date [date] NULL,
    status [bit] NOT NULL,
    account_id [int] NULL,
    motel_room_id [int] NULL,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts (account_id),
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room (motel_room_id)
    );

CREATE TABLE dbo.image(
    image_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    name [varchar](255) NULL,
    motel_room_id [int] NULL,
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room (motel_room_id)
    );

CREATE TABLE dbo.indexs(
    index_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    create_date [datetime2](7) NULL,
    electricity_index [float] NULL,
    water_index [float] NULL,
    motel_room_id [int] NULL,
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room (motel_room_id)
    );

CREATE TABLE dbo.posts(
    post_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    create_date [date] NULL,
    status [bit] NOT NULL,
    title [nvarchar](255) NULL,
    motel_id [int] NULL,
    FOREIGN KEY (motel_id) REFERENCES dbo.motels (motel_id)
    );
CREATE TABLE dbo.renter(
    renter_id [int] PRIMARY KEY NOT NULL,
    change_room_date [date] NULL,
    check_out_date [date] NULL,
    renter_date [date] NULL,
    motel_room_id [int] NULL,
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room (motel_room_id),
    FOREIGN KEY (renter_id) REFERENCES dbo.accounts (account_id)
    );


CREATE TABLE dbo.request_authority(
    request_authority_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    avatar [varchar](255) NULL,
    createdate [date] NULL,
    descriptions [nvarchar](255) NULL,
    respdescriptions [nvarchar](255) NULL,
    responsedate [date] NULL,
    account_id [int] NULL,
    request_authority_status [nvarchar](255) NULL,
    FOREIGN KEY (account_id) REFERENCES dbo.accounts (account_id));

CREATE TABLE dbo.invoice(
    invoice_id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    create_date [date] NULL,
    new_electricity_index [float] NULL,
    new_water_index [float] NULL,
    old_electricity_index [float] NULL,
    old_water_index [float] NULL,
    total_price [float] NULL,
    invoice_status [nvarchar] NULL,
    renter_id [int] NULL,
	motel_room_id INT NULL,
    FOREIGN KEY (renter_id) REFERENCES dbo.renter (renter_id),
	FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id)
    );

CREATE TABLE dbo.room_cash (
    room_cash_id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    create_date DATE NULL,
    room_price FLOAT NULL,
    electricity_price FLOAT NULL,
    water_price FLOAT NULL,
    wifi_price FLOAT NULL,
    motel_room_id INT NOT NULL,
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id)
);

CREATE TABLE dbo.rating (
    rating_id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    rating_value INT NOT NULL, -- Giá trị đánh giá, ví dụ từ 1 đến 5 sao
    create_date DATETIME NOT NULL DEFAULT GETDATE(),
    account_id INT NOT NULL, -- Tài khoản đánh giá
    motel_id INT NULL, -- Nhà trọ được đánh giá
    motel_room_id INT NULL, -- Phòng trọ được đánh giá
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id),
    FOREIGN KEY (motel_id) REFERENCES dbo.motels(motel_id),
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id),
    CONSTRAINT CHK_rating_value CHECK (rating_value >= 1 AND rating_value <= 5)
);

CREATE TABLE dbo.review (
    review_id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    review_text NVARCHAR(MAX) NOT NULL, -- Nội dung đánh giá
    create_date DATETIME NOT NULL DEFAULT GETDATE(),
    account_id INT NOT NULL, -- Tài khoản đánh giá
    motel_id INT NULL, -- Nhà trọ được đánh giá
    motel_room_id INT NULL, -- Phòng trọ được đánh giá
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id),
    FOREIGN KEY (motel_id) REFERENCES dbo.motels(motel_id),
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id)
);

CREATE TABLE dbo.feedback (
    feedback_id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    feedback_text NVARCHAR(MAX) NOT NULL, -- Nội dung phản hồi
    create_date DATETIME NOT NULL DEFAULT GETDATE(),
    account_id INT NOT NULL, -- Tài khoản phản hồi
    motel_id INT NULL, -- Nhà trọ liên quan
    motel_room_id INT NULL, -- Phòng trọ liên quan
    FOREIGN KEY (account_id) REFERENCES dbo.accounts(account_id),
    FOREIGN KEY (motel_id) REFERENCES dbo.motels(motel_id),
    FOREIGN KEY (motel_room_id) REFERENCES dbo.motel_room(motel_room_id)
);

INSERT dbo.accounts (active, avatar, citizen_id, create_date, email, fullname, gender, password, phone, role) VALUES ( 1, NULL, NULL, NULL, N'admin@gmail.com', N'ADMIN', 0, N'$2a$10$uXuofG8QEf4SFRpdWSxt3u9U4/hEX4FPLj8rHdbPo9bipmRjMqVsy', NULL,'admin')
