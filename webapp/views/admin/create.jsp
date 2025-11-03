<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create User</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2>Create New User</h2>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/admin/users/create" method="post">
            <div class="form-group">
                <label>Email</label>
                <input name="email" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input name="password" type="password" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Full Name</label>
                <input name="fullName" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Phone</label>
                <input name="phone" class="form-control">
            </div>
            <div class="form-group">
                <label>Role</label>
                <select name="role" class="form-control">
                    <option value="ADMIN">ADMIN</option>
                    <option value="RECEPTION">RECEPTION</option>
                    <option value="MEDICAL">MEDICAL</option>
                    <option value="PARENT">PARENT</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Create</button>
            
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</body>
</html>