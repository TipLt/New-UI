package com.vaccination.model;

import java.time.LocalDateTime;

public class VaccinationScheduleTemplate {
    private int templateId;
    private int vaccineId;
    private String stageName;
    private double ageInMonths;
    private int doseNumber;
    private String description;
    private boolean isMandatory;
    private int displayOrder;
    private LocalDateTime createdAt;
    
    private Vaccine vaccine;

    public VaccinationScheduleTemplate() {
    }

    public VaccinationScheduleTemplate(int templateId, int vaccineId, String stageName, double ageInMonths, 
                                      int doseNumber, String description, boolean isMandatory, int displayOrder) {
        this.templateId = templateId;
        this.vaccineId = vaccineId;
        this.stageName = stageName;
        this.ageInMonths = ageInMonths;
        this.doseNumber = doseNumber;
        this.description = description;
        this.isMandatory = isMandatory;
        this.displayOrder = displayOrder;
    }

    public int getTemplateId() {
        return templateId;
    }

    public void setTemplateId(int templateId) {
        this.templateId = templateId;
    }

    public int getVaccineId() {
        return vaccineId;
    }

    public void setVaccineId(int vaccineId) {
        this.vaccineId = vaccineId;
    }

    public String getStageName() {
        return stageName;
    }

    public void setStageName(String stageName) {
        this.stageName = stageName;
    }

    public double getAgeInMonths() {
        return ageInMonths;
    }

    public void setAgeInMonths(double ageInMonths) {
        this.ageInMonths = ageInMonths;
    }

    public int getDoseNumber() {
        return doseNumber;
    }

    public void setDoseNumber(int doseNumber) {
        this.doseNumber = doseNumber;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isMandatory() {
        return isMandatory;
    }

    public void setMandatory(boolean mandatory) {
        isMandatory = mandatory;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Vaccine getVaccine() {
        return vaccine;
    }

    public void setVaccine(Vaccine vaccine) {
        this.vaccine = vaccine;
    }

    @Override
    public String toString() {
        return "VaccinationScheduleTemplate{" +
                "templateId=" + templateId +
                ", stageName='" + stageName + '\'' +
                ", ageInMonths=" + ageInMonths +
                ", doseNumber=" + doseNumber +
                '}';
    }
}
