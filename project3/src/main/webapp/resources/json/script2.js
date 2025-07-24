$(document).ready(function() {

    console.log("si:", si, "gu:", gu); // JSP에서 선언한 전역 변수 사용 가능
    
    

    const policeJsonUrl = "/resources/json/police_stations.json";

    // 모달 생성 (없으면 생성)
    if ($("#stationListModal").length === 0) {
        $("body").append(`
            <div id="stationListModal" style="
                display:none; position:fixed; top:50%; left:50%; transform:translate(-50%, -50%);
                background:#fff; border:1px solid #ccc; padding:20px; max-height:400px; overflow-y:auto; z-index:9999;
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            ">
                <h3 style="font-weight: normal;">파출소 선택</h3>
                <ul id="stationList" style="list-style:none; padding:0; margin:0;"></ul>
                <button id="closeStationList" style="
                	padding: 5px; font-family: 'GongGothicMedium'; font-size: 12px; background-color: rgb(231, 231, 231);
        			border: 1px solid black; margin-top:7px;
               	">닫기</button>
            </div>
        `);
    }

    $("#closeStationList").click(function() {
        $("#stationListModal").hide();
    });

    // 거리 계산 함수 (m단위)
    function getDistance(lat1, lon1, lat2, lon2) {
        function deg2rad(deg) {
            return deg * (Math.PI / 180);
        }
        const R = 6371000; // 지구 반경(m)
        const dLat = deg2rad(lat2 - lat1);
        const dLon = deg2rad(lon2 - lon1);
        const a =
            Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
            Math.sin(dLon/2) * Math.sin(dLon/2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        return R * c;
    }

    // 서버에 상태 변경 요청 + 성공 시 콜백 호출
    function changeStateOnServer(newState, callback) {
        const reportId = $("input[name='id']").val();

        $.ajax({
            type: "POST",
            url: "/admin/updateState",
            data: { 
            id: reportId, 
            state: newState, 
            station: $("#station").val() },
            
            success: function(response){
                $('#state').text(newState).css('color', 'green');
                if (callback) callback();
            },
            error: function(){
                alert('상태 변경에 실패했습니다.');
            }
        });
    }

    // 파출소 배정 + 상태 변경 후 콜백
    function assignStationAndUpdateState(stationName, callback) {
        $("#station").val(stationName);       // 파출소 정보 먼저 세팅
        $("#stationListModal").hide();        // 모달 먼저 닫기

        changeStateOnServer("배정", function() {  // 그 다음 상태 변경 호출
            if (callback) callback();
        });
    }

    // 신고 위치 없을 때 현재 위치 기준 가장 가까운 파출소 배정
    function assignNearestStationByCurrentLocation(policeStations, callback) {
        if (!navigator.geolocation) {
            alert("위치 정보를 사용할 수 없습니다.");
            return;
        }
        navigator.geolocation.getCurrentPosition(function(position){
            const userLat = position.coords.latitude;
            const userLon = position.coords.longitude;
            let minDist = Number.MAX_VALUE;
            let nearestStation = null;

            policeStations.forEach(st => {
                const dist = getDistance(userLat, userLon, st.Latitude, st.Longitude);
                if(dist < minDist){
                    minDist = dist;
                    nearestStation = st;
                }
            });

            if(nearestStation){
                const stationName = nearestStation.관서명 + nearestStation.구분;
                assignStationAndUpdateState(stationName, function() {
                    alert(`제일 가까운 "${stationName}" 가 배정되었습니다.`);
                    if (callback) callback();
                });
            } else {
                alert("근처 파출소를 찾을 수 없습니다.");
            }
        }, function(err){
            alert("위치 정보 사용이 거부되었습니다.");
        });
    }

    // 신고 위치 있을 때 시/구 기준으로 파출소 목록 보여주고 선택 후 배정
    function showStationsBySiGu(policeStations, si, gu, callback) {
        const fullAddress = si + " " + gu;
        const filteredStations = policeStations.filter(st => st.주소.includes(fullAddress));

        if(filteredStations.length === 0){
            alert("해당 지역의 파출소를 찾을 수 없습니다.");
            return;
        }

        const $list = $("#stationList");
        $list.empty();

        filteredStations.forEach(st => {
            const stationName = st.관서명 + st.구분;
            const addr = st.주소;
            const $li = $(`
                <li style="padding:5px; border-bottom:1px solid #ddd; cursor:pointer;">
                    <strong style="font-weight: normal;">${stationName}</strong><br/>
                    <small style="font-weight: normal;">${addr}</small>
                </li>
            `);
            $li.on("click", function() {
                assignStationAndUpdateState(stationName, function() {
                    alert(`"${stationName}" 가 배정되었습니다.`);
                    if (callback) callback();
                });
            });
            $list.append($li);
        });

        $("#stationListModal").show();
    }

    // 신고 위치에 따라 분기 처리
    function processStationAssignment(policeStations) {
        const locationText = $("#location").text().trim();

        if(locationText === "현재 위치와 동일"){
            assignNearestStationByCurrentLocation(policeStations);
        } else if (si && gu && si !== 'none' && si !== 'null' && gu !== 'none' && gu !== 'null') {
            showStationsBySiGu(policeStations, si, gu);
        } else {
            alert("신고할 위치 정보가 정확하지 않습니다.");
        }
    }

    // 파출소 데이터 JSON 로드 후 할당 버튼 클릭 시 배정 시작
    $.getJSON(policeJsonUrl)
    .done(function(data){
        $("#assign").on("click", function(){
            processStationAssignment(data);
        });
    })
    .fail(function(){
        alert("파출소 데이터 로드에 실패했습니다.");
    });

function assignSupportStationAndUpdateState(supportStationName, callback) {
        $("#supportStation").val(supportStationName);  // 지원파출소 input에 값 세팅
        $("#stationListModal").hide();

        $.ajax({
            type: "POST",
            url: "/admin/updateSupportStation",  // 지원파출소용 별도 API (혹은 기존 updateState에 지원파출소 파라미터 추가)
            data: {
                id: $("input[name='id']").val(),
                supportStation: supportStationName,
                state: "지원 완료"
            },
            success: function(response) {
                $('#state').text("지원 완료").css('color', 'blue');
                if(callback) callback();
                alert(`지원파출소 "${supportStationName}" 가 배정되었습니다.`);
            },
            error: function() {
                alert('지원파출소 배정에 실패했습니다.');
            }
        });
    }

    // 지원 완료 버튼 클릭 처리
    $("#support_completed").on("click", function() {
        $.getJSON(policeJsonUrl)
        .done(function(data){
            processSupportStationAssignment(data);
        })
        .fail(function(){
            alert("파출소 데이터 로드에 실패했습니다.");
        });
    });

    // 지원파출소 배정 분기 처리
    function processSupportStationAssignment(policeStations) {
        const locationText = $("#location").text().trim();
        const currentStation = $("#station").val(); // 기존 배정 파출소명

        if(locationText === "현재 위치와 동일"){
            if(!navigator.geolocation){
                alert("위치 정보를 사용할 수 없습니다.");
                return;
            }
            navigator.geolocation.getCurrentPosition(function(position){
                const userLat = position.coords.latitude;
                const userLon = position.coords.longitude;
                let minDist = Number.MAX_VALUE;
                let nearestSupportStation = null;

                policeStations.forEach(st => {
                    const stationName = st.관서명 + (st.구분 || "");
                    if(stationName === currentStation) return; // 기존 파출소 제외

                    const dist = getDistance(userLat, userLon, st.Latitude, st.Longitude);
                    if(dist < minDist){
                        minDist = dist;
                        nearestSupportStation = st;
                    }
                });

                if(nearestSupportStation){
                    const supportStationName = nearestSupportStation.관서명 + (nearestSupportStation.구분 || "");
                    assignSupportStationAndUpdateState(supportStationName);
                } else {
                    alert("근처 지원파출소를 찾을 수 없습니다.");
                }
            }, function(err){
                alert("위치 정보 사용이 거부되었습니다.");
            });
        } else if (si && gu && si !== 'none' && si !== 'null' && gu !== 'none' && gu !== 'null') {
            const fullAddress = si + " " + gu;
            const filteredStations = policeStations.filter(st => st.주소.includes(fullAddress));

            // 기존 파출소는 제외
            const filteredSupportStations = filteredStations.filter(st => {
                const stationName = st.관서명 + (st.구분 || "");
                return stationName !== currentStation;
            });

            if(filteredSupportStations.length === 0){
                alert("해당 지역의 지원파출소를 찾을 수 없습니다.");
                return;
            }

            // 모달에 지원파출소 목록 출력
            const $list = $("#stationList");
            $list.empty();

            filteredSupportStations.forEach(st => {
                const supportStationName = st.관서명 + (st.구분 || "");
                const addr = st.주소;
                const $li = $(`
                    <li style="padding:5px; border-bottom:1px solid #ddd; cursor:pointer;">
                        <strong style="font-weight: normal;">${supportStationName}</strong><br/>
                        <small style="font-weight: normal;">${addr}</small>
                    </li>
                `);
                $li.on("click", function() {
                    assignSupportStationAndUpdateState(supportStationName);
                });
                $list.append($li);
            });

            $("#stationListModal").show();
        } else {
            alert("신고할 위치 정보가 정확하지 않습니다.");
        }
    }
});





