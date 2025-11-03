
package com.vaccination.controller.medical;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.vaccination.dao.*;
import com.vaccination.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/medical/vaccination-record/*")
public class RecordVaccinationDetailServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private ChildDAO childDAO;
    private VaccineDAO vaccineDAO;
    private CenterDAO centerDAO;
    private UserDAO userDAO;
    private VaccinationRecordDAO vaccinationRecordDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        childDAO = new ChildDAO();
        vaccineDAO = new VaccineDAO();
        centerDAO = new CenterDAO();
        userDAO = new UserDAO();
        vaccinationRecordDAO = new VaccinationRecordDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"MEDICAL".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // Step 1: Show appointment list (PENDING/CONFIRMED)
            showAppointmentList(request, response);
        } else if (pathInfo.equals("/datetime")) {
            // Step 1: Record Vaccination Date/Time screen
            String appointmentIdStr = request.getParameter("appointmentId");
            if (appointmentIdStr != null) {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                showRecordDateTimeScreen(request, response, appointmentId);
            } else {
                response.sendRedirect(request.getContextPath() + "/medical/vaccination-record/");
            }
        } else if (pathInfo.equals("/result")) {
            // Step 2: Record Vaccination Result screen (from session data)
            showRecordResultScreen(request, response);
        } else if (pathInfo.startsWith("/observation/")) {
            // Step 3: Observation Dashboard
            String recordIdStr = pathInfo.substring("/observation/".length());
            int recordId = Integer.parseInt(recordIdStr);
            showObservationDashboard(request, response, recordId);
        } else if (pathInfo.equals("/medical-staff-list")) {
            // API: Get medical staff list
            getMedicalStaffList(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"MEDICAL".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.equals("/save-datetime")) {
            // Save date/time data to session and forward to result screen
            saveDateTimeToSession(request, response);
        } else if (pathInfo != null && pathInfo.equals("/save-result")) {
            // Save vaccination result and create record if Administered
            saveVaccinationResult(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/update-observation/")) {
            // Update observation data
            String recordIdStr = pathInfo.substring("/update-observation/".length());
            int recordId = Integer.parseInt(recordIdStr);
            updateObservation(request, response, recordId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ==================== STEP 1: Record Vaccination Date/Time ====================

    private void showAppointmentList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all appointments with status PENDING or CONFIRMED
            List<Appointment> allAppointments = appointmentDAO.getAll();

            // Filter and enrich data
            allAppointments.removeIf(apt ->
                    !"PENDING".equals(apt.getStatus()) && !"CONFIRMED".equals(apt.getStatus())
            );

            for (Appointment apt : allAppointments) {
                Child child = childDAO.findById(apt.getChildId());
                apt.setChild(child);

                Vaccine vaccine = vaccineDAO.findById(apt.getVaccineId());
                apt.setVaccine(vaccine);

                if (apt.getCenterId() != null) {
                    Center center = centerDAO.findById(apt.getCenterId());
                    apt.setCenter(center);
                }
            }

            request.setAttribute("appointments", allAppointments);
            request.getRequestDispatcher("/views/medical/record-set-appointments.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách lịch hẹn: " + e.getMessage());
            request.getRequestDispatcher("/views/medical/record-set-appointments.jsp")
                    .forward(request, response);
        }
    }

    private void showRecordDateTimeScreen(HttpServletRequest request, HttpServletResponse response, int appointmentId)
            throws ServletException, IOException {
        try {
            Appointment appointment = appointmentDAO.findById(appointmentId);
            if (appointment == null) {
                response.sendRedirect(request.getContextPath() + "/medical/vaccination-record/");
                return;
            }

            // Enrich appointment data
            Child child = childDAO.findById(appointment.getChildId());
            appointment.setChild(child);

            Vaccine vaccine = vaccineDAO.findById(appointment.getVaccineId());
            appointment.setVaccine(vaccine);

            if (appointment.getCenterId() != null) {
                Center center = centerDAO.findById(appointment.getCenterId());
                appointment.setCenter(center);
            }

            // Get medical staff list
            List<User> medicalStaff = userDAO.findByRole("MEDICAL");

            request.setAttribute("appointment", appointment);
            request.setAttribute("medicalStaff", medicalStaff);
            request.getRequestDispatcher("/views/medical/record-vaccination-date.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/medical/vaccination-record/?error=" + e.getMessage());
        }
    }

    private void saveDateTimeToSession(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form data
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            int childId = Integer.parseInt(request.getParameter("childId"));
            int vaccineId = Integer.parseInt(request.getParameter("vaccineId"));
            String vaccinationDateTimeStr = request.getParameter("vaccinationDateTime");
            int administeredBy = Integer.parseInt(request.getParameter("administeredBy"));
            String batchNumber = request.getParameter("batchNumber");
            String doseNumberStr = request.getParameter("doseNumber");
            String room = request.getParameter("room");

            // Parse date/time
            LocalDateTime vaccinationDateTime = LocalDateTime.parse(vaccinationDateTimeStr);

            // Validate: vaccinationDateTime should not be in future
            if (vaccinationDateTime.isAfter(LocalDateTime.now())) {
                response.sendRedirect(request.getContextPath() +
                        "/medical/vaccination-record/datetime?appointmentId=" + appointmentId +
                        "&error=datetime_future");
                return;
            }

            // Create session data object
            Map<String, Object> vaccinationData = new HashMap<>();
            vaccinationData.put("appointmentId", appointmentId);
            vaccinationData.put("childId", childId);
            vaccinationData.put("vaccineId", vaccineId);
            vaccinationData.put("vaccinationDateTime", vaccinationDateTime);
            vaccinationData.put("administeredBy", administeredBy);
            vaccinationData.put("batchNumber", batchNumber);

            Integer doseNumber = null;
            if (doseNumberStr != null && !doseNumberStr.trim().isEmpty()) {
                doseNumber = Integer.parseInt(doseNumberStr);
            }
            vaccinationData.put("doseNumber", doseNumber);
            vaccinationData.put("room", room);

            // Store in session
            HttpSession session = request.getSession();
            session.setAttribute("vaccinationData", vaccinationData);

            // Redirect to result screen
            response.sendRedirect(request.getContextPath() + "/medical/vaccination-record/result");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/medical/vaccination-record/?error=" + e.getMessage());
        }
    }

    // ==================== STEP 2: Record Vaccination Result ====================

    private void showRecordResultScreen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            Map<String, Object> vaccinationData = (Map<String, Object>) session.getAttribute("vaccinationData");

            if (vaccinationData == null) {
                response.sendRedirect(request.getContextPath() + "/medical/vaccination-record/");
                return;
            }

            // Get appointment details for display
            int appointmentId = (Integer) vaccinationData.get("appointmentId");
            Appointment appointment = appointmentDAO.findById(appointmentId);

            Child child = childDAO.findById(appointment.getChildId());
            Vaccine vaccine = vaccineDAO.findById(appointment.getVaccineId());
            User administrator = userDAO.findById((Integer) vaccinationData.get("administeredBy"));

            request.setAttribute("vaccinationData", vaccinationData);
            request.setAttribute("child", child);
            request.setAttribute("vaccine", vaccine);
            request.setAttribute("administrator", administrator);

            request.getRequestDispatcher("/views/medical/record-vaccination-result.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/medical/vaccination-record/?error=" + e.getMessage());
        }
    }

    private void saveVaccinationResult(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            Map<String, Object> vaccinationData = (Map<String, Object>) session.getAttribute("vaccinationData");

            if (vaccinationData == null) {
                response.sendRedirect(request.getContextPath() + "/medical/vaccination-record/");
                return;
            }

            // Get form data
            String outcome = request.getParameter("outcome");
            String reason = request.getParameter("reason");
            String stockConfirmed = request.getParameter("stockConfirmed");

            int appointmentId = (Integer) vaccinationData.get("appointmentId");

            // Handle different outcomes
            if ("Administered".equals(outcome)) {
                // Create vaccination record
                VaccinationRecord record = new VaccinationRecord();
                record.setAppointmentId(appointmentId);
                record.setChildId((Integer) vaccinationData.get("childId"));
                record.setVaccineId((Integer) vaccinationData.get("vaccineId"));
                record.setVaccinationDate((LocalDateTime) vaccinationData.get("vaccinationDateTime"));
                record.setBatchNumber((String) vaccinationData.get("batchNumber"));
                record.setDoseNumber((Integer) vaccinationData.get("doseNumber"));
                record.setAdministeredBy((Integer) vaccinationData.get("administeredBy"));

                // Build vaccination notes
                StringBuilder notes = new StringBuilder();
                String room = (String) vaccinationData.get("room");
                if (room != null && !room.trim().isEmpty()) {
                    notes.append("Room: ").append(room);
                }
                if ("on".equals(stockConfirmed)) {
                    if (notes.length() > 0) notes.append(" | ");
                    notes.append("Stock confirmed by user ")
                            .append(vaccinationData.get("administeredBy"))
                            .append(" at ")
                            .append(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
                }
                record.setVaccinationNotes(notes.toString());

                // Insert record
                boolean recordCreated = vaccinationRecordDAO.createRecord(record);

                if (recordCreated) {
                    // Update appointment status to COMPLETED
                    appointmentDAO.updateAppointmentStatus(appointmentId, "COMPLETED",
                            (Integer) vaccinationData.get("administeredBy"));

                    // Clear session data
                    session.removeAttribute("vaccinationData");

                    // Get the created record ID
                    List<VaccinationRecord> records = vaccinationRecordDAO.findByAppointmentId(appointmentId);
                    if (!records.isEmpty()) {
                        int recordId = records.get(0).getRecordId();
                        // Redirect to observation
                        response.sendRedirect(request.getContextPath() +
                                "/medical/vaccination-record/observation/" + recordId);
                    } else {
                        response.sendRedirect(request.getContextPath() +
                                "/medical/appointments/?success=vaccination_completed");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() +
                            "/medical/vaccination-record/result?error=create_record_failed");
                }

            } else {
                // Handle other outcomes: Deferred, Contraindicated, Refused, Error, Not eligible
                String newStatus = "CONFIRMED"; // Default
                String notePrefix = "";

                switch (outcome) {
                    case "Deferred":
                        newStatus = "CONFIRMED";
                        notePrefix = "Deferred";
                        break;
                    case "Contraindicated":
                        newStatus = "REJECTED";
                        notePrefix = "Contraindicated";
                        break;
                    case "Refused":
                        newStatus = "CANCELLED";
                        notePrefix = "Refused";
                        break;
                    case "Error":
                        newStatus = "CANCELLED";
                        notePrefix = "Administration error";
                        break;
                    case "Not eligible":
                        newStatus = "REJECTED";
                        notePrefix = "Not eligible";
                        break;
                }

                // Build notes
                Appointment apt = appointmentDAO.findById(appointmentId);
                String existingNotes = apt.getNotes() != null ? apt.getNotes() : "";
                String newNote = String.format("\n%s | %s | Reason: %s",
                        LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")),
                        notePrefix,
                        reason);

                String updatedNotes = existingNotes + newNote;
                appointmentDAO.updateNotes(appointmentId, updatedNotes);
                appointmentDAO.updateAppointmentStatus(appointmentId, newStatus,
                        (Integer) vaccinationData.get("administeredBy"));

                // Clear session data
                session.removeAttribute("vaccinationData");

                // Redirect with appropriate message
                response.sendRedirect(request.getContextPath() +
                        "/medical/appointments/?success=vaccination_" + outcome.toLowerCase().replace(" ", "_"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                    "/medical/vaccination-record/result?error=" + e.getMessage());
        }
    }

    // ==================== STEP 3: Observation Dashboard ====================

    private void showObservationDashboard(HttpServletRequest request, HttpServletResponse response, int recordId)
            throws ServletException, IOException {
        try {
            VaccinationRecord record = vaccinationRecordDAO.findById(recordId);
            if (record == null) {
                response.sendRedirect(request.getContextPath() + "/medical/appointments/?error=record_not_found");
                return;
            }

            // Enrich record data
            Child child = childDAO.findById(record.getChildId());
            Vaccine vaccine = vaccineDAO.findById(record.getVaccineId());
            User staff = userDAO.findById(record.getAdministeredBy());

            record.setChild(child);
            record.setVaccine(vaccine);
            record.setStaff(staff);

            // Get appointment for reference
            Appointment appointment = appointmentDAO.findById(record.getAppointmentId());

            request.setAttribute("record", record);
            request.setAttribute("appointment", appointment);

            request.getRequestDispatcher("/views/medical/record-observations.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                    "/medical/appointments/?error=" + e.getMessage());
        }
    }

    private void updateObservation(HttpServletRequest request, HttpServletResponse response, int recordId)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Get form data
            String sideEffects = request.getParameter("sideEffects");
            String healthNotes = request.getParameter("healthNotes");
            String obsNote = request.getParameter("obsNote");
            String nextDoseDateStr = request.getParameter("nextDoseDate");

            VaccinationRecord record = vaccinationRecordDAO.findById(recordId);
            if (record == null) {
                JsonObject error = new JsonObject();
                error.addProperty("success", false);
                error.addProperty("message", "Không tìm thấy bản ghi");
                out.print(gson.toJson(error));
                return;
            }

            // Update record fields
            record.setSideEffectsReported(sideEffects);
            record.setHealthCheckNotes(healthNotes);

            // Append observation note to vaccination notes
            if (obsNote != null && !obsNote.trim().isEmpty()) {
                String existingNotes = record.getVaccinationNotes() != null ? record.getVaccinationNotes() : "";
                String newNote = String.format("\n%s | Obs note: %s",
                        LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")),
                        obsNote);
                record.setVaccinationNotes(existingNotes + newNote);
            }

            // Parse next dose date
            if (nextDoseDateStr != null && !nextDoseDateStr.trim().isEmpty()) {
                LocalDate nextDoseDate = LocalDate.parse(nextDoseDateStr);
                if (nextDoseDate.isBefore(record.getVaccinationDate().toLocalDate())) {
                    JsonObject warning = new JsonObject();
                    warning.addProperty("success", false);
                    warning.addProperty("message", "Ngày tiêm liều tiếp theo không thể trước ngày tiêm hiện tại");
                    out.print(gson.toJson(warning));
                    return;
                }
                record.setNextDoseDate(nextDoseDate);
            }

            // Update in database
            boolean updated = vaccinationRecordDAO.updateRecord(record);

            JsonObject result = new JsonObject();
            result.addProperty("success", updated);
            result.addProperty("message", updated ? "Cập nhật thành công" : "Cập nhật thất bại");
            out.print(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            JsonObject error = new JsonObject();
            error.addProperty("success", false);
            error.addProperty("message", "Lỗi: " + e.getMessage());
            out.print(gson.toJson(error));
        }
    }

    // ==================== API Methods ====================

    private void getMedicalStaffList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<User> medicalStaff = userDAO.findByRole("MEDICAL");
            String json = gson.toJson(medicalStaff);
            response.getWriter().print(json);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}