package com.vaccination.controller.parent;

import com.vaccination.dao.*;
import com.vaccination.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/parent/vaccination-history/*")
public class VaccinationHistoryServlet extends HttpServlet {
    private ChildDAO childDAO = new ChildDAO();
    private VaccinationRecordDAO recordDAO = new VaccinationRecordDAO();
    private VaccineDAO vaccineDAO = new VaccineDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"PARENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            viewHistory(request, response, user);
        } else if (pathInfo.matches("/\\d+")) {
            int childId = Integer.parseInt(pathInfo.substring(1));
            viewChildHistory(request, response, user, childId);
        } else {
            response.sendRedirect(request.getContextPath() + "/parent/vaccination-history");
        }
    }

    private void viewHistory(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        List<Child> children = childDAO.findByParentId(user.getUserId());
        
        request.setAttribute("children", children);
        request.getRequestDispatcher("/views/parent/vaccination-history.jsp").forward(request, response);
    }

    private void viewChildHistory(HttpServletRequest request, HttpServletResponse response, User user, int childId)
            throws ServletException, IOException {
        
        Child child = childDAO.findById(childId);
        
        if (child == null || child.getParentId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/parent/vaccination-history");
            return;
        }
        
        List<VaccinationRecord> records = recordDAO.findByChildId(childId);
        
        for (VaccinationRecord record : records) {
            Vaccine vaccine = vaccineDAO.findById(record.getVaccineId());
            record.setVaccine(vaccine);
            
            if (record.getAdministeredBy() > 0) {
                User medicalStaff = userDAO.findById(record.getAdministeredBy());
                record.setStaff(medicalStaff);
            }
        }
        
        request.setAttribute("child", child);
        request.setAttribute("records", records);
        request.getRequestDispatcher("/views/parent/vaccination-history-detail.jsp").forward(request, response);
    }
}
