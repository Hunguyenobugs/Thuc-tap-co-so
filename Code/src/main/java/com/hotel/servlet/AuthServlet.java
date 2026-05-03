package com.hotel.servlet;

import com.hotel.dao.UserDAO;
import com.hotel.model.User;
import com.hotel.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/auth")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 5,      // 5 MB
    maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class AuthServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "loginPage";

        switch (action) {
            case "loginPage":
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                break;
            case "logout":
                HttpSession session = req.getSession(false);
                if (session != null) session.invalidate();
                resp.sendRedirect(req.getContextPath() + "/auth?action=loginPage&msg=logout_success");
                break;
            case "profilePage":
                req.getRequestDispatcher("/WEB-INF/views/admin/admin_profile.jsp").forward(req, resp);
                break;
            case "changePasswordPage":
                req.getRequestDispatcher("/WEB-INF/views/change_password.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/auth?action=loginPage");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("login".equals(action)) {
            doLogin(req, resp);
        } else if ("changePassword".equals(action)) {
            doChangePassword(req, resp);
        } else if ("updateProfile".equals(action)) {
            doUpdateProfile(req, resp);
        }
    }

    private void doLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = userDAO.findByUsername(username);
        if (user == null || !PasswordUtil.verify(password, user.getPasswordHash())) {
            req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        if ("inactive".equals(user.getStatus())) {
            req.setAttribute("error", "Tài khoản đã bị khóa, vui lòng liên hệ quản trị viên");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("currentUser", user);

        switch (user.getRole()) {
            case "ADMIN":
                resp.sendRedirect(req.getContextPath() + "/admin/home");
                break;
            case "MANAGER":
                resp.sendRedirect(req.getContextPath() + "/manager/home");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/staff/home");
        }
    }

    private void doChangePassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        String currentPw = req.getParameter("currentPassword");
        String newPw = req.getParameter("newPassword");
        String confirmPw = req.getParameter("confirmPassword");

        if (!PasswordUtil.verify(currentPw, user.getPasswordHash())) {
            req.setAttribute("error", "Mật khẩu hiện tại không đúng");
            req.getRequestDispatcher("/WEB-INF/views/change_password.jsp").forward(req, resp);
            return;
        }

        if (!newPw.equals(confirmPw)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp, vui lòng nhập lại");
            req.getRequestDispatcher("/WEB-INF/views/change_password.jsp").forward(req, resp);
            return;
        }

        String newHash = PasswordUtil.hash(newPw);
        userDAO.updatePassword(user.getId(), newHash);
        user.setPasswordHash(newHash);
        session.setAttribute("currentUser", user);

        String redirectUrl;
        switch (user.getRole()) {
            case "ADMIN": redirectUrl = "/admin/home"; break;
            case "MANAGER": redirectUrl = "/manager/home"; break;
            default: redirectUrl = "/staff/home";
        }
        resp.sendRedirect(req.getContextPath() + redirectUrl + "?msg=password_changed");
    }

    private void doUpdateProfile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("currentUser");
        
        user.setFullName(req.getParameter("fullName"));
        user.setEmail(req.getParameter("email"));
        user.setPhone(req.getParameter("phone"));
        user.setDescription(req.getParameter("description"));
        
        try {
            Part filePart = req.getPart("avatarFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = req.getServletContext().getRealPath("") + File.separator + "images" + File.separator + "avatars";
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                filePart.write(uploadPath + File.separator + fileName);
                user.setAvatarUrl("/images/avatars/" + fileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Handle error or just ignore if no file is uploaded
        }
        
        userDAO.update(user); // update the db
        session.setAttribute("currentUser", user); // update session
        
        resp.sendRedirect(req.getContextPath() + "/auth?action=profilePage&msg=profile_updated");
    }
}
