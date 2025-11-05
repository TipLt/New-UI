package com.vaccination.controller.admin;

import com.vaccination.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import com.vaccination.model.User;

@WebServlet("/admin/users/create")
public class UserCreateServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAdminAuth(request, response)) return;
        
        // ✅ FIXED: Changed from /views/admin/users/create.jsp
        request.getRequestDispatcher("/views/admin/create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAdminAuth(request, response)) return;
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String role = request.getParameter("role");
        
    if (fullName == null || fullName.trim().isEmpty()) {
        request.setAttribute("error", "Full Name is required");
        request.setAttribute("email", email);
        request.setAttribute("phoneNumber",phoneNumber); // ✅ DÙNG: phoneNumber
        request.setAttribute("role", role);
        request.getRequestDispatcher("/views/admin/create.jsp").forward(request, response);
        return;
    }
        try {
        if (userDAO.createUserWithRole(
                email.trim(), 
                password.trim(), 
                fullName.trim(),      
                phoneNumber.trim(),   
                role.trim())) {
            request.getSession().setAttribute("success", "User created successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to create user");
            }
            response.sendRedirect(request.getContextPath() + "/admin/users");
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users/create");
        }
    }
    
    private boolean checkAdminAuth(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}