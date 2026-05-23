<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Đặt phòng online - Grand Lotus Hotel</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body class="customer-page">
<jsp:include page="../components/customer_header.jsp"/>
<section class="section fade-in">
    <div class="topbar" style="margin-bottom:24px;">
        <div>
            <h2 style="margin:0;">Đặt phòng online</h2>
            <div class="breadcrumb"><span>Chọn phòng và thêm vào giỏ</span></div>
        </div>
    </div>

    <%-- Thông báo lỗi --%>
    <c:if test="${param.error == 'invalid_dates' || not empty error}">
        <div class="alert alert-danger" style="background:#ff4d6d22;border:1.5px solid #ff4d6d;color:#ff4d6d;padding:12px 18px;border-radius:8px;margin-bottom:16px;">
            <strong><c:choose>
                <c:when test="${not empty error}">${error}</c:when>
                <c:otherwise>Ngày trả phòng phải sau ngày nhận phòng.</c:otherwise>
            </c:choose></strong>
        </div>
    </c:if>
    <c:if test="${param.error == 'past_date'}">
        <div class="alert alert-danger" style="background:#ff4d6d22;border:1.5px solid #ff4d6d;color:#ff4d6d;padding:12px 18px;border-radius:8px;margin-bottom:16px;">
            <strong>Không thể chọn ngày trong quá khứ.</strong>
        </div>
    </c:if>

    <%-- Banner loại phòng đang chọn (hiện khi đã tìm kiếm) --%>
    <c:if test="${selectedRoomType != null}">
        <div class="card mb-3" style="border:2px solid var(--accent);background:linear-gradient(135deg, var(--bg-secondary), var(--bg-primary));">
            <div style="display:flex;align-items:center;gap:16px;flex-wrap:wrap;">
                <c:if test="${not empty selectedRoomType.imageUrl}">
                    <c:set var="firstImg" value="${selectedRoomType.imageUrl.split(',')[0]}"/>
                    <img src="${pageContext.request.contextPath}${firstImg}" style="width:120px;height:80px;object-fit:cover;border-radius:8px;" alt="${selectedRoomType.name}">
                </c:if>
                <div style="flex:1;min-width:200px;">
                    <h3 style="margin:0 0 4px 0;">${selectedRoomType.name}</h3>
                    <div class="fs-sm text-muted">${selectedRoomType.capacity} khách • ${selectedRoomType.area}</div>
                </div>
                <div style="text-align:right;">
                    <div class="text-accent fw-bold" style="font-size:20px;"><fmt:formatNumber value="${selectedRoomType.basePrice}" pattern="#,##0"/>₫<span class="fs-sm text-muted" style="font-weight:400;"> /đêm</span></div>
                    <div class="fs-sm text-muted">
                        <fmt:parseDate value="${checkIn}" pattern="yyyy-MM-dd" var="pCI"/>
                        <fmt:formatDate value="${pCI}" pattern="dd/MM/yyyy"/> →
                        <fmt:parseDate value="${checkOut}" pattern="yyyy-MM-dd" var="pCO"/>
                        <fmt:formatDate value="${pCO}" pattern="dd/MM/yyyy"/>
                        (${nights} đêm)
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <div class="detail-grid">
        <!-- Cột trái: Tìm phòng -->
        <div>
            <div class="card mb-3">
                <div class="card-header"><h3>Tìm phòng trống</h3></div>
                <form method="get" action="${pageContext.request.contextPath}/onlineBooking">
                    <input type="hidden" name="action" value="searchRoom">
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
                        <select name="roomTypeId" class="form-control" required>
                            <option value="">-- Chọn loại phòng --</option>
                            <c:forEach var="rt" items="${roomTypes}">
                                <option value="${rt.id}" ${selectedType==rt.id.toString()?'selected':''}>${rt.name} - <fmt:formatNumber value="${rt.basePrice}" pattern="#,##0"/>₫/đêm (${rt.capacity} khách)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Tìm phòng</button>
                </form>
            </div>

            <c:if test="${rooms != null}">
                <div class="card">
                    <div class="card-header">
                        <h3>Phòng trống</h3>
                        <c:if test="${not empty rooms}">
                            <span class="badge badge-success">${rooms.size()} phòng khả dụng</span>
                        </c:if>
                    </div>
                    <c:choose>
                        <c:when test="${empty rooms}"><div class="no-data">Không có phòng trống trong khoảng thời gian này.<br><small>Hãy thử chọn ngày khác hoặc loại phòng khác.</small></div></c:when>
                        <c:otherwise>
                            <div class="table-container"><table><thead><tr><th>Số phòng</th><th>Tầng</th><th>Loại phòng</th><th>Giá/đêm</th><th></th></tr></thead><tbody>
                            <c:forEach var="r" items="${rooms}"><tr>
                                <td><strong>${r.roomNumber}</strong></td>
                                <td>Tầng ${r.floor}</td>
                                <td>${r.roomTypeName}</td>
                                <td class="text-accent fw-bold"><fmt:parseNumber value="${r.basePrice}" var="rp" integerOnly="false"/><fmt:formatNumber value="${rp}" pattern="#,##0"/>₫</td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/onlineBooking" style="display:inline;">
                                        <input type="hidden" name="action" value="addToCart">
                                        <input type="hidden" name="roomId" value="${r.id}">
                                        <input type="hidden" name="checkIn" value="${checkIn}">
                                        <input type="hidden" name="checkOut" value="${checkOut}">
                                        <input type="hidden" name="roomTypeId" value="${selectedType}">
                                        <button type="submit" class="btn btn-success btn-sm">Chọn phòng này</button>
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
                        <div class="no-data" style="padding:20px;">Chưa có phòng nào<br><small>Tìm và thêm phòng vào giỏ bên trái</small></div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${cart}">
                            <div class="card mb-2" style="padding:12px;background:var(--bg-primary);">
                                <div class="flex-between">
                                    <div>
                                        <strong>Phòng ${item.roomNumber}</strong>
                                        <div class="fs-sm text-muted">${item.roomTypeName}</div>
                                        <div class="fs-sm text-muted">
                                            <fmt:parseDate value="${item.checkIn}" pattern="yyyy-MM-dd" var="pCI2"/>
                                            <fmt:formatDate value="${pCI2}" pattern="dd/MM"/> →
                                            <fmt:parseDate value="${item.checkOut}" pattern="yyyy-MM-dd" var="pCO2"/>
                                            <fmt:formatDate value="${pCO2}" pattern="dd/MM/yyyy"/>
                                            (${item.nights} đêm)
                                        </div>
                                    </div>
                                    <div style="text-align:right;">
                                        <div class="text-accent fw-bold"><fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>₫</div>
                                        <a href="${pageContext.request.contextPath}/onlineBooking?action=removeRoom&roomId=${item.roomId}"
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

                        <a href="${pageContext.request.contextPath}/onlineBooking?action=confirm" class="btn btn-primary btn-block btn-lg mt-3">
                            Xác nhận đặt (${cart.size()} phòng)
                        </a>
                    </c:otherwise>
                </c:choose>
                <a href="${pageContext.request.contextPath}/search" class="btn btn-outline btn-block mt-2">← Quay lại tìm phòng</a>
            </div>
        </div>
    </div>

</section>
<footer class="customer-footer">© 2025 Grand Lotus Hotel</footer>
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
        if (checkOutEl.value && checkOutEl.value <= checkInEl.value) {
            checkOutEl.value = minDate;
        }
    }

    if (checkInEl) {
        const today = new Date().toISOString().split('T')[0];
        checkInEl.min = today;
        if (!checkInEl.value) checkInEl.value = today;
        updateCheckOutMin();
        if (!checkOutEl.value) checkOutEl.value = checkOutEl.min;
        checkInEl.addEventListener('change', () => {
            updateCheckOutMin();
            if (!checkOutEl.value || checkOutEl.value <= checkInEl.value) {
                checkOutEl.value = checkOutEl.min;
            }
        });
    }
</script>
</body></html>
