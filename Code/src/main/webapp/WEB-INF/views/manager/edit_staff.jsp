<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Sửa nhân viên</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout"><jsp:include page="../components/sidebar.jsp"/>`n    <jsp:include page="../components/manager_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>✏️ Sửa <span>nhân viên</span></h1></div></div>
    <div class="card" style="max-width:600px;"><form method="post" action="${pageContext.request.contextPath}/manager/staff"><input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${staff.id}"><input type="hidden" name="role" value="${staff.role}">
        <div class="form-row"><div class="form-group"><label>Họ tên</label><input type="text" name="fullName" class="form-control" value="${staff.fullName}" required></div><div class="form-group"><label>Email</label><input type="email" name="email" class="form-control" value="${staff.email}"></div></div>
        <div class="form-row"><div class="form-group"><label>SĐT</label><input type="tel" name="phone" class="form-control" value="${staff.phone}"></div><div class="form-group"><label>Ngày vào làm</label><input type="date" name="joinDate" class="form-control" value="${staff.joinDate}"></div></div>
        <div class="form-group"><label>Mô tả</label><input type="text" name="description" class="form-control" value="${staff.description}"></div>
        <div class="form-actions"><button type="submit" class="btn btn-primary">💾 Cập nhật</button><a href="${pageContext.request.contextPath}/manager/staff" class="btn btn-outline">← Quay lại</a></div>
    </form></div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
