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

        String uri = req.getRequestURI();
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

        if (uri.contains("/admin/") && !"ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/auth?action=loginPage&error=unauthorized");
            return;
        }
        if (uri.contains("/manager/") && !"MANAGER".equals(role) && !"ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/auth?action=loginPage&error=unauthorized");
            return;
        }
        if (uri.contains("/staff/") && !"STAFF".equals(role) && !"MANAGER".equals(role) && !"ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/auth?action=loginPage&error=unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }
}
