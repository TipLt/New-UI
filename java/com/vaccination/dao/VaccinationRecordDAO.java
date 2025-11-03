package com.vaccination.dao;

import com.vaccination.model.VaccinationRecord;
import com.vaccination.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VaccinationRecordDAO {
    
    public VaccinationRecord findById(int recordId) {
        String sql = "SELECT * FROM VaccinationRecords WHERE RecordID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, recordId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractRecordFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<VaccinationRecord> findByChildId(int childId) {
        List<VaccinationRecord> records = new ArrayList<>();
        String sql = "SELECT * FROM VaccinationRecords WHERE ChildID = ? ORDER BY VaccinationDate DESC";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, childId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                records.add(extractRecordFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }
    
    public List<VaccinationRecord> findByAppointmentId(int appointmentId) {
        List<VaccinationRecord> records = new ArrayList<>();
        String sql = "SELECT * FROM VaccinationRecords WHERE AppointmentID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, appointmentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                records.add(extractRecordFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }
    
    public boolean createRecord(VaccinationRecord record) {
        String sql = "INSERT INTO VaccinationRecords (AppointmentID, ChildID, VaccineID, VaccinationDate, " +
                     "BatchNumber, DoseNumber, AdministeredBy, HealthCheckNotes, VaccinationNotes, " +
                     "SideEffectsReported, NextDoseDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, record.getAppointmentId());
            stmt.setInt(2, record.getChildId());
            stmt.setInt(3, record.getVaccineId());
            stmt.setTimestamp(4, Timestamp.valueOf(record.getVaccinationDate()));
            stmt.setString(5, record.getBatchNumber());
            
            if (record.getDoseNumber() != null) {
                stmt.setInt(6, record.getDoseNumber());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            
            stmt.setInt(7, record.getAdministeredBy());
            stmt.setString(8, record.getHealthCheckNotes());
            stmt.setString(9, record.getVaccinationNotes());
            stmt.setString(10, record.getSideEffectsReported());
            
            if (record.getNextDoseDate() != null) {
                stmt.setDate(11, Date.valueOf(record.getNextDoseDate()));
            } else {
                stmt.setNull(11, Types.DATE);
            }
            
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    record.setRecordId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private VaccinationRecord extractRecordFromResultSet(ResultSet rs) throws SQLException {
        VaccinationRecord record = new VaccinationRecord();
        record.setRecordId(rs.getInt("RecordID"));
        record.setAppointmentId(rs.getInt("AppointmentID"));
        record.setChildId(rs.getInt("ChildID"));
        record.setVaccineId(rs.getInt("VaccineID"));
        
        Timestamp vaccinationDate = rs.getTimestamp("VaccinationDate");
        if (vaccinationDate != null) record.setVaccinationDate(vaccinationDate.toLocalDateTime());
        
        record.setBatchNumber(rs.getString("BatchNumber"));
        
        int doseNumber = rs.getInt("DoseNumber");
        if (!rs.wasNull()) record.setDoseNumber(doseNumber);
        
        record.setAdministeredBy(rs.getInt("AdministeredBy"));
        record.setHealthCheckNotes(rs.getString("HealthCheckNotes"));
        record.setVaccinationNotes(rs.getString("VaccinationNotes"));
        record.setSideEffectsReported(rs.getString("SideEffectsReported"));
        
        Date nextDoseDate = rs.getDate("NextDoseDate");
        if (nextDoseDate != null) record.setNextDoseDate(nextDoseDate.toLocalDate());
        
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) record.setCreatedAt(createdAt.toLocalDateTime());
        
        return record;
    }
    
    public boolean updateRecord(VaccinationRecord record) {
        String sql = "UPDATE VaccinationRecords SET " +
                "SideEffectsReported = ?, " +
                "HealthCheckNotes = ?, " +
                "VaccinationNotes = ?, " +
                "NextDoseDate = ? " +
                "WHERE RecordID = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, record.getSideEffectsReported());
            stmt.setString(2, record.getHealthCheckNotes());
            stmt.setString(3, record.getVaccinationNotes());

            if (record.getNextDoseDate() != null) {
                stmt.setDate(4, java.sql.Date.valueOf(record.getNextDoseDate()));
            } else {
                stmt.setNull(4, java.sql.Types.DATE);
            }

            stmt.setInt(5, record.getRecordId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
