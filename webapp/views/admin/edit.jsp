<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2>Edit User</h2>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/admin/users/edit" method="post">
            <input type="hidden" name="id" value="${user.UserID}">
            <div class="form-group">
                <label>Full Name</label>
                <input name="fullName" value="${user.FullName}" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Phone</label>
                <input name="phone" value="${user.PhoneNumber}" class="form-control">
            </div>
            <div class="form-group">
                <label>Role</label>
                <select name="role" class="form-control">
                    <option value="ADMIN" <c:if test="${user.Role == 'ADMIN'}">selected</c:if>>ADMIN</option>
                    <option value="RECEPTION" <c:if test="${user.Role == 'RECEPTION'}">selected</c:if>>RECEPTION</option>
                    <option value="MEDICAL" <c:if test="${user.Role == 'MEDICAL'}">selected</c:if>>MEDICAL</option>
                    <option value="PARENT" <c:if test="${user.Role == 'PARENT'}">selected</c:if>>PARENT</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Update</button>
            
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</body>
</html>