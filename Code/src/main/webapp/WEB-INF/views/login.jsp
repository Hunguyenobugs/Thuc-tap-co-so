<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Đăng nhập - Hotel Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="login-page">
    <div class="login-box fade-in">
        <div class="logo">🏨</div>
        <h1>Grand Lotus Hotel</h1>
        <p class="subtitle">Hệ thống quản lý nội bộ</p>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">⚠️ ${error}</div>
        <% } %>
        <% if ("logout_success".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">✅ Đăng xuất thành công</div>
        <% } %>
        <form method="post" action="${pageContext.request.contextPath}/auth">
            <input type="hidden" name="action" value="login">
            <div class="form-group">
                <label>Tên đăng nhập <span class="required">*</span></label>
                <input type="text" name="username" class="form-control" placeholder="Nhập tên đăng nhập" required autofocus>
            </div>
            <div class="form-group">
                <label>Mật khẩu <span class="required">*</span></label>
                <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg mt-2">Đăng nhập</button>
        </form>
        <p class="text-center mt-3 fs-sm text-muted">
            <a href="${pageContext.request.contextPath}/home">← Về trang chủ khách sạn</a>
        </p>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
