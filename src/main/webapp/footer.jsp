<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Footer</title>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            display: flex;
            flex-direction: column;
        }
        .content {
            flex: 1;
        }
        .footer {
            background: #343a40;
            color: white;
            padding-top: 1rem;
            padding-bottom: 1rem;
        }
        .footer a {
            color: #d1d1d1;
        }
    </style>
</head>
<body>
<div class="content">
    <!-- Your page content here -->
</div>

<div class="container-fluid bg-dark footer mt-5 pt-5 wow fadeIn" data-wow-delay="0.1s">
    <div class="container py-5">
        <div class="row g-5">
            <div class="col-lg-3 col-md-6">
                <h1 class="fw-bold text-primary mb-4">H<span class="text-secondary">O</span>ME</h1>
                <p>Chúng tôi cam kết cung cấp dịch vụ xuất sắc và sản phẩm chất lượng cho khách hàng. Đội ngũ của chúng tôi luôn nỗ lực đổi mới và hoàn thiện, đảm bảo đáp ứng và vượt qua mong đợi của bạn.</p>
                <div class="d-flex pt-2">
                    <a class="btn btn-square btn-outline-light rounded-circle me-1" href=""><i class="fab fa-twitter"></i></a>
                    <a class="btn btn-square btn-outline-light rounded-circle me-1" href=""><i class="fab fa-facebook-f"></i></a>
                    <a class="btn btn-square btn-outline-light rounded-circle me-1" href=""><i class="fab fa-youtube"></i></a>
                    <a class="btn btn-square btn-outline-light rounded-circle me-0" href=""><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <h4 class="text-light mb-4">Địa Chỉ</h4>
                <p><i class="fa fa-map-marker-alt me-3"></i>Thành phố Đà Nẵng, Quận Ngũ Hành Sơn</p>
                <p><i class="fa fa-phone-alt me-3"></i>0123456789</p>
                <p><i class="fa fa-envelope me-3"></i>info@example.com</p>
            </div>
            <div class="col-lg-3 col-md-6">
                <h4 class="text-light mb-4">Đường Link</h4>
                <a class="btn btn-link" href="about.jsp">Về Chúng Mình</a>
                <a class="btn btn-link" href="about.jsp">Liên Hệ với chúng mình</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
