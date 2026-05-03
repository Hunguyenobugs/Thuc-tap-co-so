<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Admin - Grand Lotus Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout admin-layout">
    <jsp:include page="../components/sidebar.jsp"/>
    <jsp:include page="../components/admin_header.jsp"/>
    <main class="main-content fade-in">
        <div class="topbar">
            <div>
                <h1>📊 Tổng quan <span>Hệ thống</span></h1>
                <div class="breadcrumb"><span>Dashboard</span></div>
            </div>
        </div>
        
        <% if ("password_changed".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">✅ Đổi mật khẩu thành công</div>
        <% } %>

        <div class="stat-grid mb-3">
            <div class="stat-card">
                <div class="stat-label">Vai trò</div>
                <div class="stat-value text-accent">${sessionScope.currentUser.role}</div>
                <div class="stat-desc">Quản trị hệ thống</div>
            </div>
            <div class="stat-card green">
                <div class="stat-label">Xin chào</div>
                <div class="stat-value">${sessionScope.currentUser.fullName}</div>
                <div class="stat-desc">${sessionScope.currentUser.employeeCode}</div>
            </div>
        </div>

        <!-- Lofi Chill Container -->
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;500;700&display=swap');
            .lofi-container {
                height: 60vh; min-height: 500px; width: 100%; overflow: hidden;
                border-radius: var(--radius); font-family: 'Inter', sans-serif;
                background: linear-gradient(180deg, #090a0f 0%, #15162a 50%, #2b1f47 100%);
                position: relative; box-shadow: var(--shadow-lg); margin-top: 24px;
            }
            .stars {
                position: absolute; top: 0; left: 0; width: 100%; height: 100%;
                background-image: 
                    radial-gradient(1px 1px at 20px 30px, #eee, rgba(0,0,0,0)),
                    radial-gradient(1.5px 1.5px at 90px 40px, #fff, rgba(0,0,0,0)),
                    radial-gradient(2px 2px at 160px 120px, #ddd, rgba(0,0,0,0));
                background-repeat: repeat; background-size: 200px 200px;
                opacity: 0.6; /* Removed twinkle animation for performance */
            }
            .moon {
                position: absolute; top: 20%; left: 50%; transform: translateX(-50%);
                width: 120px; height: 120px; border-radius: 50%;
                background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 99%, #fecfef 100%);
                box-shadow: 0 0 40px rgba(255, 154, 158, 0.4), inset -10px -10px 20px rgba(0,0,0,0.1);
                animation: float-moon 8s ease-in-out infinite;
                will-change: transform;
            }
            @keyframes float-moon {
                0% { transform: translate(-50%, 0); }
                50% { transform: translate(-50%, -15px); }
                100% { transform: translate(-50%, 0); }
            }
            .status-card {
                position: absolute; top: 60%; left: 50%; transform: translate(-50%, -50%);
                background: rgba(255, 255, 255, 0.08); /* Removed backdrop-filter blur for huge performance gain */
                border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 20px;
                padding: 15px 30px; text-align: center; color: white;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3); z-index: 10; min-width: 200px;
            }
            .status-title { font-size: 1.1rem; font-weight: 500; margin-bottom: 0; letter-spacing: 1px; display: flex; align-items: center; justify-content: center; gap: 8px; }
            .pulse-dot {
                width: 12px; height: 12px; background-color: #10b981; border-radius: 50%;
                /* Removed pulse animation, just static green dot */
            }
            .ocean-container { position: absolute; bottom: 0; left: 0; width: 100%; height: 30%; min-height: 200px; }
            .waves { position: absolute; bottom: 0; width: 100%; height: 100%; display: block; }
            .parallax > use { animation: move-forever 35s linear infinite; } /* Slower, linear animation */
            .parallax > use:nth-child(1) { animation-delay: -2s; animation-duration: 15s; fill: rgba(43, 31, 71, 0.5); }
            .parallax > use:nth-child(2) { display: none; } /* Removed layer to optimize */
            .parallax > use:nth-child(3) { animation-delay: -4s; animation-duration: 25s; fill: rgba(15, 23, 42, 0.8); }
            .parallax > use:nth-child(4) { display: none; } /* Removed layer to optimize */
            @keyframes move-forever { 0% { transform: translate3d(-90px, 0, 0); } 100% { transform: translate3d(85px, 0, 0); } }
            
            .shooting-star {
                position: absolute; top: 10%; right: 20%; width: 100px; height: 2px;
                background: linear-gradient(to left, rgba(255,255,255,0), rgba(255,255,255,1));
                animation: shoot 7s infinite linear; transform: rotate(-45deg); opacity: 0;
                will-change: transform, opacity;
            }
            @keyframes shoot { 0% { transform: rotate(-45deg) translateX(0); opacity: 1; } 5% { transform: rotate(-45deg) translateX(-300px); opacity: 0; } 100% { transform: rotate(-45deg) translateX(-300px); opacity: 0; } }
        </style>

        <div class="lofi-container">
            <div class="stars"></div>
            <div class="shooting-star"></div>
            <div class="moon"></div>
            <div class="status-card">
                <div class="status-title" style="margin-bottom: 0;"><div class="pulse-dot"></div>Hệ thống ổn định</div>
            </div>
            <div class="ocean-container">
                <svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
                    <defs><path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" /></defs>
                    <g class="parallax">
                        <use xlink:href="#gentle-wave" x="48" y="0" />
                        <use xlink:href="#gentle-wave" x="48" y="3" />
                        <use xlink:href="#gentle-wave" x="48" y="5" />
                        <use xlink:href="#gentle-wave" x="48" y="7" />
                    </g>
                </svg>
            </div>
        </div>

    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
