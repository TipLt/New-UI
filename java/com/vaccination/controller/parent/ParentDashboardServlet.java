package com.vaccination.controller.parent;

import com.vaccination.dao.ChildDAO;
import com.vaccination.dao.AppointmentDAO;
import com.vaccination.model.Child;
import com.vaccination.model.Appointment;
import com.vaccination.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/parent/dashboard")
public class ParentDashboardServlet extends HttpServlet {
    private ChildDAO childDAO = new ChildDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"PARENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        List<Child> children = childDAO.findByParentId(user.getUserId());
        request.setAttribute("children", children);

        request.getRequestDispatcher("/views/parent/dashboard.jsp").forward(request, response);
    }
}
