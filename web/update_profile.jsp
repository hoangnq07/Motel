<%-- 
    Document   : update_profile
    Created on : May 18, 2024, 10:06:26 PM
    Author     : BAO
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Profile</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    </head>
    <body>
        <div class="container mt-3">
            <h1>Update Profile</h1>

            <%
                // Get account information from request scope (assuming servlet sets it)
                String fullName = request.getAttribute("fullName") != null ? (String) request.getAttribute("fullName") : "";
                String email = request.getAttribute("email") != null ? (String) request.getAttribute("email") : "";
                String gender = request.getAttribute("gender") != null ? (String) request.getAttribute("gender") : ""; // Assuming retrieved value represents "Male" or "Female"
                String phone = request.getAttribute("phone") != null ? (String) request.getAttribute("phone") : "";
                String citizen = request.getAttribute("citizen") != null ? (String) request.getAttribute("citizen") : "";
                int selectedGender = gender.equals("Male") ? 1 : 0; // Convert gender string to integer for radio button selection
%>

            <form action="UpdateProfileServlet" method="post">
                <div class="mb-3">
                    <label for="fullName" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="fullName" name="fullName" value="<%= fullName%>" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" value="<%= email%>" required>
                </div>
                <div class="mb-3">
                    <label for="gender">Gender</label>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="gender" id="genderMale" value="1" <%= selectedGender == 1 ? "checked" : ""%>>
                        <label class="form-check-label" for="genderMale">Male</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="gender" id="genderFemale" value="0" <%= selectedGender == 0 ? "checked" : ""%>>
                        <label class="form-check-label" for="genderFemale">Female</label>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="phone" class="form-label">Phone</label>
                    <input type="text" class="form-control" id="phone" name="phone" value="<%= phone%>" required>
                </div>
                <div class="mb-3">
                    <label for="citizen" class="form-label">Citizen ID</label>
                    <input type="text" class="form-control" id="citizen" name="citizen" value="<%= citizen%>" required>
                </div>
                <button type="submit" class="btn btn-primary">Save</button>
            </form>
        </div>
        <script>
            const saveButton = document.querySelector('button[type="submit"]');

            saveButton.addEventListener('click', async (event) => {
                event.preventDefault(); // Prevent default form submission

                const form = document.querySelector('form');
                const formData = new FormData(form);

                try {
                    const response = await fetch('/UpdateProfileServlet', {
                        method: 'POST',
                        body: formData
                    });

                    if (response.ok) {
                        // Successful update
                        alert('Profile updated successfully!');
                        window.location.href = 'account-info.jsp'; // Redirect to account-info.jsp
                    } else {
                        // Update failed
                        alert('Error updating profile. Please try again.');
                    }
                } catch (error) {
                    console.error('Error:', error);
                    alert('An error occurred. Please try again later.');
                }
            });
        </script>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9s
