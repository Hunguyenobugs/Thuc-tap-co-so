<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Tìm phòng trống</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div class="layout staff-layout"><jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/staff_header.jsp"/><main class="main-content fade-in">

    <div class="topbar">
        <div>
            <h1>Đặt phòng - <span>Chọn phòng</span></h1>
            <div class="breadcrumb"><span>Bước 2: Tìm và thêm phòng vào giỏ</span></div>
        </div>
        <div>
            <span class="badge badge-primary" style="font-size:14px;padding:8px 14px;">Khách: <strong>${customer.fullName}</strong></span>
        </div>
    </div>

    <%-- Thông báo lỗi ngày không hợp lệ --%>
    <c:if test="${param.error == 'invalid_dates'}">
        <div class="alert alert-danger" style="background:#ff4d6d22;border:1.5px solid #ff4d6d;color:#ff4d6d;padding:12px 18px;border-radius:8px;margin-bottom:16px;">
            <strong>Ngày trả phòng phải sau ngày nhận phòng.</strong>
            Vui lòng chọn lại thời gian đặt phòng.
        </div>
    </c:if>

    <div class="detail-grid">
        <!-- Cột trái: Tìm phòng -->
        <div>
            <div class="card mb-3">
                <div class="card-header"><h3>Tìm phòng trống</h3></div>
                <form method="get" action="${pageContext.request.contextPath}/staff/booking">
                    <input type="hidden" name="action" value="searchRoom">
                    <input type="hidden" name="customerId" value="${customer.id}">
                    <div class="form-row">
                        <div class="form-group mb-0">
                            <label>Ngày nhận phòng</label>
                            <input type="date" id="checkInInput" name="checkIn" class="form-control" value="${checkIn}" required>
                        </div>
                        <div class="form-group mb-0">
                            <label>Ngày trả phòng</label>
                            <input type="date" id="checkOutInput" name="checkOut" class="form-control" value="${checkOut}" required>
                        </div>
                    </div>
                    <div class="form-group mt-2">
                        <label>Loại phòng</label>
                        <select name="roomTypeId" class="form-control">
                            <option value="">-- Chọn loại phòng --</option>
                            <c:forEach var="rt" items="${roomTypes}">
                                <option value="${rt.id}" ${selectedType==rt.id.toString()?'selected':''}>${rt.name} - <fmt:formatNumber value="${rt.basePrice}" pattern="#,##0"/>₫/đêm</option>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Tìm phòng</button>
                </form>
            </div>

            <c:if test="${rooms != null}">
                <div class="card">
                    <div class="card-header"><h3>Phòng trống</h3></div>
                    <c:choose>
                        <c:when test="${empty rooms}"><div class="no-data">Không có phòng trống trong khoảng thời gian này</div></c:when>
                        <c:otherwise>
                            <div class="table-container"><table><thead><tr><th>Số phòng</th><th>Tầng</th><th>Loại phòng</th><th>Giá/đêm</th><th></th></tr></thead><tbody>
                            <c:forEach var="r" items="${rooms}"><tr>
                                <td><strong>${r.roomNumber}</strong></td>
                                <td>Tầng ${r.floor}</td>
                                <td>${r.roomTypeName}</td>
                                <td class="text-accent fw-bold"><fmt:parseNumber value="${r.basePrice}" var="rp" integerOnly="false"/><fmt:formatNumber value="${rp}" pattern="#,##0"/>₫</td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/staff/booking" style="display:inline;">
                                        <input type="hidden" name="action" value="addToCart">
                                        <input type="hidden" name="roomId" value="${r.id}">
                                        <input type="hidden" name="checkIn" value="${checkIn}">
                                        <input type="hidden" name="checkOut" value="${checkOut}">
                                        <input type="hidden" name="customerId" value="${customer.id}">
                                        <button type="submit" class="btn btn-success btn-sm">Chọn</button>
                                    </form>
                                </td>
                            </tr></c:forEach>
                            </tbody></table></div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>

        <!-- Cột phải: Giỏ phòng đã chọn -->
        <div>
            <div class="card" style="position:sticky;top:100px;">
                <div class="card-header">
                    <h3>Các phòng đã chọn</h3>
                    <span class="badge badge-primary">${cart.size()} phòng</span>
                </div>
                <c:choose>
                    <c:when test="${empty cart}">
                        <div class="no-data" style="padding:20px;">Chưa có phòng nào<br><small>Tìm và thêm phòng vào giỏ</small></div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${cart}">
                            <div class="card mb-2" style="padding:12px;background:var(--bg-primary);">
                                <div class="flex-between">
                                    <div>
                                        <strong>Phòng ${item.roomNumber}</strong>
                                        <div class="fs-sm text-muted">${item.roomTypeName}</div>
                                        <div class="fs-sm text-muted">
                                            <fmt:parseDate value="${item.checkIn}" pattern="yyyy-MM-dd" var="pCI"/>
                                            <fmt:formatDate value="${pCI}" pattern="dd/MM"/> →
                                            <fmt:parseDate value="${item.checkOut}" pattern="yyyy-MM-dd" var="pCO"/>
                                            <fmt:formatDate value="${pCO}" pattern="dd/MM/yyyy"/>
                                            (${item.nights} đêm)
                                        </div>
                                    </div>
                                    <div style="text-align:right;">
                                        <div class="text-accent fw-bold"><fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>₫</div>
                                        <a href="${pageContext.request.contextPath}/staff/booking?action=removeRoom&roomId=${item.roomId}"
                                           class="btn btn-danger btn-sm mt-1"
                                           onclick="return confirm('Xóa phòng này khỏi giỏ?')">Xóa</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Tổng -->
                        <div style="border-top:2px solid var(--accent);padding-top:12px;margin-top:8px;text-align:center;">
                            <div class="fs-sm text-muted">TỔNG ƯỚC TÍNH</div>
                            <c:set var="total" value="0"/>
                            <c:forEach var="item" items="${cart}">
                                <c:set var="total" value="${total + item.subtotal}"/>
                            </c:forEach>
                            <div style="font-size:24px;font-weight:700;color:var(--accent);"><fmt:formatNumber value="${total}" pattern="#,##0"/>₫</div>
                        </div>

                        <a href="${pageContext.request.contextPath}/staff/booking?action=confirm" class="btn btn-primary btn-block btn-lg mt-3">
                            Xác nhận đặt (${cart.size()} phòng)
                        </a>
                    </c:otherwise>
                </c:choose>
                <a href="${pageContext.request.contextPath}/staff/booking?action=searchCustomer&reset=true" class="btn btn-outline btn-block mt-2">← Chọn lại khách</a>
            </div>
        </div>
    </div>

</main></div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    // Tự động set min checkOut = checkIn + 1 ngày
    const checkInEl = document.getElementById('checkInInput');
    const checkOutEl = document.getElementById('checkOutInput');

    function updateCheckOutMin() {
        if (!checkInEl.value) return;
        const next = new Date(checkInEl.value);
        next.setDate(next.getDate() + 1);
        const minDate = next.toISOString().split('T')[0];
        checkOutEl.min = minDate;
        // Nếu ngày trả hiện tại nhỏ hơn min thì xóa
        if (checkOutEl.value && checkOutEl.value <= checkInEl.value) {
            checkOutEl.value = minDate;
        }
    }

    if (checkInEl) {
        // Khởi tạo khi load
        const today = new Date().toISOString().split('T')[0];
        checkInEl.min = today;
        if (!checkInEl.value) checkInEl.value = today;
        updateCheckOutMin();
        checkInEl.addEventListener('change', updateCheckOutMin);
    }
</script>
</body></html>
