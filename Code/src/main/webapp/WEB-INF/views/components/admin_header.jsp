<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="user" value="${sessionScope.currentUser}"/>
<header class="admin-header">
    <div class="logo">
        <span style="font-size: 24px;">🏨</span>
        <h2>Grand Lotus Admin</h2>
    </div>
    
    <div class="user-menu">
        <div class="user-info">
            <strong>${user.fullName}</strong>
            <span>${user.role}</span>
        </div>
        <div class="avatar">
            <c:choose>
                <c:when test="${not empty user.avatarUrl}">
                    <img src="${pageContext.request.contextPath}${user.avatarUrl}" alt="Avatar" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">
                </c:when>
                <c:otherwise>
                    ${user.fullName.substring(0, 1).toUpperCase()}
                </c:otherwise>
            </c:choose>
        </div>
        <div class="dropdown-menu">
            <a href="${pageContext.request.contextPath}/auth?action=profilePage">👤 Đổi thông tin cá nhân</a>
            <a href="${pageContext.request.contextPath}/auth?action=changePasswordPage">🔒 Đổi mật khẩu</a>
            <a href="${pageContext.request.contextPath}/auth?action=logout" class="logout">🚪 Đăng xuất</a>
        </div>
    </div>
</header>
