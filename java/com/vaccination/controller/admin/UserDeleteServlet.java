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

@WebServlet("/admin/users/delete")
public class UserDeleteServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAdminAuth(request, response)) return;
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid user ID format");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        // Prevent deleting the current logged-in user
        HttpSession session = request.getSession();
        Integer currentUserId = (Integer) session.getAttribute("userId");
        if (currentUserId != null && currentUserId == id) {
            request.getSession().setAttribute("error", "Cannot delete your own account");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            if (userDAO.deleteUser(id)) {
                request.getSession().setAttribute("success", "User deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to delete user");
            }
            response.sendRedirect(request.getContextPath() + "/admin/users");
            
        } catch (SQLException e) {
            // Log the error appropriately in production
            System.err.println("Error deleting user: " + e.getMessage());
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
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
