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
            padding: 10px 0px;
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
                    <p class="blue">아래에 대한 정보를 통해 이후 조회페이지에서 조회하실 수 있습니다.</p>
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
                        숫자만 입력해 주십시오.<br>
                        필요 시, 사전 연락 메시지 이후 전화가 갈 수도 있습니다.
                    </p>
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
    $(document).ready(function(){
        // 숫자만 입력되도록 처리
        $("#phone").on("input", function () {
            this.value = this.value.replace(/[^0-9]/g, "");
        });

        // 입력문자수에 따른 글자 개수 출력
        $("textarea").on("input", function () {
            let text = $(this).val();
            let textLength = text.length;

            $("#letters").html(textLength);
            // 글자수에 따른 errMsg
            if(textLength < 10){
                $("#contentErrMsg").html("상세 내용을 10자 이상 입력해 주십시오.")
            } else{
                $("#contentErrMsg").html("");
            }
        })

        // 위치X면 위치입력 숨기기
        $("input[name='locationYn']").on("change", function () {
            if ($(this).val() === "X" && $(this).is(":checked")) {
                $("#location").hide();
                $("#locationErrMsg").html(""); // 위치 입력 안 해도 되므로 메시지 제거
            } else {
                $("#location").show();
                if ($("#location").val().trim() === "") {
                    $("#locationErrMsg").html("위치를 입력해 주십시오."); // 보이게 되면 다시 값 검사
                } else {
                    $("#locationErrMsg").html("");
                }
            }
        });

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
            let name = $("#name").val().trim();
            let phone = $("#phone").val().trim();
            let selectedType = $("#crimeType").val();
            let selectedlocation = $("input[name='locationYn']:checked").val();
            let locationValue = $("#location").val().trim();
            let content = $("#content").val().trim();
            let textLength = content.length;

            $("#nameErrMsg, #phoneErrMsg, #contentErrMsg, #sltErrMsg, #locationErrMsg").html("");

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

            if (selectedType === "none") {
                $("#sltErrMsg").html("범죄 유형을 선택해 주십시오.");
                isValid = false;
            }

            if (selectedlocation === "O" && locationValue === "") {
                $("#locationErrMsg").html("위치를 입력해 주십시오.");
                isValid = false;
            }

            if (textLength < 10) {
                $("#contentErrMsg").html("상세 내용을 10자 이상 입력해 주십시오.");
                isValid = false;
            }

         	// 이름 입력 시 에러 메시지 제거
            $("#name").on("input", function () {
                if ($(this).val().trim() !== "") {
                    $("#nameErrMsg").html("");
                }
            });

            // 전화번호 입력 시 에러 메시지 제거
            $("#phone").on("input", function () {
                this.value = this.value.replace(/[^0-9]/g, ""); // 숫자만 허용
                if (/^\d{8,11}$/.test(this.value)) {
                    $("#phoneErrMsg").html("");
                }
            });

            // 범죄 유형 선택 시 에러 메시지 제거
            $("#crimeType").on("change", function () {
                if ($(this).val() !== "none") {
                    $("#sltErrMsg").html("");
                }
            });

            // 위치 입력 시 에러 메시지 제거
            $("#location").on("input", function () {
                if ($(this).val().trim() !== "") {
                    $("#locationErrMsg").html("");
                }
            });
            
            if (!isValid) return;

            // Ajax로 전송
            const formData = new FormData();
            formData.append("name", name);
            formData.append("phone", phone);
            formData.append("crimeType", selectedType);
            formData.append("location", locationValue);
            formData.append("content", content);

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