package com.vaccination.service;

import com.vaccination.dao.*;
import com.vaccination.model.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class VaccinationService {
    private final VaccinationScheduleTemplateDAO scheduleTemplateDAO;
    private final AppointmentDAO appointmentDAO;
    private final CenterDAO centerDAO;
    
    public VaccinationService() {
        this.scheduleTemplateDAO = new VaccinationScheduleTemplateDAO();
        this.appointmentDAO = new AppointmentDAO();
        this.centerDAO = new CenterDAO();
    }
    
    /**
     * Tự động tạo appointments cho TẤT CẢ vaccine MIỄN PHÍ theo lịch TCMR
     * CHỈ TẠO NGÀY TIÊM - Phụ huynh sẽ tự chọn GIỜ + TRUNG TÂM sau
     * Được gọi khi: Thêm bé mới vào hệ thống
     * 
     * @param child Child object với thông tin ngày sinh
     * @return số lượng appointments được tạo
     */
    public int autoScheduleFreeVaccines(Child child) {
        if (child == null || child.getDateOfBirth() == null) {
            return 0;
        }
        
        // Lấy TẤT CẢ vaccine MIỄN PHÍ từ lịch TCMR (từ 0 tháng trở đi)
        List<VaccinationScheduleTemplate> allFreeTemplates = 
            scheduleTemplateDAO.findRecommendedForAge(0);
        
        if (allFreeTemplates.isEmpty()) {
            return 0;
        }
        
        // Lọc chỉ lấy vaccine MIỄN PHÍ
        List<VaccinationScheduleTemplate> freeTemplates = allFreeTemplates.stream()
            .filter(t -> t.getVaccine() != null && t.getVaccine().isFree())
            .collect(java.util.stream.Collectors.toList());
        
        if (freeTemplates.isEmpty()) {
            return 0;
        }
        
        int createdCount = 0;
        LocalDate childDOB = child.getDateOfBirth();
        
        // Đảm bảo appointments cách ít nhất 2 ngày từ ngày hiện tại
        LocalDate earliestAllowedDate = LocalDate.now().plusDays(2);
        
        for (VaccinationScheduleTemplate template : freeTemplates) {
            // Kiểm tra xem đã có appointment cho vaccine này chưa
            boolean alreadyScheduled = appointmentDAO.findByChildId(child.getChildId())
                .stream()
                .anyMatch(apt -> apt.getVaccineId() == template.getVaccineId());
            
            if (!alreadyScheduled) {
                // Tính toán ngày tiêm dựa trên DOB + AgeInMonths
                // AgeInMonths có thể là decimal (0.5, 12.5...)
                int months = (int) template.getAgeInMonths();
                int days = (int) ((template.getAgeInMonths() - months) * 30);
                LocalDate vaccinationDate = childDOB.plusMonths(months).plusDays(days);
                
                // ĐẢM BẢO ngày tiêm cách ít nhất 2 ngày từ hôm nay
                if (vaccinationDate.isBefore(earliestAllowedDate)) {
                    vaccinationDate = earliestAllowedDate;
                }
                
                // TẠO APPOINTMENT CHỈ VỚI NGÀY - Phụ huynh sẽ tự chọn GIỜ + TRUNG TÂM sau
                Appointment appointment = new Appointment();
                appointment.setChildId(child.getChildId());
                appointment.setVaccineId(template.getVaccineId());
                appointment.setCenterId(null);  // Phụ huynh sẽ chọn center
                appointment.setAppointmentDate(vaccinationDate);
                appointment.setAppointmentTime(null);  // Phụ huynh sẽ chọn giờ
                appointment.setStatus("PENDING");
                appointment.setNotes("Vaccine mien phi - Vui long chon gio va trung tam: " + 
                                   template.getVaccine().getVaccineName());
                
                if (appointmentDAO.createAppointment(appointment)) {
                    createdCount++;
                }
            }
        }
        
        return createdCount;
    }
    
    /**
     * Kiểm tra xem child có appointment nào đang pending không
     */
    public boolean hasPendingFreeVaccineAppointments(int childId) {
        return appointmentDAO.findByChildId(childId)
            .stream()
            .anyMatch(apt -> "PENDING".equals(apt.getStatus()));
    }
}
