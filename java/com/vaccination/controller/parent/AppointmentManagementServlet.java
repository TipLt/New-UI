package com.vaccination.controller.parent;

import com.vaccination.dao.*;
import com.vaccination.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/parent/appointments/*")
public class AppointmentManagementServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private ChildDAO childDAO = new ChildDAO();
    private VaccineDAO vaccineDAO = new VaccineDAO();
    private CenterDAO centerDAO = new CenterDAO();

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

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            listAppointments(request, response, user);
        } else if (pathInfo.matches("/\\d+")) {
            int appointmentId = Integer.parseInt(pathInfo.substring(1));
            viewAppointmentDetail(request, response, user, appointmentId);
        } else {
            response.sendRedirect(request.getContextPath() + "/parent/appointments");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.matches("/\\d+/cancel")) {
            int appointmentId = Integer.parseInt(pathInfo.substring(1, pathInfo.indexOf("/cancel")));
            cancelAppointment(request, response, user, appointmentId);
        } else {
            response.sendRedirect(request.getContextPath() + "/parent/appointments");
        }
    }

    private void listAppointments(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        List<Child> children = childDAO.findByParentId(user.getUserId());
        List<Appointment> allAppointments = new ArrayList<>();

        for (Child child : children) {
            List<Appointment> childAppointments = appointmentDAO.findByChildId(child.getChildId());

            for (Appointment appointment : childAppointments) {
                appointment.setChild(child);

                Vaccine vaccine = vaccineDAO.findById(appointment.getVaccineId());
                appointment.setVaccine(vaccine);

 
                if (appointment.getCenterId() != null) {
                    Center center = centerDAO.findById(appointment.getCenterId());
                    appointment.setCenter(center);
                } else {
                    appointment.setCenter(null);
                }

                allAppointments.add(appointment);
            }
        }

        request.setAttribute("appointments", allAppointments);
        request.getRequestDispatcher("/views/parent/appointments-list.jsp").forward(request, response);
    }

    private void viewAppointmentDetail(HttpServletRequest request, HttpServletResponse response, User user, int appointmentId)
            throws ServletException, IOException {

        Appointment appointment = appointmentDAO.findById(appointmentId);

        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/parent/appointments");
            return;
        }

        Child child = childDAO.findById(appointment.getChildId());

        if (child == null || child.getParentId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/parent/appointments");
            return;
        }

        appointment.setChild(child);

        Vaccine vaccine = vaccineDAO.findById(appointment.getVaccineId());
        appointment.setVaccine(vaccine);


        if (appointment.getCenterId() != null && appointment.getCenterId() > 0) {
            Center center = centerDAO.findById(appointment.getCenterId());
            appointment.setCenter(center);
        } else {
            appointment.setCenter(null);
        }

        request.setAttribute("appointment", appointment);
        request.getRequestDispatcher("/views/parent/appointment-detail.jsp").forward(request, response);
    }

    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response, User user, int appointmentId)
            throws ServletException, IOException {

        Appointment appointment = appointmentDAO.findById(appointmentId);

        if (appointment == null) {
            request.getSession().setAttribute("error", "Không tìm thấy lịch hẹn!");
            response.sendRedirect(request.getContextPath() + "/parent/appointments");
            return;
        }

        Child child = childDAO.findById(appointment.getChildId());
        if (child == null || child.getParentId() != user.getUserId()) {
            request.getSession().setAttribute("error", "Bạn không có quyền hủy lịch hẹn này!");
            response.sendRedirect(request.getContextPath() + "/parent/appointments");
            return;
        }

        if ("CONFIRMED".equals(appointment.getStatus()) || "COMPLETED".equals(appointment.getStatus())) {
            request.getSession().setAttribute("error", "Không thể hủy lịch hẹn đã xác nhận hoặc đã hoàn thành!");
            response.sendRedirect(request.getContextPath() + "/parent/appointments/" + appointmentId);
            return;
        }

        if (appointmentDAO.cancelAppointment(appointmentId)) {
            request.getSession().setAttribute("success", "Đã hủy lịch hẹn thành công!");
        } else {
            request.getSession().setAttribute("error", "Không thể hủy lịch hẹn. Vui lòng thử lại!");
        }

        response.sendRedirect(request.getContextPath() + "/parent/appointments");
    }
}