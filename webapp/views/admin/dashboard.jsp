<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2>Admin Dashboard</h2>
        <h3>Users by Role</h3>
        <table class="table table-bordered">
            <thead><tr><th>Role</th><th>Count</th></tr></thead>
            <tbody>
                <c:forEach var="entry" items="${usersByRole}">
                    <tr><td>${entry.key}</td><td>${entry.value}</td></tr>
                </c:forEach>
            </tbody>
        </table>

        <h3>New Users This Month: ${newUsers}</h3>

        <h3>Active/Inactive Users</h3>
        <table class="table table-bordered">
            <thead><tr><th>Status</th><th>Count</th></tr></thead>
            <tbody>
                <c:forEach var="entry" items="${activeInactive}">
                    <tr><td>${entry.key}</td><td>${entry.value}</td></tr>
                </c:forEach>
            </tbody>
        </table>

        <h3>Recent Logins (Last 10)</h3>
        <table class="table table-bordered">
            <thead><tr><th>User ID</th><th>Name</th><th>Last Login</th></tr></thead>
            <tbody>
                <c:forEach var="login" items="${recentLogins}">
                    <tr><td>${login.UserID}</td><td>${login.FullName}</td><td>${login.LastLogin}</td></tr>
                </c:forEach>
            </tbody>
        </table>
        
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Manage Users</a>
    </div>
</body>
</html>