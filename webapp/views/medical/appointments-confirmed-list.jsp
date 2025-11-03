<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách lịch hẹn - Y Tế</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .filter-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }
        .filter-tab {
            padding: 0.8rem 1.5rem;
            border-radius: 12px;
            border: 2px solid #e2e8f0;
            background: white;
            color: #64748b;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .filter-tab:hover {
            border-color: #3b82f6;
            transform: translateY(-2px);
        }
        .filter-tab.active {
            background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
            border-color: transparent;
            color: white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
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

<!-- MAIN DASHBOARD LAYOUT -->
<div class="dashboard-container">
    <div class="dashboard-row">
        <!-- SIDEBAR MENU -->
        <aside class="sidebar slide-in-left">
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
            <div class="page-header fade-in-up">
                <div>
                    <h1 class="page-title">Danh sách lịch hẹn</h1>
                    <p class="page-subtitle">Quản lý các lịch hẹn tiêm chủng đã xác nhận</p>
                </div>
            </div>

            <!-- SUCCESS/ERROR MESSAGES -->
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill"></i>
                    <strong>Thành công!</strong> ${sessionScope.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <strong>Lỗi!</strong> ${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <!-- FILTER TABS -->
            <div class="filter-tabs fade-in-up">
                <button class="filter-tab active" onclick="filterAppointments('ALL')">
                    <i class="bi bi-list-ul"></i> Tất cả
                </button>
                <button class="filter-tab" onclick="filterAppointments('CONFIRMED')">
                    <i class="bi bi-check-circle"></i> Đã xác nhận
                </button>
                <button class="filter-tab" onclick="filterAppointments('COMPLETED')">
                    <i class="bi bi-check-all"></i> Hoàn thành
                </button>
            </div>

            <!-- APPOINTMENTS LIST -->
            <c:choose>
                <c:when test="${empty appointments}">
                    <div class="content-card fade-in-up">
                        <div class="content-card-body">
                            <div class="empty-state">
                                <div class="empty-state-icon">
                                    <i class="bi bi-calendar-x"></i>
                                </div>
                                <h3 class="empty-state-title">Chưa có lịch hẹn</h3>
                                <p class="empty-state-text">Hiện tại chưa có lịch hẹn nào cần xử lý.</p>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="content-card fade-in-up">
                        <div class="content-card-body">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th><i class="bi bi-hash"></i> ID</th>
                                        <th><i class="bi bi-person"></i> Trẻ</th>
                                        <th><i class="bi bi-shield-check"></i> Vaccine</th>
                                        <th><i class="bi bi-hospital"></i> Trung tâm</th>
                                        <th><i class="bi bi-calendar"></i> Ngày</th>
                                        <th><i class="bi bi-clock"></i> Giờ</th>
                                        <th><i class="bi bi-info-circle"></i> Trạng thái</th>
                                        <th><i class="bi bi-gear"></i> Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${appointments}" var="appointment">
                                        <tr class="appointment-row" data-status="${appointment.status}">
                                            <td><strong>#${appointment.appointmentId}</strong></td>
                                            <td>${appointment.child.fullName}</td>
                                            <td>${appointment.vaccine.vaccineName}</td>
                                            <td>${appointment.center.centerName}</td>
                                            <td>${appointment.appointmentDate}</td>
                                            <td>${appointment.appointmentTime}</td>
                                            <td>
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
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/medical/appointments/${appointment.appointmentId}"
                                                   class="btn btn-sm btn-primary">
                                                    <i class="bi bi-eye-fill"></i> Xem
                                                </a>
                                                <c:if test="${appointment.status == 'CONFIRMED'}">
                                                    <a href="${pageContext.request.contextPath}/medical/vaccination-record/datetime?appointmentId=${appointment.appointmentId}"
                                                       class="btn btn-sm btn-success ms-1">
                                                        <i class="bi bi-syringe"></i> Tiêm
                                                    </a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function filterAppointments(status) {
        const tabs = document.querySelectorAll('.filter-tab');
        const rows = document.querySelectorAll('.appointment-row');

        tabs.forEach(tab => tab.classList.remove('active'));
        event.target.closest('.filter-tab').classList.add('active');

        rows.forEach(row => {
            if (status === 'ALL' || row.dataset.status === status) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>