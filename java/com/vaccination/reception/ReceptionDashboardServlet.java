package com.vaccination.reception;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import com.vaccination.dao.*;

@WebServlet("/reception/appointments-list")
public class ReceptionDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AppointmentDAO appointmentDAO = new AppointmentDAO();
        HttpSession session = request.getSession(false);
        if (session == null || !"RECEPTION".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

         request.setAttribute("appointments", appointmentDAO.getAll());

        request.getRequestDispatcher("/views/reception/appointments-list.jsp").forward(request, response);
    }
}
