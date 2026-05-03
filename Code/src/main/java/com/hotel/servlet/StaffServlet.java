package com.hotel.servlet;

import com.hotel.dao.UserDAO;
import com.hotel.model.User;
import com.hotel.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/manager/staff")
public class StaffServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "manage";
        switch (action) {
            case "add":
                req.getRequestDispatcher("/WEB-INF/views/manager/add_staff.jsp").forward(req, resp); break;
            case "search":
                String kw = req.getParameter("keyword");
                if (kw != null && !kw.trim().isEmpty()) {
                    req.setAttribute("results", dao.searchByUsernameOrCode(kw));
                    req.setAttribute("keyword", kw);
                } else {
                    req.setAttribute("results", dao.getAll());
                }
                req.getRequestDispatcher("/WEB-INF/views/manager/manage_staff.jsp").forward(req, resp);
                break;
            case "edit":
                req.setAttribute("staff", dao.findById(Integer.parseInt(req.getParameter("id"))));
                req.getRequestDispatcher("/WEB-INF/views/manager/edit_staff.jsp").forward(req, resp); break;
            case "delete":
                int id = Integer.parseInt(req.getParameter("id"));
                if (dao.hasRelatedData(id)) {
                    resp.sendRedirect(req.getContextPath() + "/manager/staff?action=search&keyword=&error=has_data");
                } else { dao.delete(id); resp.sendRedirect(req.getContextPath() + "/manager/staff?msg=delete_success"); }
                break;
            default:
                req.setAttribute("staff", dao.getAll());
                req.getRequestDispatcher("/WEB-INF/views/manager/manage_staff.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("insert".equals(action)) {
            String email = req.getParameter("email");
            if (dao.existsByEmail(email)) {
                req.setAttribute("error", "Email đã được sử dụng, vui lòng nhập email khác");
                req.getRequestDispatcher("/WEB-INF/views/manager/add_staff.jsp").forward(req, resp); return;
            }
            User u = new User();
            u.setFullName(req.getParameter("fullName")); u.setEmail(email); u.setPhone(req.getParameter("phone"));
            u.setRole(req.getParameter("role")); u.setDescription(req.getParameter("description"));
            u.setEmployeeCode(req.getParameter("employeeCode")); u.setUsername(req.getParameter("username"));
            u.setPasswordHash(PasswordUtil.hash("@Hotel2025"));
            String jd = req.getParameter("joinDate");
            if (jd != null && !jd.isEmpty()) u.setJoinDate(java.sql.Date.valueOf(jd));
            dao.insert(u);
            resp.sendRedirect(req.getContextPath() + "/manager/staff?msg=add_success");
        } else if ("update".equals(action)) {
            User u = dao.findById(Integer.parseInt(req.getParameter("id")));
            u.setFullName(req.getParameter("fullName")); u.setEmail(req.getParameter("email"));
            u.setPhone(req.getParameter("phone")); u.setRole(req.getParameter("role"));
            u.setDescription(req.getParameter("description"));
            String jd = req.getParameter("joinDate");
            if (jd != null && !jd.isEmpty()) u.setJoinDate(java.sql.Date.valueOf(jd));
            dao.update(u);
            resp.sendRedirect(req.getContextPath() + "/manager/staff?msg=update_success");
        }
    }
}
