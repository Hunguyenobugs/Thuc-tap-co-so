package com.hotel.servlet;

import com.hotel.dao.ServiceDAO;
import com.hotel.model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/manager/service")
public class ServiceServlet extends HttpServlet {
    private final ServiceDAO dao = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "manage";
        switch (action) {
            case "add":
                req.getRequestDispatcher("/WEB-INF/views/manager/add_service.jsp").forward(req, resp); break;
            case "search":
                String kw = req.getParameter("keyword");
                if (kw != null && !kw.trim().isEmpty()) {
                    req.setAttribute("results", dao.searchByName(kw));
                    req.setAttribute("keyword", kw);
                } else {
                    req.setAttribute("results", dao.getAll());
                }
                req.getRequestDispatcher("/WEB-INF/views/manager/manage_service.jsp").forward(req, resp);
                break;
            case "edit":
                req.setAttribute("service", dao.findById(Integer.parseInt(req.getParameter("id"))));
                req.getRequestDispatcher("/WEB-INF/views/manager/edit_service.jsp").forward(req, resp); break;
            case "delete":
                int id = Integer.parseInt(req.getParameter("id"));
                if (dao.isUsedInInvoice(id)) { resp.sendRedirect(req.getContextPath() + "/manager/service?action=search&keyword=&error=in_use"); }
                else { dao.delete(id); resp.sendRedirect(req.getContextPath() + "/manager/service?msg=delete_success"); } break;
            default:
                req.setAttribute("services", dao.getAll());
                req.getRequestDispatcher("/WEB-INF/views/manager/manage_service.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String name = req.getParameter("name");
        String priceStr = req.getParameter("price");
        if ("insert".equals(action)) {
            if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty()) {
                req.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
                req.getRequestDispatcher("/WEB-INF/views/manager/add_service.jsp").forward(req, resp); return;
            }
            Service s = new Service();
            s.setName(name.trim()); s.setCategory(req.getParameter("category")); s.setUnit(req.getParameter("unit"));
            s.setPrice(new BigDecimal(priceStr.trim())); s.setDescription(req.getParameter("description"));
            dao.insert(s);
            resp.sendRedirect(req.getContextPath() + "/manager/service?msg=add_success");
        } else if ("update".equals(action)) {
            Service s = new Service();
            s.setId(Integer.parseInt(req.getParameter("id"))); s.setName(name); s.setCategory(req.getParameter("category"));
            s.setUnit(req.getParameter("unit")); s.setPrice(new BigDecimal(priceStr)); s.setDescription(req.getParameter("description"));
            dao.update(s);
            resp.sendRedirect(req.getContextPath() + "/manager/service?msg=update_success");
        }
    }
}
