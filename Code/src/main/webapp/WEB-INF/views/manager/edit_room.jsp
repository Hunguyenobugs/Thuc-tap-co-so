<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Sửa phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout"><jsp:include page="../components/sidebar.jsp"/>`n    <jsp:include page="../components/manager_header.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>✏️ Sửa <span>phòng ${room.roomNumber}</span></h1></div></div>
    <div class="card" style="max-width:600px;">
        <form method="post" action="${pageContext.request.contextPath}/manager/room">
            <input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${room.id}">
            <div class="form-row">
                <div class="form-group"><label>Số phòng</label><input type="text" name="roomNumber" class="form-control" value="${room.roomNumber}" required></div>
                <div class="form-group"><label>Tầng</label><input type="number" name="floor" class="form-control" value="${room.floor}"></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Loại phòng</label>
                    <select name="roomTypeId" class="form-control"><c:forEach var="rt" items="${roomTypes}"><option value="${rt.id}" ${room.roomTypeId==rt.id?'selected':''}>${rt.name}</option></c:forEach></select></div>
                <div class="form-group"><label>Trạng thái</label>
                    <select name="status" class="form-control"><option value="Trống" ${room.status=='Trống'?'selected':''}>Trống</option><option value="Đang sử dụng" ${room.status=='Đang sử dụng'?'selected':''}>Đang sử dụng</option><option value="Cần dọn dẹp" ${room.status=='Cần dọn dẹp'?'selected':''}>Cần dọn dẹp</option><option value="Bảo trì" ${room.status=='Bảo trì'?'selected':''}>Bảo trì</option></select></div>
            </div>
            <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control">${room.description}</textarea></div>
            <div class="form-actions"><button type="submit" class="btn btn-primary">💾 Cập nhật</button><a href="${pageContext.request.contextPath}/manager/room?action=search" class="btn btn-outline">← Quay lại</a></div>
        </form>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
