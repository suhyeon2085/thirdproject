<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신고 조회 목록 | 관리자</title>
    <style>
        @font-face {
            font-family: 'GongGothicMedium';
            src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff') format('woff');
            font-weight: normal;
            font-style: normal;
        }
        body{
            margin: 0;
            font-family: 'GongGothicMedium';
        }
        #wrap{
            padding: 5% 20%;
        }
        #pageTitle{
            border-bottom: 1px solid black;
            padding-bottom: 10px;
            font-size: 25px;
            margin-bottom: 30px;
        }
        #sltWrap{
            display: flex;
            justify-content: center;
            gap: 5px;
            margin-bottom: 30px;
        }
        #si, #gu, #crimeType{
            font-size: 14px;
            border: 1px solid gray;
            padding: 10px 0px;
            width: 15%;
            text-align: center;
        }
        #si{
            border-radius: 20px 0 0 20px;
        }
        #gu{
            border-radius: 0px;
        }
        #crimeType{
            border-radius: 0px 20px 20px 0px;
        }
        table{
            border: 1px solid black;
            border-collapse: collapse;
            width: 100%;
        }
        .tTitle{
            background-color: rgb(231, 231, 231);
        }
        td{
            border-bottom: 1px solid black;
            padding: 10px;
            box-sizing: border-box;
            text-align: center;
        }
        .red{
            color: red;
            font-size: 14px;
            flex: 0.5;
        }
    </style>
    <link rel="stylesheet" type="text/css" href="../resources/css/menu.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/menu.jsp" />
    <div id="wrap">
        <div id="row1">
            <p id="pageTitle">신고 조회 목록 | 관리자</p>
        </div>
        <div id="row2">
            <div id="sltWrap">
                <select name="si" id="si">
                        <option value="none">시/도</option>
                        <option value="서울특별시">서울</option>
                        <option value="부산광역시">부산</option>
                        <option value="대구광역시">대구</option>
                        <option value="인천광역시">인천</option>
                        <option value="광주광역시">광주</option>
                        <option value="대전광역시">대전</option>
                        <option value="울산광역시">울산</option>
                        <option value="세종특별자치시">세종</option>
                        <option value="제주특별자치도">제주</option>
                        <option value="경기도">경기도</option>
                        <option value="강원도">강원도</option>
                        <option value="충청북도">충청북도</option>
                        <option value="충청남도">충청남도</option>
                        <option value="전라북도">전라북도</option>
                        <option value="전라남도">전라남도</option>
                        <option value="경상북도">경상북도</option>
                        <option value="경상남도">경상남도</option>
                        <option value="기타">기타</option>
                    </select>
                    <select name="gu" id="gu"></select>
                    <select name="crimeType" id="crimeType">
                        <option value="none">범죄 유형</option>
                        <option value="살인">살인</option>
                        <option value="성범죄">성범죄</option>
                        <option value="절도/강도">절도/강도</option>
                        <option value="상해/폭행">상해/폭행</option>
                        <option value="약취/유인">약취/유인</option>
                        <option value="교통범죄">교통범죄</option>
                        <option value="기타">기타</option>
                    </select>
            </div>
            <table>
            	<thead>
                <tr>
                    <td class="tTitle" width="10%">번호</td>
                    <td class="tTitle">범죄 유형</td>
                    <td class="tTitle" width="15%">확인 상태</td>
                    <td class="tTitle" width="15%">작성일</td>
                </tr>
                </thead>
                <tbody id="reportTableBody">
                <!-- 게시물이 없을 때 -->
                <tr>
                    <td td colspan="4" align="center">등록된 게시물이 없습니다.</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
<script>
$(document).ready(function() {
    const $si = $('#si');
    const $gu = $('#gu');
    const skipGuSiList = ["세종특별자치시", "기타"];

    const guOptions = {
        none: [{ value: 'none', text: '시/군/구' }],
        서울특별시: [
                { value: 'none', text: '시/군/구' },
                { value: '종로구', text: '종로구' },
                { value: '중구', text: '중구' },
                { value: '용산구', text: '용산구' },
                { value: '성동구', text: '성동구' },
                { value: '광진구', text: '광진구' },
                { value: '동대문구', text: '동대문구' },
                { value: '중랑구', text: '중랑구' },
                { value: '성북구', text: '성북구' },
                { value: '강북구', text: '강북구' },
                { value: '도봉구', text: '도봉구' },
                { value: '노원구', text: '노원구' },
                { value: '은평구', text: '은평구' },
                { value: '서대문구', text: '서대문구' },
                { value: '마포구', text: '마포구' },
                { value: '양천구', text: '양천구' },
                { value: '강서구', text: '강서구' },
                { value: '구로구', text: '구로구' },
                { value: '금천구', text: '금천구' },
                { value: '영등포구', text: '영등포구' },
                { value: '동작구', text: '동작구' },
                { value: '관악구', text: '관악구' },
                { value: '서초구', text: '서초구' },
                { value: '강남구', text: '강남구' },
                { value: '송파구', text: '송파구' },
                { value: '강동구', text: '강동구' }
            ],
            부산광역시: [
                { value: 'none', text: '시/군/구' },
                { value: '중구', text: '중구' },
                { value: '서구', text: '서구' },
                { value: '동구', text: '동구' },
                { value: '영도구', text: '영도구' },
                { value: '부산진구', text: '부산진구' },
                { value: '동래구', text: '동래구' },
                { value: '남구', text: '남구' },
                { value: '북구', text: '북구' },
                { value: '강서구', text: '강서구' },
                { value: '해운대구', text: '해운대구' },
                { value: '사하구', text: '사하구' },
                { value: '금정구', text: '금정구' },
                { value: '연제구', text: '연제구' },
                { value: '수영구', text: '수영구' },
                { value: '사상구', text: '사상구' },
                { value: '기장군', text: '기장군' }
            ],
            대구광역시: [
                { value: 'none', text: '시/군/구' },
                { value: '중구', text: '중구' },
                { value: '동구', text: '동구' },
                { value: '서구', text: '서구' },
                { value: '남구', text: '남구' },
                { value: '북구', text: '북구' },
                { value: '수성구', text: '수성구' },
                { value: '달서구', text: '달서구' },
                { value: '달성군', text: '달성군' },
                { value: '군위군', text: '군위군' }
            ],
            인천광역시: [
                { value: 'none', text: '시/군/구' },
                { value: '중구', text: '중구' },
                { value: '동구', text: '동구' },
                { value: '미추홀구', text: '미추홀구' },
                { value: '연수구', text: '연수구' },
                { value: '남동구', text: '남동구' },
                { value: '부평구', text: '부평구' },
                { value: '계양구', text: '계양구' },
                { value: '서구', text: '서구' },
                { value: '강화군', text: '강화군' },
                { value: '옹진군', text: '옹진군' }
            ],
            광주광역시: [
                { value: 'none', text: '시/군/구' },
                { value: '동구', text: '동구' },
                { value: '중구', text: '중구' },
                { value: '서구', text: '서구' },
                { value: '유성구', text: '유성구' },
                { value: '대덕구', text: '대덕구' }
            ],
            대전광역시: [
                { value: 'none', text: '시/군/구' },
                { value: '동구', text: '동구' },
                { value: '서구', text: '서구' },
                { value: '남구', text: '남구' },
                { value: '북구', text: '북구' },
                { value: '광산구', text: '광산구' }
            ],
            울산광역시: [
                { value: 'none', text: '시/군/구' },
                { value: '중구', text: '중구' },
                { value: '남구', text: '남구' },
                { value: '동구', text: '동구' },
                { value: '북구', text: '북구' },
                { value: '울주군', text: '울주군' }
            ],
            경기도: [
                { value: 'none', text: '시/군/구' },
                { value: '고양시', text: '고양시' },
                { value: '과천시', text: '과천시' },
                { value: '광명시', text: '광명시' },
                { value: '광주시', text: '광주시' },
                { value: '구리시', text: '구리시' },
                { value: '군포시', text: '군포시' },
                { value: '김포시', text: '김포시' },
                { value: '남양주시', text: '남양주시' },
                { value: '동두천시', text: '동두천시' },
                { value: '부천시', text: '부천시' },
                { value: '성남시', text: '성남시' },
                { value: '수원시', text: '수원시' },
                { value: '시흥시', text: '시흥시' },
                { value: '안산시', text: '안산시' },
                { value: '안성시', text: '안성시' },
                { value: '안양시', text: '안양시' },
                { value: '양주시', text: '양주시' },
                { value: '여주시', text: '여주시' },
                { value: '오산시', text: '오산시' },
                { value: '용인시', text: '용인시' },
                { value: '의왕시', text: '의왕시' },
                { value: '의정부시', text: '의정부시' },
                { value: '이천시', text: '이천시' },
                { value: '파주시', text: '파주시' },
                { value: '평택시', text: '평택시' },
                { value: '포천시', text: '포천시' },
                { value: '하남시', text: '하남시' },
                { value: '화성시', text: '화성시' },
                { value: '연천군', text: '연천군' }
            ],
            강원도: [
                { value: 'none', text: '시/군/구' },
                { value: '강릉시', text: '강릉시' },
                { value: '동해시', text: '동해시' },
                { value: '삼척시', text: '삼척시' },
                { value: '속초시', text: '속초시' },
                { value: '원주시', text: '원주시' },
                { value: '춘천시', text: '춘천시' },
                { value: '태백시', text: '태백시' },
                { value: '홍천군', text: '홍천군' },
                { value: '횡성군', text: '횡성군' },
                { value: '영월군', text: '영월군' },
                { value: '평창군', text: '평창군' },
                { value: '정선군', text: '정선군' },
                { value: '철원군', text: '철원군' },
                { value: '화천군', text: '화천군' },
                { value: '양구군', text: '양구군' },
                { value: '인제군', text: '인제군' },
                { value: '고성군', text: '고성군' },
                { value: '양양군', text: '양양군' }
            ],
            충청북도: [
                { value: 'none', text: '시/군/구' },
                { value: '제천시', text: '제천시' },
                { value: '청주시', text: '청주시' },
                { value: '충주시', text: '충주시' },
                { value: '보은군', text: '보은군' },
                { value: '옥천군', text: '옥천군' },
                { value: '영동군', text: '영동군' },
                { value: '증평군', text: '증평군' },
                { value: '진천군', text: '진천군' },
                { value: '괴산군', text: '괴산군' },
                { value: '음성군', text: '음성군' },
                { value: '단양군', text: '단양군' }
            ],
            충청남도: [
                { value: 'none', text: '시/군/구' },
                { value: '계룡시', text: '계룡시' },
                { value: '공주시', text: '공주시' },
                { value: '논산시', text: '논산시' },
                { value: '당진시', text: '당진시' },
                { value: '보령시', text: '보령시' },
                { value: '서산시', text: '서산시' },
                { value: '아산시', text: '아산시' },
                { value: '천안시', text: '천안시' },
                { value: '금산군', text: '금산군' },
                { value: '부여군', text: '부여군' },
                { value: '서천군', text: '서천군' },
                { value: '청양군', text: '청양군' },
                { value: '예산군', text: '예산군' },
                { value: '태안군', text: '태안군' },
                { value: '홍성군', text: '홍성군' }
            ],
            전라북도: [
                { value: 'none', text: '시/군/구' },
                { value: '군산시', text: '군산시' },
                { value: '김제시', text: '김제시' },
                { value: '남원시', text: '남원시' },
                { value: '익산시', text: '익산시' },
                { value: '전주시', text: '전주시' },
                { value: '정읍시', text: '정읍시' },
                { value: '완주군', text: '완주군' },
                { value: '고창군', text: '고창군' },
                { value: '부안군', text: '부안군' },
                { value: '임실군', text: '임실군' },
                { value: '순창군', text: '순창군' },
                { value: '진안군', text: '진안군' },
                { value: '무주군', text: '무주군' },
                { value: '장수군', text: '장수군' }
            ],
            전라남도: [
                { value: 'none', text: '시/군/구' },
                { value: '광양시', text: '광양시' },
                { value: '나주시', text: '나주시' },
                { value: '목포시', text: '목포시' },
                { value: '순천시', text: '순천시' },
                { value: '여수시', text: '여수시' },
                { value: '담양군', text: '담양군' },
                { value: '곡성군', text: '곡성군' },
                { value: '구례군', text: '구례군' },
                { value: '고흥군', text: '고흥군' },
                { value: '보성군', text: '보성군' },
                { value: '화순군', text: '화순군' },
                { value: '장흥군', text: '장흥군' },
                { value: '강진군', text: '강진군' },
                { value: '해남군', text: '해남군' },
                { value: '영암군', text: '영암군' },
                { value: '무안군', text: '무안군' },
                { value: '함평군', text: '함평군' },
                { value: '영광군', text: '영광군' },
                { value: '장성군', text: '장성군' },
                { value: '완도군', text: '완도군' },
                { value: '진도군', text: '진도군' },
                { value: '신안군', text: '신안군' }
            ],
            경상북도: [
                { value: 'none', text: '시/군/구' },
                { value: '경산시', text: '경산시' },
                { value: '경주시', text: '경주시' },
                { value: '구미시', text: '구미시' },
                { value: '김천시', text: '김천시' },
                { value: '문경시', text: '문경시' },
                { value: '상주시', text: '상주시' },
                { value: '안동시', text: '안동시' },
                { value: '영주시', text: '영주시' },
                { value: '영천시', text: '영천시' },
                { value: '포항시', text: '포항시' },
                { value: '군위군', text: '군위군' },
                { value: '의성군', text: '의성군' },
                { value: '청송군', text: '청송군' },
                { value: '영양군', text: '영양군' },
                { value: '영덕군', text: '영덕군' },
                { value: '청도군', text: '청도군' },
                { value: '고령군', text: '고령군' },
                { value: '성주군', text: '성주군' },
                { value: '칠곡군', text: '칠곡군' },
                { value: '예천군', text: '예천군' },
                { value: '봉화군', text: '봉화군' },
                { value: '울진군', text: '울진군' },
                { value: '울릉군', text: '울릉군' }
            ],
            경상남도: [
                { value: 'none', text: '시/군/구' },
                { value: '거제시', text: '거제시' },
                { value: '김해시', text: '김해시' },
                { value: '밀양시', text: '밀양시' },
                { value: '사천시', text: '사천시' },
                { value: '양산시', text: '양산시' },
                { value: '진주시', text: '진주시' },
                { value: '창원시', text: '창원시' },
                { value: '통영시', text: '통영시' },
                { value: '함안군', text: '함안군' },
                { value: '거창군', text: '거창군' },
                { value: '창녕군', text: '창녕군' },
                { value: '고성군', text: '고성군' },
                { value: '하동군', text: '하동군' },
                { value: '합천군', text: '합천군' },
                { value: '남해군', text: '남해군' },
                { value: '함양군', text: '함양군' },
                { value: '산천군', text: '산천군' },
                { value: '의령군', text: '의령군' }
            ],
            제주특별자치도: [
                { value: 'none', text: '시/군/구' },
                { value: '서귀포시', text: '서귀포시' },
                { value: '제주시', text: '제주시' }
            ]
        };

    function updateSelect($select, options) {
        $select.empty();
        $.each(options, function (_, opt) {
            $select.append($('<option>', { value: opt.value, text: opt.text }));
        });
    }

    function updateGu() {
        const siVal = $si.val();
        const options = guOptions[siVal] || guOptions.none;
        updateSelect($gu, options);

        if (skipGuSiList.includes(siVal)) {
            $gu.prop('disabled', true).val('none');
            $('#siguErrMsg').html('');
        } else {
            $gu.prop('disabled', false);
        }
    }

    // 시 select 변경 시 구 select 옵션 변경 및 조회
    $si.on('change', function() {
        updateGu();
        searchReports();
    });

    // 구 select, 범죄 유형 select 변경 시 조회
    $gu.add($('#crimeType')).on('change', function() {
        searchReports();
    });

    // 초기 세팅
    updateGu();
    searchReports();

    function searchReports() {
        const si = $si.val();
        const gu = $gu.val();
        const crimeType = $('#crimeType').val();

        $.ajax({
            url: '${pageContext.request.contextPath}/admin/reportList',
            type: 'get',
            data: { si, gu, crimeType },
            dataType: 'json',
            success: function(data) {
            	const $tbody = $('#reportTableBody');
                $tbody.empty();

                if (!data || data.length === 0) {
                    $tbody.append('<tr><td colspan="4" align="center">등록된 신고 내용이 없습니다.</td></tr>');
                    return;
                }
               

                // 서버에서 내림차순 정렬을 하므로 reverse()는 제거

                $.each(data, function(i, report) {
                    // createdAt이 문자열일 때 자르기
                    let createdDate = '';
                    if (report.createdAt) {
                        if (typeof report.createdAt === 'string') {
                            createdDate = report.createdAt.substring(0, 10);
                        } else {
                            // Date 객체일 경우 ISO 문자열 변환
                            createdDate = new Date(report.createdAt).toISOString().substring(0, 10);
                        }
                    }

                    const row = `
                        <tr>
                            <td>${i + 1}</td>
                            <td>${report.crimeType || ''}</td>
                            <td>${report.state || ''}</td>
                            <td>${createdDate}</td>
                        </tr>
                    `;
                    $tbody.append(row);
                    console.log('report.state:', report.state, typeof report.state);
                    console.log('report.crimeType:', report.crimeType, typeof report.crimeType);
                    console.log('createdDate', createdDate, typeof createdDate);
                    
                });
            },
            error: function() {
                alert('조회 실패');
            }
        });
        
    }
});
</script>
</body>
</html>