package controller;

import Account.User;
import dao.AccountDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
@WebServlet("/renters")
public class RentersServlet extends HttpServlet {
    private static final String JDBC_URL = "jdbc:sqlserver://localhost:1433;databaseName=motel1;user=yourUsername;password=yourPassword";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("search".equals(action)) {
            searchRenters(request, response);
        } else {
            displayRenters(request, response);
        }
    }

    private void searchRenters(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        List<User> accounts = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(JDBC_URL);
             PreparedStatement statement = connection.prepareStatement("SELECT * FROM accounts WHERE email LIKE ?")) {
            statement.setString(1, "%" + email + "%");

            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                accounts.add(new User(
                        resultSet.getInt("account_id"),
                        resultSet.getBoolean("active"),
                        resultSet.getString("avatar"),
                        resultSet.getString("citizen"),
                        resultSet.getDate("create_date"),
                        resultSet.getString("email"),
                        resultSet.getString("fullname"),
                        resultSet.getBoolean("gender"),
                        resultSet.getString("password"),
                        resultSet.getString("phone"),
                        resultSet.getString("role")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("accounts", accounts);
        request.getRequestDispatcher("renters.jsp").forward(request, response);
    }

    private void displayRenters(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> renters = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(JDBC_URL);
             Statement statement = connection.createStatement()) {
            ResultSet resultSet = statement.executeQuery("SELECT * FROM accounts INNER JOIN renter ON accounts.account_id = renter.account_id");

            while (resultSet.next()) {
                renters.add(new User(
                        resultSet.getInt("account_id"),
                        resultSet.getBoolean("active"),
                        resultSet.getString("avatar"),
                        resultSet.getString("citizen"),
                        resultSet.getDate("create_date"),
                        resultSet.getString("email"),
                        resultSet.getString("fullname"),
                        resultSet.getBoolean("gender"),
                        resultSet.getString("password"),
                        resultSet.getString("phone"),
                        resultSet.getString("role")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("renters", renters);
        request.getRequestDispatcher("renters.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addRenter(request, response);
        } else if ("delete".equals(action)) {
            deleteRenter(request, response);
        }
    }

    private void addRenter(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int accountId = Integer.parseInt(request.getParameter("account_id"));

        try (Connection connection = DriverManager.getConnection(JDBC_URL);
             PreparedStatement statement = connection.prepareStatement("INSERT INTO renter (account_id) VALUES (?)")) {
            statement.setInt(1, accountId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("renters");
    }

    private void deleteRenter(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int accountId = Integer.parseInt(request.getParameter("account_id"));

        try (Connection connection = DriverManager.getConnection(JDBC_URL);
             PreparedStatement statement = connection.prepareStatement("DELETE FROM renter WHERE account_id = ?")) {
            statement.setInt(1, accountId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("renters");
    }
}