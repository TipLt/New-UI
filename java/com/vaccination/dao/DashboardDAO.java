/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.vaccination.dao;

import com.vaccination.util.DatabaseConnection;
import java.sql.*;
import java.util.*;

public class DashboardDAO {
    
    /**
     * Get count of users grouped by role
     * @return Map<Role, Count>
     */
    public Map<String, Integer> getUsersByRole() throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT Role, COUNT(*) AS Count FROM Users WHERE Role != 'GUEST' GROUP BY Role";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                stats.put(rs.getString("Role"), rs.getInt("Count"));
            }
        }
        return stats;
    }

    /**
     * Get number of new users registered this month
     * @return count of new users
     */
    public int getNewUsersThisMonth() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users " +
                     "WHERE MONTH(CreatedAt) = MONTH(GETDATE()) " +
                     "AND YEAR(CreatedAt) = YEAR(GETDATE())";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /**
     * Get count of active vs inactive users
     * @return Map<"Active"/"Inactive", Count>
     */
    public Map<String, Integer> getActiveInactive() throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT IsActive, COUNT(*) AS Count FROM Users " +
                     "WHERE Role != 'GUEST' GROUP BY IsActive";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                String key = rs.getBoolean("IsActive") ? "Active" : "Inactive";
                stats.put(key, rs.getInt("Count"));
            }
        }
        return stats;
    }

    /**
     * Get recent user logins
     * @param limit number of records to return
     * @return List of recent logins with UserID, FullName, LastLogin
     */
    public List<Map<String, Object>> getRecentLogins(int limit) throws SQLException {
        List<Map<String, Object>> logins = new ArrayList<>();
        String sql = "SELECT UserID, FullName, LastLogin FROM Users " +
                     "WHERE LastLogin IS NOT NULL AND Role != 'GUEST' " +
                     "ORDER BY LastLogin DESC " +
                     "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> login = new HashMap<>();
                login.put("UserID", rs.getInt("UserID"));
                login.put("FullName", rs.getString("FullName"));
                login.put("LastLogin", rs.getTimestamp("LastLogin"));
                logins.add(login);
            }
        }
        return logins;
    }
    
    /**
     * Get total number of children in system
     */
    public int getTotalChildren() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Children WHERE IsActive = 1";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    /**
     * Get total number of appointments
     */
    public int getTotalAppointments() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Appointments";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    /**
     * Get total number of vaccination records
     */
    public int getTotalVaccinations() throws SQLException {
        String sql = "SELECT COUNT(*) FROM VaccinationRecords";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    /**
     * Get appointment statistics by status
     */
    public Map<String, Integer> getAppointmentsByStatus() throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT Status, COUNT(*) AS Count FROM Appointments GROUP BY Status";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                stats.put(rs.getString("Status"), rs.getInt("Count"));
            }
        }
        return stats;
    }
}