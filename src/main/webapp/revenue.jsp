<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Doanh Thu</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="container">
    <h1 class="mt-5">Biểu Đồ Doanh Thu</h1>
    <div class="row">
        <div class="col-md-12">
            <canvas id="revenueChart"></canvas>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        $.ajax({
            url: 'getRevenueData',
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
                var revenueChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Doanh Thu',
                            data: values,
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                }
                            }]
                        }
                    }
                });
            },
            error: function(error) {
                console.error('Error:', error);
            }
        });
    });
</script>
</body>
</html>
