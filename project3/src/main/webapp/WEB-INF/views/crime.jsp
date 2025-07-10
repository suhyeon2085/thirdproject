<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>범죄 예측 페이지</title>
<style>

    body {
        margin: 0;
        padding: 10px;
        background-color: rgb(0, 51, 153);
        font-family: 'Segoe UI', sans-serif;
        color: black;
    }

    .container {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
    }

    .left {
        flex: 1;
        border: 3px solid rgb(255, 204, 0);
        padding: 10px;
        margin: 5px;
        background: rgb(245, 247, 250);
    }

    .right {
        flex: 0 0 300px;
        display: flex;
        flex-direction: column;
        gap: 10px;
        margin: 5px;
    }

    .right .box {
        flex: 1;
        border: 3px solid rgb(255, 204, 0);
        background: rgb(245, 247, 250);
        
        display: flex;
        align-items: center;
        gap: 20px;
        overflow: visible; /* 차트 잘림 방지 */
    }

    /* 도넛 차트 */
    #donutChart1 {
        width: 450px !important;
        height: 400px !important;
        margin-left: 35px; 
    }
    #donutChart{
        width: 450px !important;
        height: 400px !important;
        padding: 0;
    }
    

    /* 막대 차트 */
    #barChart1 {
        width: 650px !important;
        height: 380px !important;
    }
	#barChart{
        width: 670px !important;
        height: 400px !important;
	}

    /* 예측 차트 */
    #forecastChart {
        background: rgb(245, 247, 250, 0.9);
        width: 1300px;  /* 또는 원하는 값으로 조절 */
    	height: 600px;
    }

	/*  시간/요일 차트  */
	#time-multi-charts canvas {
	  max-width: 400px;
	  max-height: 300px;
	  width: 100%;
	  height: auto;
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
	  padding-top: 80px;
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
	  background-size: calc(100% / 3) 700px;
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
	

   /* 툴팁 스타일 */
    .tooltip-container {
        position: relative;
        display: inline-block;
    }

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
        top: 30px;
        left: 50%;
        transform: translateX(-50%);
        z-index: 1;
        font-size: 14px;
        margin: 5px;
    }

    .tooltip-container:hover .tooltiptext {
        visibility: visible;
    }

    .tooltip-container:hover .tooltiptext2 {
        visibility: visible;
    }
    
    .info-icon {
        width: 30px;
        height: 30px;
        cursor: pointer;
    }
    
    
    .info-icon2{
        width: 32px;
        height: 30px;
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
    top: 40px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 1;
    font-size: 14px;
    margin: 5px;
	}
    

    /* 경찰 마크 이미지 */
    #police {
        width: 100px;
        height: 100px;
        margin: 0;
        padding: 0;
    }
    


</style>

</head>
<body>

<img src="resources/img/crimelogo.png" id="police">

<div class="container">
    <!-- 지도 영역 -->
    <div class="left">
        지도 api 넣는 자리 
    </div>

    <!-- 오른쪽 차트 영역 -->
    <div class="right">
    <div class="tooltip-container" style="position: absolute; top: 137px; left: 65%;">
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
	<span class="time_day">요일별 5대 범죄 발생율 추세</span>
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
		  <img src="resources/img/alert.png" alt="알림" class="info-icon2">
		  <span class="tooltiptext2">2024년 범죄 통계는 관계기관의 집계 일정에 따라 2025년 8월에 공표될 예정이며,<br> 현재 데이터는 제공되지 않습니다.</span>
		  </div>
	    </div>
	    
	    <canvas id="forecastChart" <%-- width="1100px" height="600px" --%>></canvas>
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
Chart.register(ChartDataLabels);

//------------------ 전국 차트 ------------------ //
const crimes = ["살인", "강간 강제추행", "상해 및 폭행", "교통범죄", "강도 및 절도"];
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

const jsonUrl = "<c:url value='/resources/data/nationwide.json'/>";

fetch(jsonUrl)
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
                 position: 'bottom',
                 labels: {
                     color: 'black',
                     font: { size: 16, weight: 'bold' },
                     padding: 15,
                     boxWidth: 20
                 }
             },
             title: {
                 display: true,
                 text: '연도별 5대 범죄 발생 비율 (%)',
                 color: 'rgb(0, 51, 153)',
                 font: { size: 19, weight: 'bold' },
                 padding: { top: 20, bottom: 20 }
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
                 font: { size: 19, weight: 'bold' },
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
const donutColors2 = donutColors;

let donutChart1;
let barChart1;

const jsonUrl2 = "<c:url value='/resources/data/position.json'/>";

fetch(jsonUrl2)
.then(res => res.json())
.then(data => {
 const filtered = data.filter(d => d["지역"] === "부산해운대구");

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

 createDonutChartLocal(crimesLocal, donutData);

 const barData = crimesLocal.map(c => {
     const rows = filtered.filter(d => d["중분류그룹"] === c);
     const total = rows.reduce((acc, row) => {
         return acc + ["일", "월", "화", "수", "목", "금", "토"]
             .reduce((a, day) => a + (parseFloat(row[day]) || 0), 0);
     }, 0);
     const count = rows.length * 7;
     return count > 0 ? Number((total / count).toFixed(2)) : 0;
 });

 createBarChartLocal(crimesLocal, barData);
});

function createDonutChartLocal(labels, data) {
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
                     font: { size: 14, weight: 'bold' }
                 }
             },
             title: {
                 display: true,
                 text: '부산 해운대구 5대 범죄 발생 비율 (%)',
                 color: 'rgb(0, 51, 153)',
                 font: { size: 20, weight: 'bold' },
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

function createBarChartLocal(labels, data) {
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
                 text: '부산 해운대구 범죄별 검거율(요일 평균)',
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
      const years = [...new Set(Object.values(data).flatMap(arr => arr.map(d => d.year)))].sort();
      let chart;

      function updateChart(crimeType) {
        const real = data[crimeType]?.filter(d => d.type === '실제') || [];
        const predict = data[crimeType]?.filter(d => d.type === '예측') || [];

        const datasets = [
          {
            label: `${crimeType} (실제)`,
            data: real.map(d => ({ x: d.year, y: d.count })),
            borderColor: getColor(crimeType),
            borderWidth: 2,
            tension: 0
          },
          {
            label: `${crimeType} (예측)`,
            data: predict.map(d => ({ x: d.year, y: d.count })),
            borderColor: getColor(crimeType),
            borderDash: [5, 5],
            borderWidth: 2,
            tension: 0
          }
        ];

        if (chart) chart.destroy();
        chart = new Chart(ctx, {
          type: 'line',
          data: { labels: years, datasets },
          options: {
            plugins: {
              title: {
                display: true,
                text: `5대 범죄 발생건수 연도별 추이 (2024~2025 예측)`,
                font: { size: 22, weight: 'bold' },
                color: 'rgb(0, 51, 153)'
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

      document.querySelectorAll('.crime-tab').forEach(tab => {
        tab.addEventListener('click', () => {
          const selected = tab.getAttribute('data-crime');
          updateChart(selected);
          document.querySelectorAll('.crime-tab').forEach(t => t.classList.remove('active'));
          tab.classList.add('active');
        });
      });

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
              backgroundColor: colors[idx].replace('1)', '0.15)'),
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
              legend: { display: false },
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


</script> 
</body>
</html>