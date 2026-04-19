<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Thêm phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/>
<main class="main-content fade-in">
    <div class="topbar"><div><h1>➕ Thêm <span>phòng</span></h1></div></div>
    <c:if test="${error != null}"><div class="alert alert-danger">⚠️ ${error}</div></c:if>
    <div class="card" style="max-width:600px;">
        <form method="post" action="${pageContext.request.contextPath}/manager/room">
            <input type="hidden" name="action" value="insert">
            <div class="form-row">
                <div class="form-group"><label>Số phòng <span class="required">*</span></label><input type="text" name="roomNumber" class="form-control" required></div>
                <div class="form-group"><label>Tầng</label><input type="number" name="floor" class="form-control" value="1" min="1"></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Loại phòng <span class="required">*</span></label>
                    <select name="roomTypeId" class="form-control" required>
                        <c:forEach var="rt" items="${roomTypes}"><option value="${rt.id}">${rt.name}</option></c:forEach>
                    </select></div>
                <div class="form-group"><label>Trạng thái</label>
                    <select name="status" class="form-control"><option value="Trống">Trống</option><option value="Bảo trì">Bảo trì</option></select></div>
            </div>
            <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control"></textarea></div>
            <div class="btn-group"><button type="submit" class="btn btn-primary">💾 Lưu</button><a href="${pageContext.request.contextPath}/manager/room?action=manage" class="btn btn-outline">← Quay lại</a></div>
        </form>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
