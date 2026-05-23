<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Đăng ký tài khoản</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<div class="login-page">
    <div class="login-box fade-in" style="max-width:500px;">
        <div class="logo"></div>
        <h1>Đăng ký tài khoản</h1>
        <p class="subtitle">Tạo tài khoản để đặt phòng trực tuyến</p>
        <% if (request.getAttribute("error") != null) { %><div class="alert alert-danger">${error}</div><% } %>
        <form method="post" action="${pageContext.request.contextPath}/customerAuth">
            <input type="hidden" name="action" value="register">
            <div class="form-group"><label>Họ tên <span class="required">*</span></label>
                <input type="text" name="fullName" class="form-control" required></div>
            <div class="form-row">
                <div class="form-group"><label>Số CCCD <span class="required">*</span></label><input type="text" name="idCard" class="form-control" required></div>
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
<script>
document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector("form");
    const fullNameInput = document.querySelector("input[name='fullName']");
    const idCardInput = document.querySelector("input[name='idCard']");
    const emailInput = document.querySelector("input[name='email']");
    const phoneInput = document.querySelector("input[name='phone']");
    const birthDateInput = document.querySelector("input[name='birthDate']");
    const passwordInput = document.querySelector("input[name='password']");
    const confirmPasswordInput = document.querySelector("input[name='confirmPassword']");

    if (birthDateInput) {
        const today = new Date().toISOString().split('T')[0];
        birthDateInput.max = today;
    }

    form.addEventListener("submit", function(e) {
        let isValid = true;
        let errorMessage = "";

        // 1. Kiểm tra họ tên
        if (fullNameInput.value.trim().length < 2) {
            isValid = false;
            errorMessage += "• Họ tên phải có ít nhất 2 ký tự.\n";
        }

        // 2. Kiểm tra CCCD (nếu có nhập)
        const idCardValue = idCardInput.value.trim();
        if (idCardValue.length > 0) {
            const idCardRegex = /^[0-9]+$/;
            if (!idCardRegex.test(idCardValue)) {
                isValid = false;
                errorMessage += "• Số CCCD/Hộ chiếu chỉ được chứa các chữ số.\n";
            } else if (idCardValue.length !== 9 && idCardValue.length !== 12) {
                isValid = false;
                errorMessage += "• Số CCCD phải dài đúng 9 hoặc 12 số.\n";
            }
        }

        // 3. Kiểm tra số điện thoại
        const phoneValue = phoneInput.value.trim();
        const phoneRegex = /^(0[3|5|7|8|9])[0-9]{8}$/;
        if (!phoneRegex.test(phoneValue)) {
            isValid = false;
            errorMessage += "• Số điện thoại không đúng định dạng (phải gồm 10 chữ số và bắt đầu bằng 03, 05, 07, 08 hoặc 09).\n";
        }

        // 4. Kiểm tra ngày sinh (nếu có nhập)
        if (birthDateInput.value) {
            const birth = new Date(birthDateInput.value);
            const today = new Date();
            if (birth >= today) {
                isValid = false;
                errorMessage += "• Ngày sinh không thể là ngày hiện tại hoặc tương lai.\n";
            }
        }

        // 5. Kiểm tra mật khẩu
        if (passwordInput.value.length < 6) {
            isValid = false;
            errorMessage += "• Mật khẩu phải có ít nhất 6 ký tự.\n";
        }

        // 6. Kiểm tra mật khẩu trùng khớp
        if (passwordInput.value !== confirmPasswordInput.value) {
            isValid = false;
            errorMessage += "• Mật khẩu xác nhận không khớp.\n";
        }

        if (!isValid) {
            e.preventDefault();
            alert("Vui lòng sửa các lỗi sau để đăng ký:\n\n" + errorMessage);
        }
    });
});
</script>
</body></html>
