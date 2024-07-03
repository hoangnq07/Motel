<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, context.DBcontext" %>
<%@ page import="Account.Account" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Create New Bill</title>
  <style>
    /* ... (keep the previous CSS styles) ... */
  </style>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<div class="container">
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
    <input type="number" id="totalPrice" name="totalPrice" readonly>

    <input type="hidden" id="invoiceStatus" name="invoiceStatus" value="UNPAID">

    <input type="submit" value="Create Bill">
  </form>
</div>

<script>
  $(document).ready(function() {
    function calculateTotal() {
      var electricityPrice = parseFloat($('#motelRoomId option:selected').data('electricity-price') || 0);
      var waterPrice = parseFloat($('#motelRoomId option:selected').data('water-price') || 0);
      var electricityUsage = parseFloat($('#electricityUsage').val() || 0);
      var waterUsage = parseFloat($('#waterUsage').val() || 0);

      var totalPrice = (electricityUsage * electricityPrice) + (waterUsage * waterPrice);
      $('#totalPrice').val(totalPrice.toFixed(2));
    }

    $('#motelRoomId, #electricityUsage, #waterUsage').on('change input', calculateTotal);

    $('#billForm').submit(function(e) {
      e.preventDefault();
      if ($('#motelRoomId').val() === '') {
        alert('Please select a room');
        return;
      }

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