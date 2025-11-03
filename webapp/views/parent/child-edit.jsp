<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa thông tin - Hệ thống Tiêm chủng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .form-modern {
            display: grid;
            gap: 1.5rem;
        }
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        .form-label {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .form-label .required {
            color: var(--danger-color);
        }
        .form-input, .form-select, .form-textarea {
            padding: 0.9rem 1.2rem;
            border: 2px solid var(--bg-section);
            border-radius: var(--border-radius-md);
            font-size: 1rem;
            color: var(--text-dark);
            background: white;
            transition: var(--transition-fast);
            font-family: inherit;
        }
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }
        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }
        .form-help {
            font-size: 0.85rem;
            color: var(--text-light);
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
                        <span>${sessionScope.user.fullName}</span>
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
        <div style="max-width: 900px; margin: 0 auto; padding: 2.5rem 1.5rem;">
            <div class="page-header fade-in-up">
                <h1 class="page-title">Chỉnh sửa thông tin</h1>
                <p class="page-subtitle">Cập nhật thông tin hồ sơ của ${child.fullName}</p>
            </div>

            <div class="content-card fade-in-up">
                <div class="content-card-header">
                    <h3 class="content-card-title">
                        <i class="bi bi-pencil-square"></i>
                        Thông tin trẻ em
                    </h3>
                </div>
                <div class="content-card-body">
                    <c:if test="${not empty error}">
                        <div class="alert-modern" style="background: linear-gradient(135deg, rgba(241, 70, 104, 0.1) 0%, rgba(255, 107, 157, 0.1) 100%); border-left: 4px solid var(--danger-color); margin-bottom: 2rem;">
                            <i class="bi bi-exclamation-circle-fill" style="color: var(--danger-color); font-size: 1.5rem;"></i>
                            <div>
                                <strong>Lỗi!</strong><br>
                                ${error}
                            </div>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/parent/children/update" class="form-modern">
                        <input type="hidden" name="childId" value="${child.childId}">

                        <div class="form-group">
                            <label for="fullName" class="form-label">
                                <i class="bi bi-person"></i> Họ và tên <span class="required">*</span>
                            </label>
                            <input type="text" class="form-input" id="fullName" name="fullName" 
                                   value="${child.fullName}" placeholder="Nhập họ và tên đầy đủ" required>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="dateOfBirth" class="form-label">
                                    <i class="bi bi-calendar"></i> Ngày sinh <span class="required">*</span>
                                </label>
                                <input type="date" class="form-input" id="dateOfBirth" name="dateOfBirth" 
                                       value="${child.dateOfBirth}" required>
                            </div>

                            <div class="form-group">
                                <label for="gender" class="form-label">
                                    <i class="bi bi-gender-ambiguous"></i> Giới tính <span class="required">*</span>
                                </label>
                                <select class="form-select" id="gender" name="gender" required>
                                    <option value="">Chọn giới tính</option>
                                    <option value="Male" ${child.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                    <option value="Female" ${child.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="bloodType" class="form-label">
                                    <i class="bi bi-droplet-fill"></i> Nhóm máu
                                </label>
                                <select class="form-select" id="bloodType" name="bloodType">
                                    <option value="">Chọn nhóm máu</option>
                                    <option value="A" ${child.bloodType == 'A' ? 'selected' : ''}>A</option>
                                    <option value="B" ${child.bloodType == 'B' ? 'selected' : ''}>B</option>
                                    <option value="AB" ${child.bloodType == 'AB' ? 'selected' : ''}>AB</option>
                                    <option value="O" ${child.bloodType == 'O' ? 'selected' : ''}>O</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="weight" class="form-label">
                                    <i class="bi bi-bar-chart"></i> Cân nặng (kg)
                                </label>
                                <input type="number" class="form-input" id="weight" name="weight" 
                                       value="${child.weight}" step="0.1" min="0" placeholder="VD: 3.5">
                            </div>

                            <div class="form-group">
                                <label for="height" class="form-label">
                                    <i class="bi bi-rulers"></i> Chiều cao (cm)
                                </label>
                                <input type="number" class="form-input" id="height" name="height" 
                                       value="${child.height}" step="0.1" min="0" placeholder="VD: 50">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="medicalHistory" class="form-label">
                                <i class="bi bi-file-medical"></i> Tiền sử bệnh
                            </label>
                            <textarea class="form-textarea" id="medicalHistory" name="medicalHistory" 
                                      placeholder="Ghi chú về các bệnh lý, tiền sử bệnh (nếu có)">${child.medicalHistory}</textarea>
                            <span class="form-help">Thông tin này giúp bác sĩ đánh giá và tư vấn phù hợp</span>
                        </div>

                        <div class="form-group">
                            <label for="allergies" class="form-label">
                                <i class="bi bi-exclamation-triangle"></i> Dị ứng
                            </label>
                            <textarea class="form-textarea" id="allergies" name="allergies" 
                                      placeholder="Ghi chú các loại dị ứng (thực phẩm, thuốc, khác...)">${child.allergies}</textarea>
                            <span class="form-help">Thông tin quan trọng để tránh các phản ứng phụ</span>
                        </div>

                        <div style="display: flex; gap: 1rem; padding-top: 1.5rem; border-top: 2px solid var(--bg-section);">
                            <button type="submit" class="btn-modern btn-primary-modern">
                                <i class="bi bi-check-circle"></i> Cập nhật thông tin
                            </button>
                            <a href="${pageContext.request.contextPath}/parent/children/view?id=${child.childId}" 
                               class="btn-modern btn-outline-modern">
                                <i class="bi bi-x-circle"></i> Hủy bỏ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>