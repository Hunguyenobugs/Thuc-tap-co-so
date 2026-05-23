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
    <div class="topbar"><div><h1>Quản lý <span>thanh toán</span></h1></div></div>
    <c:if test="${param.msg != null}"><div class="alert alert-success">Thao tác thành công!</div></c:if>

    <div class="card mb-3"><div class="flex gap-4" style="flex-wrap:wrap;">
        <form class="search-bar" method="get" action="${pageContext.request.contextPath}/manager/invoice" style="flex:1;margin:0;padding:0;background:none;border:none;display:flex;gap:16px;align-items:center;">
            <input type="hidden" name="action" value="list">
            <label class="fs-sm text-muted" style="white-space:nowrap;">Từ</label>
            <input type="date" name="from" class="form-control" value="${from}" style="max-width:none;">
            <label class="fs-sm text-muted" style="white-space:nowrap;">đến</label>
            <input type="date" name="to" class="form-control" value="${to}" style="max-width:none;">
            <button type="submit" class="btn btn-primary" style="flex-shrink:0;">Lọc</button>
        </form>
        <form class="search-bar" method="get" action="${pageContext.request.contextPath}/manager/invoice" style="flex:1;margin:0;padding:0;background:none;border:none;display:flex;gap:16px;">
            <input type="hidden" name="action" value="list">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm mã hóa đơn..." value="${keyword}" style="flex:1;max-width:none;">
            <button type="submit" class="btn btn-primary" style="flex-shrink:0;">Tìm kiếm</button>
        </form>
    </div></div>

    <c:choose>
        <c:when test="${empty invoiceGroups}"><div class="no-data">Chưa có hóa đơn nào</div></c:when>
        <c:otherwise>
            <div class="table-container">
                <style>
                .booking-group{border:1px solid var(--border);border-radius:12px;margin-bottom:20px;overflow:hidden;box-shadow:var(--shadow-sm);}
                .booking-group-header{display:flex;align-items:center;justify-content:space-between;padding:14px 20px;background:var(--bg-secondary);border-bottom:1px solid var(--border);flex-wrap:wrap;gap:10px;}
                .booking-group-header .bk-code{font-size:17px;font-weight:700;color:var(--accent);}
                .booking-group-header .bk-meta{font-size:13px;color:var(--text-muted);display:flex;gap:16px;flex-wrap:wrap;}
                .room-rows{padding:0 16px 12px;}
                </style>
                <c:forEach var="ig" items="${invoiceGroups}">
                    <div class="booking-group">
                        <div class="booking-group-header">
                            <div>
                                <span class="bk-code">Phiếu đặt: ${ig.bookingCode}</span>
                                <div class="bk-meta">
                                    <span>Khách hàng: ${ig.customerName}</span>
                                    <c:if test="${ig.notCheckedOutCount > 0}">
                                        <span class="badge badge-warning" style="padding:2px 6px;">Cần TT: ${ig.notCheckedOutCount} phòng</span>
                                    </c:if>
                                </div>
                            </div>
                            <div style="text-align:right;">
                                <div style="font-size:12px; color:var(--text-muted); text-transform:uppercase; font-weight:600; margin-bottom:2px;">Tổng thanh toán</div>
                                <div style="font-size:20px; font-weight:700; color:var(--accent);"><fmt:formatNumber value="${ig.totalAmount}" pattern="#,##0"/>₫</div>
                            </div>
                        </div>
                        <div class="room-rows">
                            <table style="width:100%; text-align:left; border-collapse:collapse; margin-top:8px;">
                                <thead>
                                    <tr style="border-bottom:1px solid var(--border); font-size:13px; color:var(--text-muted);">
                                        <th style="padding:8px 0;">Mã HĐ</th>
                                        <th style="padding:8px 0;">Phòng</th>
                                        <th style="padding:8px 0;">Ngày lập</th>
                                        <th style="padding:8px 0;">Tổng tiền</th>
                                        <th style="padding:8px 0;">Đã thanh toán</th>
                                        <th style="padding:8px 0;">Phương thức</th>
                                        <th style="padding:8px 0;"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="inv" items="${ig.invoices}">
                                        <tr style="border-bottom:1px dashed var(--border); font-size:14px;">
                                            <td style="padding:10px 0;"><strong>${inv.code}</strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty inv.roomNumber}">${inv.roomNumber}</c:when>
                                                    <c:otherwise><span class="text-muted fs-sm">Khác</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${inv.issueDate}" pattern="HH:mm dd/MM/yyyy"/></td>
                                            <td class="fw-bold"><fmt:formatNumber value="${inv.totalAmount}" pattern="#,##0"/>₫</td>
                                            <td class="text-success"><fmt:formatNumber value="${inv.paidAmount}" pattern="#,##0"/>₫</td>
                                            <td><span class="badge badge-info">${inv.paymentMethod}</span></td>
                                            <td style="text-align:right;"><a href="${pageContext.request.contextPath}/manager/invoice?action=detail&id=${inv.id}" class="btn btn-outline btn-sm" style="padding:4px 8px; font-size:12px;">Chi tiết</a></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
