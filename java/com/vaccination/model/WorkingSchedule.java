package com.vaccination.model;

import java.time.LocalTime;

public class WorkingSchedule {
    private int scheduleId;
    private int centerId;
    private String dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;
    private int slotDuration;
    private boolean isActive;

    public WorkingSchedule() {
    }

    public WorkingSchedule(int centerId, String dayOfWeek, LocalTime startTime, LocalTime endTime, int slotDuration) {
        this.centerId = centerId;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
        this.slotDuration = slotDuration;
        this.isActive = true;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getCenterId() {
        return centerId;
    }

    public void setCenterId(int centerId) {
        this.centerId = centerId;
    }

    public String getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(String dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public int getSlotDuration() {
        return slotDuration;
    }

    public void setSlotDuration(int slotDuration) {
        this.slotDuration = slotDuration;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "WorkingSchedule{" +
                "scheduleId=" + scheduleId +
                ", centerId=" + centerId +
                ", dayOfWeek='" + dayOfWeek + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", slotDuration=" + slotDuration +
                '}';
    }
}
