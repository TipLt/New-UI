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

@WebServlet("/admin/users/edit")
public class UserEditServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdminAuth(request, response)) {
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));

        try {
            request.setAttribute("user", userDAO.getUserById(id));
            // ✅ FIXED: Changed from /views/admin/users/edit.jsp
            request.getRequestDispatcher("/views/admin/edit.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdminAuth(request, response)) {
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String role = request.getParameter("role");

        if (fullName == null || fullName.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Full Name is required");
            response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + id);
            return;
        }

        if (phoneNumber == null || phoneNumber.trim().isEmpty()
                || role == null || role.trim().isEmpty()) {

            request.getSession().setAttribute("error", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + id);
            return;
        }
        try {
        if (userDAO.updateUserByAdmin(
                id, 
                fullName.trim(),      
                phoneNumber.trim(),   
                role.trim())) {
            request.getSession().setAttribute("success", "User updated successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to update user");
            }
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + id);
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
