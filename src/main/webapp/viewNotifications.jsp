<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.Notification" %>
<%@ page session="true" %>
<%
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Notifications</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <style>
        .page{
            margin-top: 100px;
        }
    </style>
    <script>
        var notifications = <%= new com.google.gson.Gson().toJson(notifications) %>;
        var currentPage = 1;
        var itemsPerPage = 10;

        // Function to parse date strings into Date objects
        function parseDate(dateString) {
            return new Date(dateString);
        }

        // Sort notifications by date in descending order
        notifications.sort(function(a, b) {
            return parseDate(b.createDate) - parseDate(a.createDate);
        });

        function displayPage(page) {
            var start = (page - 1) * itemsPerPage;
            var end = start + itemsPerPage;
            var paginatedItems = notifications.slice(start, end);

            var list = document.getElementById("notificationList");
            list.innerHTML = "";

            paginatedItems.forEach(function(notification) {
                var li = document.createElement("li");
                li.className = "list-group-item";
                li.innerHTML = "<div><strong>Message:</strong> " + notification.message + "</div>" +
                    "<div><strong>Date:</strong> " + notification.createDate + "</div>";
                list.appendChild(li);
            });

            document.getElementById("pageNumber").innerHTML = "Page " + page;
        }

        function nextPage() {
            if ((currentPage * itemsPerPage) < notifications.length) {
                currentPage++;
                displayPage(currentPage);
            }
        }

        function previousPage() {
            if (currentPage > 1) {
                currentPage--;
                displayPage(currentPage);
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
            displayPage(currentPage);
        });
    </script>
</head>
<body>
<jsp:include page="header.jsp" ></jsp:include>
<div class="container page">
    <h1 class="mb-4">Your Notifications</h1>
    <ul id="notificationList" class="list-group">
        <!-- Notifications will be displayed here -->
    </ul>
    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item">
                <a class="page-link" href="#" aria-label="Previous" onclick="previousPage()">
                    <span aria-hidden="true">&laquo;</span>
                </a>
            </li>
            <li class="page-item"><span class="page-link" id="pageNumber">Page 1</span></li>
            <li class="page-item">
                <a class="page-link" href="#" aria-label="Next" onclick="nextPage()">
                    <span aria-hidden="true">&raquo;</span>
                </a>
            </li>
        </ul>
    </nav>
</div>
<jsp:include page="footer.jsp" ></jsp:include>
</body>
</html>
