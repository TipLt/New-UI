<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:if test="${not empty vaccine}">
    <div class="row">
        <div class="col-md-12">
            <table class="table table-bordered">
                <tbody>
                <tr>
                    <th style="width: 30%" class="table-light">
                        <i class="bi bi-capsule"></i> Vaccine Name
                    </th>
                    <td><strong>${vaccine.vaccineName}</strong></td>
                </tr>
                <tr>
                    <th class="table-light">
                        <i class="bi bi-building"></i> Manufacturer
                    </th>
                    <td>${vaccine.manufacturer}</td>
                </tr>
                <tr>
                    <th class="table-light">
                        <i class="bi bi-file-text"></i> Description
                    </th>
                    <td>${vaccine.description}</td>
                </tr>
                <tr>
                    <th class="table-light">
                        <i class="bi bi-shield-check"></i> Diseases Prevented
                    </th>
                    <td><span class="badge bg-success">${vaccine.diseasesPrevented}</span></td>
                </tr>
                <tr>
                    <th class="table-light">
                        <i class="bi bi-calendar-event"></i> Dosage Schedule
                    </th>
                    <td>${vaccine.dosageSchedule}</td>
                </tr>
                <tr>
                    <th class="table-light">
                        <i class="bi bi-person-badge"></i> Recommended Age
                    </th>
                    <td>${vaccine.recommendedAge}</td>
                </tr>
                <tr>
                    <th class="table-light">
                        <i class="bi bi-currency-dollar"></i> Price
                    </th>
                    <td>
                        <c:choose>
                            <c:when test="${vaccine.free}">
                                    <span class="badge bg-success">
                                        <i class="bi bi-gift"></i> Free
                                    </span>
                            </c:when>
                            <c:otherwise>
                                <strong class="text-primary">
                                    <fmt:formatNumber value="${vaccine.price}" type="currency"
                                                      currencySymbol="VND " maxFractionDigits="0"/>
                                </strong>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th class="table-light">
                        <i class="bi bi-toggle-on"></i> Status
                    </th>
                    <td>
                        <c:choose>
                            <c:when test="${vaccine.active}">
                                    <span class="badge bg-success">
                                        <i class="bi bi-check-circle"></i> Active
                                    </span>
                            </c:when>
                            <c:otherwise>
                                    <span class="badge bg-secondary">
                                        <i class="bi bi-x-circle"></i> Inactive
                                    </span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>

                <c:if test="${not empty vaccine.sideEffects}">
                    <tr>
                        <th class="table-light">
                            <i class="bi bi-exclamation-triangle"></i> Side Effects
                        </th>
                        <td class="text-warning">${vaccine.sideEffects}</td>
                    </tr>
                </c:if>

                <c:if test="${not empty vaccine.contraindications}">
                    <tr>
                        <th class="table-light">
                            <i class="bi bi-x-octagon"></i> Contraindications
                        </th>
                        <td class="text-danger">${vaccine.contraindications}</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<c:if test="${empty vaccine}">
    <div class="alert alert-warning">
        <i class="bi bi-exclamation-triangle"></i> Vaccine information not found.
    </div>
</c:if>
