<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Sửa loại phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/>
<main class="main-content fade-in">
    <div class="topbar"><div><h1>✏️ Sửa <span>loại phòng</span></h1></div></div>
    <div class="card" style="max-width:700px;">
        <form method="post" action="${pageContext.request.contextPath}/manager/roomtype">
            <input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${roomType.id}">
            <div class="form-row">
                <div class="form-group"><label>Tên <span class="required">*</span></label><input type="text" name="name" class="form-control" value="${roomType.name}" required></div>
                <div class="form-group"><label>Giá/đêm (₫) <span class="required">*</span></label><input type="number" name="basePrice" class="form-control" value="${roomType.basePrice}" required></div>
            </div>
            <div class="form-row-3">
                <div class="form-group"><label>Sức chứa</label><input type="number" name="capacity" class="form-control" value="${roomType.capacity}" min="1"></div>
                <div class="form-group"><label>Diện tích</label><input type="text" name="area" class="form-control" value="${roomType.area}"></div>
                <div class="form-group"><label>Hình ảnh URL</label><input type="text" name="imageUrl" class="form-control" value="${roomType.imageUrl}"></div>
            </div>
            <div class="form-group"><label>Tiện nghi</label><input type="text" name="amenities" class="form-control" value="${roomType.amenities}"></div>
            <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control">${roomType.description}</textarea></div>
            <div class="btn-group"><button type="submit" class="btn btn-primary">💾 Cập nhật</button><a href="${pageContext.request.contextPath}/manager/roomtype?action=search" class="btn btn-outline">← Quay lại</a></div>
        </form>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
