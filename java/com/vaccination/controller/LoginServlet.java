package com.vaccination.controller;

import com.vaccination.dao.UserDAO;
import com.vaccination.model.User;
import com.vaccination.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/guest/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Trim and validate inputs
        if (email != null) email = email.trim();
        if (password != null) password = password.trim();
        
        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("/views/guest/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findByEmail(email);

        if (user != null && PasswordUtil.verifyPassword(password, user.getPassword()))  {
            if (!user.isActive()) {
                request.setAttribute("error", "Your account has been deactivated");
                request.getRequestDispatcher("/views/guest/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userName", user.getFullName());

            userDAO.updateLastLogin(user.getUserId());

            switch (user.getRole()) {
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
                case "RECEPTION":
                    response.sendRedirect(request.getContextPath() + "/reception/appointments-list");
                    break;
                case "MEDICAL":
                    response.sendRedirect(request.getContextPath() + "/medical/vaccinations");
                    break;
                case "PARENT":
                    response.sendRedirect(request.getContextPath() + "/parent/dashboard");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/");
                    break;
            }
        } else {
            request.setAttribute("error", "Invalid email or password");
request.getRequestDispatcher("/views/guest/login.jsp").forward(request, response);
        }
    }
}