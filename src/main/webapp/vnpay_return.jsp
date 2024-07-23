<%@page import="java.net.URLEncoder"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="com.vnpay.common.Config"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Payment Result">
    <meta name="author" content="">
    <title>Kết Quả Thanh Toán</title>
    <!-- Bootstrap core CSS -->
    <link href="/vnpay_jsp/assets/bootstrap.min.css" rel="stylesheet">
    <!-- Inline CSS -->
    <style>
        body {
            padding-top: 20px;
            padding-bottom: 20px;
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .header {
            margin-bottom: 20px;
        }

        .header h3 {
            margin: 0;
            font-size: 24px;
            color: #333;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th, .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .table th {
            background-color: #f5f5f5;
            font-weight: bold;
        }

        .footer {
            padding: 10px;
            text-align: center;
            border-top: 1px solid #e5e5e5;
            background-color: #f5f5f5;
            margin-top: 20px;
        }
    </style>
    <!-- jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            // Tạo một đối tượng dữ liệu từ các phần tử HTML
            var postData = {
                invoiceId: $('#vnp_TxnRef').text(),
                amount: $('#vnp_Amount').text(),
                vnp_OrderInfo: $('#vnp_OrderInfo').text(),
                responseCode: $('#vnp_ResponseCode').text(),
                vnp_TransactionNo: $('#vnp_TransactionNo').text(),
                vnp_BankCode: $('#vnp_BankCode').text(),
                vnp_PayDate: $('#vnp_PayDate').text()
            };

            // Log dữ liệu trước khi gửi yêu cầu AJAX
            console.log('Data being sent:', postData);

            // Gửi yêu cầu AJAX khi trang tải xong
            $.ajax({
                url: 'checkPayment', // Thay đổi URL nếu cần
                type: 'POST',
                data: postData,
                success: function(response) {
                    // Log phản hồi từ server
                    console.log('Success:', response);
                },
                error: function(xhr, status, error) {
                    // Log lỗi
                    console.error('Error:', error);
                    console.error('Response text:', xhr.responseText); // Log thêm thông tin từ server nếu có
                }
            });
        });
    </script>
</head>
<body>
<%
    // Begin process return from VNPAY
    Map<String, String> fields = new HashMap<>();
    for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
        String fieldName = URLEncoder.encode(params.nextElement(), StandardCharsets.US_ASCII.toString());
        String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
        if (fieldValue != null && fieldValue.length() > 0) {
            fields.put(fieldName, fieldValue);
        }
    }

    String vnp_SecureHash = request.getParameter("vnp_SecureHash");
    fields.remove("vnp_SecureHashType");
    fields.remove("vnp_SecureHash");
    String signValue = Config.hashAllFields(fields);
%>
<!-- Begin display -->
<div class="container">
    <header class="header">
        <h3>Kết Quả Thanh Toán</h3>
    </header>
    <div class="table-responsive">
        <table class="table">
            <tbody>
            <tr>
                <th>Mã giao dịch thanh toán:</th>
                <td id="vnp_TxnRef"><%= request.getParameter("vnp_TxnRef") %></td>
            </tr>
            <tr>
                <th>Số tiền:</th>
                <td id="vnp_Amount"><%= request.getParameter("vnp_Amount") %></td>
            </tr>
            <tr>
                <th>Mô tả giao dịch:</th>
                <td id="vnp_OrderInfo"><%= request.getParameter("vnp_OrderInfo") %></td>
            </tr>
            <tr>
                <th>Mã lỗi thanh toán:</th>
                <td id="vnp_ResponseCode"><%= request.getParameter("vnp_ResponseCode") %></td>
            </tr>
            <tr>
                <th>Mã giao dịch tại CTT VNPAY-QR:</th>
                <td id="vnp_TransactionNo"><%= request.getParameter("vnp_TransactionNo") %></td>
            </tr>
            <tr>
                <th>Mã ngân hàng thanh toán:</th>
                <td id="vnp_BankCode"><%= request.getParameter("vnp_BankCode") %></td>
            </tr>
            <tr>
                <th>Thời gian thanh toán:</th>
                <td id="vnp_PayDate"><%= request.getParameter("vnp_PayDate") %></td>
            </tr>
            <tr>
                <th>Tình trạng giao dịch:</th>
                <td>
                    <%
                        if (signValue.equals(vnp_SecureHash)) {
                            if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                                out.print("Thành công");
                            } else {
                                out.print("Không thành công");
                            }
                        } else {
                            out.print("Invalid signature");
                        }
                    %>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <footer class="footer">
        <p>&copy; VNPAY 2024</p>
    </footer>
</div>
</body>
</html>
