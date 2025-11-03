<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Detail</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2>User Detail</h2>
        <p><strong>ID:</strong> ${user.UserID}</p>
        <p><strong>Name:</strong> ${user.FullName}</p>
        <p><strong>Email:</strong> ${user.Email}</p>
        <p><strong>Phone:</strong> ${user.PhoneNumber}</p>
        <p><strong>Role:</strong> ${user.Role}</p>
        <p><strong>Active:</strong> ${user.IsActive ? 'Yes' : 'No'}</p>
        <p><strong>Created At:</strong> ${user.CreatedAt}</p>
        <p><strong>Last Login:</strong> ${user.LastLogin}</p>
        
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Back to List</a>
    </div>
</body>
</html>