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
        .textarea{
            height: 100px;
        }
        .image-preview-container {
            width: 100%;
            height: 300px;
            overflow: hidden;
            border: 1px solid #ccc;
            margin-top: 10px;
            border-radius: 5px;
        }
        .image-preview {
            max-width: 100%;
            height: auto;
        }
    </style>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<body>
<div class="container h-100">
    <h1>${motel == null ? "Create New Motel" : "Edit Motel"}</h1>
    <form action="/Project/motel/${motel == null ? 'create' : 'update'}" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="${motel.motelId}" />
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="${motel.name}" />

        <label for="descriptions">Descriptions:</label>
        <input class="textarea" type="text" id="descriptions" name="descriptions" value="${motel.descriptions}" />

        <label for="province">Province:</label>
        <select id="province" name="province" onchange="updateHiddenInputs()">
            <option value="-1">Chọn tỉnh thành</option>

        </select>

        <label for="district">District:</label>
        <select id="district" name="district" onchange="updateHiddenInputs()">
            <option value="-1">Chọn quận/huyện</option>
        </select>

        <label for="town">Town:</label>
        <select id="town" name="town" onchange="updateHiddenInputs()">
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

        <div class="row">
            <div class="col-md-6">
                <label for="image">Image:</label>
                <input type="file" class="form-control" id="image" name="image" onchange="previewImage(event)">
            </div>
            <div class="col-md-6">
                <div >
                    <label>Image Preview:</label>
                    <div class="image-preview-container">
                        <img id="preview" class="image-preview" src="#" alt="" style="display: none;">
                    </div>
                </div>
            </div>
        </div>
        <!-- Hidden inputs to store the selected text -->
        <input type="hidden" id="provinceText" name="provinceText" value="">
        <input type="hidden" id="districtText" name="districtText" value="">
        <input type="hidden" id="townText" name="townText" value="">
        <input type="hidden" name="accountId" value="${user.accountId}" />
        <input type="submit" value="${motel == null ? 'Create' : 'Update'}" />
    </form>
    <a href="/Project/owner">Back to List</a>
</div>
<!-- Optional JavaScript -->
<script>
    function previewImage(event) {
        var input = event.target;
        var reader = new FileReader();
        reader.onload = function () {
            var img = document.getElementById('preview');
            img.src = reader.result;
            img.style.display = 'block'; // Show image
        };
        reader.readAsDataURL(input.files[0]);
    }
    function updateHiddenInputs() {
        // Get the selected text from each select element
        var provinceSelect = document.getElementById('province');
        var districtSelect = document.getElementById('district');
        var townSelect = document.getElementById('town');

        var selectedProvinceText = provinceSelect.options[provinceSelect.selectedIndex].text;
        var selectedDistrictText = districtSelect.options[districtSelect.selectedIndex].text;
        var selectedTownText = townSelect.options[townSelect.selectedIndex].text;

        // Update the hidden inputs with the selected text
        document.getElementById('provinceText').value = selectedProvinceText;
        document.getElementById('districtText').value = selectedDistrictText;
        document.getElementById('townText').value = selectedTownText;
    }
</script>
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
