<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, context.DBcontext" %>
<%@ page import="Account.Account" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tạo Hóa Đơn Mới</title>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
</head>
<body>

<%
  Enumeration<String> attributeNames = session.getAttributeNames();
  while (attributeNames.hasMoreElements()) {
    String name = attributeNames.nextElement();
  }

  Integer motelId = null;
  if (session.getAttribute("motelId") != null) {
    motelId = (Integer) session.getAttribute("motelId");
  } else if (session.getAttribute("currentMotelId") != null) {
    motelId = (Integer) session.getAttribute("currentMotelId");
  }
%>

<div class="container">
  <h2>Tạo Hóa Đơn Mới</h2>
  <form action="createBill" method="post" id="billForm">
    <div class="form-group">
      <label for="motelRoomId">Phòng:</label>
      <select id="motelRoomId" name="motelRoomId" class="form-control" required>
        <option value="">Chọn phòng:</option>
        <%
          if (motelId != null) {
            try (Connection conn = DBcontext.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                         "SELECT mr.motel_room_id, mr.name, mr.room_price, mr.electricity_price, mr.water_price, " +
                                 "CASE WHEN r.renter_id IS NULL THEN 'Chưa Thuê' ELSE 'Đã Thuê' END AS renter_status " +
                                 "FROM motel_room mr " +
                                 "LEFT JOIN renter r ON mr.motel_room_id = r.motel_room_id AND r.check_out_date IS NULL " +
                                 "JOIN motels m ON mr.motel_id = m.motel_id " +
                                 "WHERE m.motel_id = ?")) {
              pstmt.setInt(1, motelId);
              ResultSet rs = pstmt.executeQuery();
              while (rs.next()) {
                String renterStatus = rs.getString("renter_status");
                String optionText = rs.getString("name") + " - " + renterStatus;
                String optionValue = rs.getInt("motel_room_id") + "";
                String disabled = renterStatus.equals("No renter") ? "disabled" : "";
        %>
        <option value='<%= optionValue %>'
                data-room-price='<%= rs.getFloat("room_price") %>'
                data-electricity-price='<%= rs.getFloat("electricity_price") %>'
                data-water-price='<%= rs.getFloat("water_price") %>'
                <%= disabled %>>
          <%= optionText %>
        </option>
        <%
              }
            } catch (SQLException e) {
              e.printStackTrace();
            }
          } else {
            out.println("<option value=''>Vui lòng đăng nhập!</option>");
          }
        %>
      </select>

    </div>

    <div id="noRenterMessage" class="alert alert-warning" style="display: none;">
      Phòng này chưa có người thuê.
    </div>

    <div class="form-group">
      <label for="electricityUsage">Chỉ số điện:</label>
      <input type="number" id="electricityUsage" name="electricityUsage" class="form-control" step="0.01" required>
    </div>
    <div class="form-group">
      <label for="waterUsage">Chỉ số nước:</label>
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
<button type="submit" class="btn btn-primary" onclick="confirmBill()">Tạo</button>
<button type="button" class="btn btn-secondary ml-2" data-dismiss="modal">Hủy</button>
</form>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<script>
  $(document).ready(function() {
    $('#motelRoomId').change(function() {
      var selectedOption = $(this).find('option:selected');
      if (selectedOption.is(':disabled')) {
        $('#noRenterMessage').show();
        $('#electricityUsage, #waterUsage').prop('disabled', true);
        $('button[type="submit"]').prop('disabled', true);
      } else {
        $('#noRenterMessage').hide();
        $('#electricityUsage, #waterUsage').prop('disabled', false);
        $('button[type="submit"]').prop('disabled', false);
      }
      $('#electricityUsage, #waterUsage').trigger('change');
    });

    $('#motelRoomId').change(function() {
      $('#electricityUsage, #waterUsage').trigger('change');
    });

    $('#billForm').submit(function(e) {
      e.preventDefault();

      $.ajax({
        url: 'createBill',
        type: 'POST',
        data: $(this).serialize(),
        dataType: 'text',
        success: function(response) {
          console.log('Full Response:', response);
          if (response.startsWith('SUCCESS:')) {
            var invoiceId = response.split(':')[1];
            Swal.fire({
              title: 'Thành công!',
              text: 'Hóa đơn đã được tạo thành công! ID của Hóa Đơn là ' + invoiceId,
              icon: 'success'
            }).then((result) => {
              if (result.isConfirmed) {
                window.location.href = 'owner?page=bill';
              }
            });
          } else if (response.startsWith('ERROR:')) {
            var errorMessage = response.substr(6);
            showErrorMessage(errorMessage);
          } else {
            showErrorMessage('Unexpected response. Check console for details.');
          }
        },
        error: function(xhr, status, error) {
          console.error('AJAX Error:', status, error);
          console.log('Chi tiết lỗi:', xhr.responseText);
          showErrorMessage('Đã xảy ra lỗi. Vui lòng thử lại.');
        }
      });
    });

    function showErrorMessage(message) {
      Swal.fire({
        title: 'Lỗi!',
        text: message,
        icon: 'error',
        confirmButtonText: 'Đóng'
      });
    }


  });
</script>
</body>
</html>