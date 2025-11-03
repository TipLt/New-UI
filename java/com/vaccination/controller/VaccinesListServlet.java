package com.vaccination.controller;

import com.vaccination.dao.VaccineDAO;
import com.vaccination.model.Vaccine;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/vaccines")
public class VaccinesListServlet extends HttpServlet {
    
    private VaccineDAO vaccineDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        vaccineDAO = new VaccineDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Vaccine> vaccines = vaccineDAO.getAllVaccines();
        
        request.setAttribute("vaccines", vaccines);
        
        request.getRequestDispatcher("/views/guest/vaccines.jsp").forward(request, response);
    }
}
