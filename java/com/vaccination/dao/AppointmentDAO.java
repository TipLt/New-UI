package com.vaccination.dao;

import com.vaccination.model.Appointment;
import com.vaccination.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    
    public Appointment findById(int appointmentId) {
        String sql = "SELECT * FROM Appointments WHERE AppointmentID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, appointmentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractAppointmentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Appointment> findByChildId(int childId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM Appointments WHERE ChildID = ? ORDER BY AppointmentDate DESC, AppointmentTime DESC";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, childId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(extractAppointmentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }

    public List<Appointment> findByStatus(String status) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM Appointments WHERE Status = ? ORDER BY AppointmentDate, AppointmentTime";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(extractAppointmentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }

    public List<Appointment> findByCenterId(int centerId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM Appointments WHERE CenterID = ? ORDER BY AppointmentDate DESC, AppointmentTime DESC";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, centerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(extractAppointmentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }

    public boolean createAppointment(Appointment appointment) {
        String sql = "INSERT INTO Appointments (ChildID, VaccineID, CenterID, AppointmentDate, " +
                     "AppointmentTime, Status, PaymentStatus, PaymentAmount, Notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, appointment.getChildId());
            stmt.setInt(2, appointment.getVaccineId());
            
            // CenterID can be NULL for FREE vaccines (parent selects later)
            if (appointment.getCenterId() != null) {
                stmt.setInt(3, appointment.getCenterId());
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }
            
            stmt.setDate(4, Date.valueOf(appointment.getAppointmentDate()));
            
            // AppointmentTime can be NULL for FREE vaccines (parent selects later)
            if (appointment.getAppointmentTime() != null) {
                stmt.setTime(5, Time.valueOf(appointment.getAppointmentTime()));
            } else {
                stmt.setNull(5, java.sql.Types.TIME);
            }
            
            stmt.setString(6, appointment.getStatus());
            stmt.setString(7, appointment.getPaymentStatus());
            stmt.setBigDecimal(8, appointment.getPaymentAmount());
            stmt.setString(9, appointment.getNotes());
            
            int affected = stmt.executeUpdate();
            
            if (affected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    appointment.setAppointmentId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAppointmentStatus(int appointmentId, String status, int confirmedBy) {
        String sql = "UPDATE Appointments SET Status = ?, ConfirmedBy = ?, ConfirmedAt = GETDATE(), " +
                     "UpdatedAt = GETDATE() WHERE AppointmentID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, confirmedBy);
            stmt.setInt(3, appointmentId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePaymentStatus(int appointmentId, String paymentStatus) {
        String sql = "UPDATE Appointments SET PaymentStatus = ?, UpdatedAt = GETDATE() WHERE AppointmentID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, paymentStatus);
            stmt.setInt(2, appointmentId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelAppointment(int appointmentId) {
        String sql = "UPDATE Appointments SET Status = 'CANCELLED', UpdatedAt = GETDATE() WHERE AppointmentID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, appointmentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Appointment> findByCenterAndDate(int centerId, java.time.LocalDate date) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM Appointments WHERE CenterID = ? AND AppointmentDate = ? AND Status != 'CANCELLED' ORDER BY AppointmentTime";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, centerId);
            stmt.setDate(2, Date.valueOf(date));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(extractAppointmentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }

    private Appointment extractAppointmentFromResultSet(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setAppointmentId(rs.getInt("AppointmentID"));
        appointment.setChildId(rs.getInt("ChildID"));
        appointment.setVaccineId(rs.getInt("VaccineID"));
        
        // CenterID can be NULL for FREE vaccines (parent selects later)
        int centerId = rs.getInt("CenterID");
        if (!rs.wasNull()) {
            appointment.setCenterId(centerId);
        }
        
        Date appointmentDate = rs.getDate("AppointmentDate");
        if (appointmentDate != null) appointment.setAppointmentDate(appointmentDate.toLocalDate());
        
        Time appointmentTime = rs.getTime("AppointmentTime");
        if (appointmentTime != null) appointment.setAppointmentTime(appointmentTime.toLocalTime());
        
        appointment.setStatus(rs.getString("Status"));
        appointment.setPaymentStatus(rs.getString("PaymentStatus"));
        appointment.setPaymentAmount(rs.getBigDecimal("PaymentAmount"));
        appointment.setNotes(rs.getString("Notes"));
        
        int confirmedBy = rs.getInt("ConfirmedBy");
        if (!rs.wasNull()) appointment.setConfirmedBy(confirmedBy);
        
        Timestamp confirmedAt = rs.getTimestamp("ConfirmedAt");
        if (confirmedAt != null) appointment.setConfirmedAt(confirmedAt.toLocalDateTime());
        
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) appointment.setCreatedAt(createdAt.toLocalDateTime());
        
        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) appointment.setUpdatedAt(updatedAt.toLocalDateTime());
        
        return appointment;
    }
    public List<Appointment> getAll() {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM Appointments ORDER BY AppointmentDate DESC, AppointmentTime DESC";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                appointments.add(extractAppointmentFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }   
    
    public void updateNotes(int appointmentId, String notes) {
        String sql = "UPDATE Appointments SET Notes = ?, UpdatedAt = GETDATE() WHERE AppointmentID = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, notes);
            stmt.setInt(2, appointmentId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    
}
