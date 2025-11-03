package com.vaccination.dao;

import com.vaccination.model.Vaccine;
import com.vaccination.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VaccineDAO {

    public Vaccine findById(int vaccineId) {
        String sql = "SELECT * FROM Vaccines WHERE VaccineID = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vaccineId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractVaccineFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Vaccine> getAllVaccines() {
        List<Vaccine> vaccines = new ArrayList<>();
        String sql = "SELECT * FROM Vaccines WHERE IsActive = 1 ORDER BY VaccineName";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                vaccines.add(extractVaccineFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vaccines;
    }

    public List<Vaccine> getPaidVaccines() {
        List<Vaccine> vaccines = new ArrayList<>();
        String sql = "SELECT * FROM Vaccines WHERE IsActive = 1 AND IsFree = 0 ORDER BY VaccineName";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                vaccines.add(extractVaccineFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vaccines;
    }

    public List<Vaccine> getFreeVaccines() {
        List<Vaccine> vaccines = new ArrayList<>();
        String sql = "SELECT * FROM Vaccines WHERE IsActive = 1 AND IsFree = 1 ORDER BY VaccineName";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                vaccines.add(extractVaccineFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vaccines;
    }

    public List<Vaccine> searchVaccines(String keyword) {
        List<Vaccine> vaccines = new ArrayList<>();
        String sql = "SELECT * FROM Vaccines WHERE IsActive = 1 AND " +
                     "(VaccineName LIKE ? OR DiseasesPrevented LIKE ?) " +
                     "ORDER BY VaccineName";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                vaccines.add(extractVaccineFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vaccines;
    }

    public boolean createVaccine(Vaccine vaccine) {
        // Cần cập nhật câu SQL để thêm cột ImageUrl
        String sql = "INSERT INTO Vaccines (VaccineName, Manufacturer, Description, DiseasesPrevented, " +
                     "DosageSchedule, RecommendedAge, Price, IsFree, IsActive, SideEffects, Contraindications, ImageUrl) " + // Thêm ImageUrl
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"; // Thêm ?
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, vaccine.getVaccineName());
            stmt.setString(2, vaccine.getManufacturer());
            stmt.setString(3, vaccine.getDescription());
            stmt.setString(4, vaccine.getDiseasesPrevented());
            stmt.setString(5, vaccine.getDosageSchedule());
            stmt.setString(6, vaccine.getRecommendedAge());
            stmt.setBigDecimal(7, vaccine.getPrice());
            stmt.setBoolean(8, vaccine.isFree()); // Sửa chỉ số tham số
            stmt.setBoolean(9, vaccine.isActive()); // Sửa chỉ số tham số
            stmt.setString(10, vaccine.getSideEffects()); // Sửa chỉ số tham số
            stmt.setString(11, vaccine.getContraindications()); // Sửa chỉ số tham số
            stmt.setString(12, vaccine.getImageUrl()); // Thêm ImageUrl

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    vaccine.setVaccineId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateVaccine(Vaccine vaccine) {
        // Cần cập nhật câu SQL để sửa ImageUrl
        String sql = "UPDATE Vaccines SET VaccineName = ?, Manufacturer = ?, Description = ?, " +
                     "DiseasesPrevented = ?, DosageSchedule = ?, RecommendedAge = ?, Price = ?, IsFree = ?, " + // Thêm IsFree = ?
                     "SideEffects = ?, Contraindications = ?, ImageUrl = ? WHERE VaccineID = ?"; // Thêm ImageUrl = ?
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, vaccine.getVaccineName());
            stmt.setString(2, vaccine.getManufacturer());
            stmt.setString(3, vaccine.getDescription());
            stmt.setString(4, vaccine.getDiseasesPrevented());
            stmt.setString(5, vaccine.getDosageSchedule());
            stmt.setString(6, vaccine.getRecommendedAge());
            stmt.setBigDecimal(7, vaccine.getPrice());
            stmt.setBoolean(8, vaccine.isFree()); // Thêm IsFree
            stmt.setString(9, vaccine.getSideEffects()); // Sửa chỉ số tham số
            stmt.setString(10, vaccine.getContraindications()); // Sửa chỉ số tham số
            stmt.setString(11, vaccine.getImageUrl()); // Thêm ImageUrl
            stmt.setInt(12, vaccine.getVaccineId()); // Sửa chỉ số tham số

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

     public boolean deleteVaccine(int vaccineId) {
        // Nên dùng UPDATE IsActive = 0 thay vì DELETE thật
        String sql = "UPDATE Vaccines SET IsActive = 0 WHERE VaccineID = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vaccineId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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
        vaccine.setFree(rs.getBoolean("IsFree")); // Đọc cả IsFree
        vaccine.setActive(rs.getBoolean("IsActive"));
        vaccine.setSideEffects(rs.getString("SideEffects"));
        vaccine.setContraindications(rs.getString("Contraindications"));

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) vaccine.setCreatedAt(createdAt.toLocalDateTime());

        vaccine.setImageUrl(rs.getString("ImageUrl")); // <<<===== THÊM DÒNG NÀY

        return vaccine;
    }
    
    public boolean deactivateVaccine(int vaccineId) {
        String sql = "UPDATE Vaccines SET IsActive = 0 WHERE VaccineID = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vaccineId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}