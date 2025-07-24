<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Home</title>
	<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8630523bb26c1a45d2753088246f3a05"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.3.0/dist/chart.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
<link rel="stylesheet" href="../resources/css/style.css">
<style>
	.type-link{
		color: black;
    	text-decoration: none;
	}
	#thead{
		background-color: rgb(231, 231, 231);
	}
</style>
</head>
<body>

<!-- 로고빼고 전체 div -->
<div class="container">
	<!-- 홈페이지 로고 -->
<img src="../resources/img/crimelogo.png" id="police">
	<!-- CCTV와 비상벨 위치정보 영역 --> 
	<div class="header-bar">
	  <!-- CCTV div -->
	  <div class="dropdown-row">
	    <label for="city1">CCTV 확인하기</label> 
	    	<select name="city1" id="city1">
			  <option value="">시/도 선택</option>
			  <option value="서울특별시">서울특별시</option>
			  <option value="부산">부산</option>
			  <option value="대구">대구</option>
			  <option value="인천">인천</option>
			  <option value="광주">광주</option>
			  <option value="대전">대전</option>
			  <option value="울산">울산</option>
			  <option value="세종">세종</option>
			  <option value="경기도">경기도</option>
			  <option value="강원">강원</option>
			  <option value="충청북">충청북</option>
			  <option value="충청남">충청남</option>
			  <option value="전라북">전라북</option>
			  <option value="전라남">전라남</option>
			  <option value="경상북">경상북</option>
			  <option value="경상남">경상남</option>
			  <option value="제주특별자치">제주특별자치</option>
			</select>
	    <select name="district1" id="district1">
	     <option value="" selected>전체</option>
	      <!-- JS로 옵션 동적 생성 -->
	    </select>
	    <select name="purpose1" id="purpose1">
	     <option value="" selected>전체</option>
	      <!-- JS로 옵션 동적 생성 -->
	    </select>
	    <button id="searchCCTV" type="button" style="cursor:pointer; width:47px; height:32px;">확인</button>
	  </div>
	  
	  <!-- 안전 비상벨 div -->
		<div class="dropdown-row">
		  <label for="city2">안전 비상벨 확인하기</label>
		  <select name="city2" id="city2"><!-- JS가 옵션 채움 --></select>
		
		  <select name="district2" id="district2">
		    <option value="" selected>전체</option>
		  </select>
		
		  <select name="purpose2" id="purpose2">
		    <option value="" selected>전체</option>
		  </select>
		
		  <button id="searchBell" type="button" style="cursor:pointer; width:47px; height:32px;">
		    확인
		  </button>
		</div>
	</div>

	
	<!-- 모달 창 추가 -->
	<!-- 모달 전체 -->
	<div id="mapModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 9999;">
	
		  <!-- 모달 내부 컨텐츠 -->
		  <div style="position: relative; width: 80%; height: 80%; margin: 5% auto; background: white;">
	    
		    <!-- 닫기 버튼 (단 하나만) -->
		    <button id="closeModal" style="
		      position: absolute; top: 10px; right: 10px; 
		      z-index: 1000; background: #f44336; color: white; 
		      border: none; padding: 8px 12px; font-size: 14px; 
		      cursor: pointer; border-radius: 4px;">
		      닫기 ✖
		    </button>

	    <!-- 모달 지도 영역 -->
	    <div id="modalMap" style="width: 100%; height: 100%;"></div>
	  	</div>
	  	
	</div>
	
	
<!-- 기존 페이지 상단/하단 다른 내용 -->

<div class="main-content">
  <div class="left-group">
    <div class="container1">
    	<div class="left" id="map">
        	<div class="currentPosition" id="current"><img src="../resources/img/current.png" style="width: 40px; height: 40px;"></div>
    	</div>
    </div>
    
    

<div id="one">
  <a href="${pageContext.request.contextPath}/police/listP" 
     style="text-decoration: none; color: white; display: flex; align-items: center; gap: 10px;">
    <div>신고목록 조회하기</div>
    <img src="../resources/img/sos.png" alt="신고하기" style="height: 24px; width: auto;">
  </a>
</div>

  </div>

  <div class="right">
    <div class="tooltip-container" style="position: absolute; top: 200px; left: 61%;">
      <img src="../resources/img/guide.png" alt="Info" class="info-icon">
      <span class="tooltiptext">0%의 범죄는 나타나지 않음</span>
    </div>

    <div class="box">
      <canvas id="donutChart1"></canvas>
      <canvas id="barChart1"></canvas>
    </div>

    <div class="list">
      <table class="reportList" id="reportList">
      	<tr id="thead">
      		<td class="type">범죄유형</td>
      		<td class="state">진행상태</td>
      		<td class="time">접수 시각</td>
      	</tr>
      </table>
    </div>
  </div>
</div>


    <!-- 시간/요일별 통계 영역 -->
	<div id="time">
	<span class="time_day">요일/시간별 5대 범죄 발생율 추이</span>
		<div id="time-multi-charts" style="display: flex; flex-wrap: wrap; gap: 20px;">
		  <canvas id="timechart-살인" ></canvas>
		  <canvas id="timechart-강간및추행" ></canvas>
		  <canvas id="timechart-상해및폭행" ></canvas>
		  <canvas id="timechart-교통범죄"  ></canvas>
		  <canvas id="timechart-강도및절도" ></canvas>
		</div>
	</div>
  

    <!-- 5대 범죄 예측 라인차트 영역 -->
	<div id="five">
	  <div class="forecast-wrapper">
	    <div class="tab-bar">
	      <span class="crime-tab active" data-crime="교통 범죄">교통 범죄</span>
	      <span class="crime-tab" data-crime="살인">살인</span>
	      <span class="crime-tab" data-crime="강간 및 추행">강간 및 추행</span>
	      <span class="crime-tab" data-crime="상해 및 폭행">상해 및 폭행</span>
	      <span class="crime-tab" data-crime="강도 및 절도">강도 및 절도</span>
	      
		  <div class="tooltip-container" style="margin-left: 10px;">
		  <img src="../resources/img/alert2.png" alt="알림" class="info-icon2">
		  <span class="tooltiptext2">2024년 범죄 통계는 관계기관의 집계 일정에 따라 2025년 8월에 공표될 예정이며,<br> 현재 데이터는 제공되지 않습니다.</span>
		  </div>
	    </div>
	    
	    <canvas id="forecastChart" <%-- width="1100px" height="600px" --%>></canvas>
	  </div>
	</div>
 
	<div id="declaration" style="display:flex; align-items:center; gap:170px;">
	  <canvas id="Reportreceived" width="700" height="400"></canvas>
	  <!-- 출동시간 표시용 div 추가 -->
	  <div id="arrivalTimeCircle" 
	       style="
	         width: 280px; height: 280px; 
	         border-radius: 50%; background-color: rgba(0, 123, 255,0.9); 
	         color: white; display: flex; flex-direction: column; align-items: center; justify-content: center; 
	         font-size: 20px; font-size: 22px;
	         user-select: none;  text-align: center;
	         box-shadow: 0 0 30px rgba(0, 123, 255,0.9);
	         ">
	    년도를 선택해 주세요
	  </div>
	</div> 
   
 
<!-- 	<div id="declaration"> -->
<%-- 		<canvas id="Reportreceived">112 신고접수 막대그래프</canvas> --%>
<%-- 		<canvas id="Reportprediction">112 평균 현장 도착 시간 </canvas> --%>
<!-- 	</div> -->


		<div id="location">
	   			<canvas id="stacked"></canvas>
				<div id="radar">
				  <canvas id="crimeTopChart"></canvas>
		 		</div>

		</div>

</div> 


<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.3.0/dist/chart.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-chart-matrix@4.3.0/dist/chartjs-chart-matrix.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-chart-matrix@1.1.0/dist/chartjs-chart-matrix.min.js"></script>
<script type="text/javascript" src="../resources/json/policeboxScript.js"></script>

</body>
</html>
