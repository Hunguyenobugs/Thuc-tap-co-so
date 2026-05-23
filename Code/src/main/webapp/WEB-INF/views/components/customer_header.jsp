<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="base" value="${pageContext.request.contextPath}"/>
<c:set var="cust" value="${sessionScope.currentCustomer}"/>
<%
    com.hotel.model.Customer custObj = (com.hotel.model.Customer) session.getAttribute("currentCustomer");
    String avatarName = (custObj != null && custObj.getFullName() != null && !custObj.getFullName().isEmpty()) 
                        ? custObj.getFullName().substring(0, 1).toUpperCase() 
                        : "U";
%>

<header class="customer-header">
    <div class="customer-header-inner">
        <a href="${base}/home" class="logo" style="display: flex; align-items: center; gap: 10px;">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" style="height: 35px; width: 35px; border-radius: 50%; object-fit: cover;">
            <c:choose><c:when test="${not empty applicationScope.hotelInfo.name}">${applicationScope.hotelInfo.name}</c:when><c:otherwise>Grand Lotus</c:otherwise></c:choose>
        </a>
        <nav class="customer-nav">
            <a href="${base}/home">Trang chủ</a>
            <c:choose>
                <c:when test="${cust != null}">
                    <a href="${base}/bookingHistory">Lịch sử đặt</a>
                    <div class="user-menu">
                        <div class="user-info">
                            <strong>${cust.fullName}</strong>
                        </div>
                        <div class="avatar">
                            <%= avatarName %>
                        </div>
                        <div class="dropdown-menu">
                            <a href="${base}/customerAuth?action=editProfilePage">Thông tin cá nhân</a>
                            <a href="${base}/customerAuth?action=changePasswordPage">Đổi mật khẩu</a>
                            <a href="${base}/customerAuth?action=logout" class="logout">Đăng xuất</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${base}/customerAuth?action=loginPage" class="btn btn-outline btn-sm">Đăng nhập</a>
                    <a href="${base}/customerAuth?action=registerPage" class="btn btn-primary btn-sm">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>
