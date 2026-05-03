<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Đổi mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout ${sessionScope.currentUser.role == 'ADMIN' ? 'admin-layout' : ''}">
    <jsp:include page="components/sidebar.jsp"/>
    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
        <jsp:include page="components/admin_header.jsp"/>
    </c:if>
    <main class="main-content fade-in">
        <div class="topbar"><div><h1>🔒 Đổi <span>mật khẩu</span></h1></div></div>
        <c:if test="${error != null}"><div class="alert alert-danger">⚠️ ${error}</div></c:if>
        <div class="card" style="max-width:500px; margin: 0 auto;">
            <form method="post" action="${pageContext.request.contextPath}/auth">
                <input type="hidden" name="action" value="changePassword">
                <div class="form-group">
                    <label>Mật khẩu hiện tại <span class="required">*</span></label>
                    <input type="password" name="currentPassword" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Mật khẩu mới <span class="required">*</span></label>
                    <input type="password" name="newPassword" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Xác nhận mật khẩu mới <span class="required">*</span></label>
                    <input type="password" name="confirmPassword" class="form-control" required>
                </div>
                <div style="text-align: center; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary">Đổi mật khẩu</button>
                </div>
            </form>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
