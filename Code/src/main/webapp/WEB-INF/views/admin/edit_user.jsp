<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Sửa tài khoản</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>✏️ Sửa <span>tài khoản</span></h1></div></div>
    <div class="card" style="max-width:700px;"><form method="post" action="${pageContext.request.contextPath}/admin/user"><input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${editUser.id}">
        <div class="form-row"><div class="form-group"><label>Họ tên</label><input type="text" name="fullName" class="form-control" value="${editUser.fullName}" required></div><div class="form-group"><label>Vai trò</label><select name="role" class="form-control"><option value="STAFF" ${editUser.role=='STAFF'?'selected':''}>Nhân viên</option><option value="MANAGER" ${editUser.role=='MANAGER'?'selected':''}>Quản lý</option><option value="ADMIN" ${editUser.role=='ADMIN'?'selected':''}>Admin</option></select></div></div>
        <div class="form-row"><div class="form-group"><label>Email</label><input type="email" name="email" class="form-control" value="${editUser.email}"></div><div class="form-group"><label>SĐT</label><input type="tel" name="phone" class="form-control" value="${editUser.phone}"></div></div>
        <div class="form-group"><label>Trạng thái</label><select name="status" class="form-control" style="max-width:200px;"><option value="active" ${editUser.status=='active'?'selected':''}>Hoạt động</option><option value="inactive" ${editUser.status=='inactive'?'selected':''}>Khóa</option></select></div>
        <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control">${editUser.description}</textarea></div>
        <div class="btn-group"><button type="submit" class="btn btn-primary">💾 Cập nhật</button><a href="${pageContext.request.contextPath}/admin/user?action=search" class="btn btn-outline">← Quay lại</a></div>
    </form></div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
