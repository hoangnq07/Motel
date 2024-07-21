<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">

        <!-- Font Icon -->
        <link rel="stylesheet"
              href="fonts/material-icon/css/material-design-iconic-font.min.css">

        <!-- Main css -->
        <link rel="stylesheet" href="account_assets/css/style.css">

        <style>
            body, h1, h2, h3, h4, h5, h6, p, a, input, label {
                font-family: initial;
            }
        </style>
    </head>
    <body>

        <div class="main">

            <!-- Sing in  Form -->
            <section class="sign-in">
                <div class="container">
                    <div class="signin-content">
                        <div class="signin-image">
                            <figure>
                                <img src="account_assets/images/signin-image.jpg" alt="sing up image">
                            </figure>
                            <a href="registration.jsp" class="signup-image-link">Tạo tài khoản</a>
                        </div>

                        <div class="signin-form">
                            <h2 class="form-title">Đăng Nhập</h2>
                            <form method="POST" action="login" class="register-form"
                                  id="login-form">
                                <div class="form-group">
                                    <%--@declare id="username"--%><label for="username"><i
                                            class="zmdi zmdi-account material-icons-name"></i></label> 
                                    <input type="text" name="email" id="email" required="" placeholder="Email" />
                                </div>
                                <div class="form-group">
                                    <label for="password"><i class="zmdi zmdi-lock"></i></label> <input
                                        type="password" name="password" id="password" required=""
                                        placeholder="Password" />
                                </div>
                                <div class="form-group">
                                    <%--@declare id="status"--%><label style="color: red" for="status" class="label-agree-term">
                                        <span><span></span></span><%= request.getAttribute("status") == null ? "" : request.getAttribute("status")%></label>
                                </div>

                                <div class="form-group form-button">
                                    <input type="submit" name="signin" id="signin"
                                           class="form-submit" value="Log in" />
                                </div>
                                <div class="form-group">
                                    <a href="forgot-password.jsp" class="signup-image-link">Quên Mật Khẩu ư?</a>
                                </div>
                            </form>
                            <a href="https://accounts.google.com/o/oauth2/auth?scope=email&redirect_uri=http://localhost:9999/Project/login-google&response_type=code
                                   &client_id=641055812351-oek687om0tcvhgbmfutel5qjn1cdd9nl.apps.googleusercontent.com&approval_prompt=force" class="btn btn-google">
                                <span class="google-icon">G+</span>
                                <span class="btn-text">Đăng Nhập với Google</span>
                            </a>
                        </div>
                    </div>
                </div>
            </section>

        </div>

        <!-- JS -->
        <script src="vendor/jquery/jquery.min.js"></script>
        <script src="js/main.js"></script>
    </body>
</html>