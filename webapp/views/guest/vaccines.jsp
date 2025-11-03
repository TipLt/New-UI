<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tất cả Vaccine - Vaccine For Kids</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
    
    <jsp:include page="/views/includes/header.jsp" />
    
    <div class="vaccine-list-header">
        <div class="container">
            <h1><i class="bi bi-shield-fill-check me-3"></i>Tất cả Vaccine</h1>
            <p class="lead mb-0">Danh sách đầy đủ các loại vaccine phòng ngừa bệnh cho trẻ em</p>
        </div>
    </div>
    
    <div class="container mb-5">
        <c:choose>
            <c:when test="${not empty vaccines}">
                <div class="row">
                    <c:forEach items="${vaccines}" var="vaccine">
                        <div class="col-md-6 col-lg-4">
                            <div class="vaccine-card">
                                <c:if test="${not empty vaccine.imageUrl}">
                                    <div class="vaccine-image-wrapper mb-3">
                                        <img src="${pageContext.request.contextPath}${vaccine.imageUrl}" 
                                             alt="${vaccine.vaccineName}"
                                             class="vaccine-image"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div class="vaccine-image-placeholder" style="display: none;">
                                            <i class="bi bi-shield-fill-plus"></i>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${empty vaccine.imageUrl}">
                                    <div class="vaccine-image-wrapper mb-3">
                                        <div class="vaccine-image-placeholder">
                                            <i class="bi bi-shield-fill-plus"></i>
                                        </div>
                                    </div>
                                </c:if>
                                <h4>${vaccine.vaccineName}</h4>
                                
                                <div class="vaccine-info">
                                    <c:if test="${not empty vaccine.recommendedAge}">
                                        <div class="vaccine-info-item">
                                            <i class="bi bi-calendar-check"></i>
                                            <span>${vaccine.recommendedAge}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty vaccine.diseasesPrevented}">
                                        <div class="vaccine-info-item">
                                            <i class="bi bi-shield-check"></i>
                                            <span>Phòng: ${vaccine.diseasesPrevented}</span>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <div class="vaccine-description">
                                    <c:choose>
                                        <c:when test="${not empty vaccine.description}">
                                            ${vaccine.description}
                                        </c:when>
                                        <c:otherwise>
                                            Vaccine giúp phòng ngừa các bệnh: ${vaccine.diseasesPrevented}. 
                                            Đây là một trong những loại vaccine quan trọng để bảo vệ sức khỏe của trẻ em.
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="d-flex gap-2 flex-wrap">
                                    <a href="#" class="btn btn-custom-outline btn-sm">
                                        <i class="bi bi-info-circle me-1"></i> Chi tiết
                                    </a>
                                    <c:choose>
                                        <c:when test="${sessionScope.user != null}">
                                            <a href="${pageContext.request.contextPath}/parent/booking/step1?vaccineId=${vaccine.vaccineId}" 
                                               class="btn btn-custom-outline btn-sm">
                                                <i class="bi bi-calendar-plus me-1"></i> Đặt lịch
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/login" class="btn btn-custom-outline btn-sm">
                                                <i class="bi bi-calendar-plus me-1"></i> Đặt lịch
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-vaccines">
                    <i class="bi bi-inbox" style="font-size: 4rem; color: #ddd;"></i>
                    <h3 class="mt-3">Chưa có dữ liệu vaccine</h3>
                    <p>Hiện tại chưa có thông tin vaccine nào trong hệ thống.</p>
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
