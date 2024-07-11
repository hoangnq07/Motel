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
</head>
<body>
<div class="container">
  <h2>Create New Bill</h2>
  <form action="createBill" method="post" id="billForm">
    <div class="form-group">
      <label for="motelRoomId">Motel Room:</label>
      <select id="motelRoomId" name="motelRoomId" class="form-control" required>
        <option value="">Select a room</option>
        <%
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
    </div>
    <div class="form-group">
      <label for="electricityUsage">Electricity Index:</label>
      <input type="number" id="electricityUsage" name="electricityUsage" class="form-control" step="0.01" required>
    </div>
    <div class="form-group">
      <label for="waterUsage">Water Index:</label>
      <input type="number" id="waterUsage" name="waterUsage" class="form-control" step="0.01" required>
    </div>
<%--    <div class="form-group">--%>
<%--      <label for="endDate">End Date:</label>--%>
<%--      <input type="date" id="endDate" name="endDate" class="form-control" required>--%>
<%--    </div>--%>
<%--    <div class="form-group">--%>
<%--      <label for="totalPrice">Total Price:</label>--%>
<%--      <input type="text" id="totalPrice" class="form-control" readonly>--%>
      <input type="hidden" id="totalPriceHidden" name="totalPrice">
    </div>
    <input type="hidden" id="invoiceStatus" name="invoiceStatus" value="UNPAID">
    <input type="hidden" id="action" name="action" value="confirm">
    <button type="submit" class="btn btn-primary" onclick="confirmBill()">Create Bill</button>
    <button type="button" class="btn btn-secondary ml-2" data-dismiss="modal">Cancel</button>
  </form>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<script>
  $(document).ready(function() {
    // Tính tổng tiền dựa trên dữ liệu điện nước nhập vào
    $('#electricityUsage, #waterUsage').change(function() {
      var electricityPrice = $('#motelRoomId option:selected').attr('data-electricity-price');
      var waterPrice = $('#motelRoomId option:selected').attr('data-water-price');
      var electricityUsage = parseFloat($('#electricityUsage').val());
      var waterUsage = parseFloat($('#waterUsage').val());
      var totalPrice = (electricityUsage * electricityPrice) + (waterUsage * waterPrice);
      $('#totalPrice').val(totalPrice.toFixed(2));
      $('#totalPriceHidden').val(totalPrice.toFixed(2));
    });

    // Đổi giá trị của phòng khi chọn lại
    $('#motelRoomId').change(function() {
      $('#electricityUsage, #waterUsage').trigger('change');
    });
  });
</script>
</body>
<script>
  // function confirmBill() {
  //   $.ajax({
  //     url: 'createBill',
  //     type: 'POST',
  //     data: $('#billForm').serialize(),
  //     dataType: 'json',
  //     success: function(response) {
  //       if (response.status === 'success') {
  //         alert('Bill created successfully!');
  //         $('#confirmationDialog').remove();
  //         // Optionally, reset the form or redirect to a new page
  //       } else {
  //         alert('Error: ' + response.message);
  //       }
  //     },
  //     error: function(xhr, status, error) {
  //       if (xhr.status === 409) {
  //         alert('Cannot create invoice: ' + xhr.responseJSON.message);
  //       } else {
  //         alert('An error occurred. Please try again. Details: ' + xhr.responseText);
  //       }
  //     }
  //   });
  // }

</script>
</html>
