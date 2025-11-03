package com.vaccination.controller;

import com.vaccination.dao.UserDAO;
import com.vaccination.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/doctors")
public class DoctorsListServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<User> doctors = new ArrayList<>();
        
        doctors.addAll(userDAO.findByRole("MEDICAL"));
        doctors.addAll(userDAO.findByRole("RECEPTION"));
        
        request.setAttribute("doctors", doctors);
        
        request.getRequestDispatcher("/views/guest/doctors.jsp").forward(request, response);
    }
}
