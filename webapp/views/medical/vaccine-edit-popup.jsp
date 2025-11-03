<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:if test="${not empty vaccine}">
    <form id="vaccineEditForm" method="POST" action="${pageContext.request.contextPath}/medical/vaccinations/update/${vaccine.vaccineId}">
        <div class="row">
            <div class="col-md-12">
                <div class="mb-3">
                    <label for="vaccineName" class="form-label">
                        <i class="bi bi-capsule"></i> Tên Vắc xin <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" id="vaccineName" name="vaccineName"
                           value="${vaccine.vaccineName}" required>
                </div>

                <div class="mb-3">
                    <label for="manufacturer" class="form-label">
                        <i class="bi bi-building"></i> Nhà sản xuất
                    </label>
                    <input type="text" class="form-control" id="manufacturer" name="manufacturer"
                           value="${vaccine.manufacturer}">
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">
                        <i class="bi bi-file-text"></i> Mô tả
                    </label>
                    <textarea class="form-control" id="description" name="description" rows="3">${vaccine.description}</textarea>
                </div>

                <div class="mb-3">
                    <label for="diseasesPrevented" class="form-label">
                        <i class="bi bi-shield-check"></i> Bệnh phòng ngừa <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" id="diseasesPrevented" name="diseasesPrevented"
                           value="${vaccine.diseasesPrevented}" required>
                </div>

                <div class="mb-3">
                    <label for="dosageSchedule" class="form-label">
                        <i class="bi bi-calendar-event"></i> Lịch tiêm
                    </label>
                    <textarea class="form-control" id="dosageSchedule" name="dosageSchedule" rows="2">${vaccine.dosageSchedule}</textarea>
                </div>

                <div class="mb-3">
                    <label for="recommendedAge" class="form-label">
                        <i class="bi bi-person-badge"></i> Độ tuổi khuyến cáo <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" id="recommendedAge" name="recommendedAge"
                           value="${vaccine.recommendedAge}" required>
                </div>

                <div class="row">
                    <div class="col-md-8">
                        <div class="mb-3">
                            <label for="price" class="form-label">
                                <i class="bi bi-currency-dollar"></i> Giá (VND)
                            </label>
                            <input type="number" class="form-control" id="price" name="price"
                                   value="${vaccine.price}" min="0" step="1000">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="mb-3">
                            <label class="form-label d-block">&nbsp;</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="isFree" name="isFree"
                                    ${vaccine.free ? 'checked' : ''}>
                                <label class="form-check-label" for="isFree">
                                    <i class="bi bi-gift"></i> Miễn phí
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="sideEffects" class="form-label">
                        <i class="bi bi-exclamation-triangle"></i> Tác dụng phụ
                    </label>
                    <textarea class="form-control" id="sideEffects" name="sideEffects" rows="2">${vaccine.sideEffects}</textarea>
                </div>

                <div class="mb-3">
                    <label for="contraindications" class="form-label">
                        <i class="bi bi-x-octagon"></i> Chống chỉ định
                    </label>
                    <textarea class="form-control" id="contraindications" name="contraindications" rows="2">${vaccine.contraindications}</textarea>
                </div>
            </div>
        </div>
    </form>
</c:if>

<c:if test="${empty vaccine}">
    <div class="alert alert-warning">
        <i class="bi bi-exclamation-triangle"></i> Không tìm thấy thông tin vắc xin.
    </div>
</c:if>
