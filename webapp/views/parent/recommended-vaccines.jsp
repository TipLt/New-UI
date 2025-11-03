<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vaccine khuyến nghị - Hệ thống Tiêm chủng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
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
                        <a href="${pageContext.request.contextPath}/parent/children" class="sidebar-menu-link active">
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
                        <a href="${pageContext.request.contextPath}/parent/vaccination-history" class="sidebar-menu-link">
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
                            <li><a href="${pageContext.request.contextPath}/parent/children" style="color: var(--primary-color);">Danh sách con</a></li>
                            <li style="color: var(--text-light);">/</li>
                            <li><a href="${pageContext.request.contextPath}/parent/children/view?id=${child.childId}" style="color: var(--primary-color);">${child.fullName}</a></li>
                            <li style="color: var(--text-light);">/</li>
                            <li style="color: var(--text-medium);">Vaccine khuyến nghị</li>
                        </ol>
                    </nav>
                </div>

                <div class="content-card fade-in-up">
                    <div class="content-card-body">
                        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                            <div>
                                <h4 style="margin: 0; display: flex; align-items: center; gap: 0.5rem; color: var(--text-dark);">
                                    <i class="bi bi-person-fill"></i> ${child.fullName}
                                </h4>
                                <p style="margin: 0.5rem 0 0 0; color: var(--text-medium);">
                                    Tuổi: <strong>${child.ageYears} tuổi${child.ageRemainingMonths > 0 ? ' '.concat(child.ageRemainingMonths).concat(' tháng') : ''}</strong> 
                                    (${ageInMonths} tháng)
                                </p>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/parent/vaccination-history/${child.childId}" class="btn-modern btn-outline-modern">
                                    <i class="bi bi-clipboard-pulse"></i> Xem lịch sử
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="alert-modern alert-info-modern fade-in-up">
                    <i class="bi bi-info-circle-fill"></i> 
                    <div>
                        <strong>Lịch tiêm khuyến nghị</strong> - Dưới đây là danh sách vaccine phù hợp với độ tuổi của bé.<br>
                        <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.3rem 0.8rem; background: linear-gradient(135deg, rgba(72, 199, 116, 0.2) 0%, rgba(92, 200, 190, 0.2) 100%); border-radius: 20px; color: #48C774; font-weight: 600; font-size: 0.85rem; margin: 0.5rem 0.5rem 0 0;">
                            <i class="bi bi-check-circle-fill"></i> MIỄN PHÍ
                        </span> là vaccine trong Chương trình TCMR Bộ Y tế.
                        <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.3rem 0.8rem; background: linear-gradient(135deg, rgba(255, 184, 77, 0.2) 0%, rgba(255, 107, 157, 0.2) 100%); border-radius: 20px; color: #FFB84D; font-weight: 600; font-size: 0.85rem;">
                            <i class="bi bi-cash"></i> TRẢ PHÍ
                        </span> là vaccine dịch vụ (tự nguyện).
                    </div>
                </div>

                <c:forEach items="${groupedTemplates}" var="entry">
                    <div class="content-card fade-in-up">
                        <div class="content-card-header">
                            <h3 class="content-card-title">
                                <i class="bi bi-bookmark-fill"></i>
                                ${entry.key}
                            </h3>
                        </div>
                        <div class="content-card-body">
                            <div class="table-responsive">
                                <table class="table-modern">
                                    <thead>
                                        <tr>
                                            <th style="width: 5%;"><i class="bi bi-hash"></i> STT</th>
                                            <th style="width: 35%;"><i class="bi bi-shield-check"></i> Vaccine</th>
                                            <th style="width: 20%;"><i class="bi bi-virus"></i> Phòng bệnh</th>
                                            <th style="width: 15%;"><i class="bi bi-tag"></i> Phân loại</th>
                                            <th style="width: 10%;"><i class="bi bi-info-circle"></i> Trạng thái</th>
                                            <th style="width: 15%;"><i class="bi bi-gear"></i> Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${entry.value}" var="template" varStatus="status">
                                            <c:set var="vaccine" value="${template.vaccine}" />
                                            <c:set var="isVaccinated" value="${vaccinatedVaccineIds.contains(vaccine.vaccineId)}" />
                                            <c:set var="appointment" value="${appointmentByVaccineId[vaccine.vaccineId]}" />
                                            <tr>
                                                <td><strong>${status.count}</strong></td>
                                                <td>
                                                    <strong style="color: var(--text-dark);">${vaccine.vaccineName}</strong>
                                                    <br>
                                                    <small style="color: var(--text-medium);">${template.description}</small>
                                                </td>
                                                <td>${vaccine.diseasesPrevented}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${vaccine.free}">
                                                            <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.4rem 1rem; background: linear-gradient(135deg, rgba(72, 199, 116, 0.2) 0%, rgba(92, 200, 190, 0.2) 100%); border-radius: 20px; color: #48C774; font-weight: 600; font-size: 0.85rem;">
                                                                <i class="bi bi-check-circle-fill"></i> MIỄN PHÍ
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.4rem 1rem; background: linear-gradient(135deg, rgba(255, 184, 77, 0.2) 0%, rgba(255, 107, 157, 0.2) 100%); border-radius: 20px; color: #FFB84D; font-weight: 600; font-size: 0.85rem;">
                                                                <i class="bi bi-cash"></i> TRẢ PHÍ
                                                            </span>
                                                            <br>
                                                            <small style="color: var(--text-medium);">${vaccine.price > 0 ? vaccine.price.toString().concat(' VNĐ') : 'N/A'}</small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${isVaccinated}">
                                                            <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.4rem 1rem; background: linear-gradient(135deg, rgba(58, 191, 248, 0.2) 0%, rgba(74, 144, 226, 0.2) 100%); border-radius: 20px; color: #3ABFF8; font-weight: 600; font-size: 0.85rem;">
                                                                <i class="bi bi-check-lg"></i> Đã tiêm
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${not empty appointment}">
                                                            <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.4rem 1rem; background: linear-gradient(135deg, rgba(255, 184, 77, 0.2) 0%, rgba(255, 107, 157, 0.2) 100%); border-radius: 20px; color: #FFB84D; font-weight: 600; font-size: 0.85rem;">
                                                                <i class="bi bi-calendar-event"></i> Đã đặt lịch
                                                            </span>
                                                            <br>
                                                            <small style="color: var(--text-medium);">${appointment.appointmentDate}</small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.4rem 1rem; background: rgba(120, 144, 156, 0.15); border-radius: 20px; color: var(--text-medium); font-weight: 600; font-size: 0.85rem;">
                                                                <i class="bi bi-clock"></i> Chưa có lịch
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${isVaccinated}">
                                                            <button class="btn-modern btn-outline-modern btn-sm-modern" disabled style="cursor: not-allowed; opacity: 0.6;">
                                                                <i class="bi bi-check-circle"></i> Hoàn thành
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${vaccine.free}">
                                                            <c:choose>
                                                                <c:when test="${not empty appointment}">
                                                                    <a href="${pageContext.request.contextPath}/parent/appointments" 
                                                                       class="btn-modern btn-info-modern btn-sm-modern">
                                                                        <i class="bi bi-calendar-check"></i> Xem lịch hẹn
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span style="color: var(--text-medium); font-size: 0.85rem; display: flex; align-items: center; gap: 0.3rem;">
                                                                        <i class="bi bi-info-circle"></i> Tự động tạo lịch
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/parent/booking/step1?childId=${child.childId}&vaccineId=${vaccine.vaccineId}" 
                                                               class="btn-modern btn-primary-modern btn-sm-modern">
                                                                <i class="bi bi-calendar-plus"></i> Đặt lịch
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty groupedTemplates}">
                    <div class="alert-modern fade-in-up" style="background: linear-gradient(135deg, rgba(255, 184, 77, 0.1) 0%, rgba(255, 107, 157, 0.1) 100%); border-left: 4px solid var(--warning-color);">
                        <i class="bi bi-exclamation-triangle-fill" style="color: var(--warning-color); font-size: 1.5rem;"></i>
                        <div>
                            <strong>Không có vaccine khuyến nghị</strong><br>
                            Không có vaccine khuyến nghị cho độ tuổi này.
                        </div>
                    </div>
                </c:if>

                <div style="margin-top: 2rem;">
                    <a href="${pageContext.request.contextPath}/parent/children/view?id=${child.childId}" class="btn-modern btn-outline-modern">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                </div>
            </main>
        </div>
    </div>
</body>
</html>