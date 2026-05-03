<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Manager - Grand Lotus Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="layout manager-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/manager_header.jsp"/>
    <main class="main-content fade-in">
        <div class="topbar">
            <div><h1>📊 Trang chủ <span>Quản lý</span></h1>
                <div class="breadcrumb"><span>Dashboard</span></div>
            </div>
        </div>

        <% if ("password_changed".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">✅ Đổi mật khẩu thành công</div>
        <% } %>

        <!-- Welcome & Role Section -->
        <div class="stat-grid mb-3">
            <div class="stat-card">
                <div class="stat-label">Vai trò</div>
                <div class="stat-value text-accent">${sessionScope.currentUser.role}</div>
                <div class="stat-desc">Quản lý khách sạn</div>
            </div>
            <div class="stat-card green">
                <div class="stat-label">Xin chào</div>
                <div class="stat-value">${sessionScope.currentUser.fullName}</div>
                <div class="stat-desc">${sessionScope.currentUser.employeeCode}</div>
            </div>
        </div>

        <!-- Stat cards -->
        <div class="stat-grid">
            <div class="stat-card">
                <div class="stat-label">🛏️ Phòng đang thuê</div>
                <div class="stat-value text-accent">${rentedRooms} / ${totalRooms}</div>
                <div class="stat-desc">phòng đang được sử dụng</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">📋 Đặt phòng chờ</div>
                <div class="stat-value" style="color: var(--warning);">${pendingBookings}</div>
                <div class="stat-desc">đang chờ xử lý</div>
            </div>
            <div class="stat-card green">
                <div class="stat-label">💰 Doanh thu tháng</div>
                <div class="stat-value" style="font-size: 1.2rem;">
                    <fmt:formatNumber value="${monthRevenue}" pattern="#,##0"/>₫
                </div>
                <div class="stat-desc">tháng hiện tại</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">🧾 Hóa đơn hôm nay</div>
                <div class="stat-value">${todayInvoices}</div>
                <div class="stat-desc">hóa đơn đã lập</div>
            </div>
        </div>

        <!-- Charts row -->
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:24px; margin-top:24px;">

            <!-- Revenue chart -->
            <div class="card">
                <h3 style="margin-bottom:16px; font-size:16px;">📈 Doanh thu 7 ngày gần nhất</h3>
                <canvas id="revenueChart" height="200"></canvas>
            </div>

            <!-- Top rooms -->
            <div class="card">
                <h3 style="margin-bottom:16px; font-size:16px;">🏆 Top phòng được thuê nhiều</h3>
                <c:choose>
                    <c:when test="${empty topRooms}">
                        <div class="no-data">Chưa có dữ liệu</div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-container" style="max-height:220px; overflow-y:auto;">
                            <table>
                                <thead><tr><th>#</th><th>Phòng</th><th>Loại</th><th>Lần thuê</th></tr></thead>
                                <tbody>
                                <c:forEach var="r" items="${topRooms}" varStatus="s">
                                    <tr>
                                        <td><strong>${s.index + 1}</strong></td>
                                        <td><strong>${r.roomNumber}</strong></td>
                                        <td>${r.typeName}</td>
                                        <td><span class="badge badge-info">${r.count}</span></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <script>
            const labels = [<c:forEach var="l" items="${chartLabels}">'${l}',</c:forEach>];
            const data   = [<c:forEach var="d" items="${chartData}">${d},</c:forEach>];
            const ctx = document.getElementById('revenueChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Doanh thu (₫)',
                        data: data,
                        backgroundColor: 'rgba(99,102,241,0.7)',
                        borderColor: 'rgba(99,102,241,1)',
                        borderWidth: 1,
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: {
                            ticks: { color: '#94a3b8', callback: v => (v/1e6).toFixed(1)+'M' },
                            grid: { color: 'rgba(255,255,255,0.05)' }
                        },
                        x: { ticks: { color: '#94a3b8' }, grid: { display: false } }
                    }
                }
            });
        </script>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
