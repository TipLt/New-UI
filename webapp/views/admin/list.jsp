<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>User List</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2>User List</h2>
        
        <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary mb-3">Create New User</a>
        <c:if test="${not empty message}">
            <div class="alert alert-success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/admin/users" method="get" class="mb-3">
            <select name="role" class="form-control d-inline w-auto">
                <option value="">All Roles</option>
                <option value="ADMIN" <c:if test="${roleFilter == 'ADMIN'}">selected</c:if>>ADMIN</option>
                <option value="RECEPTION" <c:if test="${roleFilter == 'RECEPTION'}">selected</c:if>>RECEPTION</option>
                <option value="MEDICAL" <c:if test="${roleFilter == 'MEDICAL'}">selected</c:if>>MEDICAL</option>
                <option value="PARENT" <c:if test="${roleFilter == 'PARENT'}">selected</c:if>>PARENT</option>
            </select>
            <button type="submit" class="btn btn-secondary">Filter</button>
        </form>
        <table class="table table-bordered">
            <thead>
                <tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Role</th><th>Active</th><th>Created At</th><th>Actions</th></tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>${user.UserID}</td>
                        <td>${user.FullName}</td>
                        <td>${user.Email}</td>
                        <td>${user.PhoneNumber}</td>
                        <td>${user.Role}</td>
                        <td>${user.IsActive ? 'Yes' : 'No'}</td>
                        <td>${user.CreatedAt}</td>
                        <td>
                            
                            <a href="${pageContext.request.contextPath}/admin/users/view?id=${user.UserID}" class="btn btn-sm btn-info">View</a>
                            
                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.UserID}" class="btn btn-sm btn-warning">Edit</a>
                            
                            <form action="${pageContext.request.contextPath}/admin/users/toggle" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${user.UserID}">
                                <input type="hidden" name="active" value="${!user.IsActive}">
                                <button type="submit" class="btn btn-sm btn-${user.IsActive ? 'danger' : 'success'}">${user.IsActive ? 'Deactivate' : 'Activate'}</button>
                            </form>
                            
                            <form action="${pageContext.request.contextPath}/admin/users/reset" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${user.UserID}">
                                <button type="submit" class="btn btn-sm btn-secondary">Reset Password</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <nav>
            <ul class="pagination">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${i}&role=${roleFilter}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </div>
</body>
</html>