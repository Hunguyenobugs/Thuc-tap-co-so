<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Quản lý loại phòng</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/>
<main class="main-content fade-in">
    <div class="topbar"><div><h1>🏷️ Quản lý <span>loại phòng</span></h1></div></div>
    <% if (request.getParameter("msg") != null) { %><div class="alert alert-success">✅ Thao tác thành công!</div><% } %>
    <div class="btn-group mb-3">
        <a href="${pageContext.request.contextPath}/manager/roomtype?action=add" class="btn btn-primary">➕ Thêm loại phòng</a>
        <a href="${pageContext.request.contextPath}/manager/roomtype?action=search" class="btn btn-outline">🔍 Tìm kiếm</a>
    </div>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
