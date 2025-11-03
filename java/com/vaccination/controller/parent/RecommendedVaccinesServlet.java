package com.vaccination.controller.parent;

import com.vaccination.dao.ChildDAO;
import com.vaccination.dao.VaccinationScheduleTemplateDAO;
import com.vaccination.dao.VaccinationRecordDAO;
import com.vaccination.dao.AppointmentDAO;
import com.vaccination.model.Child;
import com.vaccination.model.User;
import com.vaccination.model.VaccinationScheduleTemplate;
import com.vaccination.model.Appointment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/parent/recommended-vaccines")
public class RecommendedVaccinesServlet extends HttpServlet {
    private ChildDAO childDAO = new ChildDAO();
    private VaccinationScheduleTemplateDAO scheduleTemplateDAO = new VaccinationScheduleTemplateDAO();
    private VaccinationRecordDAO vaccinationRecordDAO = new VaccinationRecordDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();

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

        String childIdParam = request.getParameter("childId");
        if (childIdParam == null || childIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/parent/children");
            return;
        }

        int childId = Integer.parseInt(childIdParam);
        Child child = childDAO.findById(childId);
        
        if (child == null || child.getParentId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/parent/children");
            return;
        }

        int ageInMonths = child.getAgeInMonths();
        
        List<VaccinationScheduleTemplate> allTemplates = scheduleTemplateDAO.findRecommendedForAge(ageInMonths);
        
        Map<String, List<VaccinationScheduleTemplate>> groupedByStage = allTemplates.stream()
            .collect(Collectors.groupingBy(
                VaccinationScheduleTemplate::getStageName,
                LinkedHashMap::new,
                Collectors.toList()
            ));
        
        Set<Integer> vaccinatedVaccineIds = vaccinationRecordDAO.findByChildId(childId).stream()
            .map(record -> record.getVaccineId())
            .collect(Collectors.toSet());
        
        // Lấy danh sách appointments để hiển thị lịch hẹn đã tạo sẵn cho vaccine miễn phí
        List<Appointment> appointments = appointmentDAO.findByChildId(childId);
        Map<Integer, Appointment> appointmentByVaccineId = appointments.stream()
            .collect(Collectors.toMap(
                Appointment::getVaccineId,
                apt -> apt,
                (existing, replacement) -> existing  // Giữ appointment đầu tiên nếu có duplicate
            ));
        
        request.setAttribute("child", child);
        request.setAttribute("ageInMonths", ageInMonths);
        request.setAttribute("groupedTemplates", groupedByStage);
        request.setAttribute("vaccinatedVaccineIds", vaccinatedVaccineIds);
        request.setAttribute("appointmentByVaccineId", appointmentByVaccineId);
        
        request.getRequestDispatcher("/views/parent/recommended-vaccines.jsp").forward(request, response);
    }
}
