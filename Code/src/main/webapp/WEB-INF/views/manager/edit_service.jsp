<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Sửa dịch vụ</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>✏️ Sửa <span>dịch vụ</span></h1></div></div>
    <div class="card" style="max-width:600px;"><form method="post" action="${pageContext.request.contextPath}/manager/service"><input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${service.id}">
        <div class="form-row"><div class="form-group"><label>Tên</label><input type="text" name="name" class="form-control" value="${service.name}" required></div><div class="form-group"><label>Đơn giá</label><input type="number" name="price" class="form-control" value="${service.price}" required></div></div>
        <div class="form-row"><div class="form-group"><label>Danh mục</label><input type="text" name="category" class="form-control" value="${service.category}"></div><div class="form-group"><label>Đơn vị</label><input type="text" name="unit" class="form-control" value="${service.unit}"></div></div>
        <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control">${service.description}</textarea></div>
        <div class="btn-group"><button type="submit" class="btn btn-primary">💾 Cập nhật</button><a href="${pageContext.request.contextPath}/manager/service?action=search" class="btn btn-outline">← Quay lại</a></div>
    </form></div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
