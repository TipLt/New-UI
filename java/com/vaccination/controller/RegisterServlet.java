package com.vaccination.controller;

import com.vaccination.dao.UserDAO;
import com.vaccination.model.User;
import com.vaccination.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/guest/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");

        if (email == null || password == null || fullName == null) {
            request.setAttribute("error", "All required fields must be filled");
            request.getRequestDispatcher("/views/guest/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/views/guest/register.jsp").forward(request, response);
            return;
        }

        if (!PasswordUtil.isValidPassword(password)) {
            request.setAttribute("error", "Password must be at least 6 characters long");
            request.getRequestDispatcher("/views/guest/register.jsp").forward(request, response);
            return;
        }

        User existingUser = userDAO.findByEmail(email);
        if (existingUser != null) {
            request.setAttribute("error", "Email already registered");
            request.getRequestDispatcher("/views/guest/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setEmail(email);
        newUser.setPassword(PasswordUtil.hashPassword(password));
        newUser.setFullName(fullName);
        newUser.setPhoneNumber(phoneNumber);
        newUser.setRole("PARENT");
        newUser.setActive(true);

        if (userDAO.createUser(newUser)) {
            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("/views/guest/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/views/guest/register.jsp").forward(request, response);
        }
    }
}
