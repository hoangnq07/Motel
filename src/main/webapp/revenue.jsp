<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        #yearSelector {
            width: 200px;  /* Đặt chiều rộng cố định */
            font-size: 14px;  /* Đặt cỡ chữ nhỏ hơn */
            margin-top: 20px;
        }
        .form-group {
            text-align: center;  /* Căn giữa cho dropdown */
        }
        .dashboard-card {
            margin: 20px;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .dashboard-card .card-icon {
            font-size: 2em;
            margin-bottom: 10px;
        }
        .dashboard-card .card-title {
            font-size: 1.5em;
        }
        .dashboard-card .card-value {
            font-size: 2em;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="mt-5">Dashboard</h1>
    <div class="row">
        <div class="col-md-4">
            <div class="dashboard-card bg-info text-white">
                <div class="card-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="card-title">Renters</div>
                <div class="card-value" id="rentersCount">0</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="dashboard-card bg-success text-white">
                <div class="card-icon">
                    <i class="fas fa-home"></i>
                </div>
                <div class="card-title">Motels</div>
                <div class="card-value" id="motelsCount">0</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="dashboard-card bg-warning text-white">
                <div class="card-icon">
                    <i class="fas fa-door-open"></i>
                </div>
                <div class="card-title">Rooms</div>
                <div class="card-value" id="roomsCount">0</div>
            </div>
        </div>
    </div>
    <div class="form-group">
        <label for="yearSelector">Chọn năm:</label>
        <select class="form-control" id="yearSelector">
            <option value="2022">2022</option>
            <option value="2023">2023</option>
            <option value="2024" selected>2024</option>
        </select>
    </div>
    <div class="row">
        <div class="col-md-12">
            <canvas id="revenueChart"></canvas>
        </div>
    </div>
</div>

<script>
    function fetchDashboardStats() {
        $.ajax({
            url: 'dashboardStats',
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                $('#rentersCount').text(data.numberOfRenters);
                $('#motelsCount').text(data.numberOfMotels);
                $('#roomsCount').text(data.numberOfRooms);
            },
            error: function(error) {
                console.error('Error:', error);
            }
        });
    }

    function fetchRevenueData(year) {
        $.ajax({
            url: 'getRevenueData?year=' + year,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                var labels = [];
                var values = [];
                data.forEach(function(item) {
                    labels.push("Tháng " + item.month);
                    values.push(item.totalRevenue);
                });

                var ctx = document.getElementById('revenueChart').getContext('2d');
                if (window.revenueChart && typeof window.revenueChart.destroy === 'function') {
                    window.revenueChart.destroy();
                }
                window.revenueChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Doanh Thu ' + year,
                            data: values,
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        scales: {
                            y: {
                                ticks: {
                                    beginAtZero: true
                                }
                            }
                        }
                    }
                });
            },
            error: function(error) {
                console.error('Error:', error);
            }
        });
    }

    $(document).ready(function() {
        fetchDashboardStats();
        var selectedYear = $('#yearSelector').val();
        fetchRevenueData(selectedYear);
        $('#yearSelector').change(function() {
            fetchRevenueData($(this).val());
        });
    });
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
</body>
</html>
