package com.vaccination.reception;

import com.vaccination.dao.AppointmentDAO;
import com.vaccination.model.Appointment;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reception/appointmentDetail")
public class AppointmentDetailServlet extends HttpServlet {
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int appointmentId = Integer.parseInt(request.getParameter("id"));
        Appointment appointment = appointmentDAO.findById(appointmentId);

        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/reception/appointments-list?notfound=true");
            return;
        }

        request.setAttribute("appointment", appointment);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/reception/appointments-detail.jsp");
        dispatcher.forward(request, response);
    }
}
