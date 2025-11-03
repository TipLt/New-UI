<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ghi nhận thời điểm tiêm - Y Tế</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 15px;
            margin-bottom: 2rem;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
<!-- NAVBAR -->
<nav class="dashboard-navbar">
    <div class="dashboard-container">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <a href="${pageContext.request.contextPath}/medical/dashboard" class="navbar-brand-custom">
                <i class="bi bi-heart-pulse-fill"></i>
                <span>Vaccine For Kids - Medical</span>
            </a>
            <div style="display: flex; align-items: center;">
                <div class="navbar-user-info">
                    <i class="bi bi-person-circle"></i>
                    <span>${sessionScope.userName}</span>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                    <i class="bi bi-box-arrow-right"></i>
                    Đăng xuất
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- MAIN CONTENT -->
<div class="dashboard-container">
    <div class="dashboard-row">
        <!-- SIDEBAR -->
        <aside class="sidebar slide-in-left">
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/medical/dashboard" class="sidebar-menu-link">
                        <i class="bi bi-speedometer2"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/medical/appointments/" class="sidebar-menu-link">
                        <i class="bi bi-calendar-check"></i>
                        <span>Danh sách lịch hẹn</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/medical/vaccination-record/" class="sidebar-menu-link active">
                        <i class="bi bi-syringe"></i>
                        <span>Ghi nhận tiêm chủng</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/medical/vaccinations" class="sidebar-menu-link">
                        <i class="bi bi-syringe"></i>
                        <span>Quản lý Vắc xin</span>
                    </a>
                </li>
            </ul>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="dashboard-main">
            <div class="page-header fade-in-up">
                <div>
                    <h1 class="page-title">
                        <i class="bi bi-1-circle-fill"></i> Bước 1: Ghi nhận thời điểm tiêm
                    </h1>
                    <p class="page-subtitle">Nhập thông tin thời điểm tiêm và người thực hiện</p>
                </div>
            </div>

            <!-- APPOINTMENT INFO CARD -->
            <div class="info-card fade-in-up">
                <h5><i class="bi bi-info-circle"></i> Thông tin lịch hẹn</h5>
                <div class="info-row">
                    <span><i class="bi bi-person"></i> Trẻ:</span>
                    <strong>${appointment.child.fullName}</strong>
                </div>
                <div class="info-row">
                    <span><i class="bi bi-calendar3"></i> Ngày sinh:</span>
                    <strong>${appointment.child.dateOfBirth}</strong>
                </div>
                <div class="info-row">
                    <span><i class="bi bi-shield-check"></i> Vắc xin:</span>
                    <strong>${appointment.vaccine.vaccineName}</strong>
                </div>
                <c:if test="${not empty appointment.center}">
                    <div class="info-row">
                        <span><i class="bi bi-hospital"></i> Trung tâm:</span>
                        <strong>${appointment.center.centerName}</strong>
                    </div>
                </c:if>
            </div>

            <!-- FORM -->
            <div class="content-card fade-in-up">
                <div class="content-card-body">
                    <form method="POST" action="${pageContext.request.contextPath}/medical/vaccination-record/save-datetime" id="datetimeForm">
                        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                        <input type="hidden" name="childId" value="${appointment.childId}">
                        <input type="hidden" name="vaccineId" value="${appointment.vaccineId}">

                        <!-- Vaccination Date/Time -->
                        <div class="mb-4">
                            <label for="vaccinationDateTime" class="form-label">
                                <i class="bi bi-calendar-event"></i> Thời điểm tiêm <span class="text-danger">*</span>
                            </label>
                            <input type="datetime-local"
                                   class="form-control"
                                   id="vaccinationDateTime"
                                   name="vaccinationDateTime"
                                   required>
                            <small class="form-text text-muted">Mặc định là thời điểm hiện tại. Có thể điều chỉnh nếu cần.</small>
                        </div>

                        <!-- Administered By -->
                        <div class="mb-4">
                            <label for="administeredBy" class="form-label">
                                <i class="bi bi-person-badge"></i> Người thực hiện tiêm <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="administeredBy" name="administeredBy" required>
                                <option value="">-- Chọn nhân viên y tế --</option>
                                <c:forEach items="${medicalStaff}" var="staff">
                                    <option value="${staff.userId}">${staff.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Room/Station -->
                        <div class="mb-4">
                            <label for="room" class="form-label">
                                <i class="bi bi-door-open"></i> Phòng/Bàn tiêm
                            </label>
                            <input type="text"
                                   class="form-control"
                                   id="room"
                                   name="room"
                                   placeholder="VD: Phòng 3 - Bàn 2">
                        </div>

                        <!-- Batch Number -->
                        <div class="mb-4">
                            <label for="batchNumber" class="form-label">
                                <i class="bi bi-box-seam"></i> Số lô (Batch Number)
                            </label>
                            <input type="text"
                                   class="form-control"
                                   id="batchNumber"
                                   name="batchNumber"
                                   placeholder="VD: LOT-A1">
                        </div>

                        <!-- Dose Number -->
                        <div class="mb-4">
                            <label for="doseNumber" class="form-label">
                                <i class="bi bi-123"></i> Liều thứ (Dose Number)
                            </label>
                            <input type="number"
                                   class="form-control"
                                   id="doseNumber"
                                   name="doseNumber"
                                   min="1"
                                   placeholder="VD: 1, 2, 3...">
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/medical/vaccination-record/"
                               class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Quay lại
                            </a>
                            <button type="submit" class="btn btn-primary">
                                Tiếp theo <i class="bi bi-arrow-right"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Set default datetime to now
    document.addEventListener('DOMContentLoaded', function() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');

        const datetimeStr = `${year}-${month}-${day}T${hours}:${minutes}`;
        document.getElementById('vaccinationDateTime').value = datetimeStr;
    });
</script>
</body>
</html>
