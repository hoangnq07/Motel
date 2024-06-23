<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <title>${motel == null ? "Create New Motel" : "Edit Motel"}</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        h1 {
            color: #333;
            margin-top: 20px;
        }
        .container {
            width: 80%;
            max-width: 800px;
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 5px;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin-top: 10px;
            font-weight: bold;
        }
        input[type="text"], input[type="file"], select {
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 100%;
            box-sizing: border-box;
        }
        .radio-group {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .radio-group label {
            font-weight: normal;
            margin: 0;
        }
        input[type="submit"] {
            padding: 10px 20px;
            background-color: #007BFF;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
            align-self: flex-start;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        input[type="file"] {
            padding: 4px 8px !important;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            color: #007BFF;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<body>
<div class="container h-100">
    <h1>${motel == null ? "Create New Motel" : "Edit Motel"}</h1>
    <form action="/Project/motel/${motel == null ? 'create' : 'update'}" method="post">
        <input type="hidden" name="id" value="${motel.motelId}" />
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="${motel.name}" />

        <label for="descriptions">Descriptions:</label>
        <input type="text" id="descriptions" name="descriptions" value="${motel.descriptions}" />

        <label for="province">Province:</label>
        <select id="province" name="province">
            <option value="-1">Chọn tỉnh thành</option>
        </select>

        <label for="district">District:</label>
        <select id="district" name="district">
            <option value="-1">Chọn quận/huyện</option>
        </select>

        <label for="town">Town:</label>
        <select id="town" name="town">
            <option value="-1">Chọn phường/xã</option>
        </select>

        <label for="detailAddress">Detail Address:</label>
        <input type="text" id="detailAddress" name="detailAddress" value="${motel.detailAddress}" />

        <label>Status:</label>
        <div class="radio-group">
            <input type="radio" id="statusTrue" name="status" value="true" ${motel.status ? "checked" : ""}>
            <label for="statusTrue">Available</label>

            <input type="radio" id="statusFalse" name="status" value="false" ${!motel.status ? "checked" : ""}>
            <label for="statusFalse">Unavailable</label>
        </div>

        <label for="image" >Image:</label>
        <input type="file" class="form-control" id="image" name="image">

        <input type="hidden" name="accountId" value="${user.accountId}" />
        <input type="submit" value="${motel == null ? 'Create' : 'Update'}" />
    </form>
    <a href="/Project/owner">Back to List</a>
</div>

<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4xF86dIHNDz0W1"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/assets/province/data.json"></script>
<script src="${pageContext.request.contextPath}/assets/province/api.js"></script>

</body>
</html>
