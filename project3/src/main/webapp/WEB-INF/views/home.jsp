<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Home</title>
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8630523bb26c1a45d2753088246f3a05"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.3.0/dist/chart.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
<link rel="stylesheet" href="resources/css/style.css">
</head>
<body>
<img src="resources/img/police.png" id="police">

<div class="container">
    <!-- 지도 영역 -->
    <div class="left" id="map">
        <div class="currentPosition" id="current"><img src="../resources/img/current.png" style="width: 40px; height: 40px;"></div>
    </div>

    <!-- 오른쪽 차트 영역 -->
    <div class="right">
    
    <div class="tooltip-container" style="position: absolute; top: 105px; left: 61%;">
    <img src="resources/img/guide.png" alt="Info" class="info-icon">
    <span class="tooltiptext">0%의 범죄는 나타나지 않음</span>
</div>
    
        <!-- 현위치 범죄 예측 그래프 -->
		<div class="box">
		    <canvas id="donutChart1"></canvas>
		    <canvas id="barChart1"></canvas>
		</div>

        <!-- 전국 범죄 예측 그래프 -->
        <div class="box">
            <canvas id="donutChart"></canvas>
            <canvas id="barChart"></canvas>
        </div>
    </div>

    <!-- 시간/요일별 통계 영역 -->
    <div id="time">
        <div>시간 / 요일 통계를 기반으로 특정 시간대의 범죄 발생율 예측 차트</div>
    </div>

    <!-- 5대 범죄 예측 라인차트 영역 -->
    <div id="five">
        <canvas id="forecastChart" width="870" height="484"></canvas>
    </div>
</div>
<script type="text/javascript" src="resources/json/script.js"></script>
</body>
</html>
