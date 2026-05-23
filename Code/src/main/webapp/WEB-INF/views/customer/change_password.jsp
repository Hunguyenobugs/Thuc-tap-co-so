<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Đổi mật khẩu - ${applicationScope.hotelInfo.name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="customer-page">
<jsp:include page="../components/customer_header.jsp"/>
<section class="section fade-in">
    <div class="topbar" style="margin-bottom: 24px;">
        <div><h1>Đổi <span>mật khẩu</span></h1></div>
    </div>
    
    <div style="max-width:500px; margin: 0 auto;">
        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success">Đổi mật khẩu thành công!</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
 
        <div class="card">
            <form method="post" action="${pageContext.request.contextPath}/customerAuth">
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
                
                <div class="btn-group" style="margin-top: 24px; justify-content: center;">
                    <button type="submit" class="btn btn-primary">Đổi mật khẩu</button>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline">← Hủy</a>
                </div>
            </form>
        </div>
    </div>
</section>
<footer class="customer-footer">© 2025 ${applicationScope.hotelInfo.name}</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
