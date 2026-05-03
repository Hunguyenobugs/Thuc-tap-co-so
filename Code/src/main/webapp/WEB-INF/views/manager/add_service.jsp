<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Thêm dịch vụ</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout"><jsp:include page="../components/sidebar.jsp"/>`n    <jsp:include page="../components/manager_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>➕ Thêm <span>dịch vụ</span></h1></div></div>
    <c:if test="${error != null}"><div class="alert alert-danger">⚠️ ${error}</div></c:if>
    <div class="card" style="max-width:600px;"><form method="post" action="${pageContext.request.contextPath}/manager/service"><input type="hidden" name="action" value="insert">
        <div class="form-row"><div class="form-group"><label>Tên dịch vụ <span class="required">*</span></label><input type="text" name="name" class="form-control" required></div><div class="form-group"><label>Đơn giá (₫) <span class="required">*</span></label><input type="number" name="price" class="form-control" required></div></div>
        <div class="form-row"><div class="form-group"><label>Danh mục</label><input type="text" name="category" class="form-control" placeholder="Ăn uống, Giặt ủi..."></div><div class="form-group"><label>Đơn vị</label><input type="text" name="unit" class="form-control" placeholder="phần, kg, lần..."></div></div>
        <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control"></textarea></div>
        <div class="form-actions"><button type="submit" class="btn btn-primary">💾 Lưu</button><a href="${pageContext.request.contextPath}/manager/service?action=manage" class="btn btn-outline">← Quay lại</a></div>
    </form></div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
