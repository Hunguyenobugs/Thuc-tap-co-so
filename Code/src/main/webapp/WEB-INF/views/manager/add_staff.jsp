<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Thêm nhân viên</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>➕ Thêm <span>nhân viên</span></h1></div></div>
    <c:if test="${error != null}"><div class="alert alert-danger">⚠️ ${error}</div></c:if>
    <div class="card" style="max-width:700px;"><form method="post" action="${pageContext.request.contextPath}/manager/staff"><input type="hidden" name="action" value="insert">
        <div class="form-row"><div class="form-group"><label>Họ tên <span class="required">*</span></label><input type="text" name="fullName" class="form-control" required></div><div class="form-group"><label>Mã NV</label><input type="text" name="employeeCode" class="form-control" placeholder="VD: NV007"></div></div>
        <div class="form-row"><div class="form-group"><label>Username <span class="required">*</span></label><input type="text" name="username" class="form-control" required></div><div class="form-group"><label>Vai trò</label><select name="role" class="form-control"><option value="STAFF">Nhân viên</option><option value="MANAGER">Quản lý</option></select></div></div>
        <div class="form-row"><div class="form-group"><label>Email</label><input type="email" name="email" class="form-control"></div><div class="form-group"><label>SĐT</label><input type="tel" name="phone" class="form-control"></div></div>
        <div class="form-row"><div class="form-group"><label>Ngày vào làm</label><input type="date" name="joinDate" class="form-control"></div><div class="form-group"><label>Mô tả</label><input type="text" name="description" class="form-control"></div></div>
        <div class="alert alert-info">🔑 Mật khẩu mặc định: @Hotel2025</div>
        <div class="btn-group"><button type="submit" class="btn btn-primary">💾 Lưu</button><a href="${pageContext.request.contextPath}/manager/staff?action=manage" class="btn btn-outline">← Quay lại</a></div>
    </form></div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
