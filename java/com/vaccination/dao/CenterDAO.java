package com.vaccination.dao;

import com.vaccination.model.Center;
import com.vaccination.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CenterDAO {
    
    public Center findById(int centerId) {
        String sql = "SELECT * FROM Centers WHERE CenterID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, centerId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractCenterFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Center> getAllCenters() {
        List<Center> centers = new ArrayList<>();
        String sql = "SELECT * FROM Centers WHERE IsActive = 1 ORDER BY CenterName";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                centers.add(extractCenterFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return centers;
    }

    public List<Center> findByCity(String city) {
        List<Center> centers = new ArrayList<>();
        String sql = "SELECT * FROM Centers WHERE City = ? AND IsActive = 1 ORDER BY CenterName";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, city);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                centers.add(extractCenterFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return centers;
    }

    public boolean createCenter(Center center) {
        String sql = "INSERT INTO Centers (CenterName, Address, City, PhoneNumber, Email, " +
                     "IsActive, OperatingHours, Capacity) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, center.getCenterName());
            stmt.setString(2, center.getAddress());
            stmt.setString(3, center.getCity());
            stmt.setString(4, center.getPhoneNumber());
            stmt.setString(5, center.getEmail());
            stmt.setBoolean(6, center.isActive());
            stmt.setString(7, center.getOperatingHours());
            stmt.setInt(8, center.getCapacity());
            
            int affected = stmt.executeUpdate();
            
            if (affected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    center.setCenterId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCenter(Center center) {
        String sql = "UPDATE Centers SET CenterName = ?, Address = ?, City = ?, PhoneNumber = ?, " +
                     "Email = ?, OperatingHours = ?, Capacity = ? WHERE CenterID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, center.getCenterName());
            stmt.setString(2, center.getAddress());
            stmt.setString(3, center.getCity());
            stmt.setString(4, center.getPhoneNumber());
            stmt.setString(5, center.getEmail());
            stmt.setString(6, center.getOperatingHours());
            stmt.setInt(7, center.getCapacity());
            stmt.setInt(8, center.getCenterId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCenter(int centerId) {
        String sql = "UPDATE Centers SET IsActive = 0 WHERE CenterID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, centerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Center extractCenterFromResultSet(ResultSet rs) throws SQLException {
        Center center = new Center();
        center.setCenterId(rs.getInt("CenterID"));
        center.setCenterName(rs.getString("CenterName"));
        center.setAddress(rs.getString("Address"));
        center.setCity(rs.getString("City"));
        center.setPhoneNumber(rs.getString("PhoneNumber"));
        center.setEmail(rs.getString("Email"));
        center.setActive(rs.getBoolean("IsActive"));
        center.setOperatingHours(rs.getString("OperatingHours"));
        center.setCapacity(rs.getInt("Capacity"));
        
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) center.setCreatedAt(createdAt.toLocalDateTime());
        
        return center;
    }
}
