<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Sơ đồ phòng - Grand Lotus Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .room-map-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 16px;
            margin-top: 16px;
        }
        .room-card {
            border-radius: var(--radius);
            padding: 16px;
            text-align: center;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            border-top: 4px solid #94a3b8; /* Default */
            background: var(--surface);
        }
        .room-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .room-number {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 8px;
            color: var(--text-primary);
        }
        .room-type {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }
        .room-status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        /* Tùy chỉnh màu theo trạng thái */
        .room-card.status-trong { border-top-color: #10b981; }
        .room-card.status-trong .room-status { background: rgba(16, 185, 129, 0.1); color: #10b981; }
        
        .room-card.status-dang-su-dung { border-top-color: #ef4444; }
        .room-card.status-dang-su-dung .room-status { background: rgba(239, 68, 68, 0.1); color: #ef4444; }
        
        .room-card.status-don-dep { border-top-color: #f59e0b; }
        .room-card.status-don-dep .room-status { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }
        
        .room-card.status-bao-tri { border-top-color: #64748b; }
        .room-card.status-bao-tri .room-status { background: rgba(100, 116, 139, 0.1); color: #64748b; }
        
        .floor-title {
            grid-column: 1 / -1;
            margin-top: 24px;
            margin-bottom: 8px;
            font-size: 1.25rem;
            color: var(--accent);
            border-bottom: 1px solid var(--border);
            padding-bottom: 8px;
        }
    </style>
</head>
<body>
<div class="layout staff-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/staff_header.jsp"/>
    <main class="main-content fade-in">
        <div class="topbar">
            <div>
                <h1>🏨 Sơ đồ phòng <span>(Room Rack)</span></h1>
                <div class="breadcrumb"><span>Nghiệp vụ lễ tân</span></div>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/staff/booking?action=searchRoom" class="btn btn-primary">➕ Đặt phòng mới</a>
            </div>
        </div>

        <div class="stat-grid mb-3" style="grid-template-columns: repeat(4, 1fr);">
            <div class="stat-card" style="border-left: 4px solid #10b981;">
                <div class="stat-label">Trống</div>
            </div>
            <div class="stat-card" style="border-left: 4px solid #ef4444;">
                <div class="stat-label">Đang sử dụng</div>
            </div>
            <div class="stat-card" style="border-left: 4px solid #f59e0b;">
                <div class="stat-label">Đang dọn dẹp</div>
            </div>
            <div class="stat-card" style="border-left: 4px solid #64748b;">
                <div class="stat-label">Bảo trì</div>
            </div>
        </div>

        <div class="room-map-container">
            <!-- Xử lý hiển thị các phòng -->
            <c:set var="currentFloor" value="-1" />
            <c:forEach var="r" items="${rooms}">
                <!-- In ra tiêu đề tầng nếu chuyển tầng -->
                <c:if test="${r.floor != currentFloor}">
                    <h2 class="floor-title">Tầng ${r.floor}</h2>
                    <c:set var="currentFloor" value="${r.floor}" />
                </c:if>
                
                <!-- Class CSS tuỳ theo status -->
                <c:set var="statusClass" value="" />
                <c:choose>
                    <c:when test="${r.status == 'Trống'}"><c:set var="statusClass" value="status-trong" /></c:when>
                    <c:when test="${r.status == 'Đang sử dụng'}"><c:set var="statusClass" value="status-dang-su-dung" /></c:when>
                    <c:when test="${r.status == 'Dọn dẹp'}"><c:set var="statusClass" value="status-don-dep" /></c:when>
                    <c:when test="${r.status == 'Bảo trì'}"><c:set var="statusClass" value="status-bao-tri" /></c:when>
                    <c:otherwise><c:set var="statusClass" value="status-trong" /></c:otherwise>
                </c:choose>

                <div class="room-card ${statusClass}">
                    <div class="room-number">${r.roomNumber}</div>
                    <div class="room-type">${r.roomTypeName}</div>
                    <div class="room-status">${r.status}</div>
                </div>
            </c:forEach>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
