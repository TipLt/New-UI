<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vaccine For Kids - Hệ thống Quản lý Tiêm chủng Thông minh</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
    
    <jsp:include page="/views/includes/header.jsp" />
    
    <div class="hero-section">
        <div class="hero-content">
            <h1>Vaccine For Kids</h1>
            <p class="lead">Hệ thống quản lý tiêm chủng thông minh cho mọi trẻ em. Giúp bạn theo dõi lịch trình, đặt hẹn và lưu trữ hồ sơ tiêm chủng dễ dàng.</p>
            <c:choose>
                <c:when test="${sessionScope.user == null}">
                    <a class="btn btn-primary btn-lg" href="${pageContext.request.contextPath}/register">
                        Đặt lịch tiêm ngay
                    </a>
                </c:when>
                <c:otherwise>
                    <a class="btn btn-light btn-lg" href="${pageContext.request.contextPath}/parent/booking/step1">
                        Đặt lịch tiêm ngay
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <c:forEach items="${vaccines}" var="vaccine" varStatus="loop" begin="0" end="1">
        <div class="content-section">
            <div class="container">
                <div class="row align-items-center g-5">
                    <div class="col-md-6 ${loop.index % 2 == 1 ? 'order-md-2' : ''}">
                        <h2>${vaccine.vaccineName}</h2>
                        <p>
                            <c:choose>
                                <c:when test="${not empty vaccine.description}">
                                    ${vaccine.description}
                                </c:when>
                                <c:otherwise>
                                    Vaccine giúp phòng ngừa các bệnh: ${vaccine.diseasesPrevented}. 
                                    Đây là một trong những loại vaccine quan trọng để bảo vệ sức khỏe của trẻ em.
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty vaccine.recommendedAge}">
                                <br><small class="text-muted">
                                    <i class="bi bi-calendar-check me-1"></i>
                                    Độ tuổi khuyến nghị: ${vaccine.recommendedAge}
                                </small>
                            </c:if>
                        </p>
                        <a href="#" class="btn btn-custom-outline">
                            <i class="bi bi-info-circle me-1"></i> Xem chi tiết
                        </a>
                        <c:choose>
                            <c:when test="${sessionScope.user != null}">
                                <a href="${pageContext.request.contextPath}/parent/booking/step1?vaccineId=${vaccine.vaccineId}" 
                                   class="btn btn-custom-outline">
                                    <i class="bi bi-calendar-plus me-1"></i> Đặt lịch ngay
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-custom-outline">
                                    <i class="bi bi-calendar-plus me-1"></i> Đặt lịch ngay
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-6 ${loop.index % 2 == 1 ? 'order-md-1' : ''}">
                        <c:choose>
                            <c:when test="${not empty vaccine.imageUrl}">
                                <img src="${pageContext.request.contextPath}${vaccine.imageUrl}" 
                                     alt="${vaccine.vaccineName}" 
                                     class="content-image"
                                     onerror="this.src='https://images.unsplash.com/photo-1631815588090-d4bfec5b1ccb?w=800&auto=format&fit=crop'">
                            </c:when>
                            <c:otherwise>
                                <img src="https://images.unsplash.com/photo-1631815588090-d4bfec5b1ccb?w=800&auto=format&fit=crop" 
                                     alt="${vaccine.vaccineName}" 
                                     class="content-image">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
    
    <div class="container text-center" style="margin: 3rem auto;">
        <a href="${pageContext.request.contextPath}/vaccines" class="btn see-more-btn">
            <i class="bi bi-grid-3x3-gap me-2"></i> Xem tất cả Vaccine
        </a>
    </div>
    
    <div class="icon-features-section">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="icon-feature">
                        <div class="icon-feature-icon">
                            <i class="bi bi-calendar-check"></i>
                        </div>
                        <h5>Xem lịch tiêm</h5>
                        <p>Dễ dàng theo dõi lịch tiêm chủng được khuyến nghị cho bé. Nhận thông báo nhắc nhở tự động.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="icon-feature">
                        <div class="icon-feature-icon">
                            <i class="bi bi-clock-history"></i>
                        </div>
                        <h5>Đặt lịch tiêm</h5>
                        <p>Nhanh chóng đặt lịch hẹn tại các trung tâm y tế uy tín. Tiết kiệm thời gian chờ đợi.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="icon-feature">
                        <div class="icon-feature-icon">
                            <i class="bi bi-journal-medical"></i>
                        </div>
                        <h5>Sổ tiêm của tôi</h5>
                        <p>Lưu trữ và truy cập lịch sử tiêm chủng của con bạn mọi lúc mọi nơi, an toàn và bảo mật.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="our-doctors-section">
        <div class="container">
            <h2>Đội ngũ chuyên viên <span class="text-gradient">y tế</span></h2>
            <p class="lead">Gặp gỡ các bác sĩ và chuyên gia y tế tận tâm của chúng tôi, sẵn sàng chăm sóc sức khỏe cho con bạn.</p>
            <div class="row g-4 justify-content-center">
                <c:forEach items="${doctors}" var="doctor" begin="0" end="3">
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="doctor-card">
                            <c:choose>
                                <c:when test="${not empty doctor.imageUrl}">
                                    <img src="${pageContext.request.contextPath}${doctor.imageUrl}" 
                                         alt="${doctor.fullName}"
                                         onerror="this.src='https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&auto=format&fit=crop'">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&auto=format&fit=crop" 
                                         alt="${doctor.fullName}">
                                </c:otherwise>
                            </c:choose>
                            <h5>${doctor.fullName}</h5>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <a href="${pageContext.request.contextPath}/doctors" class="btn see-more-btn mt-5">
                <i class="bi bi-people me-2"></i> Xem tất cả đội ngũ
            </a>
        </div>
    </div>
    
    <jsp:include page="/views/includes/footer.jsp" />
    
</body>
</html>
