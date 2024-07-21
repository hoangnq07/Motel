<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Danh sách người thuê</title>
    <script>
        function searchRenters() {
            var searchTerm = document.getElementById("searchInput").value.toLowerCase();
            var tableRows = document.querySelectorAll("tbody tr");

            for (var i = 0; i < tableRows.length; i++) {
                var row = tableRows[i];
                var cells = row.querySelectorAll("td");
                var found = false;

                for (var j = 0; j < cells.length; j++) {
                    var cellText = cells[j].textContent.toLowerCase();
                    if (cellText.indexOf(searchTerm) !== -1) {
                        found = true;
                        break;
                    }
                }

                row.style.display = found ? "" : "none";
            }
        }

        function goToPage(pageNumber) {
            // Update logic here to fetch data for the specific page number
            // You might need to make an AJAX call to a servlet or another JSP
            // This example just simulates page change
            alert("Going to page " + pageNumber);
        }
    </script>
</head>
<body>
<h1>Danh sách tất cả người thuê</h1>
<div>
    <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên, email, phòng..." onkeyup="searchRenters()">
</div>
<table class="table">
    <thead>
    <tr>
        <th>Tên</th>
        <th>Email</th>
        <th>Ngày thuê</th>
        <th>Tên phòng</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="renter" items="${renters}">
        <tr>
            <td>${renter.renterName}</td>
            <td>${renter.renterEmail}</td>
            <td>${renter.renterDate}</td>
            <td>${renter.roomName}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<div>
    <c:if test="${currentPage > 1}">
        <a href="#" onclick="goToPage(${currentPage - 1})">Trang trước</a>
    </c:if>
    <c:forEach var="page" begin="1" end="${totalPages}">
        <c:if test="${page == currentPage}">
            <span style="font-weight: bold;">${page}</span>
        </c:if>
        <c:if test="${page != currentPage}">
            <a href="#" onclick="goToPage(${page})">${page}</a>
        </c:if>
    </c:forEach>
    <c:if test="${currentPage < totalPages}">
        <a href="#" onclick="goToPage(${currentPage + 1})">Trang sau</a>
    </c:if>
</div>
</body>
</html>
