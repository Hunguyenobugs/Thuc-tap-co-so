package com.hotel.servlet;

import com.hotel.dao.CustomerDAO;
import com.hotel.model.Customer;
import com.hotel.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/customerAuth")
public class CustomerAuthServlet extends HttpServlet {
    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "loginPage";

        switch (action) {
            case "loginPage":
                req.getRequestDispatcher("/WEB-INF/views/customer/customer_login.jsp").forward(req, resp);
                break;
            case "registerPage":
                req.getRequestDispatcher("/WEB-INF/views/customer/customer_register.jsp").forward(req, resp);
                break;
            case "logout":
                HttpSession session = req.getSession(false);
                if (session != null) session.invalidate();
                resp.sendRedirect(req.getContextPath() + "/home");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/customerAuth?action=loginPage");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("login".equals(action)) {
            doLogin(req, resp);
        } else if ("register".equals(action)) {
            doRegister(req, resp);
        }
    }

    private void doLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String input = req.getParameter("emailOrPhone");
        String password = req.getParameter("password");

        Customer c = customerDAO.findByEmailOrPhone(input);
        if (c == null || c.getPasswordHash() == null || !PasswordUtil.verify(password, c.getPasswordHash())) {
            req.setAttribute("error", "Email/SĐT hoặc mật khẩu không chính xác");
            req.getRequestDispatcher("/WEB-INF/views/customer/customer_login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("currentCustomer", c);

        String returnUrl = (String) session.getAttribute("returnUrl");
        if (returnUrl != null) {
            session.removeAttribute("returnUrl");
            resp.sendRedirect(returnUrl);
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    private void doRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String idCard = req.getParameter("idCard");
        String birthDate = req.getParameter("birthDate");
        String gender = req.getParameter("gender");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String address = req.getParameter("address");

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp, vui lòng nhập lại");
            req.getRequestDispatcher("/WEB-INF/views/customer/customer_register.jsp").forward(req, resp);
            return;
        }

        if (customerDAO.existsByEmail(email)) {
            req.setAttribute("error", "Email này đã được đăng ký, vui lòng dùng email khác");
            req.getRequestDispatcher("/WEB-INF/views/customer/customer_register.jsp").forward(req, resp);
            return;
        }

        if (customerDAO.existsByPhone(phone)) {
            req.setAttribute("error", "Số điện thoại đã được đăng ký");
            req.getRequestDispatcher("/WEB-INF/views/customer/customer_register.jsp").forward(req, resp);
            return;
        }

        Customer c = new Customer();
        c.setFullName(fullName);
        c.setIdCard(idCard);
        c.setIdType("CCCD");
        if (birthDate != null && !birthDate.isEmpty()) c.setBirthDate(java.sql.Date.valueOf(birthDate));
        c.setGender(gender);
        c.setPhone(phone);
        c.setEmail(email);
        c.setAddress(address);
        c.setPasswordHash(PasswordUtil.hash(password));

        customerDAO.insert(c);
        resp.sendRedirect(req.getContextPath() + "/customerAuth?action=loginPage&msg=register_success");
    }
}
