<%@ page import="com.vaccination.model.Appointment" %>
<%
    Appointment app = (Appointment) request.getAttribute("appointment");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Appointment Detail</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/appointment-style.css">
</head>
<body class="container mt-4">
    <h2>Appointment Detail</h2>

    <%
        if (app == null) {
    %>
        <p class="text-danger">Appointment not found.</p>
    <%
        } else {
            String status = app.getStatus() != null ? app.getStatus().toLowerCase() : "";
    %>
        <table class="table table-bordered w-50">
            <tr><th>ID:</th><td><%= app.getAppointmentId() %></td></tr>
            <tr><th>Child ID:</th><td><%= app.getChildId() %></td></tr>
            <tr><th>Vaccine ID:</th><td><%= app.getVaccineId() %></td></tr>
            <tr><th>Date:</th><td><%= app.getAppointmentDate() %></td></tr>
            <tr><th>Time:</th><td><%= app.getAppointmentTime() != null ? app.getAppointmentTime() : "-" %></td></tr>
            <tr><th>Status:</th><td><%= app.getStatus() %></td></tr>
            <tr><th>Payment Status:</th><td><%= app.getPaymentStatus() %></td></tr>
            <tr>
                <th>Notes:</th>
                <td>
                    <form action="<%= request.getContextPath() %>/reception/updateNote" method="post" class="d-flex">
                        <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                        <textarea name="notes" class="form-control me-2" rows="2" style="width:70%;"><%= app.getNotes() != null ? app.getNotes() : "" %></textarea>
                        <button type="submit" class="btn btn-primary">Save</button>
                    </form>
                </td>
            </tr>
        </table>

        <div class="mt-3">
            <% if ("pending".equals(status)) { %>
                <form action="<%= request.getContextPath() %>/reception/confirmAppointment" method="post" style="display:inline;">
                    <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                    <button type="submit" class="btn btn-success">Confirm Appointment</button>
                </form>
                <form action="<%= request.getContextPath() %>/reception/cancelAppointment" method="post" style="display:inline;">
                    <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                    <button type="submit" class="btn btn-danger">Reject Appointment</button>
                </form>

            <% } else if ("cancelled".equals(status)) { %>
                <form action="<%= request.getContextPath() %>/reception/confirmAppointment" method="post" style="display:inline;">
                    <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                    <button type="submit" class="btn btn-success">Confirm Appointment</button>
                </form>

            <% } else if ("confirmed".equals(status)) { %>
                <form action="<%= request.getContextPath() %>/reception/cancelAppointment" method="post" style="display:inline;">
                    <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                    <button type="submit" class="btn btn-danger">Reject Appointment</button>
                </form>
            <% } %>
        </div>

        <p class="mt-3">
            <a href="<%= request.getContextPath() %>/reception/appointments-list" class="btn btn-secondary">Back to List</a>
        </p>
    <%
        }
    %>
</body>
</html>
