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
            case "editProfilePage": {
                HttpSession session = req.getSession(false);
                Customer c = (session != null) ? (Customer) session.getAttribute("currentCustomer") : null;
                if (c == null) {
                    resp.sendRedirect(req.getContextPath() + "/customerAuth?action=loginPage");
                    return;
                }
                req.setAttribute("customer", c);
                req.getRequestDispatcher("/WEB-INF/views/customer/edit_profile.jsp").forward(req, resp);
                break;
            }
            case "changePasswordPage": {
                HttpSession session = req.getSession(false);
                Customer c = (session != null) ? (Customer) session.getAttribute("currentCustomer") : null;
                if (c == null) {
                    resp.sendRedirect(req.getContextPath() + "/customerAuth?action=loginPage");
                    return;
                }
                req.getRequestDispatcher("/WEB-INF/views/customer/change_password.jsp").forward(req, resp);
                break;
            }
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
        } else if ("editProfile".equals(action)) {
            doEditProfile(req, resp);
        } else if ("changePassword".equals(action)) {
            doChangePassword(req, resp);
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

        if ("inactive".equals(c.getStatus())) {
            req.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
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
        String fullName = req.getParameter("fullName") != null ? req.getParameter("fullName").trim() : null;
        String idCard = req.getParameter("idCard") != null ? req.getParameter("idCard").trim() : null;
        String birthDate = req.getParameter("birthDate") != null ? req.getParameter("birthDate").trim() : null;
        String gender = req.getParameter("gender");
        String phone = req.getParameter("phone") != null ? req.getParameter("phone").trim() : null;
        String email = req.getParameter("email") != null ? req.getParameter("email").trim() : null;
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String address = req.getParameter("address") != null ? req.getParameter("address").trim() : null;

        if (gender != null && gender.trim().isEmpty()) gender = null;
        if (idCard != null && idCard.trim().isEmpty()) idCard = null;
        if (phone != null && phone.trim().isEmpty()) phone = null;

        if (idCard == null) {
            req.setAttribute("error", "Vui lòng nhập Số CCCD/Hộ chiếu.");
            req.getRequestDispatcher("/WEB-INF/views/customer/customer_register.jsp").forward(req, resp);
            return;
        }

        if (phone == null) {
            req.setAttribute("error", "Vui lòng nhập Số điện thoại.");
            req.getRequestDispatcher("/WEB-INF/views/customer/customer_register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp, vui lòng nhập lại");
            req.getRequestDispatcher("/WEB-INF/views/customer/customer_register.jsp").forward(req, resp);
            return;
        }

        Customer existing = null;
        if (email != null || phone != null || idCard != null) {
            existing = customerDAO.findByEmailOrPhoneOrIdCard(email, phone, idCard);
        }

        if (existing != null) {
            if (existing.getPasswordHash() != null) {
                req.setAttribute("error", "Thông tin Email, Số điện thoại hoặc CCCD này đã có tài khoản trực tuyến. Vui lòng đăng nhập.");
                req.getRequestDispatcher("/WEB-INF/views/customer/customer_register.jsp").forward(req, resp);
                return;
            } else {
                boolean emailMatch = (existing.getEmail() == null || existing.getEmail().trim().isEmpty() || existing.getEmail().equalsIgnoreCase(email));
                boolean phoneMatch = (existing.getPhone() != null && existing.getPhone().equals(phone));
                boolean idCardMatch = (existing.getIdCard() != null && existing.getIdCard().equals(idCard));

                if (emailMatch && phoneMatch && idCardMatch) {
                    // Trùng khớp hoàn toàn -> cho phép thiết lập mật khẩu
                    existing.setFullName(fullName);
                    existing.setIdCard(idCard);
                    existing.setIdType("CCCD");
                    if (birthDate != null && !birthDate.isEmpty()) existing.setBirthDate(java.sql.Date.valueOf(birthDate));
                    existing.setGender(gender);
                    existing.setPhone(phone);
                    existing.setEmail(email);
                    existing.setAddress(address);
                    existing.setPasswordHash(PasswordUtil.hash(password));

                    if (customerDAO.update(existing)) {
                        resp.sendRedirect(req.getContextPath() + "/customerAuth?action=loginPage&msg=register_success");
                    } else {
                        req.setAttribute("error", "Có lỗi xảy ra khi tạo tài khoản. Vui lòng thử lại.");
                        req.getRequestDispatcher("/WEB-INF/views/customer/customer_register.jsp").forward(req, resp);
                    }
                    return;
                } else {
                    req.setAttribute("error", "Thông tin của khách hàng đã có trong hệ thống. Vui lòng nhập đúng chính xác tất cả thông tin CCCD, Email (nếu có) và Số điện thoại cũ để đăng ký tài khoản online.");
                    req.getRequestDispatcher("/WEB-INF/views/customer/customer_register.jsp").forward(req, resp);
                    return;
                }
            }
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

    private void doEditProfile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Customer c = (session != null) ? (Customer) session.getAttribute("currentCustomer") : null;
        if (c == null) {
            resp.sendRedirect(req.getContextPath() + "/customerAuth?action=loginPage");
            return;
        }

        String fullName = req.getParameter("fullName") != null ? req.getParameter("fullName").trim() : null;
        String idCard = req.getParameter("idCard") != null ? req.getParameter("idCard").trim() : null;
        String birthDate = req.getParameter("birthDate") != null ? req.getParameter("birthDate").trim() : null;
        String gender = req.getParameter("gender");
        String phone = req.getParameter("phone") != null ? req.getParameter("phone").trim() : null;
        String email = req.getParameter("email") != null ? req.getParameter("email").trim() : null;
        String address = req.getParameter("address") != null ? req.getParameter("address").trim() : null;

        if (gender != null && gender.trim().isEmpty()) gender = null;
        if (idCard != null && idCard.trim().isEmpty()) idCard = null;
        if (phone != null && phone.trim().isEmpty()) phone = null;

        // Validate duplicates
        if (idCard != null && !idCard.equals(c.getIdCard()) && customerDAO.existsByIdCard(idCard)) {
            req.setAttribute("error", "Số CCCD/Hộ chiếu này đã được đăng ký bởi tài khoản khác");
            req.setAttribute("customer", c);
            req.getRequestDispatcher("/WEB-INF/views/customer/edit_profile.jsp").forward(req, resp);
            return;
        }
        if (!email.equals(c.getEmail()) && customerDAO.existsByEmail(email)) {
            req.setAttribute("error", "Email này đã được đăng ký bởi tài khoản khác");
            req.setAttribute("customer", c);
            req.getRequestDispatcher("/WEB-INF/views/customer/edit_profile.jsp").forward(req, resp);
            return;
        }
        if (!phone.equals(c.getPhone()) && customerDAO.existsByPhone(phone)) {
            req.setAttribute("error", "Số điện thoại đã được đăng ký bởi tài khoản khác");
            req.setAttribute("customer", c);
            req.getRequestDispatcher("/WEB-INF/views/customer/edit_profile.jsp").forward(req, resp);
            return;
        }

        c.setFullName(fullName);
        c.setIdCard(idCard);
        if (birthDate != null && !birthDate.isEmpty()) {
            c.setBirthDate(java.sql.Date.valueOf(birthDate));
        } else {
            c.setBirthDate(null);
        }
        c.setGender(gender);
        c.setPhone(phone);
        c.setEmail(email);
        c.setAddress(address);

        if (customerDAO.update(c)) {
            session.setAttribute("currentCustomer", c);
            resp.sendRedirect(req.getContextPath() + "/customerAuth?action=editProfilePage&msg=success");
        } else {
            req.setAttribute("error", "Cập nhật thông tin thất bại");
            req.setAttribute("customer", c);
            req.getRequestDispatcher("/WEB-INF/views/customer/edit_profile.jsp").forward(req, resp);
        }
    }

    private void doChangePassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Customer c = (session != null) ? (Customer) session.getAttribute("currentCustomer") : null;
        if (c == null) {
            resp.sendRedirect(req.getContextPath() + "/customerAuth?action=loginPage");
            return;
        }

        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (c.getPasswordHash() == null || !PasswordUtil.verify(currentPassword, c.getPasswordHash())) {
            req.setAttribute("error", "Mật khẩu hiện tại không chính xác");
            req.getRequestDispatcher("/WEB-INF/views/customer/change_password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            req.getRequestDispatcher("/WEB-INF/views/customer/change_password.jsp").forward(req, resp);
            return;
        }

        c.setPasswordHash(PasswordUtil.hash(newPassword));
        if (customerDAO.update(c)) {
            session.setAttribute("currentCustomer", c);
            resp.sendRedirect(req.getContextPath() + "/customerAuth?action=changePasswordPage&msg=success");
        } else {
            req.setAttribute("error", "Đổi mật khẩu thất bại");
            req.getRequestDispatcher("/WEB-INF/views/customer/change_password.jsp").forward(req, resp);
        }
    }
}
