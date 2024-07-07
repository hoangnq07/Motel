<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, context.DBcontext" %>
<%@ page import="Account.Account" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create New Bill</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
  <style>
    body {
      margin-top: 50px;
      background-color: #f8f9fa;
    }
    .sidebar {
      background-color: #343a40;
      min-height: 100vh;
      padding-top: 20px;
    }
    .sidebar a {
      color: #f8f9fa;
      padding: 10px 15px;
      display: block;
      transition: all 0.3s;
    }
    .sidebar a:hover, .sidebar a.active {
      background-color: #495057;
      text-decoration: none;
    }
    .content-area {
      padding: 20px;
    }
    .nav-link {
      border-radius: 0;
    }
  </style>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<div class="container-fluid">
<div class="row">
  <div class="col-md-2 sidebar">
    <ul class="nav flex-column">
      <li class="nav-item">
        <a class="nav-link " href="${pageContext.request.contextPath}/home">
          <i class="fas fa-home mr-2"></i>Home
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link ${param.page == 'motel-list' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=motel-list">
          <i class="fas fa-building mr-2"></i>Quản lý Nhà trọ
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link ${param.page == 'room-list' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=room-list">
          <i class="fas fa-door-open mr-2"></i>Quản lý Phòng trọ
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link ${param.page == 'customer-management' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=customer-management">
          <i class="fas fa-users mr-2"></i>Quản lý Thành viên
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link ${param.page == 'createinvoice' ? 'active' : ''}" href="createBill.jsp">
          <i class="fas fa-file-invoice-dollar mr-2"></i>Hóa đơn
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link ${param.page == 'notifications' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=notify">
          <i class="fas fa-bell mr-2"></i>Thông báo
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
          <i class="fas fa-sign-out-alt mr-2"></i>Logout
        </a>
      </li>
    </ul>
  </div>

  <div class="col-md-10 content-area">
  <h1>Create New Bill</h1>
  <form action="createBill" method="post" id="billForm">
    <label for="motelRoomId">Motel Room:</label>
    <select id="motelRoomId" name="motelRoomId" required>
      <option value="">Select a room</option>
      <%
        // Get the accountId from the session
        Integer accountId = ((Account) session.getAttribute("user")).getAccountId();
        if (accountId != null) {
          try (Connection conn = DBcontext.getConnection();
               PreparedStatement pstmt = conn.prepareStatement(
                       "SELECT mr.motel_room_id, mr.name, mr.room_price, mr.electricity_price, mr.water_price " +
                               "FROM motel_room mr " +
                               "WHERE mr.account_id = ? AND mr.room_status = 1")) {

            pstmt.setInt(1, accountId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
              out.println("<option value='" + rs.getInt("motel_room_id") + "' " +
                      "data-room-price='" + rs.getFloat("room_price") + "' " +
                      "data-electricity-price='" + rs.getFloat("electricity_price") + "' " +
                      "data-water-price='" + rs.getFloat("water_price") + "'>" +
                      rs.getString("name") + "</option>");
            }
          } catch (SQLException e) {
            e.printStackTrace();
          }
        } else {
          out.println("<option value=''>Please log in to select a room</option>");
        }
      %>
    </select>

    <label for="electricityUsage">Electricity Usage:</label>
    <input type="number" id="electricityUsage" name="electricityUsage" step="0.01" required>

    <label for="waterUsage">Water Usage:</label>
    <input type="number" id="waterUsage" name="waterUsage" step="0.01" required>

    <label for="endDate">End Date:</label>
    <input type="date" id="endDate" name="endDate" required>

    <label for="totalPrice">Total Price:</label>
    <input type="text" id="totalPrice" readonly>
    <input type="hidden" id="totalPriceHidden" name="totalPrice">

    <input type="hidden" id="invoiceStatus" name="invoiceStatus" value="UNPAID">

    <input type="submit" value="Create Bill">
  </form>
  </div>
</div>
</div>

<script>
  $(document).ready(function() {
    var latestElectricityIndex = 0;
    var latestWaterIndex = 0;

    $('#motelRoomId').change(function() {
      var motelRoomId = $(this).val();
      if (motelRoomId) {
        $.ajax({
          url: 'getLatestInvoice',
          type: 'GET',
          data: { motelRoomId: motelRoomId },
          success: function(response) {
            latestElectricityIndex = response.electricityIndex || 0;
            latestWaterIndex = response.waterIndex || 0;
            $('#electricityUsage').attr('min', latestElectricityIndex);
            $('#waterUsage').attr('min', latestWaterIndex);
            calculateTotal();
          },
          error: function() {
            alert('Error fetching latest invoice data.');
          }
        });
      }
    });

    function formatNumber(number) {
      return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    }

    function calculateTotal() {
      var electricityPrice = parseFloat($('#motelRoomId option:selected').data('electricity-price') || 0);
      var waterPrice = parseFloat($('#motelRoomId option:selected').data('water-price') || 0);
      var electricityUsage = parseFloat($('#electricityUsage').val() || 0) - latestElectricityIndex;
      var waterUsage = parseFloat($('#waterUsage').val() || 0) - latestWaterIndex;
      var totalPrice = (electricityUsage * electricityPrice) + (waterUsage * waterPrice);

      $('#totalPrice').val(formatNumber(totalPrice.toFixed(0)));
      $('#totalPriceHidden').val(totalPrice); // Keep the original value for form submission
    }

    $('#motelRoomId, #electricityUsage, #waterUsage').on('change input', calculateTotal);

    $('#billForm').submit(function(e) {
      e.preventDefault();
      if ($('#motelRoomId').val() === '') {
        alert('Please select a room');
        return;
      }
      if (parseFloat($('#electricityUsage').val()) <= latestElectricityIndex) {
        alert('Electricity usage must be greater than ' + latestElectricityIndex);
        return;
      }
      if (parseFloat($('#waterUsage').val()) <= latestWaterIndex) {
        alert('Water usage must be greater than ' + latestWaterIndex);
        return;
      }

      $('#billForm').submit(function(e) {
        e.preventDefault();
        var totalPrice = $('#totalPriceHidden').val();
        var formData = $(this).serialize();
        $.ajax({
          url: 'createBill',
          type: 'POST',
          data: formData + '&action=preview',
          success: function(response) {
            $('body').append(response);
            var formattedTotalPrice = formatNumber(parseFloat(totalPrice).toFixed(0));
            $('#formattedTotalPrice').text(formattedTotalPrice);
            $('#confirmationDialog').show();
          },
          error: function() {
            alert('An error occurred. Please try again.');
          }
        });
      });

      $.ajax({
        url: 'createBill',
        type: 'POST',
        data: $(this).serialize() + '&action=preview',
        success: function(response) {
          $('body').append(response);
          $('#confirmationDialog').show();
        },
        error: function() {
          alert('An error occurred. Please try again.');
        }
      });
    });
  });

</script>
</body>
</html>