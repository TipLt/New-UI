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
        
        int id = Integer.parseInt(request.getParameter("id"));

        try {
            if (userDAO.deleteUser(id)) {
                request.getSession().setAttribute("success", "User deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to delete user");
            }
            response.sendRedirect(request.getContextPath() + "/admin/users");
            
        } catch (SQLException e) {
            e.printStackTrace();
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
