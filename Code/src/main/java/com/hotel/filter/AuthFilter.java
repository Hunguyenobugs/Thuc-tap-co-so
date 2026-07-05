package com.hotel.filter;

import com.hotel.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String path = req.getServletPath();

        // Cho phép truy cập static resources và các đường dẫn công khai
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/") || 
            path.equals("/auth") || path.equals("/customerAuth") || path.equals("/home") || 
            path.equals("/search") || path.equals("/")) {
            chain.doFilter(request, response);
            return;
        }

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/auth?action=loginPage");
            return;
        }

        String role = user.getRole();

        // Phân quyền nghiêm ngặt: mỗi role chỉ truy cập đúng đường dẫn của mình
        if (path.startsWith("/admin/") && !"ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/" + role.toLowerCase() + "/home");
            return;
        }
        if (path.startsWith("/manager/") && !"MANAGER".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/" + role.toLowerCase() + "/home");
            return;
        }
        if (path.startsWith("/staff/") && !"STAFF".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/" + role.toLowerCase() + "/home");
            return;
        }

        chain.doFilter(request, response);
    }
}
