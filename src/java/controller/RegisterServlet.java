
package controller;

import Account.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author PC
 */
@WebServlet(name="RegisterServlet", urlPatterns={"/register"})
public class RegisterServlet extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String pass = request.getParameter("pass");
        String gender = request.getParameter("gender");
        boolean isMale =false;
        if(gender.equals("male")) isMale=true;
        String phone = request.getParameter("phone");

        User u = new User(email,pass,isMale, phone);
        boolean registrationSuccess  = u.registerUser();
        if (registrationSuccess ) {
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("status", "User already exist.");
            request.getRequestDispatcher("registration.jsp").forward(request, response);
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    public static void main(String[] args) {
        System.out.println("hi");
    }
}
