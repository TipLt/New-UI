package com.vaccination.reception;

import com.vaccination.dao.AppointmentDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reception/confirmAppointment")
public class AppointmentConfirmServlet extends HttpServlet {
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        int staffId = (int) request.getSession().getAttribute("userId");

        boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, "CONFIRMED", staffId);
        response.sendRedirect(request.getContextPath() + "/reception/appointments-list?success=" + success);
    }
}
