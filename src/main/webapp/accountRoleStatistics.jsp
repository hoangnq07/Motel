<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Account Role Statistics</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .chart-container {
            width: 70%;
            float: left;
            height: 600px;
            margin: auto;
        }
        .stats-container {
            width: 30%;
            float: right;
            height: 600px;
            padding: 20px;
            background-color: #f8f9fa;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            justify-content: space-around;
        }
        .stat-item {
            display: flex;
            align-items: center;
            justify-content: space-around;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .stat-item img {
            width: 50px;
            height: 50px;
        }
        .stat-item .stat-text {
            margin-left: 10px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h1 class="mb-4 text-center">Account Role Statistics</h1>
    <div class="chart-container">
        <canvas id="accountRoleChart"></canvas>
    </div>
    <div class="stats-container">
        <div class="stat-item">
            <img src="images/motel.png" alt="Motel Icon">
            <div class="stat-text">
                <h3>Total Motels</h3>
                <p id="totalMotels">Loading...</p>
            </div>
        </div>
        <div class="stat-item">
            <img src="images/room.png" alt="Room Icon">
            <div class="stat-text">
                <h3>Total Rooms</h3>
                <p id="totalRooms">Loading...</p>
            </div>
        </div>
        <div class="stat-item">
            <img src="images/renter.png" alt="Renter Icon">
            <div class="stat-text">
                <h3>Total Renters</h3>
                <p id="totalRenters">Loading...</p>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        var ctx = document.getElementById('accountRoleChart').getContext('2d');
        var accountRoleChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Admin', 'Owner', 'User'],
                datasets: [{
                    label: 'Number of Accounts',
                    data: [5, 10, 20], // Sample data
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)'
                    ],
                    borderWidth: 1,
                    barThickness: 60
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        $.ajax({
            url: 'accountRoleStatistics',
            method: 'GET',
            success: function(data) {
                $('#totalMotels').text(data.totalMotels);
                $('#totalRooms').text(data.totalRooms);
                $('#totalRenters').text(data.totalRenters);
            }
        });
    });
</script>

<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
        integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI"
        crossorigin="anonymous"></script>
</body>
</html>
