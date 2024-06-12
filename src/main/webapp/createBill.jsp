<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Create Bill</title>
</head>
<body>
<h1>Create Bill</h1>
<form action="createBill" method="post">
  <label for="motelRoomId">Motel Room ID:</label>
  <input type="text" id="motelRoomId" name="motelRoomId" required><br><br>

  <label for="totalPrice">Total Price:</label>
  <input type="text" id="totalPrice" name="totalPrice" required><br><br>

  <label for="invoiceStatus">Invoice Status:</label>
  <input type="text" id="invoiceStatus" name="invoiceStatus" required><br><br>

  <label for="endDate">End Date:</label>
  <input type="date" id="endDate" name="endDate" required><br><br>

  <label for="electricityIndex">Electricity Index:</label>
  <input type="text" id="electricityIndex" name="electricityIndex" required><br><br>

  <label for="waterIndex">Water Index:</label>
  <input type="text" id="waterIndex" name="waterIndex" required><br><br>

  <input type="submit" value="Create Bill">
</form>
</body>
</html>
