<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Đăng nhập khách hàng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="login-page">
    <div class="login-box fade-in">
        <div class="logo">🏨</div>
        <h1>Đăng nhập</h1>
        <p class="subtitle">Đăng nhập để đặt phòng trực tuyến</p>
        <% if (request.getAttribute("error") != null) { %><div class="alert alert-danger">⚠️ ${error}</div><% } %>
        <% if ("register_success".equals(request.getParameter("msg"))) { %><div class="alert alert-success">✅ Đăng ký thành công! Vui lòng đăng nhập.</div><% } %>
        <form method="post" action="${pageContext.request.contextPath}/customerAuth">
            <input type="hidden" name="action" value="login">
            <div class="form-group">
                <label>Email hoặc SĐT <span class="required">*</span></label>
                <input type="text" name="emailOrPhone" class="form-control" placeholder="Nhập email hoặc số điện thoại" required autofocus>
            </div>
            <div class="form-group">
                <label>Mật khẩu <span class="required">*</span></label>
                <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg mt-2">Đăng nhập</button>
        </form>
        <p class="text-center mt-3 fs-sm text-muted">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/customerAuth?action=registerPage">Đăng ký ngay</a></p>
        <p class="text-center mt-1 fs-sm"><a href="${pageContext.request.contextPath}/home">← Về trang chủ</a></p>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
