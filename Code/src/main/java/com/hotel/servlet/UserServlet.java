package com.hotel.servlet;

import com.hotel.dao.UserDAO;
import com.hotel.model.User;
import com.hotel.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/user")
public class UserServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "manage";
        switch (action) {
            case "add":
                req.getRequestDispatcher("/WEB-INF/views/admin/add_user.jsp").forward(req, resp); break;
            case "edit":
                req.setAttribute("editUser", dao.findById(Integer.parseInt(req.getParameter("id"))));
                req.getRequestDispatcher("/WEB-INF/views/admin/edit_user.jsp").forward(req, resp); break;
            case "delete":
                int id = Integer.parseInt(req.getParameter("id"));
                User currentUser = (User) req.getSession().getAttribute("currentUser");
                if (currentUser != null && currentUser.getId() == id) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=manage&error=self_delete");
                } else {
                    dao.delete(id); 
                    resp.sendRedirect(req.getContextPath() + "/admin/user?msg=delete_success");
                }
                break;
            case "restore":
                int rid = Integer.parseInt(req.getParameter("id"));
                dao.restore(rid);
                resp.sendRedirect(req.getContextPath() + "/admin/user?msg=restore_success");
                break;
            default:
                String kw = req.getParameter("keyword");
                if (kw == null) kw = "";
                req.setAttribute("results", dao.searchByUsernameOrCode(kw));
                req.setAttribute("keyword", kw);
                req.getRequestDispatcher("/WEB-INF/views/admin/manage_user.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("insert".equals(action)) {
            String username = req.getParameter("username");
            String pw = req.getParameter("password");
            String confirmPw = req.getParameter("confirmPassword");
            String empCode = req.getParameter("employeeCode");

            User u = new User();
            u.setEmployeeCode(empCode); 
            u.setUsername(username);
            u.setFullName(req.getParameter("fullName"));
            u.setEmail(req.getParameter("email")); 
            u.setPhone(req.getParameter("phone"));
            u.setRole(req.getParameter("role")); 
            u.setDescription(req.getParameter("description"));
            String jd = req.getParameter("joinDate");
            if (jd != null && !jd.isEmpty()) u.setJoinDate(java.sql.Date.valueOf(jd));

            if (!pw.equals(confirmPw)) {
                req.setAttribute("error", "Mật khẩu xác nhận không khớp");
                req.setAttribute("inputUser", u);
                req.getRequestDispatcher("/WEB-INF/views/admin/add_user.jsp").forward(req, resp); return;
            }
            if (dao.existsByUsername(username)) {
                req.setAttribute("error", "Tên đăng nhập đã được sử dụng, vui lòng chọn tên khác");
                req.setAttribute("inputUser", u);
                req.getRequestDispatcher("/WEB-INF/views/admin/add_user.jsp").forward(req, resp); return;
            }
            if (dao.existsByEmployeeCode(empCode)) {
                req.setAttribute("error", "Mã nhân viên đã tồn tại, vui lòng nhập mã khác");
                req.setAttribute("inputUser", u);
                req.getRequestDispatcher("/WEB-INF/views/admin/add_user.jsp").forward(req, resp); return;
            }

            u.setPasswordHash(PasswordUtil.hash(pw)); 
            dao.insert(u);
            resp.sendRedirect(req.getContextPath() + "/admin/user?msg=add_success");
        } else if ("update".equals(action)) {
            User u = dao.findById(Integer.parseInt(req.getParameter("id")));
            
            String newUsername = req.getParameter("username");
            if (newUsername != null && !newUsername.isEmpty() && !newUsername.equals(u.getUsername()) && dao.existsByUsername(newUsername)) {
                req.setAttribute("error", "Tên đăng nhập đã tồn tại!");
                req.setAttribute("editUser", u);
                req.getRequestDispatcher("/WEB-INF/views/admin/edit_user.jsp").forward(req, resp);
                return;
            }
            if (newUsername != null && !newUsername.isEmpty()) {
                u.setUsername(newUsername);
            }
            
            String newPw = req.getParameter("password");
            if (newPw != null && !newPw.trim().isEmpty()) {
                u.setPasswordHash(PasswordUtil.hash(newPw));
            }

            u.setFullName(req.getParameter("fullName")); u.setEmail(req.getParameter("email"));
            u.setPhone(req.getParameter("phone")); u.setRole(req.getParameter("role"));
            u.setStatus(req.getParameter("status")); u.setDescription(req.getParameter("description"));
            dao.update(u);
            resp.sendRedirect(req.getContextPath() + "/admin/user?msg=update_success");
        }
    }
}
