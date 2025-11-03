<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết lịch hẹn - Y Tế</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .info-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .info-label {
            font-weight: 600;
            color: #64748b;
            font-size: 0.85rem;
            margin-bottom: 0.3rem;
        }
        .info-value {
            font-size: 1rem;
            color: #1e293b;
            margin-bottom: 1rem;
        }
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .status-CONFIRMED {
            background: linear-gradient(135deg, rgba(72, 199, 116, 0.2) 0%, rgba(92, 200, 190, 0.2) 100%);
            color: #48C774;
        }
        .status-COMPLETED {
            background: linear-gradient(135deg, rgba(58, 191, 248, 0.2) 0%, rgba(74, 144, 226, 0.2) 100%);
            color: #3ABFF8;
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

<div class="dashboard-container">
    <div class="dashboard-row">
        <!-- SIDEBAR -->
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/medical/dashboard" class="sidebar-menu-link">
                        <i class="bi bi-speedometer2"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/medical/appointments/" class="sidebar-menu-link active">
                        <i class="bi bi-calendar-check"></i>
                        <span>Danh sách lịch hẹn</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/medical/vaccination-record/" class="sidebar-menu-link">
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
            <!-- PAGE HEADER -->
            <div class="page-header">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h1 class="page-title">Chi tiết lịch hẹn #${appointment.appointmentId}</h1>
                        <p class="page-subtitle">Thông tin chi tiết về lịch hẹn tiêm chủng</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/medical/appointments/" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>

            <!-- APPOINTMENT STATUS -->
            <div class="info-card">
                <div class="info-label">Trạng thái</div>
                <span class="status-badge status-${appointment.status}">
                        <c:choose>
                            <c:when test="${appointment.status == 'CONFIRMED'}">
                                <i class="bi bi-check-circle-fill"></i> Đã xác nhận
                            </c:when>
                            <c:when test="${appointment.status == 'COMPLETED'}">
                                <i class="bi bi-check-all"></i> Hoàn thành
                            </c:when>
                        </c:choose>
                    </span>
            </div>

            <div class="row">
                <!-- CHILD INFORMATION -->
                <div class="col-md-6">
                    <div class="info-card">
                        <h5 style="color: #3b82f6; margin-bottom: 1.5rem;">
                            <i class="bi bi-person-fill"></i> Thông tin trẻ
                        </h5>
                        <div class="info-label">Họ và tên</div>
                        <div class="info-value"><strong>${appointment.child.fullName}</strong></div>

                        <div class="info-label">Ngày sinh</div>
                        <div class="info-value">
                            ${appointment.child.dateOfBirth}
                        </div>

                        <div class="info-label">Giới tính</div>
                        <div class="info-value">${appointment.child.gender}</div>

                        <c:if test="${not empty appointment.child.bloodType}">
                            <div class="info-label">Nhóm máu</div>
                            <div class="info-value">${appointment.child.bloodType}</div>
                        </c:if>

                        <c:if test="${not empty appointment.child.allergies}">
                            <div class="info-label">Dị ứng</div>
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle-fill"></i>
                                    ${appointment.child.allergies}
                            </div>
                        </c:if>

                        <c:if test="${not empty appointment.child.medicalHistory}">
                            <div class="info-label">Tiền sử bệnh</div>
                            <div class="info-value">${appointment.child.medicalHistory}</div>
                        </c:if>
                    </div>
                </div>

                <!-- APPOINTMENT INFORMATION -->
                <div class="col-md-6">
                    <div class="info-card">
                        <h5 style="color: #10b981; margin-bottom: 1.5rem;">
                            <i class="bi bi-calendar-check"></i> Thông tin lịch hẹn
                        </h5>
                        <div class="info-label">Ngày hẹn</div>
                        <div class="info-value">
                            <i class="bi bi-calendar3"></i>
                            ${appointment.appointmentDate}
                        </div>

                        <div class="info-label">Giờ hẹn</div>
                        <div class="info-value">
                            <i class="bi bi-clock"></i>
                            ${appointment.appointmentTime}
                        </div>

                        <c:if test="${not empty appointment.center}">
                            <div class="info-label">Trung tâm</div>
                            <div class="info-value">
                                <i class="bi bi-hospital"></i>
                                    ${appointment.center.centerName}
                            </div>

                            <div class="info-label">Địa chỉ</div>
                            <div class="info-value">${appointment.center.address}</div>
                        </c:if>

                        <c:if test="${not empty appointment.notes}">
                            <div class="info-label">Ghi chú</div>
                            <div class="alert alert-info">
                                <i class="bi bi-info-circle"></i>
                                    ${appointment.notes}
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- VACCINE INFORMATION -->
            <div class="info-card">
                <h5 style="color: #8b5cf6; margin-bottom: 1.5rem;">
                    <i class="bi bi-shield-check"></i> Thông tin vaccine
                </h5>
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-label">Tên vaccine</div>
                        <div class="info-value"><strong>${appointment.vaccine.vaccineName}</strong></div>

                        <div class="info-label">Nhà sản xuất</div>
                        <div class="info-value">${appointment.vaccine.manufacturer}</div>

                        <div class="info-label">Phòng ngừa</div>
                        <div class="info-value">${appointment.vaccine.diseasesPrevented}</div>
                    </div>

                    <div class="col-md-6">
                        <div class="info-label">Độ tuổi khuyến nghị</div>
                        <div class="info-value">
                            <c:out value="${appointment.vaccine.recommendedAge}" default="N/A"/>
                        </div>

                        <div class="info-label">Giá</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${empty appointment.vaccine}">
                                    <span class="text-muted">Không có thông tin</span>
                                </c:when>
                                <c:when test="${appointment.vaccine.price == 0}">
                                    <span class="badge bg-success">Miễn phí</span>
                                </c:when>
                                <c:otherwise>
                                        <span class="text-primary fw-bold">
                                            <c:out value="${appointment.vaccine.price}"/> VND
                                        </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-label">Trạng thái thanh toán</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${appointment.paymentStatus == 'PAID'}">
                                        <span class="badge bg-success">
                                            <i class="bi bi-check-circle-fill"></i> Đã thanh toán
                                        </span>
                                </c:when>
                                <c:when test="${appointment.paymentStatus == 'FREE'}">
                                        <span class="badge bg-info">
                                            <i class="bi bi-gift-fill"></i> Miễn phí
                                        </span>
                                </c:when>
                                <c:otherwise>
                                        <span class="badge bg-warning">
                                            <i class="bi bi-clock-fill"></i> Chưa thanh toán
                                        </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ACTION BUTTONS -->
            <c:if test="${appointment.status == 'CONFIRMED'}">
                <div class="info-card">
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button type="button" class="btn btn-primary btn-lg" onclick="performVaccination()">
                            <i class="bi bi-syringe"></i> Thực hiện tiêm chủng
                        </button>
                    </div>
                </div>
            </c:if>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function performVaccination() {
        if (confirm('Bạn có chắc chắn muốn thực hiện tiêm chủng cho lịch hẹn này?')) {
            window.location.href = '${pageContext.request.contextPath}/medical/vaccinations/perform?id=${appointment.appointmentId}';
        }
    }
</script>
</body>
</html>