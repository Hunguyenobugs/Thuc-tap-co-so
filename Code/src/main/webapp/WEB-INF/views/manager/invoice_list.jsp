<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Danh sách hóa đơn</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout manager-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/manager_header.jsp"/>
<main class="main-content fade-in">
    <div class="topbar"><div><h1>💰 Quản lý <span>thanh toán</span></h1></div></div>
    <c:if test="${param.msg != null}"><div class="alert alert-success">✅ Thao tác thành công!</div></c:if>

    <div class="card mb-3"><div class="flex gap-4" style="flex-wrap:wrap;">
        <form class="search-bar" method="get" action="${pageContext.request.contextPath}/manager/invoice" style="flex:1;margin:0;padding:0;background:none;border:none;display:flex;gap:16px;align-items:center;">
            <input type="hidden" name="action" value="list">
            <label class="fs-sm text-muted" style="white-space:nowrap;">Từ</label>
            <input type="date" name="from" class="form-control" value="${from}" style="max-width:none;">
            <label class="fs-sm text-muted" style="white-space:nowrap;">đến</label>
            <input type="date" name="to" class="form-control" value="${to}" style="max-width:none;">
            <button type="submit" class="btn btn-primary" style="flex-shrink:0;">📅 Lọc</button>
        </form>
        <form class="search-bar" method="get" action="${pageContext.request.contextPath}/manager/invoice" style="flex:1;margin:0;padding:0;background:none;border:none;display:flex;gap:16px;">
            <input type="hidden" name="action" value="list">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm mã hóa đơn..." value="${keyword}" style="flex:1;max-width:none;">
            <button type="submit" class="btn btn-primary" style="flex-shrink:0;">🔍 Tìm kiếm</button>
        </form>
    </div></div>

    <c:choose>
        <c:when test="${empty invoices}"><div class="no-data">Chưa có hóa đơn nào</div></c:when>
        <c:otherwise>
            <div class="table-container"><table>
                <thead><tr><th>Mã HD</th><th>Mã đặt phòng</th><th>Khách hàng</th><th>Ngày lập</th><th>Tổng tiền</th><th>Thanh toán</th><th></th></tr></thead>
                <tbody>
                <c:forEach var="inv" items="${invoices}">
                    <tr>
                        <td><strong>${inv.code}</strong></td>
                        <td>${inv.bookingCode}</td>
                        <td>${inv.customerName}</td>
                        <td><fmt:formatDate value="${inv.issueDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td class="text-accent fw-bold"><fmt:formatNumber value="${inv.totalAmount}" pattern="#,##0"/>₫</td>
                        <td><span class="badge badge-info">${inv.paymentMethod}</span></td>
                        <td><a href="${pageContext.request.contextPath}/manager/invoice?action=detail&id=${inv.id}" class="btn btn-outline btn-sm">👁️ Xem</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table></div>
        </c:otherwise>
    </c:choose>
</main></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
