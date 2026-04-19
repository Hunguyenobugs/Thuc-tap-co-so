<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Đăng ký tài khoản</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="login-page">
    <div class="login-box fade-in" style="max-width:500px;">
        <div class="logo">🏨</div>
        <h1>Đăng ký tài khoản</h1>
        <p class="subtitle">Tạo tài khoản để đặt phòng trực tuyến</p>
        <% if (request.getAttribute("error") != null) { %><div class="alert alert-danger">⚠️ ${error}</div><% } %>
        <form method="post" action="${pageContext.request.contextPath}/customerAuth">
            <input type="hidden" name="action" value="register">
            <div class="form-group"><label>Họ tên <span class="required">*</span></label>
                <input type="text" name="fullName" class="form-control" required></div>
            <div class="form-row">
                <div class="form-group"><label>Số CCCD</label><input type="text" name="idCard" class="form-control"></div>
                <div class="form-group"><label>Giới tính</label>
                    <select name="gender" class="form-control"><option value="">--Chọn--</option><option value="Nam">Nam</option><option value="Nữ">Nữ</option><option value="Khác">Khác</option></select></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Email <span class="required">*</span></label><input type="email" name="email" class="form-control" required></div>
                <div class="form-group"><label>SĐT <span class="required">*</span></label><input type="tel" name="phone" class="form-control" required></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Ngày sinh</label><input type="date" name="birthDate" class="form-control"></div>
                <div class="form-group"><label>Địa chỉ</label><input type="text" name="address" class="form-control"></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Mật khẩu <span class="required">*</span></label><input type="password" name="password" class="form-control" required></div>
                <div class="form-group"><label>Xác nhận MK <span class="required">*</span></label><input type="password" name="confirmPassword" class="form-control" required></div>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg mt-2">Đăng ký</button>
        </form>
        <p class="text-center mt-3 fs-sm text-muted">Đã có tài khoản? <a href="${pageContext.request.contextPath}/customerAuth?action=loginPage">Đăng nhập</a></p>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
