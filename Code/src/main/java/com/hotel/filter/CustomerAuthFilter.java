package com.hotel.filter;

import com.hotel.model.Customer;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class CustomerAuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        Customer customer = (session != null) ? (Customer) session.getAttribute("currentCustomer") : null;

        if (customer == null) {
            String returnUrl = req.getRequestURI();
            if (req.getQueryString() != null) returnUrl += "?" + req.getQueryString();
            req.getSession(true).setAttribute("returnUrl", returnUrl);
            res.sendRedirect(req.getContextPath() + "/customerAuth?action=loginPage");
            return;
        }

        chain.doFilter(request, response);
    }
}
