package com.vaccination.dao;

import com.vaccination.model.Vaccine;
import com.vaccination.model.VaccinationScheduleTemplate;
import com.vaccination.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VaccinationScheduleTemplateDAO {
    
    public List<VaccinationScheduleTemplate> findByAgeInMonths(double ageInMonths) {
        List<VaccinationScheduleTemplate> templates = new ArrayList<>();
        String sql = "SELECT vst.*, v.* FROM VaccinationScheduleTemplate vst " +
                    "INNER JOIN Vaccines v ON vst.VaccineID = v.VaccineID " +
                    "WHERE vst.AgeInMonths = ? " +
                    "ORDER BY vst.DisplayOrder";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDouble(1, ageInMonths);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                VaccinationScheduleTemplate template = extractTemplateFromResultSet(rs);
                Vaccine vaccine = extractVaccineFromResultSet(rs);
                template.setVaccine(vaccine);
                templates.add(template);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return templates;
    }
    
    public List<VaccinationScheduleTemplate> findRecommendedForAge(double ageInMonths) {
        List<VaccinationScheduleTemplate> templates = new ArrayList<>();
        String sql = "SELECT vst.TemplateID, vst.VaccineID, vst.StageName, vst.AgeInMonths, vst.DoseNumber, " +
                    "vst.Description AS TemplateDescription, vst.IsMandatory, vst.DisplayOrder, vst.CreatedAt AS TemplateCreatedAt, " +
                    "v.VaccineName, v.Manufacturer, v.Description, v.DiseasesPrevented, v.DosageSchedule, " +
                    "v.RecommendedAge, v.Price, v.IsFree, v.IsActive, v.SideEffects, v.Contraindications, v.CreatedAt " +
                    "FROM VaccinationScheduleTemplate vst " +
                    "INNER JOIN Vaccines v ON vst.VaccineID = v.VaccineID " +
                    "WHERE vst.AgeInMonths >= ? AND v.IsActive = 1 " +
                    "ORDER BY vst.AgeInMonths, vst.DisplayOrder";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDouble(1, ageInMonths);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                VaccinationScheduleTemplate template = extractTemplateFromResultSet(rs);
                Vaccine vaccine = extractVaccineFromResultSet(rs);
                template.setVaccine(vaccine);
                templates.add(template);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return templates;
    }
    
    public List<VaccinationScheduleTemplate> findMandatoryByAge(double ageInMonths) {
        List<VaccinationScheduleTemplate> templates = new ArrayList<>();
        String sql = "SELECT vst.*, v.* FROM VaccinationScheduleTemplate vst " +
                    "INNER JOIN Vaccines v ON vst.VaccineID = v.VaccineID " +
                    "WHERE vst.AgeInMonths = ? AND vst.IsMandatory = 1 AND v.IsActive = 1 " +
                    "ORDER BY vst.DisplayOrder";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDouble(1, ageInMonths);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                VaccinationScheduleTemplate template = extractTemplateFromResultSet(rs);
                Vaccine vaccine = extractVaccineFromResultSet(rs);
                template.setVaccine(vaccine);
                templates.add(template);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return templates;
    }
    
    private VaccinationScheduleTemplate extractTemplateFromResultSet(ResultSet rs) throws SQLException {
        VaccinationScheduleTemplate template = new VaccinationScheduleTemplate();
        template.setTemplateId(rs.getInt("TemplateID"));
        template.setVaccineId(rs.getInt("VaccineID"));
        template.setStageName(rs.getString("StageName"));
        template.setAgeInMonths(rs.getDouble("AgeInMonths"));
        template.setDoseNumber(rs.getInt("DoseNumber"));
        
        try {
            template.setDescription(rs.getString("TemplateDescription"));
        } catch (SQLException e) {
            template.setDescription(rs.getString("Description"));
        }
        
        template.setMandatory(rs.getBoolean("IsMandatory"));
        template.setDisplayOrder(rs.getInt("DisplayOrder"));
        
        try {
            Timestamp createdAt = rs.getTimestamp("TemplateCreatedAt");
            if (createdAt != null) {
                template.setCreatedAt(createdAt.toLocalDateTime());
            }
        } catch (SQLException e) {
            Timestamp createdAt = rs.getTimestamp("CreatedAt");
            if (createdAt != null) {
                template.setCreatedAt(createdAt.toLocalDateTime());
            }
        }
        
        return template;
    }
    
    private Vaccine extractVaccineFromResultSet(ResultSet rs) throws SQLException {
        Vaccine vaccine = new Vaccine();
        vaccine.setVaccineId(rs.getInt("VaccineID"));
        vaccine.setVaccineName(rs.getString("VaccineName"));
        vaccine.setManufacturer(rs.getString("Manufacturer"));
        vaccine.setDescription(rs.getString("Description"));
        vaccine.setDiseasesPrevented(rs.getString("DiseasesPrevented"));
        vaccine.setDosageSchedule(rs.getString("DosageSchedule"));
        vaccine.setRecommendedAge(rs.getString("RecommendedAge"));
        vaccine.setPrice(rs.getBigDecimal("Price"));
        vaccine.setFree(rs.getBoolean("IsFree"));
        vaccine.setActive(rs.getBoolean("IsActive"));
        vaccine.setSideEffects(rs.getString("SideEffects"));
        vaccine.setContraindications(rs.getString("Contraindications"));
        
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            vaccine.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return vaccine;
    }
}
