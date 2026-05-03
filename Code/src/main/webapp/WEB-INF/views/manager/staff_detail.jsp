<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Chi tiết nhân viên</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/manager_header.jsp"/>
<main class="main-content fade-in">
    <div class="topbar">
        <div>
            <h1>👤 Chi tiết <span>nhân viên</span></h1>
            <div class="breadcrumb"><a href="${pageContext.request.contextPath}/manager/staff">Nhân viên</a><span>Chi tiết</span></div>
        </div>
    </div>

    <div class="detail-grid">
        <!-- Thông tin cơ bản -->
        <div>
            <div class="card mb-3">
                <div class="card-header"><h3>📋 Thông tin cá nhân</h3></div>
                <ul class="detail-list">
                    <li><span class="label">Mã nhân viên</span><span class="value fw-bold">${staff.employeeCode}</span></li>
                    <li><span class="label">Họ tên</span><span class="value">${staff.fullName}</span></li>
                    <li><span class="label">Username</span><span class="value">${staff.username}</span></li>
                    <li><span class="label">Vai trò</span>
                        <span class="value">
                            <c:choose>
                                <c:when test="${staff.role=='ADMIN'}"><span class="badge badge-danger">${staff.role}</span></c:when>
                                <c:when test="${staff.role=='MANAGER'}"><span class="badge badge-warning">${staff.role}</span></c:when>
                                <c:otherwise><span class="badge badge-info">${staff.role}</span></c:otherwise>
                            </c:choose>
                        </span>
                    </li>
                    <li><span class="label">Email</span><span class="value">${staff.email}</span></li>
                    <li><span class="label">Số điện thoại</span><span class="value">${staff.phone}</span></li>
                    <li><span class="label">Ngày vào làm</span><span class="value"><fmt:formatDate value="${staff.joinDate}" pattern="dd/MM/yyyy"/></span></li>
                    <li><span class="label">Trạng thái</span>
                        <span class="value">
                            <c:choose>
                                <c:when test="${staff.status=='active'}"><span class="badge badge-success">Hoạt động</span></c:when>
                                <c:otherwise><span class="badge badge-danger">Không hoạt động</span></c:otherwise>
                            </c:choose>
                        </span>
                    </li>
                    <c:if test="${not empty staff.description}">
                        <li><span class="label">Mô tả</span><span class="value">${staff.description}</span></li>
                    </c:if>
                </ul>
            </div>
        </div>

        <!-- Hiệu suất làm việc -->
        <div>
            <div class="card" style="position:sticky;top:100px;">
                <h3 class="mb-3">📊 Hiệu suất làm việc</h3>
                <div class="stat-card mb-3" style="margin-bottom:20px;">
                    <div class="stat-label">🛏️ Số lượt đặt phòng đã xử lý</div>
                    <div class="stat-value text-accent">${bookingCount}</div>
                    <div class="stat-desc">lượt đặt phòng cho khách</div>
                </div>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/manager/staff" class="btn btn-outline">← Quay lại</a>
                </div>
            </div>
        </div>
    </div>
</main></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
