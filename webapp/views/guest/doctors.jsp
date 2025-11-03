<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đội ngũ Y tế - Vaccine For Kids</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
    
    <jsp:include page="/views/includes/header.jsp" />
    
    <div class="doctors-list-header">
        <div class="container">
            <h1><i class="bi bi-people-fill me-3"></i>Đội ngũ Y tế</h1>
            <p class="lead mb-0">Gặp gỡ các bác sĩ và chuyên gia y tế tận tâm, sẵn sàng chăm sóc sức khỏe cho con bạn</p>
        </div>
    </div>
    
    <div class="container mb-5">
        <c:choose>
            <c:when test="${not empty doctors}">
                <div class="row">
                    <c:forEach items="${doctors}" var="doctor">
                        <div class="col-md-6 col-lg-4">
                            <div class="doctor-profile-card">
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
                                
                                <h4>${doctor.fullName}</h4>
                                
                                <div class="doctor-specialty">
                                    <i class="bi bi-award-fill"></i>
                                </div>
                                
                                <div class="doctor-info">
                                    <c:if test="${not empty doctor.email}">
                                        <div class="doctor-info-item">
                                            <i class="bi bi-envelope-fill"></i>
                                            <small>${doctor.email}</small>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty doctor.phoneNumber}">
                                        <div class="doctor-info-item">
                                            <i class="bi bi-telephone-fill"></i>
                                            <small>${doctor.phoneNumber}</small>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty doctor.role}">
                                        <div class="doctor-info-item">
                                            <i class="bi bi-person-badge-fill"></i>
                                            <small>
                                                <c:choose>
                                                    <c:when test="${doctor.role == 'RECEPTION'}">Lễ tân</c:when>
                                                    <c:when test="${doctor.role == 'NURSE'}">Y tá</c:when>
                                                    <c:when test="${doctor.role == 'DOCTOR'}">Bác sĩ</c:when>
                                                    <c:otherwise>${doctor.role}</c:otherwise>
                                                </c:choose>
                                            </small>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <div class="mt-3">
                                    <a href="#" class="btn btn-custom-outline btn-sm">
                                        <i class="bi bi-person-lines-fill me-1"></i> Xem hồ sơ
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-doctors">
                    <i class="bi bi-person-x" style="font-size: 4rem; color: #ddd;"></i>
                    <h3 class="mt-3">Chưa có dữ liệu đội ngũ y tế</h3>
                    <p>Hiện tại chưa có thông tin bác sĩ/nhân viên y tế nào trong hệ thống.</p>
                </div>
            </c:otherwise>
        </c:choose>
        
        <div class="text-center mt-5">
            <a href="${pageContext.request.contextPath}/" class="btn btn-custom-outline">
                <i class="bi bi-arrow-left me-2"></i> Về trang chủ
            </a>
        </div>
    </div>
    
    <jsp:include page="/views/includes/footer.jsp" />
    
</body>
</html>
