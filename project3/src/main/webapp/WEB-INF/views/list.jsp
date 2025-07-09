<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신고 조회 목록</title>
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
        }
        .infowrap{
            display: flex;
            align-items: center;
            margin: 0 20px 30px;
            gap: 30px;
            flex-wrap: wrap;
        }
        .cate{
            width: 70px;
            font-size: 18px;
        }
        .inp{
            flex: 0.5;
            border: none;
            border-bottom: 1px solid gray;
            padding: 10px;
        }
        #btnBox{
            display: flex;
            justify-content: center;
        }
        button{
            padding: 10px 15px;
            font-family: 'GongGothicMedium';
            border: 1px solid black;
            background-color: rgb(231, 231, 231);
            font-size: 15px;
            cursor: pointer;
            margin-bottom: 30px;
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
    <link rel="stylesheet" type="text/css" href="resources/css/menu.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/menu.jsp" />
    <div id="wrap">
        <div id="row1">
            <p id="pageTitle">신고 조회 목록</p>
        </div>
        <div id="row2">
            <div class="infowrap">
                <span class="cate">이름</span>
                <input class="inp" type="text" id="name" name="name">
                <span class="red" id="nameErrMsg"></span>
            </div>
            <div class="infowrap">
                <span class="cate">전화번호</span>
                <input class="inp" type="text" id="phone" name="phone">
                <span class="red" id="phoneErrMsg"></span>
            </div>
            <div class="infowrap">
                <span class="cate">비밀번호</span>
                <input class="inp" type="password" id="password" name="password">
                <span class="red" id="passwordErrMsg"></span>
            </div>
            <div id="btnBox">
                <button id="searchBtn">조회</button>
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
	$(document).ready(function(){
		$("#searchBtn").on("click", function(e) {
			e.preventDefault();
			
			let isValid = true;
		    let name = $.trim($("#name").val());
		    let phone = $.trim($("#phone").val());
		    let password = $.trim($("#password").val());

		    $("#nameErrMsg, #phoneErrMsg").html("");

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
            
         	// 비밀번호 입력 시 에러 메시지 제거
            $("#password").on("input", function () {
                if ($(this).val().trim() !== "") {
                    $("#passwordErrMsg").html("");
                }
            });
            
            if (!isValid) return;
            
            /*$.ajax({
                url: "${pageContext.request.contextPath}/report/search",
                type: "get",
                data: { name: name, phone: phone },
                dataType: "json",
                success: function(data) {
                    var $tbody = $("#reportTableBody");
                    $tbody.empty(); // 기존 내용 제거

                    if (data.length === 0) {
                        $tbody.append("<tr><td colspan='4' align='center'>등록된 신고 내용이 없습니다.</td></tr>");
                    } else {
                        $.each(data, function(index, report) {
                            var row = "<tr>" +
                                "<td>" + (index + 1) + "</td>" +
                                "<td>" + report.crimeType + "</td>" +
                                "<td>" + (report.confirmYn === 'Y' ? "확인됨" : report.confirmYn === 'C'? "전화 필요" : "미확인") + "</td>" +
                                "<td>" + report.createdAt + "</td>" +
                                "</tr>";
                            $tbody.append(row);
                        });
                    }
                },
                error: function(xhr, status, error) {
                    console.error("오류 발생:", error);
                }
            });*/
		});
	})
</script>
</body>
</html>