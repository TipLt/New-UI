<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lịch tiêm - Bước 1 - Hệ thống Tiêm chủng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .selection-card {
            cursor: pointer;
            transition: var(--transition-smooth);
            border: 2px solid var(--bg-section);
            border-radius: var(--border-radius-lg);
            background: white;
            height: 100%;
        }
        .selection-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-light);
        }
        .selection-card.selected {
            border-color: var(--primary-color);
            background: linear-gradient(135deg, rgba(74, 144, 226, 0.08) 0%, rgba(92, 200, 190, 0.08) 100%);
            box-shadow: var(--shadow-md);
        }
        .selection-card .form-check-input:checked ~ .form-check-label {
            color: var(--primary-color);
            font-weight: 600;
        }
        .vaccine-price {
            font-size: 1.3rem;
            font-weight: 800;
            background: var(--gradient-hero);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
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
                        <a href="${pageContext.request.contextPath}/parent/booking/step1" class="sidebar-menu-link active">
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
                <div class="page-header fade-in-up">
                    <h1 class="page-title">Đặt lịch tiêm - Bước 1</h1>
                    <p class="page-subtitle">Chọn trẻ em và vaccine cần tiêm</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert-modern fade-in-up" style="background: linear-gradient(135deg, rgba(241, 70, 104, 0.1) 0%, rgba(255, 107, 157, 0.1) 100%); border-left: 4px solid var(--danger-color);">
                        <i class="bi bi-exclamation-circle-fill" style="color: var(--danger-color); font-size: 1.5rem;"></i>
                        <div>
                            <strong>Lỗi!</strong><br>
                            ${error}
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert-modern fade-in-up" style="background: linear-gradient(135deg, rgba(72, 199, 116, 0.1) 0%, rgba(92, 200, 190, 0.1) 100%); border-left: 4px solid #48C774;">
                        <i class="bi bi-check-circle-fill" style="color: #48C774; font-size: 1.5rem;"></i>
                        <div>
                            <strong>Thành công!</strong><br>
                            ${success}
                        </div>
                    </div>
                </c:if>

                <form method="get" action="${pageContext.request.contextPath}/parent/booking/step2" id="bookingForm">
                    <div class="content-card fade-in-up">
                        <div class="content-card-header">
                            <h3 class="content-card-title">
                                <i class="bi bi-person-fill"></i>
                                Chọn trẻ em
                            </h3>
                        </div>
                        <div class="content-card-body">
                            <c:choose>
                                <c:when test="${empty children}">
                                    <div class="alert-modern alert-info-modern">
                                        <i class="bi bi-info-circle-fill"></i>
                                        <div>
                                            <strong>Chưa có thông tin trẻ em</strong><br>
                                            Bạn chưa thêm thông tin con của mình. 
                                            <a href="${pageContext.request.contextPath}/parent/children/add" style="color: var(--primary-color); text-decoration: underline;">
                                                Nhấn vào đây để thêm
                                            </a>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem;">
                                        <c:forEach items="${children}" var="child">
                                            <div class="selection-card" onclick="selectChild(${child.childId})">
                                                <div style="padding: 1.5rem;">
                                                    <div class="form-check">
                                                        <input class="form-check-input child-radio" type="radio" 
                                                               name="childId" value="${child.childId}" 
                                                               id="child${child.childId}" required>
                                                        <label class="form-check-label" for="child${child.childId}" style="width: 100%; cursor: pointer;">
                                                            <h6 style="font-size: 1.1rem; font-weight: 700; color: var(--text-dark); margin-bottom: 1rem;">
                                                                <i class="bi bi-person-fill"></i> ${child.fullName}
                                                            </h6>
                                                            <div style="display: flex; flex-direction: column; gap: 0.5rem; font-size: 0.9rem; color: var(--text-medium);">
                                                                <div>
                                                                    <i class="bi bi-calendar3"></i> 
                                                                    <strong>Ngày sinh:</strong> ${child.dateOfBirth}
                                                                </div>
                                                                <div>
                                                                    <i class="bi bi-gender-ambiguous"></i> 
                                                                    <strong>Giới tính:</strong> ${child.gender}
                                                                </div>
                                                                <c:if test="${not empty child.bloodType}">
                                                                    <div>
                                                                        <i class="bi bi-droplet-fill"></i> 
                                                                        <strong>Nhóm máu:</strong> ${child.bloodType}
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="content-card fade-in-up">
                        <div class="content-card-header">
                            <h3 class="content-card-title">
                                <i class="bi bi-shield-fill-check"></i>
                                Chọn vaccine
                            </h3>
                        </div>
                        <div class="content-card-body">
                            <c:choose>
                                <c:when test="${empty vaccines}">
                                    <div class="alert-modern alert-info-modern">
                                        <i class="bi bi-info-circle-fill"></i>
                                        <div>
                                            <strong>Không có vaccine</strong><br>
                                            Hiện tại không có vaccine nào khả dụng.
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(400px, 1fr)); gap: 1.5rem;">
                                        <c:forEach items="${vaccines}" var="vaccine">
                                            <div class="selection-card" onclick="selectVaccine(${vaccine.vaccineId})">
                                                <div style="padding: 1.5rem;">
                                                    <div class="form-check">
                                                        <input class="form-check-input vaccine-radio" type="radio" 
                                                               name="vaccineId" value="${vaccine.vaccineId}" 
                                                               id="vaccine${vaccine.vaccineId}" required>
                                                        <label class="form-check-label" for="vaccine${vaccine.vaccineId}" style="width: 100%; cursor: pointer;">
                                                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                                                                <h6 style="font-size: 1.1rem; font-weight: 700; color: var(--text-dark); margin: 0;">
                                                                    <i class="bi bi-shield-fill-check" style="color: var(--primary-color);"></i> 
                                                                    ${vaccine.vaccineName}
                                                                </h6>
                                                                <span class="vaccine-price">
                                                                    <fmt:formatNumber value="${vaccine.price}" pattern="#,###"/> đ
                                                                </span>
                                                            </div>
                                                            <div style="display: flex; flex-direction: column; gap: 0.5rem; font-size: 0.9rem; color: var(--text-medium);">
                                                                <c:if test="${not empty vaccine.manufacturer}">
                                                                    <div>
                                                                        <i class="bi bi-building"></i> 
                                                                        <strong>NSX:</strong> ${vaccine.manufacturer}
                                                                    </div>
                                                                </c:if>
                                                                <c:if test="${not empty vaccine.description}">
                                                                    <div style="color: var(--text-dark); line-height: 1.5;">
                                                                        ${vaccine.description}
                                                                    </div>
                                                                </c:if>
                                                                <c:if test="${not empty vaccine.diseasesPrevented}">
                                                                    <div>
                                                                        <i class="bi bi-virus"></i> 
                                                                        <strong>Phòng bệnh:</strong> ${vaccine.diseasesPrevented}
                                                                    </div>
                                                                </c:if>
                                                                <c:if test="${not empty vaccine.recommendedAge}">
                                                                    <div>
                                                                        <i class="bi bi-clock"></i> 
                                                                        <strong>Độ tuổi:</strong> ${vaccine.recommendedAge}
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div style="display: flex; justify-content: space-between; gap: 1rem; margin-top: 2rem;">
                        <a href="${pageContext.request.contextPath}/parent/dashboard" class="btn-modern btn-outline-modern">
                            <i class="bi bi-arrow-left"></i> Quay lại Dashboard
                        </a>
                        <c:if test="${not empty children and not empty vaccines}">
                            <button type="submit" class="btn-modern btn-primary-modern">
                                Bước tiếp theo <i class="bi bi-arrow-right"></i>
                            </button>
                        </c:if>
                    </div>
                </form>
            </main>
        </div>
    </div>

    <script>
        function selectChild(childId) {
            document.querySelectorAll('.child-card, .selection-card').forEach(card => {
                if (card.querySelector('.child-radio')) {
                    card.classList.remove('selected');
                }
            });
            const input = document.getElementById('child' + childId);
            input.checked = true;
            input.closest('.selection-card').classList.add('selected');
        }

        function selectVaccine(vaccineId) {
            document.querySelectorAll('.selection-card').forEach(card => {
                if (card.querySelector('.vaccine-radio')) {
                    card.classList.remove('selected');
                }
            });
            const input = document.getElementById('vaccine' + vaccineId);
            input.checked = true;
            input.closest('.selection-card').classList.add('selected');
        }

        document.querySelectorAll('.child-radio').forEach(radio => {
            radio.addEventListener('change', function() {
                document.querySelectorAll('.selection-card').forEach(card => {
                    if (card.querySelector('.child-radio')) {
                        card.classList.remove('selected');
                    }
                });
                if (this.checked) {
                    this.closest('.selection-card').classList.add('selected');
                }
            });
        });

        document.querySelectorAll('.vaccine-radio').forEach(radio => {
            radio.addEventListener('change', function() {
                document.querySelectorAll('.selection-card').forEach(card => {
                    if (card.querySelector('.vaccine-radio')) {
                        card.classList.remove('selected');
                    }
                });
                if (this.checked) {
                    this.closest('.selection-card').classList.add('selected');
                }
            });
        });
    </script>
</body>
</html>