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
        .inpWrap{
            flex: 0.5;
            border-bottom: 1px solid gray;
            box-sizing: border-box;
        }
        .inp{
            box-sizing: border-box;
            padding: 10px;
            border: none;
            font-size: 15px;
            width: 100%;
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
        a{
        	color: black;
        }
    </style>
    <link rel="stylesheet" type="text/css" href="resources/css/menu.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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
                <div class="inpWrap">
                	<input class="inp" type="text" id="name" name="name">
                </div>
                <span class="red" id="nameErrMsg"></span>
            </div>
            <div class="infowrap">
                <span class="cate">전화번호</span>
                <div class="inpWrap">
                	<input class="inp" type="text" id="phone" name="phone">
                </div>
                <span class="red" id="phoneErrMsg"></span>
            </div>
            <div class="infowrap">
                <span class="cate">비밀번호</span>
                <div class="inpWrap" id="pwBox">
	                <input class="inp" type="password" id="password" name="password">
	                <i class="bi bi-eye-slash eye-icon" onclick="togglePassword()"></i>
                </div>
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
/*
function formatDate(createdAtObj) {
    const y = createdAtObj.year;
    const m = String(createdAtObj.month).padStart(2, '0');
    const d = String(createdAtObj.day).padStart(2, '0');
    const h = String(createdAtObj.hour).padStart(2, '0');
    const min = String(createdAtObj.minute).padStart(2, '0');
    return `${y}-${m}-${d} ${h}:${min}`;
}*/

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
            
            
            $.ajax({
                url: "${pageContext.request.contextPath}/search",
                type: "get",
                data: { 
                    name: name, 
                    phone: phone,
                    password: password
                },
                dataType: "json",
                success: function(data) {
                    var $tbody = $("#reportTableBody");
                    $tbody.empty();

                    if (data.length === 0) {
                        $tbody.append("<tr><td colspan='4' align='center'>등록된 신고 내용이 없습니다.</td></tr>");
                    } else {
                        $.each(data, function(index, report) {
                        	var dateOnly = report.createdAt.substring(0, 10); // 앞의 10글자: "2025-07-14"
                            var row = "<tr>" +
                            	"<td>" + (data.length - index) + "</td>" +
                                "<td><a href='${pageContext.request.contextPath}/view?id=" + report.id + "'>" + report.crimeType + "</a></td>" +
                                "<td>" + (report.state === '확인완료' ? "확인완료" : report.state === '확인필요'? "확인필요" : "미확인") + "</td>" +
                                "<td>" + dateOnly + "</td>" +
                                "</tr>";
                            $tbody.append(row);
                        });
                    }
                },
                error: function(xhr) {
                    if(xhr.status === 401){
                        alert("비밀번호가 올바르지 않습니다.");
                    } else {
                        alert("조회 중 오류가 발생했습니다.");
                    }
                }
            });
		});
	})
</script>
</body>
</html>