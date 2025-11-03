package com.vaccination.dao;

import com.vaccination.model.Child;
import com.vaccination.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChildDAO {
    
    public Child findById(int childId) {
        String sql = "SELECT * FROM Children WHERE ChildID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, childId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractChildFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Child> findByParentId(int parentId) {
        List<Child> children = new ArrayList<>();
        String sql = "SELECT * FROM Children WHERE ParentID = ? AND IsActive = 1 ORDER BY DateOfBirth DESC";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, parentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                children.add(extractChildFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return children;
    }

    public boolean createChild(Child child) {
        String sql = "INSERT INTO Children (ParentID, FullName, DateOfBirth, Gender, BloodType, " +
                     "MedicalHistory, Allergies, Weight, Height, IsActive) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, child.getParentId());
            stmt.setString(2, child.getFullName());
            stmt.setDate(3, Date.valueOf(child.getDateOfBirth()));
            stmt.setString(4, child.getGender());
            stmt.setString(5, child.getBloodType());
            stmt.setString(6, child.getMedicalHistory());
            stmt.setString(7, child.getAllergies());
            
            if (child.getWeight() != null) {
                stmt.setBigDecimal(8, child.getWeight());
            } else {
                stmt.setNull(8, Types.DECIMAL);
            }
            
            if (child.getHeight() != null) {
                stmt.setBigDecimal(9, child.getHeight());
            } else {
                stmt.setNull(9, Types.DECIMAL);
            }
            
            stmt.setBoolean(10, child.isActive());
            
            int affected = stmt.executeUpdate();
            
            if (affected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    child.setChildId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateChild(Child child) {
        String sql = "UPDATE Children SET FullName = ?, DateOfBirth = ?, Gender = ?, BloodType = ?, " +
                     "MedicalHistory = ?, Allergies = ?, Weight = ?, Height = ?, UpdatedAt = GETDATE() " +
                     "WHERE ChildID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, child.getFullName());
            stmt.setDate(2, Date.valueOf(child.getDateOfBirth()));
            stmt.setString(3, child.getGender());
            stmt.setString(4, child.getBloodType());
            stmt.setString(5, child.getMedicalHistory());
            stmt.setString(6, child.getAllergies());
            
            if (child.getWeight() != null) {
                stmt.setBigDecimal(7, child.getWeight());
            } else {
                stmt.setNull(7, Types.DECIMAL);
            }
            
            if (child.getHeight() != null) {
                stmt.setBigDecimal(8, child.getHeight());
            } else {
                stmt.setNull(8, Types.DECIMAL);
            }
            
            stmt.setInt(9, child.getChildId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteChild(int childId) {
        String sql = "UPDATE Children SET IsActive = 0, UpdatedAt = GETDATE() WHERE ChildID = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, childId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Child extractChildFromResultSet(ResultSet rs) throws SQLException {
        Child child = new Child();
        child.setChildId(rs.getInt("ChildID"));
        child.setParentId(rs.getInt("ParentID"));
        child.setFullName(rs.getString("FullName"));
        
        Date dob = rs.getDate("DateOfBirth");
        if (dob != null) child.setDateOfBirth(dob.toLocalDate());
        
        child.setGender(rs.getString("Gender"));
        child.setBloodType(rs.getString("BloodType"));
        child.setMedicalHistory(rs.getString("MedicalHistory"));
        child.setAllergies(rs.getString("Allergies"));
        child.setWeight(rs.getBigDecimal("Weight"));
        child.setHeight(rs.getBigDecimal("Height"));
        child.setActive(rs.getBoolean("IsActive"));
        
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) child.setCreatedAt(createdAt.toLocalDateTime());
        
        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) child.setUpdatedAt(updatedAt.toLocalDateTime());
        
        return child;
    }
}
