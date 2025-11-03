package com.vaccination.reception;

import com.vaccination.dao.AppointmentDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reception/cancelPayment")
public class CancelPaymentServlet extends HttpServlet {
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

        appointmentDAO.updatePaymentStatus(appointmentId, "UNPAID");

        response.sendRedirect(request.getContextPath() + "/reception/appointmentsManage");
    }
}
