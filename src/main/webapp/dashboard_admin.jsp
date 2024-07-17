<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard</title>
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
        <div>
            <div class="brand-logo d-flex align-items-center justify-content-between">
                <a href="home" class="text-nowrap logo-img">HOME</a>
                <div class="close-btn d-xl-none d-block sidebartoggler cursor-pointer" id="sidebarCollapse">
                    <i class="ti ti-x fs-8"></i>
                </div>
            </div>
            <!-- Sidebar navigation-->
            <nav class="sidebar-nav scroll-sidebar" data-simplebar="">
                <ul id="sidebarnav">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="./index.html" aria-expanded="false">
                                <span>
                                    <i class="ti ti-layout-dashboard"></i>
                                </span>
                            <span class="hide-menu">Dashboard</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="#" id="accounts" aria-expanded="false">
                                <span>
                                    <i class="ti ti-user"></i>
                                </span>
                            <span class="hide-menu">Accounts</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="#" id="feedback" aria-expanded="false">
                                <span>
                                    <i class="ti ti-message"></i>
                                </span>
                            <span class="hide-menu">Feedback</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="./authorityRequests.jsp">
                            <span class="icon">
                                <i class="ti ti-user"></i>
                            </span>
                            <span>Request</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="./statistics.html">
                            <span class="icon">
                                <i class="ti ti-chart-bar"></i>
                            </span>
                            <span>Statistics</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="pending-room-requests?action=listPending" id="posting-requests" aria-expanded="false">
                            <span>
                                <i class="ti ti-file"></i>
                            </span>
                            <span class="hide-menu">Posting Requests</span>
                        </a>
                    </li>
                </ul>
            </nav>
            <!-- End Sidebar navigation -->
        </div>
        <!-- End Sidebar scroll-->
    </aside>
    <!-- Sidebar End -->
    <!-- Main wrapper -->
    <div class="body-wrapper">
        <!-- Header -->
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
                            <a class="nav-link nav-icon-hover" href="javascript:void(0)" id="drop2"
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="./assets1/images/profile/user-1.jpg" alt="" width="35" height="35"
                                     class="rounded-circle">
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
                            <!-- Main content where accounts and feedbacks are displayed -->
                            <div id="content-container"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="add-account-modal" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Account</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="add-account-form">
                    <div class="mb-3">
                        <label for="fullname" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="fullname" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="tel" class="form-control" id="phone" required>
                    </div>
                    <div class="mb-3">
                        <label for="dob" class="form-label">Date of Birth</label>
                        <input type="date" class="form-control" id="dob" required>
                    </div>
                    <div class="mb-3">
                        <label for="citizenId" class="form-label">Citizen ID</label>
                        <input type="text" class="form-control" id="citizenId" required>
                    </div>
                    <div class="mb-3">
                        <label for="gender" class="form-label">Gender</label>
                        <select class="form-select" id="gender" required>
                            <option value="">Select gender</option>
                            <option value="true">Male</option>
                            <option value="false">Female</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="role" class="form-label">Role</label>
                        <select class="form-select" id="role" required>
                            <option value="">Select a role</option>
                            <option value="user">User</option>
                            <option value="owner">Owner</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" required>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="active" checked>
                        <label class="form-check-label" for="active">Active</label>
                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="save-account">Save Account</button>
            </div>
        </div>
    </div>
</div>
<script src="./assets1/libs/jquery/dist/jquery.min.js"></script>
<script src="./assets1/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
<script src="./assets1/js/sidebarmenu.js"></script>
<script src="./assets1/js/app.min.js"></script>
<script>
    $(document).ready(function () {
        // Handle Accounts click
        $('#accounts').click(function (e) {
            e.preventDefault();
            $.ajax({
                url: 'fetchAllAccounts',
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    var accountsHtml = '<h3>All Accounts</h3><button id="add-account-btn" class="btn btn-success mb-3">Add Account</button><table class="table table-hover">' +
                        '<thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Role</th><th>Status</th><th>Actions</th></tr></thead><tbody>';

                    data.forEach(function (account) {
                        accountsHtml += '<tr>' +
                            '<td>' + account.accountId + '</td>' +
                            '<td>' + account.fullname + '</td>' +
                            '<td>' + account.email + '</td>' +
                            '<td>' + account.phone + '</td>' +
                            '<td>' + account.role + '</td>' +
                            '<td><div class="form-check form-switch">' +
                            '<input class="form-check-input status-toggle" type="checkbox" role="switch" ' +
                            'id="status-' + account.accountId + '" ' + (account.active ? 'checked' : '') + ' ' +
                            'data-id="' + account.accountId + '">' +
                            '<label class="form-check-label" for="status-' + account.accountId + '">' +
                            '</div></td>' +
                            '<td>' +
                            '<button class="btn btn-primary btn-sm edit-account" data-id="' + account.accountId + '">Edit</button> ' +
                            // '<button class="btn btn-danger btn-sm delete-account" data-id="' + account.accountId + '">Delete</button>' +
                            '</td>' +
                            '</tr>';
                    });

                    accountsHtml += '</tbody></table>';
                    $('#content-container').html(accountsHtml);
                    // Add Account functionality
                    $('#add-account-btn').click(function () {
                        $('#add-account-modal').modal('show');
                    });
                    // Edit account functionality
                    $('.edit-account').click(function () {
                        var accountId = $(this).data('id');
                        $.ajax({
                            url: 'fetchAccount',
                            type: 'GET',
                            data: {accountId: accountId},
                            success: function (account) {
                                // Populate the add account form with the account details
                                $('#fullname').val(account.fullname);
                                $('#email').val(account.email);
                                $('#phone').val(account.phone);
                                var dobDate = new Date(account.dob);
                                var year = dobDate.getFullYear();
                                var month = (dobDate.getMonth() + 1).toString().padStart(2, '0'); // Month is zero-based
                                var day = dobDate.getDate().toString().padStart(2, '0');
                                var formattedDate = year + '-' + month + '-' + day;
                                $('#dob').val(formattedDate);
                                $('#avatar').val(account.avatar);
                                $('#citizenId').val(account.citizenId);
                                var genderValue = account.gender ? 'true' : 'false';
                                $('#gender').val(genderValue);
                                $('#role').val(account.role);
                                $('#active').prop('checked', account.active);
                                // Change the modal title and save button text
                                $('.modal-title').text('Edit Account');
                                $('#save-account').text('Update Account').data('id', accountId);

                                // Show the modal
                                $('#add-account-modal').modal('show');
                            },
                            error: function () {
                                alert('Failed to fetch account details');
                            }
                        });
                    });
                    // Modify the save account function to handle both add and edit
                    $('#save-account').click(function () {
                        var accountData = {
                            fullname: $('#fullname').val() || null,
                            email: $('#email').val() || null,
                            phone: $('#phone').val() || null,
                            dob: $('#dob').val() || null,
                            avatar: $('#avatar').val() || null,
                            citizenId: $('#citizenId').val() || null,
                            gender: $('#gender').val() || null,
                            role: $('#role').val() || null,
                            active: $('#active').prop('checked'),
                        };
                        console.log(accountData);
                        // Kiểm tra nếu accountId tồn tại, thêm vào dữ liệu gửi đi
                        var url = 'addAccount';
                        var accountId = $(this).data('id');
                        if (accountId) {
                            url = 'updateAccount';
                            accountData.accountId = accountId;
                            if (!$('#password').val()) {
                                delete accountData.password;
                            } else {
                                accountData.password = $('#password').val() || null;
                            }
                        } else {
                            accountData.password = $('#password').val() || null;
                        }

                        // Kiểm tra và xử lý dữ liệu rỗng
                        for (var key in accountData) {
                            if (accountData.hasOwnProperty(key) && accountData[key] === null) {
                                delete accountData[key]; // Xóa các trường có giá trị null khỏi đối tượng
                            }
                        }

                        $.ajax({
                            url: url,
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify(accountData),
                            success: function (response) {
                                if (response.success) {
                                    alert(accountId ? 'Account updated successfully' : 'Account added successfully');
                                    $('#add-account-modal').modal('hide');
                                    $('#accounts').click(); // Refresh the account list
                                } else {
                                    alert(accountId ? 'Failed to update account' : 'Failed to add account');
                                }
                            },
                            error: function () {
                                alert('An error occurred');
                            }
                        });
                    });

                    // Reset the form when the modal is hidden
                    $('#add-account-modal').on('hidden.bs.modal', function () {
                        $('#add-account-form')[0].reset();
                        $('.modal-title').text('Add New Account');
                        $('#save-account').text('Save Account').removeData('id');
                    });

                    // Delete account functionality
                    $('.delete-account').click(function () {
                        var accountId = $(this).data('id');
                        if (confirm('Are you sure you want to delete this account?')) {
                            $.ajax({
                                url: 'deleteAccount',
                                type: 'POST',
                                data: {accountId: accountId},
                                success: function (response) {
                                    if (response.success) {
                                        alert('Account deleted successfully');
                                        $('#accounts').click(); // Refresh the account list
                                    } else {
                                        alert('Failed to delete account');
                                    }
                                },
                                error: function () {
                                    alert('An error occurred while deleting the account');
                                }
                            });
                        }
                    });

                    // Add event listener for status toggle
                    $('.status-toggle').change(function () {
                        var accountId = $(this).data('id');
                        var isActive = $(this).prop('checked');
                        updateAccountStatus(accountId, isActive);
                    });
                },
                error: function () {
                    alert('Unable to fetch accounts. Please try again later.');
                }
            });
        });



        function updateAccountStatus(accountId, isActive) {
            $.ajax({
                url: 'updateAccountStatus',
                type: 'POST',
                data: {
                    accountId: accountId,
                    active: isActive
                },
                success: function (response) {
                    if (response.success) {
                        // Update the label
                        alert('Account status updated successfully');
                    } else {
                        alert('Failed to update account status');
                        // Revert the toggle if update failed
                        $('#status-' + accountId).prop('checked', !isActive);
                    }
                },
                error: function () {
                    alert('An error occurred while updating account status');
                    // Revert the toggle if update failed
                    $('#status-' + accountId).prop('checked', !isActive);
                }
            });
        }

        // Existing feedback handling code
        $('#feedback').click(function (e) {
            e.preventDefault();
            $.ajax({
                url: 'fetchAdminFeedback',
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    var feedbackHtml = '<h3>Feedback</h3><table class="table table-hover">' +
                        '<thead><tr><th>Date</th><th>Feedback</th><th>From</th><th>Actions</th></tr></thead><tbody>';

                    data.forEach(function (fb) {
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

                    feedbackHtml += '</tbody></table>';
                    $('#content-container').html(feedbackHtml);

                    $('.reply-btn').click(function () {
                        var id = $(this).data('id');
                        $('#reply-row-' + id).toggle();
                    });
                },
                error: function () {
                    alert('Unable to fetch feedback. Please try again later.');
                }
            });
        });
    });
</script>

</body>

</html>
