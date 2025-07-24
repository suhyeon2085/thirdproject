/**
 * 
 */
 
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
		const lat = 35.5420747;
		const lon = 129.3413943;
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
/*		renderNearestStations(map, position, station, currentLocation);	*/
	/*	setupIdleTracking(map, position, station, currentLocation);
*/
		reportListView();

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
		const markerImg = new kakao.maps.MarkerImage('../resources/img/office.png', new kakao.maps.Size(25, 40), new kakao.maps.Point(15, 15));
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
	
	function reportListView()
	{
		let table = document.getElementById('reportList');

		let si = 'none';
		let gu = 'none';
		let crimeType = 'none';
		let page = 1;
		let size = 11; /* 사이즈조절 */
		 
		$.ajax({
		    url: '/temp/list',
		    type: 'get',
		    data: { si, gu, crimeType, page, size },
		    dataType: 'json',
		    success: function(response) {
		        $.each(response.data, function(index, value) {
		        
		        	if (value.state != '미확인') {
			            let row = document.createElement('tr');
			            let type = document.createElement('td');
			
			            let link = document.createElement('a');
			            link.href = `${contextPath}/admin/viewA?id=${encodeURIComponent(value.id)}`;
			            link.textContent = value.crimeType;
			            link.className = 'type-link';
			
			            type.appendChild(link);
			            row.appendChild(type);
			
			            let state = document.createElement('td');
			            state.className = 'state';
			            state.textContent = value.state;
			            
			            // 상태에 따라 색상 지정
					    let color = 'red';
					    if (value.state === '배정') color = 'green';
					    else if (value.state === '출동') color = 'orange';
					    else if (value.state === '지원 요청') color = 'purple';
					    else if (value.state === '지원 완료') color = 'blue';
					    else if (value.state === '상황 종료') color = 'gray';
					
					    // 색상 적용
					    state.style.color = color;
			            
			            row.appendChild(state);
			
			            let time = document.createElement('td');
			            let date = new Date(value.createdAt.replace(" ", "T"));
			            let hours = String(date.getHours()).padStart(2, '0');
			            let minutes = String(date.getMinutes()).padStart(2, '0');
			            time.textContent = `${hours}:${minutes}`;
			            row.appendChild(time);
			            
			            table.appendChild(row);
			            
			        }
		
		        });
		    }
		});

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
	     	responsive: true,
  			devicePixelRatio: 2,
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
	                     font: { family: 'GongGothicMedium', size: 14 }
	                 }
	             },
	             title: {
	                 display: true,
	                 text: region + '5대 범죄 발생 비율 (%)',
	                 color: 'rgb(0, 51, 153)',
	                 font: { family: 'GongGothicMedium', size: 20, weight: 'normal' },
	                 align: 'start',
	                 padding: { top: 50, bottom: 5 }
	             },
	             datalabels: {
	                 color: 'black',
	                 font: { family: 'GongGothicMedium', size: 16 },
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
	     	 responsive: true,
  			 devicePixelRatio: 2,
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
	                     font: { size: 16, family: 'GongGothicMedium' }
	                 }
	             },
	             x: {
	                 ticks: {
	                     color: 'rgb(0, 51, 153)',
	                     font: { size: 14, family: 'GongGothicMedium' }
	                 }
	             }
	         },
	         plugins: {
	             legend: { display: false },
	             title: {
	                 display: true,
	                 text: region + '범죄별 검거율',
	                 color: 'rgb(0, 51, 153)',
	                 font: { size: 20, family: 'GongGothicMedium', weight: 'normal' },
	                 padding: { top: 0, bottom: 20 }
	             },
	             datalabels: {
	                 anchor: 'end',
	                 align: 'top',
	                 color: 'rgb(0, 51, 153)',
	                 font: { family: 'GongGothicMedium', size: 14 },
	                 formatter: v => v + '%'
	             }
	         }
	     },
	     plugins: [ChartDataLabels]
	 });
	}

	
	//------------------ 예측 차트 ------------------ //
	fetch("../resources/data/crime_forecast.json")
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
                font: { size: 20, family: 'GongGothicMedium', weight: 'normal' },
                color: 'rgb(0, 51, 153)',
                padding: { top: 15, bottom: 15 }
              },
              legend: {
                labels: {
                  color: 'black',
                  font: { size: 14, family: 'GongGothicMedium' }
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
                  font: { size: 14, family: 'GongGothicMedium' }
                }
              },
              x: {
                type: 'linear',
                ticks: {
                  callback: val => val.toString(),
                  color: 'black',
                  font: { size: 14, family: 'GongGothicMedium' }
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

//------------------ 예측 차트 ------------------ //

document.addEventListener('DOMContentLoaded', () => {
  initForecastChart();
});

function initForecastChart() {
  fetch('../resources/data/crime_forecast.json')
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
                font: { size: 20, family: 'GongGothicMedium' },
                color: 'rgb(0, 51, 153)',
                padding: { top: 15, bottom: 15 }
              },
              legend: {
                labels: {
                  color: 'black',
                  font: { size: 14, family: 'GongGothicMedium' }
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
                  font: { size: 14, family: 'GongGothicMedium' }
                }
              },
              x: {
                type: 'linear',
                ticks: {
                  callback: val => val.toString(),
                  color: 'black',
                  font: { size: 14, family: 'GongGothicMedium' }
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

  fetch('../resources/data/crime_time_day.json')
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
  			devicePixelRatio: 2,
            maintainAspectRatio: false,
            plugins: {
              title: {
                display: true,
                text: crime2 ,

                font: { size: 20, family: 'GongGothicMedium', weight: 'normal' },
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
            	      font: { size: 15, family: 'GongGothicMedium' }
            	    },
            	    grid: {
            	      color: '#adadad'  // y축 격자선 색상 (연한 검정)
            	    }
            	  },
            	  x: {
            	    ticks: {
            	      color: 'black',
            	      font: { size: 15, family: 'GongGothicMedium' }
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
    const stackedRes = await fetch('../resources/data/stacked_bar_chart2.json');
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
            family: 'GongGothicMedium',
            weight: 'normal'
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
              family: 'GongGothicMedium'
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
              family: 'GongGothicMedium'
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
              family: 'GongGothicMedium'
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
fetch("../resources/data/radar_chart_crime6.json")
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
        	          family: 'GongGothicMedium'
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
        	          family: 'GongGothicMedium',
        	          weight: 'normal'
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
        	          family: 'GongGothicMedium'
        	        }
        	      },
        	      ticks: {
        	        color: '#555',  // x축 눈금 글자색 (빨강 예시)
        	        font: {
        	          size: 14,
        	          family: 'GongGothicMedium'
        	        }
        	      }
        	    },
        	    y: {
        	      stacked: true,
        	      ticks: {
        	        color: '#555',  // y축 눈금 글자색 (초록 예시)
        	        font: {
        	          size: 14,
        	          family: 'GongGothicMedium'
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
fetch('../resources/data/Predicted.json')
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
                  family: 'GongGothicMedium'          
                }
              }
            },
            x: {
              ticks: {
                color: 'black',
                font: {
                  size: 14,
                  family: 'GongGothicMedium'
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
                  family: 'GongGothicMedium',
                  weight: 'normal'
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
    const fileUrl = "../resources/data/" + selectedCity+ ".json";
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

  const validDistrictRegex = /^[가-힣]{2,}(시|군|구)$/; // 예: 강남구, 고양시, 전주시 등

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
    "광주", "대전", "울산", "세종특별시",
    "경기도", "강원", "충청북", "충청남",
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
    const container = document.getElementById('modalMap');
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
    const fileUrl = "../resources/data/"+selectedCity+"_bell.json"; // 경로는 프로젝트에 맞게 수정
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
    const container = document.getElementById('modalMap');
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
 