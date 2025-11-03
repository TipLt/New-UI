package com.vaccination.controller.medical;

import com.vaccination.dao.AppointmentDAO;
import com.vaccination.dao.ChildDAO;
import com.vaccination.dao.VaccineDAO;
import com.vaccination.dao.CenterDAO;
import com.vaccination.model.Appointment;
import com.vaccination.model.Child;
import com.vaccination.model.User;
import com.vaccination.model.Vaccine;
import com.vaccination.model.Center;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "MedicalAppointmentManagementServlet", urlPatterns = {"/medical/appointments", "/medical/appointments/", "/medical/appointments/*"})
public class ConfirmedAppointmentManagementServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final ChildDAO childDAO = new ChildDAO();
    private final VaccineDAO vaccineDAO = new VaccineDAO();
    private final CenterDAO centerDAO = new CenterDAO();

    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("===================================================");
        System.out.println("Medical ConfirmedAppointmentManagementServlet INITIALIZED!");
        System.out.println("===================================================");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("\n========== MEDICAL APPOINTMENTS SERVLET ==========");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Servlet Path: " + request.getServletPath());
        System.out.println("Path Info: " + request.getPathInfo());
        System.out.println("Query String: " + request.getQueryString());
        System.out.println("==================================================\n");

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("No session found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check role authorization
        User user = (User) session.getAttribute("user");
        if (user == null || !"MEDICAL".equals(user.getRole())) {
            System.out.println("User role: " + (user != null ? user.getRole() : "null"));
            System.out.println("Access denied - not MEDICAL role");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Medical role required.");
            return;
        }

        System.out.println("User authenticated: " + user.getFullName() + " (Role: " + user.getRole() + ")");

        // Get path info
        String pathInfo = request.getPathInfo();

        // Route to appropriate handler
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.isEmpty()) {
            System.out.println("Routing to: LIST APPOINTMENTS");
            listAppointments(request, response);
        } else {
            System.out.println("Routing to: VIEW APPOINTMENT DETAIL");
            // View appointment detail
            try {
                // Remove leading slash and parse ID
                String idString = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
                int appointmentId = Integer.parseInt(idString);
                viewAppointmentDetail(request, response, appointmentId);
            } catch (NumberFormatException e) {
                System.err.println("Invalid appointment ID format: " + pathInfo);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID: " + pathInfo);
            }
        }
    }

    private void listAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            System.out.println("Loading appointments list...");

            // Get filter parameter (optional)
            String statusFilter = request.getParameter("status");
            System.out.println("Status filter: " + statusFilter);

            List<Appointment> appointments;

            if (statusFilter != null && !statusFilter.isEmpty()) {
                // Filter by specific status
                appointments = appointmentDAO.findByStatus(statusFilter);
            } else {
                // Get all appointments
                appointments = appointmentDAO.getAll();
            }

            System.out.println("Total appointments from DB: " + appointments.size());

            // Enrich appointments with related data
            for (Appointment appointment : appointments) {
                // Get child information
                Child child = childDAO.findById(appointment.getChildId());
                appointment.setChild(child);

                // Get vaccine information
                Vaccine vaccine = vaccineDAO.findById(appointment.getVaccineId());
                appointment.setVaccine(vaccine);

                // Get center information
                if (appointment.getCenterId() != null) {
                    Center center = centerDAO.findById(appointment.getCenterId());
                    appointment.setCenter(center);
                }
            }

            // Filter for medical staff: only show CONFIRMED and COMPLETED appointments
            List<Appointment> medicalAppointments = new ArrayList<>();
            for (Appointment app : appointments) {
                if ("CONFIRMED".equals(app.getStatus()) || "COMPLETED".equals(app.getStatus())) {
                    medicalAppointments.add(app);
                }
            }

            System.out.println("Medical appointments (CONFIRMED/COMPLETED): " + medicalAppointments.size());

            request.setAttribute("appointments", medicalAppointments);

            String jspPath = "/views/medical/appointments-confirmed-list.jsp";
            System.out.println("Forwarding to JSP: " + jspPath);

            request.getRequestDispatcher(jspPath).forward(request, response);

            System.out.println("Successfully forwarded to JSP");

        } catch (Exception e) {
            System.err.println("ERROR in listAppointments:");
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi tải danh sách lịch hẹn: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/medical/dashboard");
        }
    }


    private void viewAppointmentDetail(HttpServletRequest request, HttpServletResponse response, int appointmentId)
            throws ServletException, IOException {

        try {
            System.out.println("Loading appointment detail #" + appointmentId);

            Appointment appointment = appointmentDAO.findById(appointmentId);

            if (appointment == null) {
                System.out.println("Appointment not found: #" + appointmentId);
                request.getSession().setAttribute("error", "Không tìm thấy lịch hẹn #" + appointmentId);
                response.sendRedirect(request.getContextPath() + "/medical/appointments/");
                return;
            }

            // Only allow viewing CONFIRMED or COMPLETED appointments
            if (!"CONFIRMED".equals(appointment.getStatus()) && !"COMPLETED".equals(appointment.getStatus())) {
                System.out.println("Invalid appointment status: " + appointment.getStatus());
                request.getSession().setAttribute("error", "Bạn chỉ có thể xem lịch hẹn đã xác nhận hoặc hoàn thành");
                response.sendRedirect(request.getContextPath() + "/medical/appointments/");
                return;
            }

            // Get child information
            Child child = childDAO.findById(appointment.getChildId());
            appointment.setChild(child);
            System.out.println("DEBUG - Child: " + (child != null ? child.getFullName() : "NULL"));

            // Get vaccine information
            Vaccine vaccine = vaccineDAO.findById(appointment.getVaccineId());
            appointment.setVaccine(vaccine);
            System.out.println("DEBUG - Vaccine: " + (vaccine != null ? vaccine.getVaccineName() : "NULL"));
            System.out.println("DEBUG - Vaccine isFree: " + (vaccine != null ? vaccine.isFree() : "NULL"));
            System.out.println("DEBUG - Vaccine price: " + (vaccine != null ? vaccine.getPrice() : "NULL"));

            // Get center information
            if (appointment.getCenterId() != null) {
                Center center = centerDAO.findById(appointment.getCenterId());
                appointment.setCenter(center);
                System.out.println("DEBUG - Center: " + (center != null ? center.getCenterName() : "NULL"));
            }

            System.out.println("Appointment loaded successfully");

            request.setAttribute("appointment", appointment);

            String jspPath = "/views/medical/appointments-confirmed-details.jsp";
            System.out.println("Forwarding to JSP: " + jspPath);

            request.getRequestDispatcher(jspPath).forward(request, response);

            System.out.println("Successfully forwarded to detail JSP");

        } catch (Exception e) {
            System.err.println("ERROR in viewAppointmentDetail:");
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi tải chi tiết lịch hẹn: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/medical/appointments/");
        }
    }
}