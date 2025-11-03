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

@WebServlet("/admin/users")
public class UserListServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAdminAuth(request, response)) return;
        
        int page = request.getParameter("page") != null ? 
                   Integer.parseInt(request.getParameter("page")) : 1;
        int size = 10;
        String roleFilter = request.getParameter("role");

        try {
            request.setAttribute("users", userDAO.getUsers(page, size, roleFilter));
            request.setAttribute("totalPages", 
                (int) Math.ceil(userDAO.getTotalUsers(roleFilter) / (double) size));
            request.setAttribute("currentPage", page);
            request.setAttribute("roleFilter", roleFilter);
            
            // ✅ FIXED: Changed from /views/admin/users/list.jsp
            request.getRequestDispatcher("/views/admin/list.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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