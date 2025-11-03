package com.vaccination.reception;

import com.vaccination.dao.AppointmentDAO;
import com.vaccination.model.Appointment;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/reception/appointmentsManage")
public class AppointmentsManageServlet extends HttpServlet {
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Appointment> appointments = appointmentDAO.findByStatus("CONFIRMED");

        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/views/reception/appointments-manage.jsp").forward(request, response);
    }
}
