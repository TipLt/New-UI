package com.vaccination.controller.parent;

import com.vaccination.dao.*;
import com.vaccination.model.*;
import com.vaccination.util.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.DayOfWeek;
import static java.time.DayOfWeek.FRIDAY;
import static java.time.DayOfWeek.MONDAY;
import static java.time.DayOfWeek.SATURDAY;
import static java.time.DayOfWeek.SUNDAY;
import static java.time.DayOfWeek.THURSDAY;
import static java.time.DayOfWeek.TUESDAY;
import static java.time.DayOfWeek.WEDNESDAY;
import java.util.List;

@WebServlet("/parent/booking/*")
public class AppointmentBookingServlet extends HttpServlet {
    private ChildDAO childDAO = new ChildDAO();
    private VaccineDAO vaccineDAO = new VaccineDAO();
    private CenterDAO centerDAO = new CenterDAO();
    private WorkingScheduleDAO scheduleDAO = new WorkingScheduleDAO();
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

        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/step1")) {
            showStep1(request, response, user);
        } else if (pathInfo.equals("/step2")) {
            showStep2(request, response, user);
        } else if (pathInfo.equals("/confirm")) {
            showConfirm(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/parent/booking/step1");
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
        
        if (pathInfo != null && pathInfo.equals("/create")) {
            createAppointment(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/parent/booking/step1");
        }
    }

    private void showStep1(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Child> children = childDAO.findByParentId(user.getUserId());
        List<Vaccine> vaccines = vaccineDAO.getPaidVaccines();
        
        request.setAttribute("children", children);
        request.setAttribute("vaccines", vaccines);
        
        request.getRequestDispatcher("/views/parent/booking-step1.jsp").forward(request, response);
    }

    private void showStep2(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String childIdStr = request.getParameter("childId");
        String vaccineIdStr = request.getParameter("vaccineId");
        String dateStr = request.getParameter("date");
        String centerIdStr = request.getParameter("centerId");
        String timeStr = request.getParameter("time");
        
        if (childIdStr == null || vaccineIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/parent/booking/step1");
            return;
        }
        
        int childId = Integer.parseInt(childIdStr);
        int vaccineId = Integer.parseInt(vaccineIdStr);
        
        Child child = childDAO.findById(childId);
        Vaccine vaccine = vaccineDAO.findById(vaccineId);
        
        if (child == null || vaccine == null || child.getParentId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/parent/booking/step1");
            return;
        }
        
        List<Center> centers = centerDAO.getAllCenters();
        
        List<String> availableSlots = null;
        if (dateStr != null && centerIdStr != null) {
            int centerId = Integer.parseInt(centerIdStr);
            LocalDate selectedDate = LocalDate.parse(dateStr);
            String dayOfWeek = getDayOfWeekName(selectedDate);
            availableSlots = scheduleDAO.getAvailableTimeSlots(centerId, dayOfWeek, selectedDate);
        }
        
        LocalDate minDate = LocalDate.now();
        String minDateStr = minDate.toString();
        
        request.setAttribute("child", child);
        request.setAttribute("vaccine", vaccine);
        request.setAttribute("centers", centers);
        request.setAttribute("selectedDate", dateStr);
        request.setAttribute("selectedCenterId", centerIdStr);
        request.setAttribute("selectedTimeSlot", timeStr);
        request.setAttribute("availableSlots", availableSlots);
        request.setAttribute("minDate", minDateStr);
        
        request.getRequestDispatcher("/views/parent/booking-step2.jsp").forward(request, response);
    }

    private void showConfirm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String childIdStr = request.getParameter("childId");
        String vaccineIdStr = request.getParameter("vaccineId");
        String centerIdStr = request.getParameter("centerId");
        String dateStr = request.getParameter("date");
        String timeStr = request.getParameter("time");
        
        if (childIdStr == null || vaccineIdStr == null || centerIdStr == null || 
            dateStr == null || timeStr == null) {
            response.sendRedirect(request.getContextPath() + "/parent/booking/step1");
            return;
        }
        
        int childId = Integer.parseInt(childIdStr);
        int vaccineId = Integer.parseInt(vaccineIdStr);
        int centerId = Integer.parseInt(centerIdStr);
        
        Child child = childDAO.findById(childId);
        Vaccine vaccine = vaccineDAO.findById(vaccineId);
        Center center = centerDAO.findById(centerId);
        
        if (child == null || vaccine == null || center == null || 
            child.getParentId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/parent/booking/step1");
            return;
        }
        
        request.setAttribute("child", child);
        request.setAttribute("vaccine", vaccine);
        request.setAttribute("center", center);
        request.setAttribute("appointmentDate", dateStr);
        request.setAttribute("appointmentTime", timeStr);
        
        request.getRequestDispatcher("/views/parent/booking-confirm.jsp").forward(request, response);
    }

    private void createAppointment(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int childId = Integer.parseInt(request.getParameter("childId"));
            int vaccineId = Integer.parseInt(request.getParameter("vaccineId"));
            int centerId = Integer.parseInt(request.getParameter("centerId"));
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            
            Child child = childDAO.findById(childId);
            if (child == null || child.getParentId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/parent/booking/step1");
                return;
            }
            
            Appointment appointment = new Appointment();
            appointment.setChildId(childId);
            appointment.setVaccineId(vaccineId);
            appointment.setCenterId(centerId);
            appointment.setAppointmentDate(LocalDate.parse(dateStr));
            appointment.setAppointmentTime(java.time.LocalTime.parse(timeStr));
            appointment.setStatus("PENDING");
            appointment.setPaymentStatus("UNPAID");
            
            if (appointmentDAO.createAppointment(appointment)) {
                request.getSession().setAttribute("success", "Đặt lịch hẹn thành công!");
                response.sendRedirect(request.getContextPath() + "/parent/appointments");
            } else {
                request.setAttribute("error", "Không thể đặt lịch. Vui lòng thử lại.");
                showConfirm(request, response, user);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showStep1(request, response, user);
        }
    }

    private String getDayOfWeekName(LocalDate date) {
        DayOfWeek dayOfWeek = date.getDayOfWeek();
        switch (dayOfWeek) {
            case MONDAY: return "Monday";
            case TUESDAY: return "Tuesday";
            case WEDNESDAY: return "Wednesday";
            case THURSDAY: return "Thursday";
            case FRIDAY: return "Friday";
            case SATURDAY: return "Saturday";
            case SUNDAY: return "Sunday";
            default: return "";
        }
    }
}
