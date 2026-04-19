<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Danh sách hóa đơn</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout"><jsp:include page="../components/sidebar.jsp"/><main class="main-content fade-in">
    <div class="topbar"><div><h1>💰 Quản lý <span>thanh toán</span></h1></div></div>
    <% if (request.getParameter("msg") != null) { %><div class="alert alert-success">✅ Thao tác thành công!</div><% } %>
    <div class="card mb-3"><div class="flex gap-2" style="flex-wrap:wrap;">
        <form class="search-bar" method="get" action="${pageContext.request.contextPath}/manager/invoice" style="flex:1;margin:0;padding:0;background:none;border:none;">
            <input type="hidden" name="action" value="list"><label class="fs-sm text-muted" style="white-space:nowrap;padding:10px 0;">Từ</label><input type="date" name="from" class="form-control" value="${from}"><label class="fs-sm text-muted" style="white-space:nowrap;padding:10px 0;">đến</label><input type="date" name="to" class="form-control" value="${to}"><button type="submit" class="btn btn-primary">📅 Lọc</button>
        </form>
        <form class="search-bar" method="get" action="${pageContext.request.contextPath}/manager/invoice" style="flex:1;margin:0;padding:0;background:none;border:none;">
            <input type="hidden" name="action" value="list"><input type="text" name="keyword" class="form-control" placeholder="Tìm mã hóa đơn..." value="${keyword}"><button type="submit" class="btn btn-outline">🔍 Tìm</button>
        </form>
    </div></div>
    <c:if test="${invoices != null}"><c:choose><c:when test="${empty invoices}"><div class="no-data">Không có hóa đơn</div></c:when><c:otherwise>
        <div class="table-container"><table><thead><tr><th>Mã HD</th><th>Mã đặt phòng</th><th>Khách hàng</th><th>Ngày lập</th><th>Tổng tiền</th><th>Thanh toán</th><th></th></tr></thead><tbody>
        <c:forEach var="inv" items="${invoices}"><tr><td><strong>${inv.code}</strong></td><td>${inv.bookingCode}</td><td>${inv.customerName}</td><td><fmt:formatDate value="${inv.issueDate}" pattern="dd/MM/yyyy HH:mm"/></td>
            <td class="text-accent fw-bold"><fmt:formatNumber value="${inv.totalAmount}" pattern="#,##0"/>₫</td><td><span class="badge badge-info">${inv.paymentMethod}</span></td>
            <td><a href="${pageContext.request.contextPath}/manager/invoice?action=detail&id=${inv.id}" class="btn btn-outline btn-sm">👁️ Xem</a></td></tr></c:forEach>
        </tbody></table></div></c:otherwise></c:choose></c:if>
</main></div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
