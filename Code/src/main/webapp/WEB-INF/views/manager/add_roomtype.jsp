<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Thêm loại phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/>
<main class="main-content fade-in">
    <div class="topbar"><div><h1>➕ Thêm <span>loại phòng</span></h1><div class="breadcrumb"><a href="${pageContext.request.contextPath}/manager/roomtype?action=manage">Loại phòng</a><span>Thêm mới</span></div></div></div>
    <c:if test="${error != null}"><div class="alert alert-danger">⚠️ ${error}</div></c:if>
    <div class="card" style="max-width:700px;">
        <form method="post" action="${pageContext.request.contextPath}/manager/roomtype">
            <input type="hidden" name="action" value="insert">
            <div class="form-row">
                <div class="form-group"><label>Tên loại phòng <span class="required">*</span></label><input type="text" name="name" class="form-control" required></div>
                <div class="form-group"><label>Giá/đêm (₫) <span class="required">*</span></label><input type="number" name="basePrice" class="form-control" required></div>
            </div>
            <div class="form-row-3">
                <div class="form-group"><label>Sức chứa</label><input type="number" name="capacity" class="form-control" value="2" min="1"></div>
                <div class="form-group"><label>Diện tích</label><input type="text" name="area" class="form-control" placeholder="28m²"></div>
                <div class="form-group"><label>Hình ảnh URL</label><input type="text" name="imageUrl" class="form-control"></div>
            </div>
            <div class="form-group"><label>Tiện nghi</label><input type="text" name="amenities" class="form-control" placeholder="TV, minibar, wifi..."></div>
            <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control"></textarea></div>
            <div class="btn-group"><button type="submit" class="btn btn-primary">💾 Lưu</button><a href="${pageContext.request.contextPath}/manager/roomtype?action=manage" class="btn btn-outline">← Quay lại</a></div>
        </form>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
