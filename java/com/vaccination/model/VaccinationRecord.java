package com.vaccination.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class VaccinationRecord {
    private int recordId;
    private int appointmentId;
    private int childId;
    private int vaccineId;
    private LocalDateTime vaccinationDate;
    private String batchNumber;
    private Integer doseNumber;
    private int administeredBy;
    private String healthCheckNotes;
    private String vaccinationNotes;
    private String sideEffectsReported;
    private LocalDate nextDoseDate;
    private LocalDateTime createdAt;

    private Child child;
    private Vaccine vaccine;
    private User staff;

    public VaccinationRecord() {
    }

    public VaccinationRecord(int appointmentId, int childId, int vaccineId, int administeredBy) {
        this.appointmentId = appointmentId;
        this.childId = childId;
        this.vaccineId = vaccineId;
        this.administeredBy = administeredBy;
        this.vaccinationDate = LocalDateTime.now();
    }

    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getChildId() {
        return childId;
    }

    public void setChildId(int childId) {
        this.childId = childId;
    }

    public int getVaccineId() {
        return vaccineId;
    }

    public void setVaccineId(int vaccineId) {
        this.vaccineId = vaccineId;
    }

    public LocalDateTime getVaccinationDate() {
        return vaccinationDate;
    }

    public void setVaccinationDate(LocalDateTime vaccinationDate) {
        this.vaccinationDate = vaccinationDate;
    }

    public String getBatchNumber() {
        return batchNumber;
    }

    public void setBatchNumber(String batchNumber) {
        this.batchNumber = batchNumber;
    }

    public Integer getDoseNumber() {
        return doseNumber;
    }

    public void setDoseNumber(Integer doseNumber) {
        this.doseNumber = doseNumber;
    }

    public int getAdministeredBy() {
        return administeredBy;
    }

    public void setAdministeredBy(int administeredBy) {
        this.administeredBy = administeredBy;
    }

    public String getHealthCheckNotes() {
        return healthCheckNotes;
    }

    public void setHealthCheckNotes(String healthCheckNotes) {
        this.healthCheckNotes = healthCheckNotes;
    }

    public String getVaccinationNotes() {
        return vaccinationNotes;
    }

    public void setVaccinationNotes(String vaccinationNotes) {
        this.vaccinationNotes = vaccinationNotes;
    }

    public String getSideEffectsReported() {
        return sideEffectsReported;
    }

    public void setSideEffectsReported(String sideEffectsReported) {
        this.sideEffectsReported = sideEffectsReported;
    }

    public LocalDate getNextDoseDate() {
        return nextDoseDate;
    }

    public void setNextDoseDate(LocalDate nextDoseDate) {
        this.nextDoseDate = nextDoseDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Child getChild() {
        return child;
    }

    public void setChild(Child child) {
        this.child = child;
    }

    public Vaccine getVaccine() {
        return vaccine;
    }

    public void setVaccine(Vaccine vaccine) {
        this.vaccine = vaccine;
    }

    public User getStaff() {
        return staff;
    }

    public void setStaff(User staff) {
        this.staff = staff;
    }

    @Override
    public String toString() {
        return "VaccinationRecord{" +
                "recordId=" + recordId +
                ", childId=" + childId +
                ", vaccineId=" + vaccineId +
                ", vaccinationDate=" + vaccinationDate +
                '}';
    }
}
