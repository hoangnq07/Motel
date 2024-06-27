<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Send Notification</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        form {
            max-width: 600px;
            margin: auto;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }
        select, textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 16px;
        }
        input[type="submit"] {
            width: 100%;
            background-color: #4CAF50;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        #description {
            display: block;
            margin-bottom: 16px;
            font-size: 16px;
            color: #333;
        }
    </style>
</head>
<body>
<h1>Send Notification to Renter</h1>
<form action="sendNotification" method="post">
    <label for="motelRoomId">Motel Room:</label>
    <select id="motelRoomId" name="motelRoomId" required>
        <!-- Options will be populated dynamically -->
    </select><br><br>
    <label for="description">Description:</label>
    <span id="description"></span><br><br>
    <label for="message">Message:</label>
    <textarea id="message" name="message" rows="6" required></textarea><br><br>
    <input type="submit" value="Send Notification">
</form>

<script>
    $(document).ready(function() {
        // Fetch initial data for motel rooms
        $.ajax({
            url: 'getMotelRooms', // URL for fetching the list of rooms
            method: 'GET',
            success: function(data) {
                var motelRooms = JSON.parse(data);
                motelRooms.forEach(function(room) {
                    $('#motelRoomId').append(new Option(room.description, room.motelRoomId));
                });
            },
            error: function() {
                alert('Failed to fetch motel rooms.');
            }
        });

        // Handle motel room selection change
        $('#motelRoomId').change(function() {
            var selectedRoomId = $(this).val();
            $.ajax({
                url: 'getRoomDescription', // URL for fetching room description
                method: 'GET',
                data: { motel_room_id: selectedRoomId },
                success: function(data) {
                    var room = JSON.parse(data);
                    $('#description').text(room.description);
                },
                error: function() {
                    alert('Failed to fetch room description.');
                }
            });
        });
    });
</script>
</body>
</html>
