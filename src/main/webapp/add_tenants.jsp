<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Tenants</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
    </style>
</head>
<body>
<div class="container">
    <h1>Add Tenants</h1>

    <form id="searchForm">
        <input type="text" id="searchTerm" name="searchTerm" placeholder="Search by email, phone, or citizen ID" required>
        <input type="hidden" id="motelRoomId" name="motelRoomId" value="${param.motel_room_id}">
        <input type="button" value="Search" onclick="searchAccounts()">
    </form>

    <div id="searchResults"></div>
</div>

<script>
    function searchAccounts() {
        var searchTerm = $('#searchTerm').val();
        var motelRoomId = $('#motelRoomId').val();

        $.ajax({
            url: 'searchAccounts',
            method: 'GET',
            data: { searchTerm: searchTerm, motelRoomId: motelRoomId },
            success: function(response) {
                $('#searchResults').html(response);
            },
            error: function() {
                $('#searchResults').html('<p>An error occurred while searching.</p>');
            }
        });
    }

    function addTenant(accountId) {
        var motelRoomId = $('#motelRoomId').val();
        var startDate = $('#startDate_' + accountId).val();

        if (!motelRoomId) {
            console.error('motelRoomId is empty');
            alert('Error: Motel Room ID is missing');
            return;
        }

        console.log('Adding tenant with accountId:', accountId);
        console.log('motelRoomId:', motelRoomId);
        console.log('startDate:', startDate);

        $.ajax({
            url: 'addTenant',
            method: 'POST',
            data: { accountId: accountId, motelRoomId: motelRoomId, startDate: startDate },
            success: function(response) {
                if (response === 'success') {
                    alert('Tenant added successfully');
                } else {
                    alert('Error adding tenant: ' + response);
                    console.error('Server response:', response);
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                alert('Error adding tenant: ' + textStatus + ' - ' + errorThrown);
                console.error('AJAX error:', jqXHR.responseText);
            }
        });
    }
</script>
</body>
</html>