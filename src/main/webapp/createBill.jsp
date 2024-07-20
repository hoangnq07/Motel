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
                         "SELECT mr.motel_room_id, mr.name, mr.room_price, mr.electricity_price, mr.water_price \n" +
                                 "FROM motel_room mr\n" +
                                 "JOIN motels m ON mr.motel_id = m.motel_id\n" +
                                 "WHERE m.motel_id = ? AND mr.room_status = 1")) {
              pstmt.setInt(1, motelId);
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
            out.println("<option value=''>Vui lòng đăng nhập!</option>");
          }
        %>
      </select>
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

    $('#motelRoomId').change(function() {
      $('#electricityUsage, #waterUsage').trigger('change');
    });

    $('#billForm').submit(function(e) {
      e.preventDefault();

      $.ajax({
        url: 'createBill',
        type: 'POST',
        data: $(this).serialize(),
        dataType: 'json',
        success: function(response) {
          if (response.success) {
            Swal.fire({
              title: 'Thành công!',
              text: 'Hóa đơn đã được tạo thành công! ID: ' + response.invoiceId,
              icon: 'success'
            }).then((result) => {
              if (result.isConfirmed) {
                $('#billForm')[0].reset();
                // Optionally, redirect to another page
              }
            });
          } else if (response.error) {
            showErrorMessage(response.error);
          }
        },
        error: function(xhr, status, error) {
          let errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại.';

          try {
            const responseJson = JSON.parse(xhr.responseText);
            if (responseJson && responseJson.message) {
              errorMessage = responseJson.message.replace(/^Unexpected error:\s*/, '');
            }
          } catch (e) {
            console.error('Error parsing JSON response:', e);
          }

          showErrorMessage(errorMessage);
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
