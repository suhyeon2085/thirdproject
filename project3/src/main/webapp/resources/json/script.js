/**
 * 
 */
 
 	
	function haversine(lat1, lng1, lat2, lng2) {
		var R = 6371;
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
		var node = this.node = document.createElement('div');
	    node.className = 'node';
	    
	    var tooltip = document.createElement('div');
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
	    var panel = this.getPanels().overlayLayer;
	    panel.appendChild(this.node);
	};
	
	TooltipMarker.prototype.onRemove = function() {
		this.node.parentNode.removeChild(this.node);
	}
	
	TooltipMarker.prototype.draw = function() {
		var projection = this.getProjection();
		
		var point = projection.pointFromCoords(this.position);
		
		var width = this.node.offsetWidth;
		var height = this.node.offsetHeight;
		
		this.node.style.left = (point.x - width / 2) + "px";
		this.node.style.top = (point.y - height / 2) + "px";
	}
	
	TooltipMarker.prototype.getPosition = function() {
		return this.position;
	}
	
	function MarkerTracker(map, target) {
		var OUTCODE = {
			INSIDE: 0,
			TOP: 8,
			RIGHT: 2,
			BOTTOM: 4,
			LEFT: 1
		};
		
		var BOUNDS_BUFFER = 30;
		var CLIP_BUFFER = 40;
		var tracker = document.createElement('div');
		tracker.className = 'tracker';

		var icon = document.createElement('div');
		icon.className = 'icon';
		var balloon = document.createElement('div');
		balloon.className = 'balloon';
		
		tracker.appendChild(balloon);
		tracker.appendChild(icon);
		
		map.getNode().appendChild(tracker);
		
		tracker.onclick = function() {
			map.setCenter(target.getPosition());
			setVisible(false);
		}
		
		function tracking() {
			var proj = map.getProjection();
			var bounds = map.getBounds();
			var extBounds = extendBounds(bounds, proj);
			
			if (extBounds.contain(target.getPosition()))
			{
				setVisible(false);	
			}
			else {
				var pos = proj.containerPointFromCoords(target.getPosition());
				var center = proj.containerPointFromCoords(map.getCenter());
				var sw = proj.containerPointFromCoords(bounds.getSouthWest());
				var ne = proj.containerPointFromCoords(bounds.getNorthEast());
				var top = ne.y + CLIP_BUFFER;
				var right = ne.x - CLIP_BUFFER;
				var bottom = sw.y - CLIP_BUFFER;
				var left = sw.x + CLIP_BUFFER;
				var clipPosition = getClipPosition(top, right, bottom, left, center, pos);
				
				tracker.style.top = clipPosition.y + "px";
				tracker.style.left = clipPosition.x + "px";
				
				var angle = getAngle(center, pos);
				
				balloon.style.cssText += '-ms-transform: rotate(' + angle + 'deg);' + '-webkit-transform: rotate(' + angle + 'deg);' + 'transform: rotate(' + angle + 'deg);';
				setVisible(true);
			}
		}
		
		function extendBounds(bounds, proj) {
			var sw = proj.pointFromCoords(bounds.getSouthWest());
			var ne = proj.pointFromCoords(bounds.getNorthEast());
			
			sw.x -= BOUNDS_BUFFER;
			sw.y += BOUNDS_BUFFER;
			ne.x += BOUNDS_BUFFER;
			ne.y -= BOUNDS_BUFFER;
			
			return new kakao.maps.LatLngBounds(proj.coordsFromPoint(sw), proj.coordsFromPoint(ne));
		}
		
		function getClipPosition(top, right, bottom, left, inner, outer) {
			function calcOutcode(x, y) {
				var outcode = OUTCODE.INSIDE;
				
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
			
			var ix = inner.x;
			var iy = inner.y;
			var ox = outer.x;
			var oy = outer.y;
			
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
			var dx = target.x - center.x;
			var dy = center.y - target.y;
			var deg = Math.atan2(dx, dy) * 180 / Math.PI;
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
		
/* 		const isDevTools = () => window.outerWidth - window.innerWidth > 160 || window.outerHeight - window.innerHeight > 160;

		if (isDevTools()) {
		    console.warn("🛡️ DevTools 감지됨 → tracker 경량화");
		    tracker.style.contain = 'layout paint style';
		    tracker.style.overflow = 'hidden';
		    tracker.style.maxWidth = '100px';
		    tracker.style.maxHeight = '100px';
		    tracker.style.transition = 'none';
		    tracker.style.transform = 'none';  // 회전은 꺼도 무방할 땐 이 옵션 추가
		} */
	}
	
	
	var station = [];
	var markers = [];
	var markerTrackers = [];
	
	fetch('../resources/json/police_stations.json')
		.then(response => response.json())
		.then(data => { station = data;
			navigator.geolocation.getCurrentPosition((position) => {
				var lat = position.coords.latitude;
				var lon = position.coords.longitude;
				var container = document.getElementById('map');
				var option = { center: new kakao.maps.LatLng(lat, lon), level: 3 };
				var map = new kakao.maps.Map(container, option);
				var markerPosition = new kakao.maps.LatLng(position.coords.latitude, position.coords.longitude);
				var currentMarker = new kakao.maps.Marker({position: markerPosition});
				currentMarker.setMap(map);
				
				kakao.maps.event.addListener(map, 'resize', function() {
					tracking();
				})
				
				var debounceTimer;
				kakao.maps.event.addListener(map, "idle", function() {
					clearTimeout(debounceTimer);
					debounceTimer = setTimeout(() => {
						var center = map.getCenter();
						var near3 = getNearStation(center.getLat(), center.getLng(), station);
						var nearest = near3[0];
						
						console.log("최근접 3개", near3);
						console.log("가장 가까운", nearest);
						
						markerReset();
						
						var img = "../resources/img/marker.png";
						var imageSize = new kakao.maps.Size(30, 48);
						var markerImage = new kakao.maps.MarkerImage(img, imageSize);
						for (var i = 0; i < near3.length; i++)
						{
							var position = new kakao.maps.LatLng(near3[i].Latitude, near3[i].Longitude);
							var title = near3[i]['관서명'] + near3[i]['구분']
							var marker = new kakao.maps.Marker({
								map: map,
								position: position,
								title: title,
								image: markerImage
							});
							var markerTracker = new MarkerTracker(map, marker);
							markers.push(marker);
							markerTrackers.push(markerTracker);							
						}
						markerTrackers.forEach(el => el.run());

						window.addEventListener('resize', function() {
							markerReset();
							markerTrackers.forEach(el => el.run());

						})
					}, 300);
				});
		
			})
			
			function markerReset() {
				markers.forEach(m => m.setMap(null));
				markers = [];
				document.querySelectorAll('.tracker').forEach(el => el.remove());
				markerTrackers = [];
			}
			

		})
		
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
	                 padding: { top: 10, bottom: 20 }
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
	const donutColors2 = donutColors; // 동일한 색상 사용
	
	let donutChart1;
	let barChart1;
	
	fetch('/resources/data/position.json')
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
	fetch("/resources/data/crime_forecast.json")
	.then(res => res.json())
	.then(data => {
	  // 모든 연도 추출 및 정렬
	  const allYears = [...new Set(Object.values(data).flatMap(arr => arr.map(d => d.year)))];
	  allYears.sort((a, b) => a - b);
	
	  const datasets = [];
	
	  // 각 범죄별 실제/예측 데이터 분리 후 datasets 생성
	  Object.entries(data).forEach(([crime, records]) => {
	    const realData = records.filter(d => d.type === '실제');
	    const predictData = records.filter(d => d.type === '예측');
	
	    if (realData.length) {
	      datasets.push({
	        label: crime + ' (실제)',
	        data: realData.map(d => ({ x: d.year, y: d.count })),
	        borderColor: getColor(crime),
	        backgroundColor: getColor(crime),
	        tension: 0.4,
	        borderWidth: 2,
	        fill: false
	      });
	    }
	
	    if (predictData.length) {
	      datasets.push({
	        label: crime + ' (예측)',
	        data: predictData.map(d => ({ x: d.year, y: d.count })),
	        borderColor: getColor(crime),
	    /*     backgroundColor: getColor(crime), */
	        tension: 0.4,
	        borderDash: [5, 5],
	        borderWidth: 2,
	        fill: false
	      });
	    }
	  });
	
	  // 차트 생성
	  const ctx = document.getElementById('forecastChart').getContext('2d');
	
	  new Chart(ctx, {
	    type: 'line',
	    data: {
	      labels: allYears,
	      datasets: datasets
	    },
	    options: {
	      interaction: {
	        mode: 'nearest',
	        intersect: true
	      },
	      plugins: {
	        title: {
	          display: true,
	          text: '5대 범죄 발생건수 연도별 추이 (2024~2025 예측값)',
	          font: { size: 22, weight: 'bold'},
	          padding: { top: 15, bottom: 10 },
	          color: 'rgb(0, 51, 153)' // 제목 파란색 유지
	        },
	        datalabels: {
	          display: false
	        },
	        tooltip: {
	          enabled: true,
	          bodyColor: 'white',
	          titleColor: 'white',
	          callbacks: {
	            /*  label: ctx => `${ctx.dataset.label}: ${ctx.parsed.y.toLocaleString()}건`  */
	          }
	        },
	        legend: {
	          labels: {
	            color: 'black',
	            font: { size: 14, weight: 'bold' }
	          }
	        }
	      },
	      scales: {
	        y: {
	          type: 'logarithmic',
	          beginAtZero: false,
	          title: {
	            display: true,
	//             text: '발생 건수',
	            color: 'black',
	            font: { size: 14, weight: 'bold' }
	          },
	          ticks: {
	            color: 'black',
	            font: { size: 14, weight: 'bold' }
	          }
	        },
	        x: {
	          type: 'linear',
	          title: {
	            display: true,
	            text: '※ 2024년 실제 통계는 2025년 8월에 공개 예정입니다.',
	            color: 'red',
	            font: { size: 15, weight: 'bold' }
	          },
	          ticks: {
	            color: 'black',
	            font: { size: 14, weight: 'bold' },
	            callback: val => val
	          }
	        }
	      }
	    }
	  });
	
	  // 범죄별 색상 지정 함수
	  function getColor(crime) {
	    const colorMap = {
	      '살인': 'red',
	      '강간 및 추행': 'purple',
	      '상해 및 폭행': 'orange',
	      '교통 범죄': 'blue',
	      '강도 및 절도': 'green'
	    };
	    return colorMap[crime] || 'gray';
	  }
	});

 