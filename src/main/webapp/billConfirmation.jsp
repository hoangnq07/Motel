<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="confirmationDialog" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%,-50%); background-color:white; padding:20px; border:1px solid black;">
    <h2>Xác nhận thông tin về hóa đơn</h2>
    <p>Chỉ số điện: ${param.electricityUsage}</p>
    <p>Chỉ số nước: ${param.waterUsage}</p>
    <p>Tổng giá: ${param.totalPrice}VNĐ</p>
    <button onclick="confirmBill()">Xác nhận</button>
    <button onclick="cancelBill()">Hủy</button>
</div>

<script>
    function confirmBill() {
        $.ajax({
            url: 'createBill',
            type: 'POST',
            data: $('#billForm').serialize() + '&action=confirm',
            dataType: 'json',
            success: function(response) {
                if (response.status === 'success') {
                    alert('Bill đã tạo thành công!');
                    $('#confirmationDialog').remove();
                    // Optionally, reset the form or redirect to a new page
                } else {
                    alert('Error: ' + response.message);
                }
            },
            error: function(xhr, status, error) {
                if (xhr.status === 409) {
                    alert('Không thể tạo được hóa đơn ' + xhr.responseJSON.message);
                } else {
                    alert('Xảy ra lỗi. Làm ơn hãy thử lại. Chi tiết: ' + xhr.responseText);
                }
            }
        });
    }

    function cancelBill() {
        $('#confirmationDialog').remove();
    }
</script>