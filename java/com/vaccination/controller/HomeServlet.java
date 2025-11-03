package com.vaccination.controller;

import com.vaccination.dao.VaccineDAO;
import com.vaccination.dao.CenterDAO;
import com.vaccination.dao.UserDAO; // Import UserDAO
import com.vaccination.model.Vaccine;
import com.vaccination.model.Center;
import com.vaccination.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet({"/home"})
public class HomeServlet extends HttpServlet {

    // Tạo đối tượng DAO
    private VaccineDAO vaccineDAO = new VaccineDAO();
    private CenterDAO centerDAO = new CenterDAO();
    private UserDAO userDAO = new UserDAO(); // <<<===== THÊM DÒNG NÀY

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ DAO
        List<Vaccine> vaccines = vaccineDAO.getAllVaccines(); // Lấy hết hoặc chỉ vài cái nổi bật
        List<Center> centers = centerDAO.getAllCenters(); // Lấy danh sách trung tâm (nếu cần)
        List<User> doctors = userDAO.findByRole("MEDICAL"); // <<<===== SỬA DÒNG NÀY (gọi qua userDAO)

        // Đặt dữ liệu vào request attribute để JSP dùng
        request.setAttribute("vaccines", vaccines);
        request.setAttribute("centers", centers); // Gửi cả center nếu JSP cần dùng
        request.setAttribute("doctors", doctors); // <<<===== THÊM DÒNG NÀY

        // Forward sang JSP
        request.getRequestDispatcher("/views/guest/home.jsp").forward(request, response);
    }
}
