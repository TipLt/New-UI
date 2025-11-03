<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ tiêm chủng - ${child.fullName}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .child-header {
            background: var(--gradient-hero);
            color: white;
            padding: 2.5rem;
            border-radius: var(--border-radius-lg);
            margin-bottom: 2rem;
            box-shadow: var(--shadow-lg);
        }
        .child-info-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: var(--border-radius-md);
            display: inline-block;
            margin-right: 1rem;
            margin-bottom: 0.5rem;
            backdrop-filter: blur(10px);
        }
        .timeline {
            position: relative;
            padding-left: 3rem;
        }
        .timeline::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
            background: var(--gradient-hero);
        }
        .timeline-item {
            position: relative;
            padding-bottom: 3rem;
            animation: fadeInUp 0.6s ease;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -3.45rem;
            top: 0;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: var(--gradient-hero);
            border: 4px solid white;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.3);
            z-index: 1;
        }
        .record-card {
            border: 2px solid var(--bg-section);
            border-radius: var(--border-radius-lg);
            padding: 1.5rem;
            background: white;
            transition: var(--transition-smooth);
        }
        .record-card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateX(10px);
            border-color: var(--primary-light);
        }
        .next-dose-badge {
            background: linear-gradient(135deg, rgba(255, 184, 77, 0.2) 0%, rgba(255, 107, 157, 0.1) 100%);
            color: var(--warning-color);
            padding: 1rem 1.5rem;
            border-radius: var(--border-radius-md);
            border: 2px solid rgba(255, 184, 77, 0.3);
            font-weight: 600;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }
        .info-item {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }
        .info-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-light);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-dark);
        }
    </style>
</head>
<body>
    <nav class="dashboard-navbar">
        <div class="dashboard-container">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <a href="${pageContext.request.contextPath}/parent/dashboard" class="navbar-brand-custom">
                    <i class="bi bi-heart-pulse-fill"></i>
                    <span>Vaccine For Kids</span>
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
            <aside class="sidebar slide-in-left">
                <ul class="sidebar-menu">
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/dashboard" class="sidebar-menu-link">
                            <i class="bi bi-speedometer2"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/children" class="sidebar-menu-link">
                            <i class="bi bi-people-fill"></i>
                            <span>Danh sách con</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/booking/step1" class="sidebar-menu-link">
                            <i class="bi bi-calendar-plus"></i>
                            <span>Đặt lịch tiêm</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/appointments" class="sidebar-menu-link">
                            <i class="bi bi-calendar-check"></i>
                            <span>Lịch hẹn của tôi</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="${pageContext.request.contextPath}/parent/vaccination-history" class="sidebar-menu-link active">
                            <i class="bi bi-clipboard-pulse"></i>
                            <span>Lịch sử tiêm chủng</span>
                        </a>
                    </li>
                </ul>
            </aside>

            <main class="dashboard-main">
                <div style="margin-bottom: 1.5rem;">
                    <nav aria-label="breadcrumb">
                        <ol style="display: flex; list-style: none; padding: 0; margin: 0; gap: 0.5rem; font-size: 0.9rem;">
                            <li><a href="${pageContext.request.contextPath}/parent/dashboard" style="color: var(--primary-color);">Dashboard</a></li>
                            <li style="color: var(--text-light);">/</li>
                            <li><a href="${pageContext.request.contextPath}/parent/vaccination-history" style="color: var(--primary-color);">Lịch sử tiêm chủng</a></li>
                            <li style="color: var(--text-light);">/</li>
                            <li style="color: var(--text-medium);">${child.fullName}</li>
                        </ol>
                    </nav>
                </div>

                <div class="child-header fade-in-up">
                    <div style="display: flex; justify-content: space-between; align-items: start; flex-wrap: wrap; gap: 1rem;">
                        <div>
                            <h2 style="margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem;">
                                <i class="bi bi-person-circle"></i> ${child.fullName}
                            </h2>
                            <div>
                                <div class="child-info-badge">
                                    <i class="bi bi-calendar3"></i> Ngày sinh: ${child.dateOfBirth}
                                </div>
                                <div class="child-info-badge">
                                    <i class="bi bi-gender-ambiguous"></i> ${child.gender != null ? child.gender : 'N/A'}
                                </div>
                                <div class="child-info-badge">
                                    <i class="bi bi-droplet-fill"></i> Nhóm máu: ${child.bloodType != null ? child.bloodType : 'N/A'}
                                </div>
                            </div>
                        </div>
                        <div style="display: flex; gap: 0.75rem;">
                            <button class="btn-modern btn-outline-modern" style="background: rgba(255, 255, 255, 0.2); border-color: rgba(255, 255, 255, 0.5); color: white;" disabled>
                                <i class="bi bi-download"></i> Tải giấy chứng nhận
                            </button>
                            <button class="btn-modern btn-outline-modern" style="background: rgba(255, 255, 255, 0.2); border-color: rgba(255, 255, 255, 0.5); color: white;" disabled>
                                <i class="bi bi-printer"></i> In
                            </button>
                        </div>
                    </div>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                    <h4 style="display: flex; align-items: center; gap: 0.5rem; color: var(--text-dark);">
                        <i class="bi bi-clipboard2-pulse"></i> Hồ sơ tiêm chủng
                    </h4>
                    <a href="${pageContext.request.contextPath}/parent/vaccination-history" class="btn-modern btn-outline-modern">
                        <i class="bi bi-arrow-left"></i> Quay lại danh sách
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty records}">
                        <div class="content-card fade-in-up">
                            <div class="content-card-body">
                                <div class="empty-state">
                                    <div class="empty-state-icon">
                                        <i class="bi bi-clipboard-x"></i>
                                    </div>
                                    <h3 class="empty-state-title">Chưa có hồ sơ tiêm chủng</h3>
                                    <p class="empty-state-text">Trẻ này chưa được tiêm chủng lần nào.</p>
                                    <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn-modern btn-primary-modern">
                                        <i class="bi bi-calendar-plus"></i>
                                        Đặt lịch tiêm
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="timeline">
                            <c:forEach items="${records}" var="record">
                                <div class="timeline-item">
                                    <div class="record-card">
                                        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1.5rem;">
                                            <h5 style="margin: 0; display: flex; align-items: center; gap: 0.5rem; color: var(--text-dark);">
                                                <i class="bi bi-shield-fill-check" style="color: var(--success-color);"></i> 
                                                ${record.vaccine.vaccineName}
                                            </h5>
                                            <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.4rem 1rem; background: var(--gradient-info); border-radius: var(--border-radius-xl); color: white; font-weight: 600; font-size: 0.85rem;">
                                                <i class="bi bi-calendar-check-fill"></i>
                                                <fmt:formatDate value="${record.vaccinationDate}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>

                                        <div class="info-grid">
                                            <div class="info-item">
                                                <span class="info-label">
                                                    <i class="bi bi-building"></i> Nhà sản xuất
                                                </span>
                                                <span class="info-value">${record.vaccine.manufacturer}</span>
                                            </div>

                                            <div class="info-item">
                                                <span class="info-label">
                                                    <i class="bi bi-clock"></i> Ngày & Giờ
                                                </span>
                                                <span class="info-value">
                                                    <fmt:formatDate value="${record.vaccinationDate}" pattern="dd/MM/yyyy 'lúc' HH:mm"/>
                                                </span>
                                            </div>

                                            <c:if test="${not empty record.batchNumber}">
                                                <div class="info-item">
                                                    <span class="info-label">
                                                        <i class="bi bi-upc-scan"></i> Số lô
                                                    </span>
                                                    <span class="info-value">${record.batchNumber}</span>
                                                </div>
                                            </c:if>

                                            <c:if test="${record.doseNumber != null}">
                                                <div class="info-item">
                                                    <span class="info-label">
                                                        <i class="bi bi-hash"></i> Mũi tiêm
                                                    </span>
                                                    <span class="info-value">
                                                        Mũi ${record.doseNumber}
                                                        <c:if test="${not empty record.vaccine.dosageSchedule}">
                                                            / ${record.vaccine.dosageSchedule}
                                                        </c:if>
                                                    </span>
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty record.staff}">
                                                <div class="info-item">
                                                    <span class="info-label">
                                                        <i class="bi bi-person-badge"></i> Người tiêm
                                                    </span>
                                                    <span class="info-value">${record.staff.fullName}</span>
                                                </div>
                                            </c:if>
                                        </div>

                                        <c:if test="${not empty record.healthCheckNotes || not empty record.vaccinationNotes || not empty record.sideEffectsReported}">
                                            <hr style="margin: 1.5rem 0; border: none; border-top: 2px solid var(--bg-section);">
                                        </c:if>

                                        <c:if test="${not empty record.healthCheckNotes}">
                                            <div style="margin-bottom: 1rem;">
                                                <strong style="color: var(--text-medium); display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;">
                                                    <i class="bi bi-heart-pulse"></i> Khám sức khỏe:
                                                </strong>
                                                <p style="margin: 0; padding-left: 1.8rem; color: var(--text-dark);">${record.healthCheckNotes}</p>
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty record.vaccinationNotes}">
                                            <div style="margin-bottom: 1rem;">
                                                <strong style="color: var(--text-medium); display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;">
                                                    <i class="bi bi-journal-medical"></i> Ghi chú:
                                                </strong>
                                                <p style="margin: 0; padding-left: 1.8rem; color: var(--text-dark);">${record.vaccinationNotes}</p>
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty record.sideEffectsReported}">
                                            <div style="margin-bottom: 1rem;">
                                                <strong style="color: var(--warning-color); display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;">
                                                    <i class="bi bi-exclamation-triangle"></i> Tác dụng phụ:
                                                </strong>
                                                <p style="margin: 0; padding-left: 1.8rem; color: var(--warning-color); font-weight: 500;">${record.sideEffectsReported}</p>
                                            </div>
                                        </c:if>

                                        <c:if test="${record.nextDoseDate != null}">
                                            <div class="next-dose-badge" style="margin-top: 1rem;">
                                                <i class="bi bi-calendar-check"></i> 
                                                <strong>Mũi tiếp theo:</strong> ${record.nextDoseDate}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div style="margin-top: 2rem; text-align: center;">
                            <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn-modern btn-primary-modern">
                                <i class="bi bi-calendar-plus"></i> Đặt lịch tiêm mới
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>
</body>
</html>