<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>About Us</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .contact-info {
            background-color: #f8f9fa;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .contact-info h2 {
            color: #343a40;
        }
        .contact-info p {
            color: #6c757d;
        }
        .social-icons a {
            font-size: 24px;
            margin-right: 15px;
            color: #343a40;
        }
        .body {
        margin-top: 100px;
        }

    </style>
</head>
<body  class="body">
<jsp:include page="header.jsp" ></jsp:include>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="contact-info text-center">
                <h2>Contact Us</h2>
                <p>Feel free to get in touch with us through any of the following methods:</p>
                <div class="row mt-4">
                    <div class="col-md-6">
                        <h5>Address</h5>
                        <p>Da Nang<br>City, Ngu Hanh Son<br>District</p>
                    </div>
                    <div class="col-md-6">
                        <h5>Phone</h5>
                        <p>0123456789</p>
                    </div>
                </div>
                <div class="row mt-4">
                    <div class="col-md-6">
                        <h5>Email</h5>
                        <p>info@company.com</p>
                    </div>
                    <div class="col-md-6">
                        <h5>Working Hours</h5>
                        <p>Monday - Friday: 9 AM - 6 PM<br>Saturday - Sunday: Closed</p>
                    </div>
                </div>
                <div class="social-icons mt-4">
                    <h5>Follow Us</h5>
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<!-- Font Awesome -->
<script src="https://kit.fontawesome.com/a076d05399.js"></script>
<jsp:include page="footer.jsp" />
</body>
</html>
