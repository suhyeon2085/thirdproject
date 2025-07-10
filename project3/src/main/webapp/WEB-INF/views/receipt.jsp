<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>범죄 신고</title>
    <style>
        #wrap{
            padding: 5% 20%;
        }
        #pageTitle{
            border-bottom: 1px solid black;
            padding-bottom: 10px;
            font-size: 25px;
        }
        #notice{
            border: 1px solid black;
            /* padding: 15px;
            padding-right: 20px; */
            background-color: rgb(231, 231, 231);
            word-break: keep-all; /* 단어 단위로 줄바꿈 */
            white-space: normal; /* 기본 줄바꿈 허용 */
            overflow-wrap: break-word; /* 긴 단어가 있으면 자동 줄바꿈 */
        }
        #notice ul{
            padding: 20px 5%;
        }
        #notice li{
            padding: 3px 0;
        }
        .infowrap{
            margin: 15px 0;
        }
        .redStar{
            color: red;
        }
        .cate{
            font-size: 15px;
            margin: 5px 0;
        }
        .inp{
            width: 100%;
            border: none;
            border-bottom: 1px solid gray;
            padding: 10px;
            box-sizing: border-box;
        }
        .infoT{
            margin-top: 60px;
            margin-bottom: 30px;
        }
        .title{
            border: 1px solid black;
            padding: 10px;
            margin-bottom: 0;
            background-color: rgb(231, 231, 231);
        }
        .blue{
            color: blue;
            font-size: 14px;
            margin-top: 5px;
            margin-bottom: 0;
        }
        .red{
            color: red;
            font-size: 14px;
            margin-top: 5px;
            margin-bottom: 0;
        }
        #pwBox{
        	position: relative;
        }
        .eye-icon {
            cursor: pointer;
            position: absolute;
            bottom: 6px;
            right: 15px;
            font-size: 18px;
        }
        #crimeType{
            font-size: 14px;
            border: none;
            border-bottom: 1px solid gray;
            padding: 10px 0px;
            width: 50%;
        }
        #check{
            margin-bottom: 10px;
            font-size: 15px;
        }
        #si, #gu{
            font-size: 14px;
            border: none;
            border-bottom: 1px solid gray;
            padding: 10px 0px;
            width: 25%;
        }
        #location{
            margin-top: 10px;
        }
        #content{
            width: 100%;
            height: 150px;
            resize: none;
            padding: 10px;
            box-sizing: border-box;
            word-break: keep-all; /* 단어 단위로 줄바꿈 */
            white-space: normal; /* 기본 줄바꿈 허용 */
            overflow-wrap: break-word; /* 긴 단어가 있으면 자동 줄바꿈 */
        }
        #contentWrapper {
            position: relative;
        }
        #txtlength {
            position: absolute;
            bottom: 10px;
            right: 10px;
            font-size: 14px;
            background: white;
            padding: 2px 5px;
        }
        #fileWrapper{
            display: flex;
            gap: 5px;
            margin-bottom: 10px;
        }
        #filename{
            border: 1px solid gray;
            flex: 1;
            padding: 0 15px;
            align-content: center;
            color: gray;
        }
        #addFileBtn{
            padding: 10px 15px;
            font-family: 'GongGothicMedium';
            border: 1px solid black;
            background-color: rgb(231, 231, 231);
            font-size: 15px;
            cursor: pointer;
        }
        #submitReportBtn{
            padding: 10px 15px;
            font-family: 'GongGothicMedium';
            border: 1px solid black;
            background-color: rgb(231, 231, 231);
            font-size: 15px;
            margin: 30px 0;
            cursor: pointer;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="resources/css/menu.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/menu.jsp" />
    <div id="wrap">
        <div id="row1">
            <p id="pageTitle">범죄 신고 접수</p>
            <div id="notice">
                <ul>
                    <li>전자민원은 행정기관 민원서비스 통합에 따라 국민권익위원회에서 운영 (전화:국번없이 110)하는 국민신문고 (www.epeople.go.kr)를 통하여 관리되고 있습니다.</li>
                    <li>원하시는 업무분야에 신청하면 즉시 해당과에 접수되며, 기타 분야는 민원실에서 해당부서로 분류합니다.</li>
                    <li>경찰청 소관민원이 아닌 경우, 타 부처 또는 해당 지자체로 민원이 이첩됩니다.</li>
                    <li>경찰 허위신고는 공무집행방해죄로 형사처벌하거나 500만 원 이하의 과태료를 부과할 수 있습니다.</li>
                    <li>민원 신청 중 다음 단계로 넘어가지 않을 경우, (전화 : 국번없이 1600-8172) 또는 국민신문고 사이트(www.epeople.go.kr)에서 신청 바랍니다.</li>
                </ul>
            </div>
        </div>
        <div id="row2">
            <form id="reportForm">
                <div class="infoT">
                    <p class="title">신고인 기본 정보</p>
                    <p class="blue">
                    	아래에 대한 정보를 통해 이후 조회페이지에서 조회하실 수 있습니다.<br>
                        필요 시, 사전 연락 메시지 이후 전화가 갈 수도 있습니다.
                    </p>
                </div>
                <div class="infowrap">
                    <p class="cate">이름<span class="redStar">*</span></p>
                    <input class="inp" type="text" id="name" name="name">
                    <p class="red" id="nameErrMsg"></p>
                </div>
                <div class="infowrap">
                    <p class="cate">전화번호<span class="redStar">*</span></p>
                    <input class="inp" type="text" id="phone" name="phone">
                    <p class="red" id="phoneErrMsg"></p>
                    <p class="blue">
                        숫자만 입력해 주십시오.
                    </p>
                </div>
                <div class="infowrap">
                    <p class="cate">비밀번호<span class="redStar">*</span></p>
                    <div id="pwBox">
	                    <input class="inp" type="password" id="password" name="password">
	                    <i class="bi bi-eye-slash eye-icon" onclick="togglePassword()"></i>
                    </div>
                    <p class="red" id="passwordErrMsg"></p>
                </div>
                <div class="infoT">
                    <p class="title">신고 내용</p>
                </div>
                <div class="infowrap">
                    <p class="cate">범죄 유형<span class="redStar">*</span></p>
                    <select name="crimeType" id="crimeType">
                        <option value="none">선택</option>
                        <option value="살인">살인</option>
                        <option value="성범죄">성범죄</option>
                        <option value="절도/강도">절도/강도</option>
                        <option value="상해/폭행">상해/폭행</option>
                        <option value="약취/유인">약취/유인</option>
                        <option value="교통범죄">교통범죄</option>
                        <option value="기타">기타</option>
                    </select>
                    <p class="red" id="sltErrMsg"></p>
                </div>
                <div class="infowrap">
                    <p class="cate">위치<span class="redStar">*</span></p>
                    <div id="check">
                        <input type="radio" name="locationYn" value="O" checked>입력
                        <input type="radio" name="locationYn" value="X">입력X(기억나지 않습니다)
                    </div>
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
                    <p class="red" id="siguErrMsg"></p>
                    <input class="inp" type="text" id="location" name="location">
                    <span class="red" id="locationErrMsg"></span>
                </div>
                <div class="infowrap">
                    <p class="cate">상세 내용<span class="redStar">*</span></p>
                    <div id="contentWrapper">
                        <textarea name="content" id="content" placeholder="범죄 피해/목격 사실에 대해 입력해 주십시오."></textarea>
                        <span id="txtlength"><strong id="letters">0</strong>글자</span>
                    </div>
                    <div id="bottomMsg">
                        <span class="red" id="contentErrMsg"></span>
                    </div>
                </div>
                 <div class="infowrap">
                    <p class="cate">첨부 파일</p>
                    <div id="fileWrapper">
                        <div id="filename"></div>
                        <input type="file" id="filePath" name="files" style="display: none;" multiple>
                        <button type="button" id="addFileBtn">추가</button>
                    </div>
                    <div id="files"></div>
                </div>
                <div id="submitBtn">
                    <button type="button" id="submitReportBtn">제출</button>
                </div>
            </form>
        </div>
    </div>
<script>
function togglePassword() {
    const input = document.getElementById("password");
    const icon = document.querySelector(".eye-icon");
    if (input.type === "password") {
        input.type = "text";
        icon.classList.remove("bi-eye-slash");
        icon.classList.add("bi-eye");
    } else {
        input.type = "password";
        icon.classList.remove("bi-eye");
        icon.classList.add("bi-eye-slash");
    }
}

    $(document).ready(function(){
    	// 숫자만 입력되도록 처리 및 에러 제거
    	$("#phone").on("input", function () {
    	    this.value = this.value.replace(/[^0-9]/g, "");
    	    if (/^\d{8,11}$/.test(this.value)) {
    	        $("#phoneErrMsg").html("");
    	    }
    	});

    	// 텍스트 길이 체크 및 에러 제거
    	$("textarea").on("input", function () {
    	    const textLength = $(this).val().length;
    	    $("#letters").html(textLength);
    	    $("#contentErrMsg").html(textLength < 10 ? "상세 내용을 10자 이상 입력해 주십시오." : "");
    	});

    	// 이름, 비밀번호 입력 시 에러 제거
    	$("#name").on("input", function () {
    	    if ($(this).val().trim() !== "") {
    	        $("#nameErrMsg").html("");
    	    }
    	});
    	$("#password").on("input", function () {
    	    if ($(this).val().trim() !== "") {
    	        $("#passwordErrMsg").html("");
    	    }
    	});

    	// 범죄 유형 선택 시 에러 제거
    	$("#crimeType").on("change", function () {
    	    if ($(this).val() !== "none") {
    	        $("#sltErrMsg").html("");
    	    }
    	});

    	// 위치 입력 시 에러 제거
    	$("#location").on("input", function () {
    	    if ($(this).val().trim() !== "") {
    	        $("#locationErrMsg").html("");
    	    }
    	});

    	// 시/군/구 선택 시 에러 제거
    	// gu를 선택하지 않아도 되는 시/도 목록
    	const skipGuSiList = ["세종특별자치시", "기타"];

		function validateSigu() {
		    const siVal = $("#si").val();
		    const guVal = $("#gu").val();
		
		    if (siVal === "none") {
		        $("#siguErrMsg").html("시/도를 선택해 주십시오.");
		    } else if (!skipGuSiList.includes(siVal) && guVal === "none") {
		        $("#siguErrMsg").html("시/군/구를 선택해 주십시오.");
		    } else {
		        $("#siguErrMsg").html("");
		    }
		}
		
		// 시 선택 시 gu 비활성화/활성화
		$("#si").on("change", function () {
		    const siVal = $(this).val();
		
		    if (skipGuSiList.includes(siVal)) {
		        $("#gu").prop("disabled", true).val("none");
		        $("#siguErrMsg").html("");
		    } else {
		        $("#gu").prop("disabled", false);
		    }
		
		    validateSigu();
		});
		
		// gu 선택 시에도 validate
		$("#gu").on("change", validateSigu);
		
		// 위치X면 위치 입력 숨기기
		$("input[name='locationYn']").on("change", function () {
		    const isLocationX = $(this).val() === "X";
		
		    $("#location, #si, #gu").toggle(!isLocationX);
		
		    if (isLocationX) {
		        $("#locationErrMsg, #siguErrMsg").html("");
		    } else {
		        if ($("#location").val().trim() === "") {
		            $("#locationErrMsg").html("상세 위치를 입력해 주십시오.");
		        }
		        validateSigu();
		    }
		});

        
     	// 시구 select
        const $si = $('#si');
        const $gu = $('#gu');
        
        const guOptions = {
            none: [
                { value: 'none', text: '시/군/구' },
            ],
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
                $select.append($('<option>', {
                    value: opt.value,
                    text: opt.text
                }));
            });
        }

        function updateGu() {
            const siValue = $si.val();
            const options = guOptions[siValue] || [];
            updateSelect($gu, options);
        }

        $si.on('change', updateGu);

        // 초기화
        updateGu();

        // 첨부 파일 추가
        let selectedFiles = [];

        $("#addFileBtn").on("click", function () {
            $("#filePath").click(); // 숨겨진 파일 입력창 클릭
        });

        $("#filePath").on("change", function (e) {
            const files = Array.from(e.target.files);

            for (let file of files) {
                // 파일 이름 중복 방지
                if (!selectedFiles.find(f => f.name === file.name)) {
                    selectedFiles.push(file);
                }
            }

            renderFileList();
            $("#filePath").val(""); // 동일 파일 다시 선택 가능하도록 초기화
        });

        function renderFileList() {
            // filename: 마지막 선택된 파일 이름
            if (selectedFiles.length > 0) {
                $("#filename").text(selectedFiles[selectedFiles.length - 1].name);
            }

            // files: 전체 목록 출력
            $("#files").html(""); // 초기화
            selectedFiles.forEach((file, index) => {
                $("#files").append(`
                    <div class="file-item">
                        \${file.name}
                        <i class="bi bi-x-square file-remove" data-index="${index}" style="cursor:pointer; margin-left:10px;"></i>
                    </div>
                `);
            });
        }

        // x 버튼 클릭 시 파일 제거
        $(document).on("click", ".file-remove", function () {
            const index = $(this).data("index");
            selectedFiles.splice(index, 1);
            renderFileList();
        });


     	// 폼 제출 시 유효성 검사
        $("#submitReportBtn").on("click", function (e) {
            e.preventDefault();

            let isValid = true;
            const name = $("#name").val().trim();
            const phone = $("#phone").val().trim();
            const password = $("#password").val().trim();
            const selectedType = $("#crimeType").val();
            const selectedLocation = $("input[name='locationYn']:checked").val();
            const siType = $("#si").val();
            const guType = $("#gu").val();
            const locationValue = $("#location").val().trim();
            const content = $("#content").val().trim();

            // 에러 초기화
            $("#nameErrMsg, #phoneErrMsg, #passwordErrMsg, #sltErrMsg, #locationErrMsg, #siguErrMsg, #contentErrMsg").html("");

            if (!name) {
                $("#nameErrMsg").html("이름을 입력해 주십시오.");
                isValid = false;
            }

            if (!phone) {
                $("#phoneErrMsg").html("전화번호를 입력해 주십시오.");
                isValid = false;
            } else if (!/^\d{8,11}$/.test(phone)) {
                $("#phoneErrMsg").html("전화번호는 숫자만 8~11자리 입력해 주십시오.");
                isValid = false;
            }

            if (!password) {
                $("#passwordErrMsg").html("비밀번호를 입력해 주십시오.");
                isValid = false;
            }

            if (selectedType === "none") {
                $("#sltErrMsg").html("범죄 유형을 선택해 주십시오.");
                isValid = false;
            }

            if (selectedLocation === "O") {
                if (siType === "none") {
                    $("#siguErrMsg").html("시/도를 선택해 주십시오.");
                    isValid = false;
                } else if (!skipGuSiList.includes(siType) && guType === "none") {
                    $("#siguErrMsg").html("시/군/구를 선택해 주십시오.");
                    isValid = false;
                }

                if (locationValue === "") {
                    $("#locationErrMsg").html("상세 위치를 입력해 주십시오.");
                    isValid = false;
                }
            }

            if (content.length < 10) {
                $("#contentErrMsg").html("상세 내용을 10자 이상 입력해 주십시오.");
                isValid = false;
            }

            if (!isValid) return;

            // Ajax로 전송
            const formData = new FormData();
            formData.append("name", name);
            formData.append("phone", phone);
            formData.append("crimeType", selectedType);
            formData.append("location", locationValue);
            formData.append("content", content);
            
            formData.append("password", password); 
            
            formData.append("si", siType);
            formData.append("gu", guType);

            for (let i = 0; i < selectedFiles.length; i++) {
                formData.append("files", selectedFiles[i]); // input name="files"에 맞춤
            }

            $.ajax({
                url: "/receipt",
                type: "POST",
                data: formData,
                contentType: false,
                processData: false,
                dataType: "json",
                success: function (res) {
                	console.log(res);
                    // res.id를 받아서 상세 페이지로 이동
                    window.location.href = "/view?id=" + res.id;
                },
                error: function () {
                    alert("제출에 실패했습니다. 관리자에게 문의하세요.");  // 필요하면 복구
                }
            });
        });
    })
</script>
</body>
</html>