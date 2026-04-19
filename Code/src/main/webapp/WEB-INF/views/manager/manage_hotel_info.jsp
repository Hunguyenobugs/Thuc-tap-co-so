<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Quản lý thông tin KS</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/>
<main class="main-content fade-in">
    <div class="topbar"><div><h1>🏨 Thông tin <span>khách sạn</span></h1></div></div>
    <% if ("update_success".equals(request.getParameter("msg"))) { %><div class="alert alert-success">✅ Cập nhật thông tin khách sạn thành công</div><% } %>
    <c:if test="${error != null}"><div class="alert alert-danger">⚠️ ${error}</div></c:if>
    <div class="card" style="max-width:700px;">
        <form method="post" action="${pageContext.request.contextPath}/manager/hotel">
            <div class="form-group"><label>Tên khách sạn <span class="required">*</span></label><input type="text" name="name" class="form-control" value="${hotel.name}" required></div>
            <div class="form-row">
                <div class="form-group"><label>Số điện thoại</label><input type="text" name="phone" class="form-control" value="${hotel.phone}"></div>
                <div class="form-group"><label>Email</label><input type="email" name="email" class="form-control" value="${hotel.email}"></div>
            </div>
            <div class="form-group"><label>Địa chỉ</label><input type="text" name="address" class="form-control" value="${hotel.address}"></div>
            <div class="form-group"><label>Số sao</label>
                <select name="starRating" class="form-control" style="max-width:200px;">
                    <c:forEach begin="1" end="5" var="i"><option value="${i}" ${hotel.starRating==i?'selected':''}>${i} ⭐</option></c:forEach>
                </select></div>
            <div class="form-group"><label>Mô tả</label><textarea name="description" class="form-control">${hotel.description}</textarea></div>
            <button type="submit" class="btn btn-primary">💾 Lưu thay đổi</button>
        </form>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
