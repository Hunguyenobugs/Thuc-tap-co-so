package com.hotel.filter;

import com.hotel.dao.HotelDAO;
import com.hotel.model.Hotel;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class EncodingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        ServletContext application = request.getServletContext();
        if (application.getAttribute("hotelInfo") == null) {
            try {
                HotelDAO hotelDAO = new HotelDAO();
                Hotel hotel = hotelDAO.getHotelInfo();
                if (hotel != null) {
                    application.setAttribute("hotelInfo", hotel);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        chain.doFilter(request, response);
    }
}

