<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Check-in</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
.booking-group{border:1px solid var(--border);border-radius:12px;margin-bottom:20px;overflow:hidden;box-shadow:var(--shadow-sm);}
.booking-group-header{display:flex;align-items:center;justify-content:space-between;padding:14px 20px;background:var(--bg-secondary);border-bottom:1px solid var(--border);flex-wrap:wrap;gap:10px;}
.booking-group-header .bk-code{font-size:17px;font-weight:700;color:var(--accent);}
.booking-group-header .bk-meta{font-size:13px;color:var(--text-muted);display:flex;gap:16px;flex-wrap:wrap;}
.room-rows{padding:0 16px 12px;}
.room-row{display:flex;align-items:center;gap:12px;padding:10px 0;border-bottom:1px dashed var(--border);flex-wrap:wrap;}
.room-row:last-child{border-bottom:none;}
.room-row .room-num{font-weight:700;min-width:60px;color:var(--text-primary);}
.room-row .room-type{color:var(--text-muted);font-size:13px;min-width:100px;}
.room-row .room-dates{font-size:13px;color:var(--text-secondary);flex:1;}
</style>
</head>
<body><div class="layout staff-layout"><jsp:include page="../components/sidebar.jsp"/>
<jsp:include page="../components/staff_header.jsp"/>
<main class="main-content fade-in">
    <div class="topbar"><div><h1><span>Check-in</span></h1><div class="breadcrumb">Hiển thị theo phiếu đặt</div></div></div>

    <form class="search-bar" method="get" action="${pageContext.request.contextPath}/staff/checkin">
        <input type="hidden" name="action" value="search">
        <input type="text" name="q" class="form-control" placeholder="Nhập mã phiếu hoặc tên khách..." value="${keyword}">
        <button type="submit" class="btn btn-primary">Tìm</button>
    </form>

    <c:if test="${results != null}">
        <c:choose>
            <c:when test="${empty results}">
                <div class="no-data">Không có phòng nào chờ check-in</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="b" items="${results}">
                    <div class="booking-group">
                        <div class="booking-group-header">
                            <div>
                                <span class="bk-code">${b.code}</span>
                                <div class="bk-meta">
                                    <span>${b.customerName}</span>
                                    <c:if test="${not empty b.customerPhone}"><span>${b.customerPhone}</span></c:if>
                                    <span>Đặt ngày: <fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy"/></span>
                                </div>
                            </div>
                            <c:choose>
                                <c:when test="${b.status=='Chưa nhận phòng'}"><span class="badge badge-info">${b.status}</span></c:when>
                                <c:when test="${b.status=='Lưu trú một phần'}"><span class="badge badge-primary">${b.status}</span></c:when>
                                <c:when test="${b.status=='Đang lưu trú'}"><span class="badge badge-primary">${b.status}</span></c:when>
                                <c:otherwise><span class="badge badge-warning">${b.status}</span></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="room-rows">
                            <c:forEach var="br" items="${b.rooms}">
                                <div class="room-row">
                                    <span class="room-num">${br.roomNumber}</span>
                                    <span class="room-type">${br.roomTypeName}</span>
                                    <span class="room-dates">
                                        Nhận: <fmt:formatDate value="${br.checkIn}" pattern="HH:mm dd/MM/yyyy"/>
                                        &nbsp;→&nbsp;
                                        Trả: <fmt:formatDate value="${br.checkOut}" pattern="HH:mm dd/MM/yyyy"/>
                                    </span>
                                    <span class="badge badge-warning" style="font-size:12px;">${br.roomStatus}</span>
                                    <a href="${pageContext.request.contextPath}/staff/checkin?action=confirm&bookedRoomId=${br.id}"
                                       class="btn btn-success btn-sm">Check-in</a>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </c:if>
</main>
</div><script src="${pageContext.request.contextPath}/js/main.js"></script></body></html>
