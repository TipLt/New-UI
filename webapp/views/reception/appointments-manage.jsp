<%@ page import="java.util.List" %>
<%@ page import="com.vaccination.model.Appointment" %>
<%
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Payments - Reception</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manage-payments.css">

</head>
<body class="container mt-4">
    <h2>Appointments Pending Payment</h2>

    <a href="<%= request.getContextPath() %>/reception/appointments-list" class="btn btn-secondary mb-3">
        Back to Appointment List
    </a>

    <table class="table table-bordered">
        <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Child ID</th>
                <th>Vaccine</th>
                <th>Date</th>
                <th>Time</th>
                <th>Status</th>
                <th>Payment Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <%
            if (appointments != null && !appointments.isEmpty()) {
                for (Appointment app : appointments) {
        %>
            <tr>
                <td><%= app.getAppointmentId() %></td>
                <td><%= app.getChildId() %></td>
                <td><%= app.getVaccineId() %></td>
                <td><%= app.getAppointmentDate() %></td>
                <td><%= app.getAppointmentTime() != null ? app.getAppointmentTime() : "-" %></td>
                <td><%= app.getStatus() %></td>
                <td><%= app.getPaymentStatus() %></td>
                <td>
                    <%-- mark as paid --%>
                    <form action="<%= request.getContextPath() %>/reception/completePayment" 
                          method="post" style="display:inline;">
                        <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                        <button type="submit" class="btn btn-success btn-sm"
                            <%= "Paid".equalsIgnoreCase(app.getPaymentStatus()) ? "disabled" : "" %>>
                            Mark as Paid
                        </button>
                    </form>

                    <%-- mark as unpaid --%>
                    <form action="<%= request.getContextPath() %>/reception/cancelPayment" 
                          method="post" style="display:inline;">
                        <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                        <button type="submit" class="btn btn-warning btn-sm"
                            <%= "Unpaid".equalsIgnoreCase(app.getPaymentStatus()) ? "disabled" : "" %>>
                            Mark as Unpaid
                        </button>
                    </form>
                </td>
            </tr>
        <%
                }
            } else {
        %>
<tr>
                <td colspan="8" class="text-center text-muted">No pending payments found.</td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
</body>
</html>