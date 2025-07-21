<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 로그인</title>
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
            padding: 5% 30%;
        }
        #row1{
            display: flex;
            justify-content: center;
        }
        #pageTitle{
            border-bottom: 2px solid black;
            padding-bottom: 10px;
            font-size: 25px;
            margin-bottom: 30px;
        }
        #row2{
            border: 1px solid black;
            padding: 7% 10%;
            background: linear-gradient(white, whitesmoke);
        }
        #idBox, #pwBox{
            border: 1px solid gray;
            position: relative;
        }
        #idBox{
            border-bottom: 1px solid transparent;
        }
        .inp{
            width: 100%;
            padding: 27px 15px 8px;
            box-sizing: border-box;
            border: none;
            display: block;
            z-index: 1;
            background-color: rgb(231, 231, 231);
            font-size: 18px;
        }
        .lb{
            position: absolute;
            z-index: 5;
            bottom: 18px;
            left: 10px;
            color: gray;
            transition: all .3s cubic-bezier(0.4, 0, 0.2, 1);
            pointer-events: none;
        }
        .inp:focus + .lb,
        .inp:not(:placeholder-shown) + .lb {
            bottom: 30px;
            left: 7px;
            font-size: 12px;
            color: gray;
        }
        .inp:focus {
            outline: 2px solid rgb(24, 6, 104);
            border-radius: 0px;
        }
        .eye-icon {
            cursor: pointer;
            position: absolute;
            bottom: 15px;
            right: 15px;
            font-size: 18px;
        }
        #loginSave{
            margin-top: 15px;
            margin-bottom: 20px;
            margin-right: 5px;
        }
        input, #loginSaveTxt{
            cursor: pointer;
        }
        input[type=checkbox]:checked {
            accent-color: rgb(24, 6, 104);
        }
        input[type=submit]{
            width: 100%;
            box-sizing: border-box;
            padding: 10px 15px;
            font-family: 'GongGothicMedium';
            border: 1px solid black;
            background-color: rgb(24, 6, 104);
            font-size: 18px;
            color: rgb(241, 217, 75);
            margin-top: 35px;
        }
        @media screen and (max-width: 1080px){
        	#wrap{
                padding: 5% 20%;
            }
        }
        @media screen and (max-width: 480px){
        	#wrap{
                padding: 5% 15%;
            }
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="resources/css/menu.css">
</head>
<body>
<!-- 로그인 실패 시 alert 출력 -->
    <c:if test="${param.error == 'true'}">
        <script>
            alert('로그인에 실패하셨습니다.');
        </script>
    </c:if>
    
	<jsp:include page="/WEB-INF/views/menu.jsp" />
    <div id="wrap">
        <div id="row1">
            <p id="pageTitle">관리자 로그인</p>
        </div>
        <div id="row2">
            <form action="<c:url value='/login' />" method="post">
                <div id="loginBox">
                    <div id="idBox">
                        <input type="text" class="inp" id="username" name="username" placeholder=" " >
                        <label for="username" class="lb">아이디</label>
                    </div>
                    <div id="pwBox">
                        <input type="password" class="inp" id="password" name="password" placeholder=" " >
                        <label for="password" class="lb">비밀번호</label>
                        <i class="bi bi-eye-slash eye-icon" onclick="togglePassword()"></i>
                    </div>
                </div>
                <!-- <input type="checkbox" id="loginSave" name="loginSave"><label for="loginSave" id="loginSaveTxt">로그인 정보 저장</label> -->
                <input type="submit" value="로그인">
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
</script>
</body>
</html>