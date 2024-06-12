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

            <!-- Sign up form -->
            <section class="signup">
                <div class="container">
                    <div class="signup-content">
                        <div class="signup-form">
                            <h2 class="form-title">Sign up</h2>

                            <form method="POST" action="register" class="register-form"
                                  id="register-form">

                                <div class="form-group">
                                    <label for="email"><i class="zmdi zmdi-email"></i></label> <input
                                        type="email" name="email" id="email" required="" placeholder="Your Email" />
                                </div>
                                <div class="form-group">
                                    <label for="pass"><i class="zmdi zmdi-lock"></i></label> <input
                                        type="password" name="pass" id="pass" required="" placeholder="Password" />
                                </div>
                                
                                <div class="form-group">
                                    <label for="contact"><i class="zmdi zmdi-lock-outline"></i></label>
                                    <input type="text" name="phone" id="contact" required="" placeholder="Phone number" />
                                </div>
                                <div class="form-group">
                                    <label style="color: red" for="status" class="label-agree-term">
                                        <span><span></span></span><%= request.getAttribute("status") == null ? "" : request.getAttribute("status")%></label>
                                </div>
                                <div class="form-group form-button">
                                    <input type="submit" name="signup" id="signup"
                                           class="form-submit" value="Register" />
                                </div>
                            </form>
                        </div>
                        <div class="signup-image">
                            <figure>
                                <img src="account_assets/images/signup-image.jpg" alt="sing up image">
                            </figure>
                            <a href="login.jsp" class="signup-image-link">I am already member</a>
                        </div>
                    </div>
                </div>
            </section>


        </div>
        <!-- JS -->
        <script src="vendor/jquery/jquery.min.js"></script>
        <script src="js/main.js"></script>



    </body>
    <!-- This templates was made by Colorlib (https://colorlib.com) -->
</html>