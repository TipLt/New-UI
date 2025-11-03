package com.vaccination.controller.admin;

import com.vaccination.dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    private DashboardDAO dashboardDAO = new DashboardDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        if (!"ADMIN".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        try {
            request.setAttribute("usersByRole", dashboardDAO.getUsersByRole());
            request.setAttribute("newUsers", dashboardDAO.getNewUsersThisMonth());
            request.setAttribute("activeInactive", dashboardDAO.getActiveInactive());
            request.setAttribute("recentLogins", dashboardDAO.getRecentLogins(10));
            request.setAttribute("totalChildren", dashboardDAO.getTotalChildren());
            request.setAttribute("totalAppointments", dashboardDAO.getTotalAppointments());
            request.setAttribute("totalVaccinations", dashboardDAO.getTotalVaccinations());
            request.setAttribute("appointmentsByStatus", dashboardDAO.getAppointmentsByStatus());
            
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}