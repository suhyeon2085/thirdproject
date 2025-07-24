<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>범죄 예측 페이지</title>
<!-- 지도 api 자바스크립트 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8630523bb26c1a45d2753088246f3a05"></script>



<style>

body {
  margin: 0;
  padding: 10px;
  background-color: rgb(0, 51, 153);
  font-family: 'Segoe UI', sans-serif;
  color: black;
  overflow-x: hidden; /* ★ 추가해보세요 */
}

/*전체 div */
.container-total{
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-left: 7%;
        margin-right: 7%;
}
 
/*지도 신고 현위치 전국차트만 포함한 div*/
    .container {
        display: flex;
        flex-wrap: wrap;
        height: 100vh; /* 전체 높이 기준이면 명확히 */
        padding: 0;    /* 필요시 추가 여백 제거 */
  		width:100%;
  		height:710px;
  		}



/* 신고 전체 div*/
#one {
  background-color: #ff4d4d;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 12px 20px;
  font-size: 20px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.2);
  cursor: pointer;
  height: 100px;          /* 높이를 60px로 고정 */
  width: 100%; 
  transition: transform 0.2s, box-shadow 0.2s;
  box-sizing: border-box;
  margin-top: 5px;
}
#one:hover {
  transform: scale(1.02); /* 2%만 확대 */
  box-shadow: 0 6px 12px rgba(0,0,0,0.25); /* 그림자도 살짝 줄임 */
}

/*신고 글자 */
#one div {
  font-weight: bold;
  font-size: 22px;
  letter-spacing: 1px;
  font-family: 'Segoe UI', sans-serif;
  
}

#one img {
  height: 24px;
  width: 24px;
  object-fit: contain;
}

.tooltip-container {
  position: absolute;
  top: 100%;   /* 필요 시 조정 */
  right: 0px;   /* 오른쪽 정렬 (필요시 center도 가능) */
  z-index: 10;
}

/* 툴팁 텍스트 스타일 조정 */
.tooltiptext {
  visibility: hidden;
  width: 180px;
  background-color: white;
  color: black;
  text-align: center;
  border: 1px solid black;
  border-radius: 2px;
  padding: 5px;
  position: absolute;
  top: 100%; /* 아이콘 바로 아래 위치 (조절 가능) */
  left: 50%;
  transform: translateX(-50%);
  z-index: 1;
  font-size: 14px;
  white-space: nowrap;
}

/* 마우스 올릴 때만 표시 */
.tooltip-container:hover .tooltiptext {
  visibility: visible;
}
/* 왼쪽 그룹: 지도, 신고 버튼 등 */
.left-group {
  display: flex;
  flex-direction: column;
  height: 710px;          /* 전체 높이 */
  width: 550px;           /* 좌측 너비 */
  flex: 0 0 550px;        /* 고정 가로 폭 */
  gap: 10px;              /* 요소간 간격 */
  box-sizing: border-box;
}

/* /* 지도와 신고 영역 포함하는 패널 */ */
 .left { 
   border: 3px solid rgb(255, 204, 0); 
   background: rgb(245, 247, 250); 
   box-sizing: border-box; 
   height: 710px; 
   width: 100%;              /* 💡 .left-group 기준 100%로 */ 
 } 
/* 지도 영역 */
.left#map {
  border: 3px solid rgb(255, 204, 0);
  background: rgb(245, 247, 250);
  flex: none;                /* 남은 공간 모두 차지 */
  height: 600px;      /* 지도 최소 높이 */
  box-sizing: border-box;
  position: relative;
}
/* 오른쪽 전체: 차트 영역 */
.right {
  flex: 1;                /* 남은 공간 자동 채움 */
  display: flex;
  flex-direction: column;
  gap: 10px;
  box-sizing: border-box;
  margin-left: 10px;
  align-items: center;
  position: relative;
  max-height: none;       /* 고정 높이 해제 */
}

/* 공통 차트 박스 */
.right .box {
  flex: none;
  border: 3px solid rgb(255, 204, 0);
  background: rgb(245, 247, 250);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  width: 100%;
  height: 350px;
  box-sizing: border-box;
}

/* 현위치 차트 (도넛) */
#donutChart1 {
  width: 380px !important;       /* 💡 가로 확대 */
  height: 370px !important;      /* 💡 세로 확대 */
  margin-left: 20px;
}
#donutChart {
  width: 380px !important;
  height: 370px !important;
  padding: 0;
}

/* 연도별 검거율 차트 (막대) */
#barChart1 {
  width: 380px !important;       /* 💡 더 넓게 */
  height: 420px !important;      /* 💡 더 높게 */
}
#barChart {
  width: 380px !important;
  height: 420px !important;
}


	#location {
	  display: flex;
	  justify-content: space-between;;
	  align-items: center;
	  gap: 1px;  /* 차트 사이 간격 */
	  width: 100%;
	  height: 600px;
	  border: 3px solid rgb(255, 204, 0);
	  background: rgb(245, 247, 250);
	  box-sizing: border-box;
	  position: relative;
	  text-align: center; /* span을 중앙에 정렬 */
	}
	
	
	#stacked {
	  flex: 2;           /* 기존 3 → 2 (너비 줄임) */
	  max-width: 40%;    /* 기존 60% → 40% */
	  height: 100%;
	  display: flex;
	  justify-content: center;
	  align-items: center;
	}
	
	#radar {
	  flex: 3;           /* 기존 2 → 3 (너비 늘림) */
	  max-width: 60%;    /* 기존 40% → 60% */
	  height: 100%;      /* 기존 100% → 120% (높이 늘림) */
	  display: flex;
	  justify-content: center;
	  align-items: center;
	}
	
	
	#stacked canvas{
	  width: 100% !important;
	  height: auto !important;
	  max-height: 100%;
	}
	
	#crimeTopChart canvas {
	  width: 100% !important;
	  height: auto !important;
	  max-height: 100%;
	}


	  /*신고접수 div*/
	#declaration{
	  position: relative;
	  display: flex;
	  flex-direction: row;
	  align-items: center;
	  justify-content: center;
	  width: 100%;
	  height: 550px;
	  margin-top: 20px;
	  border: 3px solid rgb(255, 204, 0);
/* 	  padding-top: 80px; */
	  background: rgb(245, 247, 250);
	  box-sizing: border-box;
	  margin-bottom: 20px;
	}
	
	#Reportreceived{
        width: 900px !important;
        height: 500px !important;
	}

/*     /* 도넛 차트 */ */
/*     #donutChart1 { */
/*         width: 300px !important; */
/*         height: 320px !important; */
/*         margin-left: 35px;  */
/*     } */
/*     #donutChart{ */
/*         width: 300px !important; */
/*         height: 320px !important; */
/*         padding: 0; */
/*     } */
    

/*     /* 막대 차트 */ */
/*     #barChart1 { */
/*         width: 520px !important; */
/*         height: 320px !important; */
/*     } */
/* 	#barChart{ */
/*         width: 530px !important; */
/*         height: 320px !important; */
/* 	} */

    /* 예측 차트 */
    #forecastChart {
        background: rgb(245, 247, 250, 0.9);
        width: 900px;  /* 또는 원하는 값으로 조절 */
    	height: 600px;
    }

	/*  시간/요일 차트  */
	#time-multi-charts canvas {
	  max-width: 300px;
	  max-height: 360px;
	  width: 100%;
	  height: 290px;
	}

    /* 시간 / 요일 / 예측 영역 */
	#time {
	  position: relative;
	  display: flex;
	  flex-direction: column;
	  align-items: center;      /* 가로 중앙 */
	  justify-content: center;  /* 세로 중앙 */
	  width: 100%;
	  height: 450px;            /* 높이 지정해서 세로 중앙 효과 */
	  margin-top: 20px;
	  border: 3px solid rgb(255, 204, 0);
	  background: rgb(245, 247, 250);
	  box-sizing: border-box;
	}
	    
	.time_day {
	  position: absolute;
	  top: 15px;                    /* 위쪽 여백 살짝 늘림 */
	  left: 50%;                   /* 가로 중앙 */
	  transform: translateX(-50%);
	  font-weight: 700;
	  font-size: 28px;
	  color: rgb(0, 51, 153);
	  padding: 6px 20px;
	  border: 3px solid rgb(255, 204, 0);
	  box-sizing: border-box;
	  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	  z-index: 10;
	}

	
	/* 제5대 범죄 예측차트 */
	#five {
	  display: flex;
	  justify-content: center;
	  align-items: center;
	  width: 100%;
	  
	  height: 650px;
	  margin-top: 20px;
	  background: linear-gradient(rgba(255,255,255,0.3), rgba(255,255,255,1)),
	              url('resources/img/crimelogo.png');
	  background-repeat: repeat;
	  background-position: center center;
	  background-size: calc(100% / 3) 650px;
	  background-blend-mode: lighten;  /* or overlay */
	  border: 3px solid rgb(255, 204, 0);
	  box-sizing: border-box;
	  flex-direction: column;
	}
	
	.forecast-wrapper {
	  width: 1100px;
	  display: flex;
	  flex-direction: column;
	  align-items: center;
	}
	
	.tab-bar {
	  display: flex;
	  justify-content: center;
	  flex-wrap: wrap;
	  margin-bottom: 5px;
	  margin-top: 1px;
	}
	
	.crime-tab {
	  cursor: pointer;
	  margin: 0 10px;
	  font-weight: bold;
	  font-size: 18px;
	  color: rgb(0, 51, 153);
	  padding: 6px 10px;
	  border-bottom: 3px solid transparent; 
	  transition: all 0.3s;
	  margin-bottom: 10px;   
	  background: rgba(255,255,255,0.5);
	  width: 120px;
	  height: 25px;
	  
	  display: flex;                /* ⭐ Flexbox 사용 */
	  justify-content: center;      /* 가로 중앙 정렬 */
	  align-items: center;   
	}
	
	.crime-tab:hover {
	  color: white;
	  
	}
	
	.crime-tab.active {
	  border-bottom: 3px solid rgb(255, 204, 0);
	}
	
    
    .info-icon {
        width: 30px;
        height: 30px;
        cursor: pointer;
    }
    
    
    .info-icon2{
        width: 35px;
        height: 35px;
        cursor: pointer;
    }
    
	.tooltip-container2 {
	  position: relative;  /* 변경: 상대 위치 기준으로 툴팁 표시 */
	  display: inline-block;
	  margin-left: 10px;
	  cursor: pointer;
	}
	.tooltiptext2 {
	  visibility: hidden;
	  width: 320px;
	  background-color: white;
	  color: black;
	  text-align: center;
	  border: 1px solid black;
	  border-radius: 2px;
	  padding: 5px;
	  position: absolute;
	  top: 40px;  /* 이미지 밑에 글짜뜨는 거리 조절 */
	  left: 50%;
	  transform: translateX(-50%);
	  z-index: 999;  /* 다른 요소보다 위에 표시되게 */
	  font-size: 14px;
	  white-space: normal;
	  line-height: 1.4;
	}
        .tooltip-container2:hover .tooltiptext2 {
        visibility: visible;
    }

    /* 경찰 마크 이미지 */
    #police {
        width: 100px;
        height: 100px;
        margin-bottom: 2px;
        padding: 0;
    }
    
.header-bar {
    display: flex;          /* 가로 정렬 추가 */
    justify-content: center;/* 중앙 정렬 */
    align-items: center;    /* 수직 중앙 정렬 */
    width: 100%;
    height: 50px;
    background: rgb(245, 247, 250,0.5);
    border: 2px solid gold; /* 노란색 테두리 */
    color: white;
    font-weight: bold;
    font-size: 20px;
    text-align: center;
    line-height: 30px;
    box-sizing: border-box;
    margin-bottom: 10px;
}

/* .dropdown-row가 한 줄 유지되도록 */
.dropdown-row {
  display: flex;
  gap: 3px;
  margin: 10px;
  height: 32px;
  flex-wrap: nowrap; /* ✅ 줄바꿈 방지 */
  align-items: center; /* ✅ 수직 정렬 보정 */
}

/* 라벨이 줄바꿈 없이 가로 정렬되도록 */
.dropdown-row label {
  display: flex;
  align-items: center;       /* 수직 중앙 정렬 */
  font-size: 14px;           /* 글자 작게 */
  margin-right: 6px;         /* select와 간격 */
  white-space: nowrap;       /* 줄바꿈 방지 */
  height: 32px;              /* select와 높이 맞춤 */
}


select {
  appearance: none;           /* 기본 화살표 제거 */
  -webkit-appearance: none;
  -moz-appearance: none;
  background-color: #fff;
  border: 1.5px solid #f1c40f; /* 노란색 테두리 */
  border-radius: 6px;
  padding: 8px 38px 8px 12px;  /* 오른쪽 여유 공간은 화살표 아이콘 자리 */
  font-size: 14px;
  color: #333;
  cursor: pointer;
  transition: border-color 0.3s ease;
  position: relative;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  width: 200px;
  height: 32px;
}

/* 마우스 올릴 때 테두리 강조 */ 
select:hover, select:focus {
  border-color: #f39c12;
  outline: none;
}

select:active {
  border-color: #d78f0f;
  box-shadow: inset 2px 2px 2px rgba(0,0,0,0.3);
  outline: none;
}


/* 화살표 커스텀: select 박스 내부 오른쪽에 삼각형 */
select {
  background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20width%3D%2210%22%20height%3D%227%22%20viewBox%3D%220%200%2010%207%22%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%3E%3Cpath%20d%3D%22M0%200l5%207%205-7z%22%20fill%3D%22%23f1c40f%22/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 12px center;
  background-size: 10px 7px;
}

#search{
width: 32px;
height: 32px;
    justify-content: center;/* 중앙 정렬 */
    align-items: center;    /* 수직 중앙 정렬 */
    display: flex;
    color: yellow;
}

#searchBell, #searchCCTV{
background-color: white;
 background-color: #fff;
  border: 1.5px solid #f1c40f; /* 노란색 테두리 */
  border-radius: 6px;
}


/* 모던창 주소 창 css*/
.infowindow-address {
  padding: 6px 10px;
  font-size: 13px;
  background-color: white;
  border: 1px solid #888;
  border-radius: 4px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
  color: #333;
  font-weight: 500;
}

/*모던 창 닫기 css*/
#closeModal {
  background: #f44336;
  color: white;
  border: none;
  padding: 8px 12px;
  font-size: 14px;
  cursor: pointer;
  border-radius: 4px;
}

#closeModal:hover {
  background: #d32f2f;
}


	/*수현씨가 만든 css*/
	.tracker {
	    position: absolute;
	    margin: -35px 0 0 -30px;
	    display: none;
	    cursor: pointer;
	    z-index: 3;
	}
	
	.icon {
	    position: absolute;
	    left: 6px;
	    top: 9px;
	    width: 48px;
	    height: 48px;
	    background-image: url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/sign-info-48.png);
	}
	
	.balloon {
	    position: absolute;
	    width: 60px;
	    height: 60px;
	    background-image: url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/balloon.png);
	    -ms-transform-origin: 50% 34px;
	    -webkit-transform-origin: 50% 34px;
	    transform-origin: 50% 34px;
	}
	    .currentPosition {
    	width: 40px;
    	height: 40px;
    	background-color: white;
    	border: 1px solid black;
    	border-radius: 10%;
    	position: absolute;
    	z-index: 2;
    }


</style>

</head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<body>
<!-- 홈페이지 로고 -->
<img src="resources/img/crimelogo.png" id="police">
<!-- 로고빼고 전체 div -->
<div class="container-total">

	
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
	    <div id="map2" style="width: 100%; height: 100%;"></div>
	  	</div>
	  	
	</div>
	
<!-- 지도와 툴팁과 현위치 + 전국 차트들  -->
<div class="container">
  <!-- 왼쪽 그룹: 지도 + 신고 버튼 -->
  <div class="left-group">
    <div class="left" id="map">
      <div class="currentPosition" id="current">
        <img src="../resources/img/current.png" style="width: 40px; height: 40px;">
      </div>
    </div>
    <div id="one">
      <a href="/receipt" style="text-decoration: none; color: white; display: flex; align-items: center; gap: 10px;">
        <div>도움이 필요하신가요? 여기로 신고해 주세요</div>
        <img src="/resources/img/sos.png" alt="신고하기" style="height: 24px; width: auto;">
      </a>
    </div>
  </div>

  <!-- 오른쪽 그룹: 차트들 -->
  <div class="right">
    <div class="tooltip-container">
      <img src="resources/img/guide.png" alt="Info" class="info-icon">
      <span class="tooltiptext">0%의 범죄는 나타나지 않음</span>
    </div>

    <div class="box">
      <canvas id="donutChart1"></canvas>
      <canvas id="barChart1"></canvas>
    </div>

    <div class="box">
      <canvas id="donutChart"></canvas>
      <canvas id="barChart"></canvas>
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
	      
		  <div class="tooltip-container2" style="margin-left: 10px;">
		  <img src="resources/img/alert2.png" alt="알림" class="info-icon2">
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
	         font-weight: bold; font-size: 20px; font-size: 22px;
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



<script>


let cctvData = [];

// 시/도 선택 시 JSON 파일 로드
document.getElementById('city1').addEventListener('change', async function () {
  const selectedCity = this.value.trim();
  const districtSelect = document.getElementById('district1');
  const purposeSelect = document.getElementById('purpose1');

  // 옵션 초기화
  districtSelect.innerHTML = '<option value="">전체</option>';
  purposeSelect.innerHTML = '<option value="">전체</option>';
  cctvData = [];

  if (!selectedCity) return;

  try {
    const fileUrl = "/resources/data/" + selectedCity+ ".json";
    const res = await fetch(fileUrl);
    if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);

    const data = await res.json();
    cctvData = data;

    populateDistrictAndPurpose(data, 'district1', 'purpose1');
  } catch (err) {
    console.error('❌ JSON 로드 실패:', err);
  }
});

// 구/군 + 설치목적 옵션 채우기
function populateDistrictAndPurpose(data, districtId, purposeId) {
  const districtSet = new Set();
  const purposeSet = new Set();

  const validDistrictRegex = /^[가-힣]+(시|군|구)$/; // 예: 강남구, 고양시, 전주시 등

  data.forEach(item => {
    const rawDistrict = item.sigungu?.trim();
    const rawPurpose = item.purpose?.trim();

    // ✅ 구/군 필터: 한글로 구성된 'xx구', 'xx시', 'xx군' 형태만
    if (rawDistrict && validDistrictRegex.test(rawDistrict)) {
      districtSet.add(rawDistrict);
    }

    // ✅ 설치목적 필터: 빈 값 아닌 경우만
    if (rawPurpose && rawPurpose !== '') {
      purposeSet.add(rawPurpose);
    }
  });

  addOptions(document.getElementById(districtId), districtSet);
  addOptions(document.getElementById(purposeId), purposeSet);
}


// 구 선택 시 설치목적 필터링
document.getElementById('district1').addEventListener('change', function () {
  const selectedDistrict = this.value.trim();
  const purposeSelect = document.getElementById('purpose1');

  purposeSelect.innerHTML = '<option value="">전체</option>';

  const filteredData = !selectedDistrict
    ? cctvData
    : cctvData.filter(item => item.sigungu?.trim() === selectedDistrict);

  const purposeSet = new Set();
  filteredData.forEach(item => {
    if (item.purpose && item.purpose.trim() !== '') {
      purposeSet.add(item.purpose.trim());
    }
  });

  addOptions(purposeSelect, purposeSet);
});

// 옵션 추가 함수 (가나다 정렬)
function addOptions(select, set) {
  const sortedArray = Array.from(set).sort((a, b) => a.localeCompare(b, 'ko'));
  sortedArray.forEach(val => {
    const opt = new Option(val, val);
    select.appendChild(opt);
  });
}

// 페이지 로드시 시/도 옵션 세팅
window.addEventListener('DOMContentLoaded', () => {
  const citySelect = document.getElementById('city1');
  const sidoList = [
    "서울특별시", "부산", "대구", "인천",
    "광주", "대전", "울산", "세종",
    "경기", "강원", "충청북", "충청남",
    "전라북", "전라남", "경상북", "경상남", "제주특별자치"
  ];

  citySelect.innerHTML = '<option value="">시/도 선택</option>';
  sidoList.forEach(city => {
    const opt = new Option(city, city);
    citySelect.appendChild(opt);
  });
});

// 검색 버튼 클릭 시 지도 표시
document.getElementById('searchCCTV').addEventListener('click', function () {
  const selectedDistrict = document.getElementById('district1').value.trim();
  const selectedPurpose = document.getElementById('purpose1').value.trim();

  const filteredData = cctvData.filter(item => {
    const sigungu = item.sigungu?.trim() || '';
    const address = item.address?.trim() || '';
    const purpose = item.purpose?.trim() || '';

    const districtMatch = !selectedDistrict || sigungu === selectedDistrict || address.includes(selectedDistrict);
    const purposeMatch = !selectedPurpose || purpose === selectedPurpose;

    return districtMatch && purposeMatch;
  });

  if (filteredData.length === 0) {
    alert("해당 조건의 CCTV가 없습니다.");
    return;
  }

  document.getElementById('mapModal').style.display = 'block';
  drawMap(filteredData);
});

// 지도 표시
function drawMap(locations) {
  if (typeof kakao === 'undefined') {
    console.error("Kakao Maps가 로딩되지 않았습니다.");
    return;
  }

  kakao.maps.load(function () {
    const container = document.getElementById('map');
    container.innerHTML = "";

    const centerLat = locations[0].latitude;
    const centerLng = locations[0].longitude;

    const map = new kakao.maps.Map(container, {
      center: new kakao.maps.LatLng(centerLat, centerLng),
      level: 2
    });

    locations.forEach(item => {
      const position = new kakao.maps.LatLng(item.latitude, item.longitude);

      const marker = new kakao.maps.Marker({
        map: map,
        position: position,
        title: item.address || '주소 없음'
      });

      const infowindow = new kakao.maps.InfoWindow({
        content: `<div style="padding:5px; font-size:13px;">🏠 ${item.address || '주소 없음'}</div>`
      });

      kakao.maps.event.addListener(marker, 'click', function () {
        infowindow.open(map, marker);
      });
    });
  });
}

// 모달 닫기
document.getElementById('closeModal').addEventListener('click', function () {
  document.getElementById('mapModal').style.display = 'none';
});
	
	
// 이제부터는 방범용벨 -----------------------------------------------------------------------------------------------
let bellData = [];

// 비상벨 시/도 선택 시 JSON 로드
document.getElementById('city2').addEventListener('change', async function () {
  const selectedCity = this.value;

  // 옵션 초기화
  const districtSelect = document.getElementById('district2');
  const purposeSelect = document.getElementById('purpose2');
  districtSelect.innerHTML = '<option value="">전체</option>';
  purposeSelect.innerHTML = '<option value="">전체</option>';
  bellData = [];

  if (!selectedCity) return;

  try {
    const fileUrl = "/resources/data/"+selectedCity+"_bell.json"; // 경로는 프로젝트에 맞게 수정
    const res = await fetch(fileUrl);
    if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);

    const data = await res.json();
    bellData = data;

    populateBellDistrictAndPurpose(bellData, 'district2', 'purpose2');
  } catch (err) {
    console.error('❌ 비상벨 JSON 로드 실패:', err);
  }
});

// 구 선택 시 설치목적 다시 필터링
document.getElementById('district2').addEventListener('change', function () {
  const selectedDistrict = this.value.trim();

  const purposeSelect = document.getElementById('purpose2');
  purposeSelect.innerHTML = '<option value="">전체</option>';

  if (!selectedDistrict) {
    // 구 선택 안 하면 시/도 전체 데이터 기준 설치목적 보여주기
    const purposeSet = new Set();
    bellData.forEach(item => {
      if (item.purpose && item.purpose.trim() !== '') {
        purposeSet.add(item.purpose.trim());
      }
    });
    addBellOptions(purposeSelect, purposeSet);
    return;
  }

  // 선택한 구에 해당하는 데이터 필터링 후 설치목적만 추출
  const filteredData = bellData.filter(item => item.sigungu?.trim() === selectedDistrict);
  const purposeSet = new Set();
  filteredData.forEach(item => {
    if (item.purpose && item.purpose.trim() !== '') {
      purposeSet.add(item.purpose.trim());
    }
  });

  addBellOptions(purposeSelect, purposeSet);
});

// 비상벨 구/군, 설치목적 필터 옵션 채우기
function populateBellDistrictAndPurpose(data, districtId, purposeId) {
  const districtSet = new Set();
  const purposeSet = new Set();

  data.forEach(item => {
    const rawDistrict = item.sigungu?.trim();
    const rawPurpose = item.purpose?.trim();

    if (
      rawDistrict &&
      rawDistrict !== '' &&
      !/[0-9]/.test(rawDistrict) &&             // 숫자 제외
      !/[-–—?]/.test(rawDistrict) &&            // 특수문자 포함 제외
      !/^[-–—?]+$/.test(rawDistrict) &&         // 특수문자만 있는 경우 제외
      rawDistrict.length >= 2                    // 너무 짧은 문자열 제외
    ) {
      districtSet.add(rawDistrict);
    }

    if (rawPurpose && rawPurpose !== '') {
      purposeSet.add(rawPurpose);
    }
  });

  addBellOptions(document.getElementById(districtId), districtSet);
  addBellOptions(document.getElementById(purposeId), purposeSet);
}

function addBellOptions(select, set) {
  Array.from(set).sort().forEach(val => {
    const opt = document.createElement('option');
    opt.value = val;
    opt.textContent = val;
    select.appendChild(opt);
  });
}

// 시/도 목록 로딩 (초기화)
window.addEventListener('DOMContentLoaded', () => {
  const city2 = document.getElementById('city2');
  const sidoList = [
    "서울", "부산", "대구", "인천", "광주", "대전", "울산", "세종",
    "경기도", "강원", "충청북", "충청남", "전북", "전라남", "경상북", "경상남", "제주"
  ];

  city2.innerHTML = '<option value="">시/도 선택</option>';
  sidoList.forEach(city => {
    const opt = new Option(city, city);
    city2.appendChild(opt);
  });
});

// 확인 버튼 클릭 시 지도 표시
document.getElementById('searchBell').addEventListener('click', function () {
  const selectedDistrict = document.getElementById('district2').value.trim();
  const selectedPurpose = document.getElementById('purpose2').value.trim();

  const filteredData = bellData.filter(item => {
    const sigungu = item.sigungu?.trim() || '';
    const purpose = item.purpose?.trim() || '';

    const districtMatch = !selectedDistrict || sigungu === selectedDistrict;
    const purposeMatch = !selectedPurpose || purpose === selectedPurpose;

    return districtMatch && purposeMatch;
  });

  if (filteredData.length === 0) {
    alert("해당 조건의 비상벨이 없습니다.");
    return;
  }

  document.getElementById('mapModal').style.display = 'block';
  drawBellMap(filteredData);
});

// 지도에 비상벨 마커 표시
function drawBellMap(locations) {
  if (typeof kakao === 'undefined') {
    console.error("Kakao Maps가 로드되지 않았습니다.");
    return;
  }

  kakao.maps.load(function () {
    const container = document.getElementById('map');
    container.innerHTML = "";

    const centerLat = locations[0].latitude;
    const centerLng = locations[0].longitude;

    const map = new kakao.maps.Map(container, {
      center: new kakao.maps.LatLng(centerLat, centerLng),
      level: 4
    });

    locations.forEach(item => {
      const position = new kakao.maps.LatLng(item.latitude, item.longitude);

      const marker = new kakao.maps.Marker({
        map: map,
        position: position,
        title: item.address || '주소 없음'
      });

      const infowindow = new kakao.maps.InfoWindow({
        content: `
          <div style="padding:5px; font-size:13px;">
            🏠 ${item.address || '주소 없음'}<br/>
            ☎️ ${item.manager_phone || '관리번호 없음'}<br/>
            🔔 벨 ID: ${item.bell_id || '없음'}<br/>
            👮 경찰 연계: ${item.police_linked || '미확인'}
          </div>`
      });

      kakao.maps.event.addListener(marker, 'click', function () {
        infowindow.open(map, marker);
      });
    });
  });
}






















let regionMap = {
		'서울특별시': '서울',
		'부산광역시': '부산',
		'대구광역시': '대구',
		'인천광역시': '인천',
		'광주광역시': '광주',
		'대전광역시': '대전',
		'울산광역시': '울산',
		'세종특별자치시': '세종',
		'경기도': '경기',
		'강원도': '강원',
		'충청북도': '충북',
		'충청남도': '충남',
		'전라북도': '전북',
		'전라남도': '전남',
		'경상북도': '경북',
		'경상남도': '경남',
		'제주특별자치도': '제주'
	};
	
	let region = '';
 	
	function haversine(lat1, lng1, lat2, lng2) {
		let R = 6371;
		const toRad = deg => deg * Math.PI / 180;
		const dLat = toRad(lat2 - lat1);
        const dLon = toRad(lng2 - lng1);
        const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                  Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
                  Math.sin(dLon/2) * Math.sin(dLon/2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        return R * c;
	}
	
	function getNearStation(lat, lon, station) {
		return station.map(s => ({...s, dist: haversine(lat, lon, s.Latitude, s.Longitude)})).sort((a, b) => a.dist - b.dist).slice(0, 3);
	}
	
	function getNearest(lat, lon, station) {
		return getNearStation(lat, lon, station)[0];
	}
	
	function TooltipMarker(position, tooltipText) {
		this.position = position;
		let node = this.node = document.createElement('div');
	    node.className = 'node';
	    
	    let tooltip = document.createElement('div');
	    tooltip.className = 'tooltip';
	    
	    tooltip.appendChild(document.createTextNode(tooltipText));
	    node.appendChild(tooltip);
	    
	    node.onmouseover = function() {
			tooltip.style.display = 'block';
		};
		node.onmouseout = function() {
			tooltip.style.display = 'none';
		};
	}
	
	TooltipMarker.prototype = new kakao.maps.AbstractOverlay;
	
	TooltipMarker.prototype.onAdd = function() {
	    let panel = this.getPanels().overlayLayer;
	    panel.appendChild(this.node);
	};
	
	TooltipMarker.prototype.onRemove = function() {
		this.node.parentNode.removeChild(this.node);
	}
	
	TooltipMarker.prototype.draw = function() {
		let projection = this.getProjection();
		
		let point = projection.pointFromCoords(this.position);
		
		let width = this.node.offsetWidth;
		let height = this.node.offsetHeight;
		
		this.node.style.left = (point.x - width / 2) + "px";
		this.node.style.top = (point.y - height / 2) + "px";
	}
	
	TooltipMarker.prototype.getPosition = function() {
		return this.position;
	}
	
	function MarkerTracker(map, target) {
		let OUTCODE = {
			INSIDE: 0,
			TOP: 8,
			RIGHT: 2,
			BOTTOM: 4,
			LEFT: 1
		};
		
		let BOUNDS_BUFFER = 30;
		let CLIP_BUFFER = 40;
		let tracker = document.createElement('div');
		tracker.className = 'tracker';

		let icon = document.createElement('div');
		icon.className = 'icon';
		let balloon = document.createElement('div');
		balloon.className = 'balloon';
		
		tracker.appendChild(balloon);
		tracker.appendChild(icon);
		
		map.getNode().appendChild(tracker);
		
		tracker.onclick = function() {
			map.setCenter(target.getPosition());
			setVisible(false);
		}
		
		function tracking() {
			let proj = map.getProjection();
			let bounds = map.getBounds();
			let extBounds = extendBounds(bounds, proj);
			
			if (extBounds.contain(target.getPosition()))
			{
				setVisible(false);	
			}
			else {
				let pos = proj.containerPointFromCoords(target.getPosition());
				let center = proj.containerPointFromCoords(map.getCenter());
				let sw = proj.containerPointFromCoords(bounds.getSouthWest());
				let ne = proj.containerPointFromCoords(bounds.getNorthEast());
				let top = ne.y + CLIP_BUFFER;
				let right = ne.x - CLIP_BUFFER;
				let bottom = sw.y - CLIP_BUFFER;
				let left = sw.x + CLIP_BUFFER;
				let clipPosition = getClipPosition(top, right, bottom, left, center, pos);
				
				tracker.style.top = clipPosition.y + "px";
				tracker.style.left = clipPosition.x + "px";
				
				let angle = getAngle(center, pos);
				
				balloon.style.cssText += '-ms-transform: rotate(' + angle + 'deg);' + '-webkit-transform: rotate(' + angle + 'deg);' + 'transform: rotate(' + angle + 'deg);';
				setVisible(true);
			}
		}
		
		function extendBounds(bounds, proj) {
			let sw = proj.pointFromCoords(bounds.getSouthWest());
			let ne = proj.pointFromCoords(bounds.getNorthEast());
			
			sw.x -= BOUNDS_BUFFER;
			sw.y += BOUNDS_BUFFER;
			ne.x += BOUNDS_BUFFER;
			ne.y -= BOUNDS_BUFFER;
			
			return new kakao.maps.LatLngBounds(proj.coordsFromPoint(sw), proj.coordsFromPoint(ne));
		}
		
		function getClipPosition(top, right, bottom, left, inner, outer) {
			function calcOutcode(x, y) {
				let outcode = OUTCODE.INSIDE;
				
				if (x < left)
				{
					outcode |= OUTCODE.LEFT;
				} else if (x > right) {
					outcode |= OUTCODE.RIGHT;
				}
				
				if (y < top)
				{
					outcode |= OUTCODE.TOP;
				} else if (y > bottom) {
					outcode |= OUTCODE.BOTTOM;
				}
				return outcode;
			}
			
			let ix = inner.x;
			let iy = inner.y;
			let ox = outer.x;
			let oy = outer.y;
			
			var code = calcOutcode(ox, oy);
			
			while(true)
			{
				if (!code) { break; }
				
				if (code & OUTCODE.TOP)
				{
					ox = ox + (ix - ox) / (iy - oy) * (top - oy);
	                oy = top;
				} else if (code & OUTCODE.RIGHT) {
	                oy = oy + (iy - oy) / (ix - ox) * (right - ox);        
	                ox = right;
	            } else if (code & OUTCODE.BOTTOM) {
	                ox = ox + (ix - ox) / (iy - oy) * (bottom - oy);
	                oy = bottom;
	            } else if (code & OUTCODE.LEFT) {
	                oy = oy + (iy - oy) / (ix - ox) * (left - ox);     
	                ox = left;
	            }
				code = calcOutcode(ox, oy);
			}
			return { x: ox, y: oy };
		}
		
		function getAngle(center, target) {
			let dx = target.x - center.x;
			let dy = center.y - target.y;
			let deg = Math.atan2(dx, dy) * 180 / Math.PI;
			return ((-deg + 360) % 360 | 0) + 90;
		}
		
		function setVisible(visible)
		{
			tracker.style.display = visible ? 'block' : 'none';
		}
		
		function hideTracker() {
			setVisible(false);
		}
		
		this.run = function() {
			kakao.maps.event.addListener(map, 'zoom_start', hideTracker);
			kakao.maps.event.addListener(map, 'zoom_changed', tracking);
			kakao.maps.event.addListener(map, 'center_changed', tracking);
			tracking();
		}
		
		this.stop = function() {
			kakao.maps.removeListener(map, 'zoom_start', hideTracker);
			kakao.maps.removeListener(map, 'zoom_changed', tracking);
			kakao.maps.removeListener(map, 'center_changed', tracking);
			setVisible(false);
		}	
	}
	
	let markers = [];
	let markerTrackers = [];


	document.addEventListener('DOMContentLoaded', mapLoad);

	async function mapLoad() {
		const { lat, lon } = await getUserLocation();
		const map = createMap(lat, lon);
		const currentLocation = new kakao.maps.LatLng(lat, lon);

		$('.currentPosition').on('click', function () {
			map.setCenter(currentLocation);
		})
		
		kakao.maps.event.addListener(map, 'resize', () => tracking());

		const position = await fetchJson('../resources/data/position.json');
		const station = await fetchJson('../resources/json/police_stations.json');

		const near3 = getNearStation(lat, lon, station);
		const nearest = near3[0];
		regionChart(position, nearest['축약주소']);
		
		renderCurrentLocationMarker(map, lat, lon);
		renderNearestStations(map, position, station, currentLocation);	
		setupIdleTracking(map, position, station, currentLocation);

	}

	function getUserLocation() {
		return new Promise((resolve, reject) => {
			navigator.geolocation.getCurrentPosition(pos => {
				resolve({ lat: pos.coords.latitude, lon: pos.coords.longitude });
			}, reject);
		});
	}

	function createMap(lat, lon) {
		const container = document.getElementById('map');
		const option = { center: new kakao.maps.LatLng(lat, lon), level: 3 };
		return new kakao.maps.Map(container, option);
	}

	async function fetchJson(path) {
		const res = await fetch(path);
		return res.json();
	}

	function renderCurrentLocationMarker(map, lat, lon) {
		const markerImg = new kakao.maps.MarkerImage('../resources/img/resize.png', new kakao.maps.Size(30, 30), new kakao.maps.Point(15, 15));
		const position = new kakao.maps.LatLng(lat, lon);
		new kakao.maps.Marker({ position, image: markerImg }).setMap(map);
	}

	function setupIdleTracking(map, position, station, currentLocation) {
		let debounceTimer;
			
		kakao.maps.event.addListener(map, 'idle', () => {
		clearTimeout(debounceTimer);
		debounceTimer = setTimeout(() => {
			renderNearestStations(map, position, station, currentLocation);
			}, 300);
		});
	}
	
	function renderNearestStations(map, position, station, currentLocation) {
		const center = map.getCenter();
		const near3 = getNearStation(center.getLat(), center.getLng(), station);
		const nearest = near3[0];
		
		if (currentLocation.La != center.La || currentLocation.Ma != center.Ma) {
			regionChart(position, nearest['축약주소']);
		}
		
		console.log("최근접 3개", near3);
		console.log("가장 가까운", nearest);
		
		resetMarkers();
		renderNearestMarkers(map, near3);
		runAllTrackers();
	}

	function resetMarkers() {
		markers.forEach(m => m.setMap(null));
		markers = [];
		document.querySelectorAll('.tracker').forEach(el => el.remove());
		markerTrackers = [];
	}

	function renderNearestMarkers(map, near3) {
		const img = "../resources/img/marker.png";
		const imageSize = new kakao.maps.Size(30, 48);
		const markerImage = new kakao.maps.MarkerImage(img, imageSize);

		near3.forEach(station => {
			const position = new kakao.maps.LatLng(station.Latitude, station.Longitude);
			const title = station['관서명'] + station['구분'];
			const marker = new kakao.maps.Marker({ map, position, title, image: markerImage });
			const tracker = new MarkerTracker(map, marker);

			markers.push(marker);
			markerTrackers.push(tracker);
		});
	}

	function runAllTrackers() {
		markerTrackers.forEach(el => el.run());
	}
		
	Chart.register(ChartDataLabels);
	
	//------------------ 전국 차트 ------------------ //
	const crimes = ["살인", "강간 및 추행", "상해 및 폭행", "교통범죄", "강도 및 절도"];
	const donutColors = [
	 'rgba(255, 206, 86, 0.9)',
	 'rgba(255, 99, 132, 0.9)',
	 'rgba(54, 162, 235, 0.9)',
	 'rgba(75, 192, 192, 0.9)',
	 'rgba(153, 102, 255, 0.9)'
	];
	
	let rawData;
	let donutChart;
	let barChart;
	
	fetch('/resources/data/nationwide.json')
	.then(res => res.json())
	.then(data => {
	 rawData = data;
	 const years = Object.keys(rawData).sort();
	 const latestYear = years[years.length - 1];
	
	 let donutRawData = crimes.map(c => rawData[latestYear]?.[c] ?? 0);
	 donutRawData = donutRawData.map((v, i) => (crimes[i] === "살인" && v < 10000) ? 10000 : v);
	
	 const total = donutRawData.reduce((a, b) => a + b, 0);
	 const donutData = donutRawData.map(v => parseFloat(((v / total) * 100).toFixed(1)));
	
	 createDonutChart(crimes, donutData);
	 const initialBarData = getBarData("전체");
	 createBarChart(initialBarData, "5대 범죄 전체 합계");
	});
	
	function createDonutChart(labels, data) {
	 const ctx = document.getElementById('donutChart').getContext('2d');
	 if (donutChart) donutChart.destroy();
	 donutChart = new Chart(ctx, {
	     type: 'doughnut',
	     data: {
	         labels,
	         datasets: [{
	             data,
	             backgroundColor: donutColors,
	             borderColor: '#222',
	             borderWidth: 2,
	             hoverOffset: 15
	         }]
	     },
	     options: {
	         responsive: true,
	         cutout: '50%',
	         plugins: {
	             legend: {
	                 position: 'right',
	                 labels: {
	                     color: 'black',
	                     font: { size: 14 },

	                 }
	             },
	             title: {
	                 display: true,
	                 text: '연도별 5대 범죄 발생 비율 (%)',
	                 color: 'rgb(0, 51, 153)',
	                 font: { size: 16, weight: 'bold' },
	                 align: 'start',
	                 padding: { top: 20, bottom: 5 }
	             },
	             datalabels: { display: false }
	         },
	         onClick: (evt, elements) => {
	             if (elements.length) {
	                 const idx = elements[0].index;
	                 const selectedCrime = crimes[idx];
	                 const barData = getBarData(selectedCrime);
	                 updateBarChart(barData, selectedCrime);
	             }
	         }
	     },
	     plugins: [ChartDataLabels]
	 });
	}
	
	function getBarData(selectedCrime) {
	 const years = Object.keys(rawData).sort();
	 if (selectedCrime === "전체") {
	     return years.map(y => ({
	         year: y,
	         count: crimes.reduce((sum, c) => sum + (rawData[y]?.[c] || 0), 0)
	     }));
	 } else {
	     return years.map(y => ({
	         year: y,
	         count: rawData[y]?.[selectedCrime] || 0
	     }));
	 }
	}
	
	function createBarChart(data, title) {
	 const ctx = document.getElementById('barChart').getContext('2d');
	 const gradient = ctx.createLinearGradient(0, 0, 0, 300);
	 gradient.addColorStop(0, 'rgba(54, 162, 235, 1)');
	 gradient.addColorStop(1, 'rgba(54, 162, 235, 0.3)');
	
	 const labels = data.map(d => d.year);
	 const values = data.map(d => d.count);
	
	 if (barChart) barChart.destroy();
	
	 barChart = new Chart(ctx, {
	     type: 'bar',
	     data: {
	         labels,
	         datasets: [{
	             label: title,
	             data: values,
	             backgroundColor: gradient,
	             borderColor: 'rgba(54, 162, 235, 1)',
	             borderWidth: 1,
	             borderRadius: 6
	         }]
	     },
	     options: {
	         responsive: true,
	         animation: {
	             duration: 1000,
	             easing: 'easeOutBounce'
	         },
	         scales: {
	             y: {
	                 beginAtZero: true,
	                 ticks: {
	                     color: 'rgb(0, 51, 153)',
	                     font: { size: 17, weight: 'bold' },
	                     callback: val => val.toLocaleString()
	                 }
	             },
	             x: {
	                 ticks: {
	                     color: 'rgb(0, 51, 153)',
	                     font: { size: 17, weight: 'bold' }
	                 }
	             }
	         },
	         plugins: {
	             legend: { display: false },
	             title: {
	                 display: true,
	                 text: title,
	                 color: 'rgb(0, 51, 153)',
	                 font: { size: 16, weight: 'bold' },
	                 padding: { top: 15, bottom: 2 }
	             },
	             datalabels: {
	                 color: 'rgb(0, 51, 153)',
	                 anchor: 'end',
	                 align: 'top',
	                 font: { weight: 'bold', size: 15 },
	                 formatter: val => val.toLocaleString()
	             }
	         }
	     },
	     plugins: [ChartDataLabels]
	 });
	}
	
	function updateBarChart(data, crimeName) {
	 if (!barChart) return;
	 barChart.data.labels = data.map(d => d.year);
	 barChart.data.datasets[0].data = data.map(d => d.count);
	 barChart.data.datasets[0].label = crimeName + " 연도별 발생건수";
	 barChart.options.plugins.title.text = crimeName + " 연도별 발생건수";
	 barChart.update();
	}
	
	

	//------------------ 현위치 차트 ------------------ //
	const crimesLocal = ["살인", "강간 및 추행", "상해 및 폭행", "교통범죄", "강도 및 절도"];
	const donutColors2 = donutColors; // 동일한 색상 사용
	
	let donutChart1;
	let barChart1;
 
    function regionChart(position, region) {
	    const filtered = position.filter(d => d["지역"] == region);
	
	    function sumByCrime(crime) {
	        return filtered
	            .filter(d => d["중분류그룹"] === crime)
	            .reduce((acc, row) => {
	                return acc + ["일", "월", "화", "수", "목", "금", "토"]
	                    .reduce((a, day) => a + (parseFloat(row[day]) || 0), 0);
                }, 0);
        }
	
	    const totalByCrime = {};
	    crimesLocal.forEach(c => totalByCrime[c] = sumByCrime(c));
	    const totalSum = Object.values(totalByCrime).reduce((a, b) => a + b, 0);
	    const donutData = crimesLocal.map(c => Number(((totalByCrime[c] / totalSum) * 100).toFixed(1)));
	
	    createDonutChartLocal(crimesLocal, donutData, region);
	
	    const barData = crimesLocal.map(c => {
	        const rows = filtered.filter(d => d["중분류그룹"] === c);
	        const total = rows.reduce((acc, row) => {
	            return acc + ["일", "월", "화", "수", "목", "금", "토"]
	                .reduce((a, day) => a + (parseFloat(row[day]) || 0), 0);
	        }, 0);
	        const count = rows.length * 7;
	        return count > 0 ? Number((total / count).toFixed(2)) : 0;
	    });
	
	    createBarChartLocal(crimesLocal, barData, region);
	}
	
	function createDonutChartLocal(labels, data, region) {
	 const ctx = document.getElementById('donutChart1').getContext('2d');
	 const filteredLabels = [], filteredData = [], filteredColors = [];
	
	 data.forEach((value, index) => {
	     if (value > 0) {
	         filteredLabels.push(labels[index]);
	         filteredData.push(value);
	         filteredColors.push(donutColors2[index]);
	     }
	 });
	
	 if (donutChart1) donutChart1.destroy();
	 donutChart1 = new Chart(ctx, {
	     type: 'doughnut',
	     data: {
	         labels: filteredLabels,
	         datasets: [{
	             data: filteredData,
	             backgroundColor: filteredColors,
	             borderColor: '#000',
	             borderWidth: 2,
	             hoverOffset: 25
	         }]
	     },
	     options: {
	         cutout: '50%',
	         animation: {
	             duration: 1500,
	             easing: 'easeInOutCubic'
	         },
	         plugins: {
	             legend: {
	                 position: 'right',
	                 labels: {
	                     color: 'black',
	                     font: { size: 14 }
	                 }
	             },
	             title: {
	                 display: true,
	                 text: region + '5대 범죄 발생 비율 (%)',
	                 color: 'rgb(0, 51, 153)',
	                 font: { size: 16, weight: 'bold' },
	                 align: 'start',
	                 padding: { top: 20, bottom: 5 }
	             },
	             datalabels: {
	                 color: 'black',
	                 font: { weight: 'bold', size: 16 },
	                 formatter: val => val + '%',
	                 anchor: 'end',
	                 align: 'start'
	             }
	         }
	     },
	     plugins: [ChartDataLabels]
	 });
    }
	
	function createBarChartLocal(labels, data, region) {
	 const maxBarValue = Math.max(...data);
	 const ctx = document.getElementById('barChart1').getContext('2d');
	 if (barChart1) barChart1.destroy();
	
	 barChart1 = new Chart(ctx, {
	     type: 'bar',
	     data: {
	         labels,
	         datasets: [{
	             label: '검거율',
	             data,
	             backgroundColor: 'rgba(54, 99, 235, 1)',
	             borderRadius: 5,
	             borderSkipped: false
	         }]
	     },
	     options: {
	         animation: {
	             duration: 1200,
	             easing: 'easeOutQuart'
	         },
	         scales: {
	             y: {
	                 beginAtZero: true,
	                 max: maxBarValue < 2 ? 2 : Math.ceil(maxBarValue),
	                 ticks: {
	                     color: 'rgb(0, 51, 153)',
	                     font: { size: 16, weight: 'bold' }
	                 }
	             },
	             x: {
	                 ticks: {
	                     color: 'rgb(0, 51, 153)',
	                     font: { size: 14, weight: 'bold' }
	                 }
	             }
	         },
	         plugins: {
	             legend: { display: false },
	             title: {
	                 display: true,
	                 text: region + '범죄별 검거율(요일 평균)',
	                 color: 'rgb(0, 51, 153)',
	                 font: { size: 20, weight: 'bold' },
	                 padding: { top: 0, bottom: 20 }
	             },
	             datalabels: {
	                 anchor: 'end',
	                 align: 'top',
	                 color: 'rgb(0, 51, 153)',
	                 font: { weight: 'bold', size: 14 },
	                 formatter: v => v + '%'
	             }
	         }
	     },
	     plugins: [ChartDataLabels]
	 });
	}


//------------------ 예측 차트 ------------------ //

document.addEventListener('DOMContentLoaded', () => {
  initForecastChart();
});

function initForecastChart() {
  fetch('<c:url value="/resources/data/crime_forecast.json"/>')
    .then(res => res.json())
    .then(data => {
      const ctx = document.getElementById('forecastChart').getContext('2d');
      let chart;

      function updateChart(crimeType) {
        const real = data[crimeType]?.filter(d => d.type === '실제') || [];
        const predictOnly = data[crimeType]?.filter(d => d.type === '예측') || [];

        // 예측 dataset에도 실제값(2018~2023) 포함
        const predict = [...real, ...predictOnly];

        if (chart) chart.destroy();

        chart = new Chart(ctx, {
          type: 'line',
          data: {
            labels: predict.map(d => d.year),
            datasets: [
            	  {
            	    label: `${crimeType} (실제)`,
            	    data: real.map(d => ({ x: d.year, y: d.count })),
            	    borderColor: getColor(crimeType),
            	    backgroundColor: 'rgb(255,255,255, 0)',
            	    borderWidth: 2,
            	    tension: 0,
            	    pointRadius: 4,
            	    pointBackgroundColor: getColor(crimeType),
            	    pointBorderColor: getColor(crimeType),
            	  },
            	  {
            	    label: `${crimeType} (예측)`,
            	    data: predict.map(d => ({ x: d.year, y: d.count })),
            	    borderColor: getColor(crimeType),
            	    backgroundColor: 'rgb(255,255,255, 0)',
            	    borderDash: [5, 5],
            	    borderWidth: 2,
            	    tension: 0,
            	    pointRadius: 4,
            	    pointBackgroundColor: 'white', // 예측은 점 내부 색을 흰색으로
            	    pointBorderColor: getColor(crimeType),
            	  }
            	]

          },
          options: {
            plugins: {
              title: {
                display: true,
                text: `5대 범죄 발생건수 추세 및 예측`,
                font: { size: 20, weight: 'bold' },
                color: 'rgb(0, 51, 153)',
                padding: { top: 15, bottom: 15 }
              },
              legend: {
                labels: {
                  color: 'black',
                  font: { size: 14, weight: 'bold' }
                }
              },
              tooltip: { enabled: true },
              datalabels: { display: false }
            },
            scales: {
              y: {
                type: 'logarithmic',
                ticks: {
                  color: 'black',
                  font: { size: 14, weight: 'bold' }
                }
              },
              x: {
                type: 'linear',
                ticks: {
                  callback: val => val.toString(),
                  color: 'black',
                  font: { size: 14, weight: 'bold' }
                }
              }
            }
          }
        });
      }

      function getColor(crime) {
        const map = {
          '살인': 'red',
          '강간 및 추행': 'purple',
          '상해 및 폭행': 'orange',
          '교통 범죄': 'blue',
          '강도 및 절도': 'green'
        };
        return map[crime] || 'gray';
      }

      // 탭 클릭 이벤트 설정
      document.querySelectorAll('.crime-tab').forEach(tab => {
        tab.addEventListener('click', () => {
          const selected = tab.getAttribute('data-crime');
          updateChart(selected);
          document.querySelectorAll('.crime-tab').forEach(t => t.classList.remove('active'));
          tab.classList.add('active');
        });
      });

      // 초기 표시: 교통 범죄
      updateChart('교통 범죄');
    });
}



//------------------ 시간/요일 선형 차트 ------------------ //




document.addEventListener('DOMContentLoaded', () => {
  const crimes2 = ['살인', '강간 및 추행', '상해 및 폭행', '교통 범죄', '강도 및 절도'];
  const labels = ["일", "월", "화", "수", "목", "금", "토"];
  const colors = [
    "rgba(255, 99, 132, 1)",
    "rgba(54, 162, 235, 1)",
    "rgba(255, 206, 86, 1)",
    "rgba(75, 192, 192, 1)",
    "rgba(153, 102, 255, 1)"
  ];

  const charts = {};

  fetch('<c:url value="/resources/data/crime_time_day.json"/>')
    .then(res => res.json())
    .then(data => {
      crimes2.forEach((crime2, idx) => {
        const safeCrimeId = crime2.replace(/\s/g, '');
        const sums = Array(7).fill(0);

        data.forEach(item => {
          if (item["중분류그룹"] === crime2) {
            labels.forEach((day, i) => {
              sums[i] += parseFloat(item[day]) || 0;
            });
          }
        });

        var timechart = "timechart-" + safeCrimeId;
        const canvas = document.getElementById(timechart);

        if (!canvas) {
          console.warn(`Canvas element 'timechart-${safeCrimeId}' 가 없습니다.`);
          return;
        }

        const isEmpty = sums.every(v => v === 0);
        if (isEmpty) {
          canvas.style.display = 'none';
          return;
        } else {
          canvas.style.display = 'block';
        }

        const ctx = canvas.getContext('2d');
        if (charts[timechart]) charts[timechart].destroy();
       
        charts[timechart] = new Chart(ctx, {
          type: 'line',
          data: {
            labels,
            datasets: [{
              label: crime2,
              data: sums,
              borderColor: colors[idx],
              backgroundColor: colors[idx].replace('1)', '0.30)'),
              fill: true,
              tension: 0.4,
              borderWidth: 3,
              pointRadius: 5,
              pointHoverRadius: 7,
              pointBackgroundColor: colors[idx],
              pointBorderColor: "#fff"
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              title: {
                display: true,
                text: crime2 ,

                font: { size: 20, weight: 'bold' },
                color: 'rgb(0, 51, 153)',
                padding: { top: 5, bottom: 15 }
              },
              legend: { display: true },
              tooltip: {
            	  enabled: true,

                callbacks: {
//                   label: ctx => `${ctx.parsed.y.toFixed(1)} 건`
                }
              },
              datalabels: { display: false }
            },
            scales: {
            	  y: {
            	    beginAtZero: true,
            	    ticks: {
            	      color: 'black',
            	      font: { size: 15, weight: 'bold' }
            	    },
            	    grid: {
            	      color: '#adadad'  // y축 격자선 색상 (연한 검정)
            	    }
            	  },
            	  x: {
            	    ticks: {
            	      color: 'black',
            	      font: { size: 15, weight: 'bold' }
            	    },
            	    grid: {
            	      color: '#adadad'  // x축 격자선 색상
            	    }
            	  }
            	}

          },
          plugins: [ChartDataLabels]
        });
      });
    });
});
// 장소별 ---------------------------------------------------------------------------------------------
// 전역 변수 선언 (중복 방지)
let stackedBarData = {};

// 색상 정의
const colors = {
  "주거시설": "#FF6B6B",
  "상업시설": "#b04a0b",
  "교통시설": "#22aac9",
  "공공/교육/문화시설": "#96CEB4",
  "자연/기타시설": "#FFEAA7"
};

// 활성 차트들을 담는 배열 (resize 시 사용)
const activeCharts = [];

// JSON 데이터 로드
async function loadDataFromJSON() {
  try {
    const stackedRes = await fetch('resources/data/stacked_bar_chart2.json');
    if (!stackedRes.ok) throw new Error('stacked_bar_chart2.json 로드 실패');
    stackedBarData = await stackedRes.json();
    console.log('✅ stacked_bar_chart2.json 로드 완료');
  } catch (error) {
    console.error('❌ JSON 로딩 오류:', error);
  }
}

// 차트 초기화
async function initializeCharts() {
  await loadDataFromJSON();
  resizeCanvas('stacked', 400);
  createStackedBarChart();
}

// canvas 크기 조절
function resizeCanvas(id, height, width) {
  const canvas = document.getElementById(id);
  if (canvas) {
    canvas.style.height = `${height}px`;
    if (width) canvas.style.width = `${width}px`;
  }
}

// stacked bar chart 생성
function createStackedBarChart() {
  const ctx = document.getElementById('stacked').getContext('2d');
  const years = Object.keys(stackedBarData);
  const categories = Object.keys(stackedBarData[years[0]]);

  const datasets = categories.map(category => ({
    label: category,
    data: years.map(year => stackedBarData[year][category]),
    backgroundColor: colors[category],
    borderColor: '#888888',
    borderWidth: 1,
    hoverBorderColor: '#454545',
    hoverBorderWidth: 2,
    barThickness: 100
  }));

  const chart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: years,
      datasets: datasets
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        datalabels: { display: false },
        title: {
          display: true,
          text: '연도별 범죄 발생건수',
          color: '#333',
          font: {
            size: 20,
            weight: 'bold',
            family: "'Noto Sans KR', sans-serif"
          },
          padding: { top: 25, bottom: 10 },
          backgroundColor: 'rgba(255, 204, 0, 0.2)',
          borderColor: 'rgb(255, 204, 0)',
          borderWidth: 3,
        },
        legend: {
          position: 'top',
          labels: {
            usePointStyle: true,
            padding: 20,
            boxWidth: 12,
            color: 'black',
            font: {
              size: 13,
              weight: 'bold',
              family: "'Arial', sans-serif"
            },
            generateLabels(chart) {
              const datasets = chart.data.datasets;
              return datasets.map((dataset, i) => ({
                text: dataset.label,
                fillStyle: dataset.backgroundColor,
                hidden: !chart.isDatasetVisible(i),
                datasetIndex: i
              }));
            }
          }
        },
        tooltip: {
          mode: 'index',
          intersect: false
        }
      },
      scales: {
        x: {
          stacked: true,
          ticks: {
            font: {
              size: 15,
              weight: '600',
              family: "'Noto Sans KR', sans-serif"
            },
            maxRotation: 0,
            autoSkip: true,
            maxTicksLimit: 10
          },
          grid: {
            color: '#eee',
            borderColor: '#ccc'
          }
        },
        y: {
          stacked: true,
          ticks: {
            color: '#555',
            font: {
              size: 14,
              weight: '600',
              family: "'Noto Sans KR', sans-serif"
            },
            callback: value => value.toLocaleString(),
            maxTicksLimit: 7
          },
          grid: {
            color: '#eee',
            borderColor: '#ccc'
          }
        }
      },
      interaction: {
        mode: 'nearest',
        axis: 'x',
        intersect: false
      }
    }
  });

  activeCharts.push(chart);
}

// DOM 준비되면 초기화 실행
document.addEventListener('DOMContentLoaded', initializeCharts);

// 창 크기 조절 시 차트 리사이즈
window.addEventListener('resize', () => {
  activeCharts.forEach(chart => chart.resize());
});

//여기서부터는 장소별 범죄 발생건수 차트 ------------------------------------------------------------------------
fetch("resources/data/radar_chart_crime6.json")
  .then(res => res.json())
  .then(data => {
    const 장소목록 = Object.keys(data);
    const 범죄종목목록 = [...new Set(장소목록.flatMap(loc => Object.keys(data[loc])))];
    
    const colors = [
      "rgba(255, 99, 132, 0.7)",
      "rgba(54, 162, 235, 0.7)",
      "rgba(255, 206, 86, 0.7)",
      "rgba(75, 192, 192, 0.7)",
      "rgba(153, 102, 255, 0.7)",
      "rgba(255, 159, 64, 0.7)"
    ];

    const datasets = 범죄종목목록.map((crime, i) => {
    	  const originalData = 장소목록.map(loc => data[loc][crime] || 0);
    	  const MIN_VALUE = 1200;
    	  const adjustedData = originalData.map(v => v + MIN_VALUE);

    	  return {
    	    label: crime,
    	    data: adjustedData,
    	    backgroundColor: colors[i % colors.length],
    	    stack: 'stack1'
    	  };
    	});


    new Chart(document.getElementById('crimeTopChart'), {
        type: 'bar',
        data: {
          labels: 장소목록,
          datasets: datasets
        },
        
        
        options: {
        	  indexAxis: 'y',
        	  responsive: true,
        	  plugins: {
        	    legend: { 
        	      position: 'top',
        	      labels: {
        	        color: '#444444',           // 범례 글자 색
        	        font: {
        	          size: 14,                 // 글자 크기
        	          weight: '600',            // 글자 굵기
        	          family: "'Noto Sans KR', sans-serif"  // 폰트
        	        },
        	        padding: 15,                // 범례 글자 좌우 여백
        	        boxWidth: 18,               // 범례 색상 박스 크기
        	        usePointStyle: true         // 점 모양으로 표시
        	      }
        	    },
        	    title: {
        	        display: true,
        	        text: '장소별 범죄 발생건수',
        	        color: '#333', // 글자 색
        	        font: {
        	          size: 20,     // 글자 크기
        	          weight: 'bold',
        	          family: "'Noto Sans KR', sans-serif"
        	        },
        	        padding: {
        	          top: 10,
        	          bottom: 10
        	        }
        	      },
        	    datalabels: {
        	      display: false
        	    }
        	  },
        	  // ... 이하 scales 등 옵션 유지

          scales: {
        	    x: {
        	      stacked: true,
        	      max: 125000,
        	      title: {
        	        display: true,
        	        // text: '발생건수',
        	        color: '#555',  // x축 제목 글자색
        	        font: {
        	          size: 14,
        	          weight: 'bold'
        	        }
        	      },
        	      ticks: {
        	        color: '#555',  // x축 눈금 글자색 (빨강 예시)
        	        font: {
        	          size: 14,
        	          weight: 'bold'
        	        }
        	      }
        	    },
        	    y: {
        	      stacked: true,
        	      ticks: {
        	        color: '#555',  // y축 눈금 글자색 (초록 예시)
        	        font: {
        	          size: 14,
        	          weight: 'bold'
        	        }
        	      },
        	      title: {
        	        display: false,
        	        // text: '장소',
        	        color: '#000000',
        	        font: {
        	          size: 14
        	        }
        	      }
        	    }
        	  }
        	}
        
        
        ,
        plugins: [ChartDataLabels]  // 플러그인 등록 필수!
      });
    });
    
    
  // 이제부터는 신고접수 예측과 평균 출동 시간 차트 -------------------------------------------
fetch('resources/data/Predicted.json')
  .then(res => res.json())
  .then(data => {
    const years = data.map(d => d.연도);
    const counts = data.map(d => d.신고접수건수);
    const arrivalTimes = {};
    data.forEach(d => {
      arrivalTimes[d.연도] = d.현장평균도착시간.replace(/분(\d)/,'분 $1');
    });

    const actualEndYear = 2024;
    
    const actualCounts = counts.map((count, i) => years[i] <= actualEndYear ? count : null);
 	const predictedCounts = counts.map((count, i) => years[i] > actualEndYear ? count : null);
    
    const canvas = document.getElementById('Reportreceived');
    const style = getComputedStyle(canvas);
    const width = parseInt(style.width);
    const height = parseInt(style.height);

    canvas.width = width;
    canvas.height = height;

    const ctx = canvas.getContext('2d');

    const gradient = ctx.createLinearGradient(0, 0, 0, height);
    gradient.addColorStop(0, 'rgba(0, 123, 255, 1)');
    gradient.addColorStop(1, 'rgba(0, 123, 255, 0.4)');

    // 그라데이션 막대 & 단색 막대 설정
    const backgroundColors = years.map(year => {
      if (year <= actualEndYear) {
        const gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(0, 123, 255, 1)');   // 진한 파랑
        gradient.addColorStop(1, 'rgba(0, 123, 255, 0.4)'); // 연한 파랑
        return gradient;
      } else {
        return 'rgba(0, 123, 255, 0.2)';  // 예측값: 연한 단색
      }
    });

    const chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: years,
        datasets: [{
          label: '신고접수건수',
          data: counts,
          backgroundColor: backgroundColors,
          borderRadius: 4
        }]
      },
      options: {
        responsive: false,
        scales: {
            y: {
              beginAtZero: true,
              ticks: {
                color: 'black',           
                font: {
                  size: 14,               
                  weight: 'bold'          
                }
              }
            },
            x: {
              ticks: {
                color: 'black',
                font: {
                  size: 14,
                  weight: 'bold'
                }
              }
            }
          },
        onClick: (evt, elements) => {
          if (elements.length > 0) {
            const index = elements[0].index;
            const selectedYear = years[index];
            const timeText = arrivalTimes[selectedYear];
            const el = document.getElementById('arrivalTimeCircle');
            el.innerHTML = '<div style="font-size:21px;">🚨\u00A0현장 평균 출동시간\u00A0🚨</div><div style="font-size:38px; margin-top:10px;">' + timeText + '</div>';
          }
        },
        plugins: {
            title: {
                display: true,
                text: '📞\u00A0112 신고접수 추세와 예측', 
                font: {
                  size: 25,
                  weight: 'bold'
                },
                padding: {
                  top: 10,
                  bottom: 30
                },
                color: '#003366'
              },
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: (ctx) => {
            	  const year = ctx.label;
            	  const value = ctx.parsed.y;
            	  if(year <= actualEndYear){
            		  return '실제값 : ' + value.toLocaleString() + '건';

            	  } else {
            		  return '예측값 : ' + value.toLocaleString() + '건';
            	  }
              }
            }
          },
          datalabels: {
        	  display: false
          }
        }
      }
    });
  })
  .catch(e => console.error('JSON 로딩 실패:', e));


</script> 

</body>
</html>