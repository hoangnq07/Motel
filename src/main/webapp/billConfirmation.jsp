<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="confirmationDialog" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%,-50%); background-color:white; padding:20px; border:1px solid black;">
    <h2>Confirm Bill Details</h2>
    <p>Electricity Usage: ${param.electricityUsage}</p>
    <p>Water Usage: ${param.waterUsage}</p>
    <p>Total Price: ${param.totalPrice}VNĐ</p>
    <button onclick="confirmBill()">Confirm</button>
    <button onclick="cancelBill()">Cancel</button>
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
                    alert('Bill created successfully!');
                    $('#confirmationDialog').remove();
                    // Optionally, reset the form or redirect to a new page
                } else {
                    alert('Error: ' + response.message);
                }
            },
            error: function(xhr, status, error) {
                if (xhr.status === 409) {
                    alert('Cannot create invoice: ' + xhr.responseJSON.message);
                } else {
                    alert('An error occurred. Please try again. Details: ' + xhr.responseText);
                }
            }
        });
    }

    function cancelBill() {
        $('#confirmationDialog').remove();
    }
</script>