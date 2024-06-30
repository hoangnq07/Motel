<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Modernize Free</title>
    <link rel="shortcut icon" type="image/png" href="./assets1/images/logos/favicon.png"/>
    <link rel="stylesheet" href="./assets1/css/styles.min.css"/>
</head>

<body>
<!-- Body Wrapper -->
<div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
     data-sidebar-position="fixed" data-header-position="fixed">
    <!-- Sidebar Start -->
    <aside class="left-sidebar">
        <!-- Sidebar scroll-->
        <div class="sidebar-nav scroll-sidebar">
            <div class="brand-logo d-flex align-items-center justify-content-between">
                <a href="home" class="text-nowrap logo-img">HOME</a>
                <div class="close-btn d-xl-none d-block sidebartoggler cursor-pointer" id="sidebarCollapse">
                    <i class="ti ti-x fs-8"></i>
                </div>
            </div>
            <!-- Sidebar navigation-->
            <nav class="sidebar-nav" data-simplebar="">
                <ul id="sidebarnav">
                    <li class="sidebar-item"><a class="sidebar-link" href="./index.html"><span>Dashboard</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="./account.html"><span>Account</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="#" id="feedback"><span>Feedback</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="./request.html"><span>Request</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="./statistics.html"><span>Statistics</span></a></li>
                </ul>
            </nav>
            <!-- End Sidebar navigation -->
        </div>
        <!-- End Sidebar scroll-->
    </aside>
    <!-- Sidebar End -->
    <!-- Main wrapper -->
    <div class="body-wrapper">
        <header class="app-header">
            <nav class="navbar navbar-expand-lg navbar-light">
                <ul class="navbar-nav">
                    <li class="nav-item d-block d-xl-none">
                        <a class="nav-link sidebartoggler nav-icon-hover" id="headerCollapse" href="javascript:void(0)">
                            <i class="ti ti-menu-2"></i>
                        </a>
                    </li>
                </ul>
                <div class="navbar-collapse justify-content-end" id="navbarNav">
                    <ul class="navbar-nav flex-row ms-auto align-items-center">
                        <li class="nav-item dropdown">
                            <a class="nav-link nav-icon-hover" href="javascript:void(0)" id="drop2" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="./assets1/images/profile/user-1.jpg" alt="" width="35" height="35" class="rounded-circle">
                            </a>
                            <div class="dropdown-menu dropdown-menu-end" aria-labelledby="drop2">
                                <a href="javascript:void(0)" class="d-flex align-items-center gap-2 dropdown-item">
                                    <i class="ti ti-user fs-6"></i>
                                    <p>My Profile</p>
                                </a>
                                <a href="javascript:void(0)" class="d-flex align-items-center gap-2 dropdown-item">
                                    <i class="ti ti-mail fs-6"></i>
                                    <p>Change password</p>
                                </a>
                                <a href="logout" class="btn btn-outline-primary mx-3 mt-2">Logout</a>
                            </div>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>
        <!-- Container fluid -->
        <div class="container-fluid">
            <div class="row">
                <div class="col-12 d-flex align-items-stretch">
                    <div class="card w-100">
                        <div class="card-body p-4">
                            <!-- Main content where feedbacks are displayed -->
                            <div id="feedback-container" style="display: none;">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Feedback</th>
                                        <th>From</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody id="feedback-list"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="./assets1/libs/jquery/dist/jquery.min.js"></script>
<script src="./assets1/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="./assets1/js/sidebarmenu.js"></script>
<script src="./assets1/js/app.min.js"></script>
<script>
    $(document).ready(function() {
        $('#feedback').click(function(e) {
            e.preventDefault(); // Prevent the default link behavior
            $.ajax({
                url: 'fetchAdminFeedback',
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    var feedbackHtml = '';
                    data.forEach(function(fb) {
                        feedbackHtml += '<tr>' +
                            '<td>' + new Date(fb.createDate).toLocaleString() + '</td>' +
                            '<td>' + fb.feedbackText + '</td>' +
                            '<td>' + fb.senderName + '</td>' +
                            '<td><button class="btn btn-primary reply-btn" data-id="' + fb.feedbackId + '">Reply</button></td>' +
                            '</tr>' +
                            '<tr id="reply-row-' + fb.feedbackId + '" class="reply-row" style="display:none;">' +
                            '<td colspan="4"><textarea class="form-control" rows="2"></textarea><button class="btn btn-success mt-2">Send Reply</button></td>' +
                            '</tr>';
                    });
                    $('#feedback-list').html(feedbackHtml);
                    $('#feedback-container').show();
                    $('.reply-btn').click(function() {
                        var id = $(this).data('id');
                        $('#reply-row-' + id).toggle();
                    });
                },
                error: function() {
                    alert('Unable to fetch feedback. Please try again later.');
                }
            });
        });
    });
</script>
</body>
</html>
