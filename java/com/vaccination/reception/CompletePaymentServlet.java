package com.vaccination.reception;

import com.vaccination.dao.AppointmentDAO;
import com.vaccination.model.Appointment;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/reception/completePayment")
public class CompletePaymentServlet extends HttpServlet {
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        appointmentDAO.updatePaymentStatus(appointmentId, "PAID");
        response.sendRedirect(request.getContextPath() + "/reception/appointmentsManage");
    }
}
