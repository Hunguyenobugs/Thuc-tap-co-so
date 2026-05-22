<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Xác nhận đặt phòng - Grand Lotus Hotel</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body class="customer-page">
<jsp:include page="../components/customer_header.jsp"/>
<section class="section fade-in">
    <div class="topbar" style="margin-bottom:24px;">
        <div>
            <h2 style="margin:0;">📋 Xác nhận đặt phòng</h2>
            <div class="breadcrumb"><span>Kiểm tra thông tin và xác nhận</span></div>
        </div>
    </div>

    <div class="detail-grid">
        <div>
            <!-- Thông tin khách hàng -->
            <div class="card mb-3"><div class="card-header"><h3>👤 Thông tin khách hàng</h3></div>
                <ul class="detail-list">
                    <li><span class="label">Họ tên</span><span class="value">${customer.fullName}</span></li>
                    <li><span class="label">CCCD</span><span class="value">${customer.idCard}</span></li>
                    <li><span class="label">SĐT</span><span class="value">${customer.phone}</span></li>
                    <li><span class="label">Email</span><span class="value">${customer.email}</span></li>
                </ul>
            </div>

            <!-- Danh sách phòng -->
            <div class="card"><div class="card-header"><h3>🛏️ Danh sách phòng đặt</h3><span class="badge badge-primary">${cart.size()} phòng</span></div>
                <div class="table-container"><table><thead><tr><th>Phòng</th><th>Loại phòng</th><th>Ngày nhận</th><th>Ngày trả</th><th>Đêm</th><th>Thành tiền</th></tr></thead><tbody>
                <c:forEach var="item" items="${cart}">
                    <tr>
                        <td><strong>${item.roomNumber}</strong></td>
                        <td>${item.roomTypeName}</td>
                        <td>14:00 <fmt:parseDate value="${item.checkIn}" pattern="yyyy-MM-dd" var="pCI"/><fmt:formatDate value="${pCI}" pattern="dd/MM/yyyy"/></td>
                        <td>12:00 <fmt:parseDate value="${item.checkOut}" pattern="yyyy-MM-dd" var="pCO"/><fmt:formatDate value="${pCO}" pattern="dd/MM/yyyy"/></td>
                        <td>${item.nights}</td>
                        <td class="fw-bold text-accent"><fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>₫</td>
                    </tr>
                </c:forEach>
                </tbody></table></div>
            </div>
        </div>

        <!-- Cột phải: Tổng kết & Form xác nhận -->
        <div><div class="card" style="position:sticky;top:100px;">
            <h3 class="mb-3">💰 Tổng kết</h3>
            <div style="text-align:center;padding:20px;border-bottom:1px solid var(--border);">
                <div class="fs-sm text-muted mb-1">TỔNG ƯỚC TÍNH</div>
                <span style="font-size:32px;font-weight:700;color:var(--accent);"><fmt:formatNumber value="${totalEstimate}" pattern="#,##0"/>₫</span>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/onlineBooking" style="margin-top:16px;">
                <input type="hidden" name="action" value="insert">
                <div class="form-group"><label>Ghi chú / Yêu cầu đặc biệt</label><textarea name="note" class="form-control" rows="3" placeholder="VD: Cần thêm gối, phòng tầng cao..."></textarea></div>
                <button type="submit" class="btn btn-primary btn-block btn-lg">✅ Xác nhận đặt phòng</button>
            </form>
            <a href="${pageContext.request.contextPath}/onlineBooking?action=searchRoom" class="btn btn-outline btn-block mt-2">← Thêm/bớt phòng</a>
            <a href="${pageContext.request.contextPath}/search" class="btn btn-outline btn-block mt-1">🔄 Tìm phòng lại</a>
        </div></div>
    </div>
</section>
<footer class="customer-footer">© 2025 Grand Lotus Hotel</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body></html>
