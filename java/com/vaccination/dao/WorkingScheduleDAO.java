package com.vaccination.dao;

import com.vaccination.model.WorkingSchedule;
import com.vaccination.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class WorkingScheduleDAO {
    
    public List<WorkingSchedule> findByCenterId(int centerId) {
        List<WorkingSchedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM WorkingSchedule WHERE CenterID = ? AND IsActive = 1 ORDER BY DayOfWeek";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, centerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                schedules.add(extractScheduleFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }
    
    public WorkingSchedule findByCenterAndDay(int centerId, String dayOfWeek) {
        String sql = "SELECT * FROM WorkingSchedule WHERE CenterID = ? AND DayOfWeek = ? AND IsActive = 1";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, centerId);
            stmt.setString(2, dayOfWeek);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractScheduleFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<String> getAvailableTimeSlots(int centerId, String dayOfWeek, java.time.LocalDate date) {
        List<String> availableSlots = new ArrayList<>();
        WorkingSchedule schedule = findByCenterAndDay(centerId, dayOfWeek);
        
        if (schedule == null) {
            return availableSlots;
        }
        
        LocalTime current = schedule.getStartTime();
        LocalTime end = schedule.getEndTime();
        int duration = schedule.getSlotDuration();
        
        while (current.isBefore(end)) {
            String timeSlot = current.toString();
            
            if (!isSlotBooked(centerId, date, timeSlot)) {
                availableSlots.add(timeSlot);
            }
            
            current = current.plusMinutes(duration);
        }
        
        return availableSlots;
    }
    
    private boolean isSlotBooked(int centerId, java.time.LocalDate date, String time) {
        String sql = "SELECT COUNT(*) FROM Appointments WHERE CenterID = ? AND AppointmentDate = ? AND AppointmentTime = ? AND Status NOT IN ('CANCELLED', 'REJECTED')";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, centerId);
            stmt.setDate(2, Date.valueOf(date));
            stmt.setString(3, time);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean createSchedule(WorkingSchedule schedule) {
        String sql = "INSERT INTO WorkingSchedule (CenterID, DayOfWeek, StartTime, EndTime, SlotDuration, IsActive) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, schedule.getCenterId());
            stmt.setString(2, schedule.getDayOfWeek());
            stmt.setTime(3, Time.valueOf(schedule.getStartTime()));
            stmt.setTime(4, Time.valueOf(schedule.getEndTime()));
            stmt.setInt(5, schedule.getSlotDuration());
            stmt.setBoolean(6, schedule.isActive());
            
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    schedule.setScheduleId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private WorkingSchedule extractScheduleFromResultSet(ResultSet rs) throws SQLException {
        WorkingSchedule schedule = new WorkingSchedule();
        schedule.setScheduleId(rs.getInt("ScheduleID"));
        schedule.setCenterId(rs.getInt("CenterID"));
        schedule.setDayOfWeek(rs.getString("DayOfWeek"));
        
        Time startTime = rs.getTime("StartTime");
        if (startTime != null) schedule.setStartTime(startTime.toLocalTime());
        
        Time endTime = rs.getTime("EndTime");
        if (endTime != null) schedule.setEndTime(endTime.toLocalTime());
        
        schedule.setSlotDuration(rs.getInt("SlotDuration"));
        schedule.setActive(rs.getBoolean("IsActive"));
        
        return schedule;
    }
}
