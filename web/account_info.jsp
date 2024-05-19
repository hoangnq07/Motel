<%-- 
    Document   : accounti-info
    Created on : May 18, 2024, 9:54:44 PM
    Author     : BAO
--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Account Information</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    </head>
    <body>
        <div class="container mt-3">
            <h1>Account Information</h1>

            <%
                // Get account information from request scope (assuming servlet sets it)
                String fullName = request.getAttribute("fullName") != null ? (String) request.getAttribute("fullName") : "";
                String email = request.getAttribute("email") != null ? (String) request.getAttribute("email") : "";
                String gender = request.getAttribute("gender") != null ? (String) request.getAttribute("gender") : "";
                String phone = request.getAttribute("phone") != null ? (String) request.getAttribute("phone") : "";
                String citizen = request.getAttribute("citizen") != null ? (String) request.getAttribute("citizen") : "";
            %>

            <div class="card">
                <div class="card-body">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">Full Name: <span class="fw-bold"><%= fullName%></span></li>
                        <li class="list-group-item">Email: <span class="fw-bold"><%= email%></span></li>
                        <li class="list-group-item">Gender: <span class="fw-bold"><%= gender%></span></li>
                        <li class="list-group-item">Phone: <span class="fw-bold"><%= phone%></span></li>
                        <li class="list-group-item">Citizen ID: <span class="fw-bold"><%= citizen%></span></li>
                    </ul>
                </div>

            </div>

            <form action="update_profile.jsp">
                <button type="submit" class="btn btn-primary">Update</button>
            </form>

        </div>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
    </body>
</html>
