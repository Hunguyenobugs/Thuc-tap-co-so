<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Thêm khách hàng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>➕ Thêm <span>khách hàng mới</span></h1></div></div>
    <div class="card" style="max-width:700px;"><form method="post" action="${pageContext.request.contextPath}/staff/booking"><input type="hidden" name="action" value="insertCustomer">
        <div class="form-row"><div class="form-group"><label>Họ tên <span class="required">*</span></label><input type="text" name="fullName" class="form-control" required></div><div class="form-group"><label>Số CCCD <span class="required">*</span></label><input type="text" name="idCard" class="form-control" required></div></div>
        <div class="form-row"><div class="form-group"><label>SĐT</label><input type="tel" name="phone" class="form-control"></div><div class="form-group"><label>Email</label><input type="email" name="email" class="form-control"></div></div>
        <div class="form-row"><div class="form-group"><label>Ngày sinh</label><input type="date" name="birthDate" class="form-control"></div><div class="form-group"><label>Giới tính</label><select name="gender" class="form-control"><option value="Nam">Nam</option><option value="Nữ">Nữ</option><option value="Khác">Khác</option></select></div></div>
        <div class="form-group"><label>Địa chỉ</label><input type="text" name="address" class="form-control"></div>
        <div class="btn-group"><button type="submit" class="btn btn-primary">💾 Lưu & Tiếp tục</button><a href="${pageContext.request.contextPath}/staff/booking?action=searchCustomer" class="btn btn-outline">← Quay lại</a></div>
    </form></div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
