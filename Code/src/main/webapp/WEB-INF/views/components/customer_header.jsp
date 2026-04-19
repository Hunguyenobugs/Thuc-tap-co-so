<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="base" value="${pageContext.request.contextPath}"/>
<c:set var="cust" value="${sessionScope.currentCustomer}"/>
<header class="customer-header">
    <div class="customer-header-inner">
        <a href="${base}/home" class="logo">🏨 Grand <span>Lotus</span></a>
        <nav class="customer-nav">
            <a href="${base}/home">Trang chủ</a>
            <a href="${base}/search">Tìm phòng</a>
            <c:choose>
                <c:when test="${cust != null}">
                    <a href="${base}/bookingHistory">Lịch sử đặt</a>
                    <a href="${base}/customerAuth?action=logout" class="btn btn-outline btn-sm">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="${base}/customerAuth?action=loginPage" class="btn btn-outline btn-sm">Đăng nhập</a>
                    <a href="${base}/customerAuth?action=registerPage" class="btn btn-primary btn-sm">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>
