package com.vaccination.controller.medical;

import com.vaccination.dao.VaccineDAO;
import com.vaccination.model.Vaccine;
import com.vaccination.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/medical/vaccinations/*")
public class VaccineManageServlet extends HttpServlet {
    private VaccineDAO vaccineDAO;

    @Override
    public void init() throws ServletException {
        vaccineDAO = new VaccineDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        // Check if user has MEDICAL role
        if (!"MEDICAL".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            // Show vaccine list
            showVaccineList(request, response);
        } else if (pathInfo.startsWith("/detail/")) {
            // Get vaccine detail (for AJAX request)
            getVaccineDetail(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Get vaccine edit form (for AJAX request)
            getVaccineEditForm(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showVaccineList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all vaccines
            List<Vaccine> vaccines = vaccineDAO.getAllVaccines();

            request.setAttribute("vaccines", vaccines);
            request.getRequestDispatcher("/views/medical/vaccine-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load vaccine list: " + e.getMessage());
            request.getRequestDispatcher("/views/medical/vaccine-list.jsp").forward(request, response);
        }
    }

    private void getVaccineDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            String vaccineIdStr = pathInfo.substring(pathInfo.lastIndexOf('/') + 1);
            int vaccineId = Integer.parseInt(vaccineIdStr);

            Vaccine vaccine = vaccineDAO.findById(vaccineId);

            if (vaccine != null) {
                request.setAttribute("vaccine", vaccine);
                request.getRequestDispatcher("/views/medical/vaccine-detail-popup.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Vaccine not found");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid vaccine ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading vaccine details");
        }
    }

    private void getVaccineEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            String vaccineIdStr = pathInfo.substring(pathInfo.lastIndexOf('/') + 1);
            int vaccineId = Integer.parseInt(vaccineIdStr);

            Vaccine vaccine = vaccineDAO.findById(vaccineId);

            if (vaccine != null) {
                request.setAttribute("vaccine", vaccine);
                request.getRequestDispatcher("/views/medical/vaccine-edit-popup.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Vaccine not found");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid vaccine ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading vaccine for edit");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/hide/")) {
            // Handle hide vaccine action
            hideVaccine(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/update/")) {
            // Handle update vaccine action
            updateVaccine(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void hideVaccine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            String vaccineIdStr = pathInfo.substring(pathInfo.lastIndexOf('/') + 1);
            int vaccineId = Integer.parseInt(vaccineIdStr);

            boolean success = vaccineDAO.deactivateVaccine(vaccineId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/medical/vaccinations/list?success=hidden");
            } else {
                response.sendRedirect(request.getContextPath() + "/medical/vaccinations/list?error=hide_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/medical/vaccinations/list?error=" + e.getMessage());
        }
    }

    private void updateVaccine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set encoding for Vietnamese characters
            request.setCharacterEncoding("UTF-8");

            String pathInfo = request.getPathInfo();
            String vaccineIdStr = pathInfo.substring(pathInfo.lastIndexOf('/') + 1);
            int vaccineId = Integer.parseInt(vaccineIdStr);

            // Get form data
            String vaccineName = request.getParameter("vaccineName");
            String manufacturer = request.getParameter("manufacturer");
            String description = request.getParameter("description");
            String diseasesPrevented = request.getParameter("diseasesPrevented");
            String dosageSchedule = request.getParameter("dosageSchedule");
            String recommendedAge = request.getParameter("recommendedAge");
            String priceStr = request.getParameter("price");
            String isFreeStr = request.getParameter("isFree");
            String sideEffects = request.getParameter("sideEffects");
            String contraindications = request.getParameter("contraindications");

            // Create vaccine object
            Vaccine vaccine = new Vaccine();
            vaccine.setVaccineId(vaccineId);
            vaccine.setVaccineName(vaccineName);
            vaccine.setManufacturer(manufacturer);
            vaccine.setDescription(description);
            vaccine.setDiseasesPrevented(diseasesPrevented);
            vaccine.setDosageSchedule(dosageSchedule);
            vaccine.setRecommendedAge(recommendedAge);

            // Parse price
            BigDecimal price = BigDecimal.ZERO;
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                price = new BigDecimal(priceStr);
            }
            vaccine.setPrice(price);

            // Parse isFree
            boolean isFree = "on".equals(isFreeStr) || "true".equals(isFreeStr);
            vaccine.setFree(isFree);

            vaccine.setSideEffects(sideEffects);
            vaccine.setContraindications(contraindications);

            // Update in database
            boolean success = vaccineDAO.updateVaccine(vaccine);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/medical/vaccinations/list?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/medical/vaccinations/list?error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/medical/vaccinations/list?error=" + e.getMessage());
        }
    }
}