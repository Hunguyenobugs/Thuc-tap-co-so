package com.hotel.servlet;

import com.hotel.dao.CustomerDAO;
import com.hotel.model.Customer;
import com.hotel.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/customer")
public class CustomerAccountServlet extends HttpServlet {
    private final CustomerDAO dao = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "manage";
        switch (action) {
            case "add":
                req.getRequestDispatcher("/WEB-INF/views/admin/add_customer.jsp").forward(req, resp);
                break;
            case "edit":
                int editId = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("editCustomer", dao.findById(editId));
                req.getRequestDispatcher("/WEB-INF/views/admin/edit_customer.jsp").forward(req, resp);
                break;
            case "delete":
                int deleteId = Integer.parseInt(req.getParameter("id"));
                try {
                    dao.delete(deleteId);
                    resp.sendRedirect(req.getContextPath() + "/admin/customer?action=manage&msg=delete_success");
                } catch (SQLException e) {
                    resp.sendRedirect(req.getContextPath() + "/admin/customer?action=manage&error=foreign_key");
                }
                break;
            case "restore":
                int restoreId = Integer.parseInt(req.getParameter("id"));
                dao.restore(restoreId);
                resp.sendRedirect(req.getContextPath() + "/admin/customer?action=manage&msg=restore_success");
                break;
            default:
                String kw = req.getParameter("keyword");
                if (kw == null) kw = "";
                req.setAttribute("results", dao.searchByKeyword(kw));
                req.setAttribute("keyword", kw);
                req.getRequestDispatcher("/WEB-INF/views/admin/manage_customer.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("insert".equals(action)) {
            String idCard = req.getParameter("idCard");
            String idType = req.getParameter("idType");
            String fullName = req.getParameter("fullName");
            String nationality = req.getParameter("nationality");
            String birthDateStr = req.getParameter("birthDate");
            String gender = req.getParameter("gender");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            String address = req.getParameter("address");
            String pw = req.getParameter("password");
            String confirmPw = req.getParameter("confirmPassword");

            Customer c = new Customer();
            c.setIdCard(idCard);
            c.setIdType(idType);
            c.setFullName(fullName);
            c.setNationality(nationality);
            if (birthDateStr != null && !birthDateStr.isEmpty()) {
                c.setBirthDate(java.sql.Date.valueOf(birthDateStr));
            }
            c.setGender(gender);
            c.setPhone(phone);
            c.setEmail(email);
            c.setAddress(address);

            if (pw != null && !pw.isEmpty()) {
                if (!pw.equals(confirmPw)) {
                    req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                    req.setAttribute("inputCustomer", c);
                    req.getRequestDispatcher("/WEB-INF/views/admin/add_customer.jsp").forward(req, resp);
                    return;
                }
            } else {
                req.setAttribute("error", "Vui lòng nhập mật khẩu!");
                req.setAttribute("inputCustomer", c);
                req.getRequestDispatcher("/WEB-INF/views/admin/add_customer.jsp").forward(req, resp);
                return;
            }

            if (dao.existsByIdCard(idCard)) {
                req.setAttribute("error", "Số CCCD/Hộ chiếu đã tồn tại!");
                req.setAttribute("inputCustomer", c);
                req.getRequestDispatcher("/WEB-INF/views/admin/add_customer.jsp").forward(req, resp);
                return;
            }
            if (dao.existsByPhone(phone)) {
                req.setAttribute("error", "Số điện thoại đã được sử dụng!");
                req.setAttribute("inputCustomer", c);
                req.getRequestDispatcher("/WEB-INF/views/admin/add_customer.jsp").forward(req, resp);
                return;
            }
            if (email != null && !email.isEmpty() && dao.existsByEmail(email)) {
                req.setAttribute("error", "Email đã được sử dụng!");
                req.setAttribute("inputCustomer", c);
                req.getRequestDispatcher("/WEB-INF/views/admin/add_customer.jsp").forward(req, resp);
                return;
            }

            c.setPasswordHash(PasswordUtil.hash(pw));
            dao.insert(c);
            resp.sendRedirect(req.getContextPath() + "/admin/customer?msg=add_success");

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Customer c = dao.findById(id);

            String idCard = req.getParameter("idCard");
            String idType = req.getParameter("idType");
            String fullName = req.getParameter("fullName");
            String nationality = req.getParameter("nationality");
            String birthDateStr = req.getParameter("birthDate");
            String gender = req.getParameter("gender");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            String address = req.getParameter("address");
            String pw = req.getParameter("password");
            String confirmPw = req.getParameter("confirmPassword");
            String status = req.getParameter("status");
            if (status == null || status.isEmpty()) status = "active";

            Customer temp = new Customer();
            temp.setId(id);
            temp.setIdCard(idCard);
            temp.setIdType(idType);
            temp.setFullName(fullName);
            temp.setNationality(nationality);
            if (birthDateStr != null && !birthDateStr.isEmpty()) {
                temp.setBirthDate(java.sql.Date.valueOf(birthDateStr));
            }
            temp.setGender(gender);
            temp.setPhone(phone);
            temp.setEmail(email);
            temp.setAddress(address);
            temp.setStatus(status);

            if (idCard != null && !idCard.equals(c.getIdCard()) && dao.existsByIdCardExcludeId(idCard, id)) {
                req.setAttribute("error", "Số CCCD/Hộ chiếu đã tồn tại!");
                req.setAttribute("editCustomer", temp);
                req.getRequestDispatcher("/WEB-INF/views/admin/edit_customer.jsp").forward(req, resp);
                return;
            }
            if (phone != null && !phone.equals(c.getPhone()) && dao.existsByPhoneExcludeId(phone, id)) {
                req.setAttribute("error", "Số điện thoại đã được sử dụng!");
                req.setAttribute("editCustomer", temp);
                req.getRequestDispatcher("/WEB-INF/views/admin/edit_customer.jsp").forward(req, resp);
                return;
            }
            if (email != null && !email.isEmpty() && !email.equals(c.getEmail()) && dao.existsByEmailExcludeId(email, id)) {
                req.setAttribute("error", "Email đã được sử dụng!");
                req.setAttribute("editCustomer", temp);
                req.getRequestDispatcher("/WEB-INF/views/admin/edit_customer.jsp").forward(req, resp);
                return;
            }

            if (pw != null && !pw.trim().isEmpty()) {
                if (!pw.equals(confirmPw)) {
                    req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                    req.setAttribute("editCustomer", temp);
                    req.getRequestDispatcher("/WEB-INF/views/admin/edit_customer.jsp").forward(req, resp);
                    return;
                }
                c.setPasswordHash(PasswordUtil.hash(pw));
            }

            c.setIdCard(idCard);
            c.setIdType(idType);
            c.setFullName(fullName);
            c.setNationality(nationality);
            if (birthDateStr != null && !birthDateStr.isEmpty()) {
                c.setBirthDate(java.sql.Date.valueOf(birthDateStr));
            } else {
                c.setBirthDate(null);
            }
            c.setGender(gender);
            c.setPhone(phone);
            c.setEmail(email);
            c.setAddress(address);
            c.setStatus(status);

            dao.update(c);
            resp.sendRedirect(req.getContextPath() + "/admin/customer?msg=update_success");
        }
    }
}
