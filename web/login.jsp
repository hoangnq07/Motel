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
                            <a href="registration.jsp" class="signup-image-link">Create an account</a>
                        </div>

                        <div class="signin-form">
                            <h2 class="form-title">Sign in</h2>
                            <form method="POST" action="login" class="register-form"
                                  id="login-form">
                                <div class="form-group">
                                    <label for="username"><i
                                            class="zmdi zmdi-account material-icons-name"></i></label> 
                                    <input type="text" name="email" id="email" required="" placeholder="Email" />
                                </div>
                                <div class="form-group">
                                    <label for="password"><i class="zmdi zmdi-lock"></i></label> <input
                                        type="password" name="password" id="password" required=""
                                        placeholder="Password" />
                                </div>
                                <div class="form-group">
                                    <label style="color: red" for="status" class="label-agree-term">
                                        <span><span></span></span><%= request.getAttribute("status") == null ? "" : request.getAttribute("status")%></label>
                                </div>

                                <div class="form-group form-button">
                                    <input type="submit" name="signin" id="signin"
                                           class="form-submit" value="Log in" />
                                </div>
                                <div class="form-group">
                                    <a href="#" class="signup-image-link">Forgot password?</a>
                                </div>
                            </form>

                            <div class="social-login">
                                <a href="https://accounts.google.com/o/oauth2/auth?scope=email&redirect_uri=http://localhost:9999/Assignment/login-google&response_type=code
                                   &client_id=409560142881-vcesta6vsjgkn20u47uefh0cdqbe72b5.apps.googleusercontent.com&approval_prompt=force" class="social-label-button><i
                                   class="display-flex-center"> </i> Or login with Google
                                </a>
                            </div>
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