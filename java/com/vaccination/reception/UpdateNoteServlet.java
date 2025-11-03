package com.vaccination.reception;

import com.vaccination.dao.AppointmentDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reception/updateNote")
public class UpdateNoteServlet extends HttpServlet {
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        String notes = request.getParameter("notes");

        appointmentDAO.updateNotes(appointmentId, notes);

        response.sendRedirect(request.getContextPath() + "/reception/appointmentDetail?id=" + appointmentId);

         }
}
