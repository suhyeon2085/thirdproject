<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신고 조회</title>
    <style>
        #wrap{
            padding: 5% 20%;
        }
        #row1{
            border-bottom: 1px solid black;
            padding-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: end;
        }
        #pageTitle{
            font-size: 25px;
        }
        .title{
            font-size: 18px;
        }
        #row2, #row3{
            margin-bottom: 50px;
        }
        table{
            border: 1px solid black;
            border-collapse: collapse;
            width: 100%;
        }
        td{
            border: 1px solid black;
        }
        .infoT{
            background-color: rgb(231, 231, 231);
            padding: 10px;
            box-sizing: border-box;
            text-align: center;
            width: 10%;
        }
        #bottomBtn{
        	display: flex;
        	gap: 5px;
        }
        .btn{
            padding: 10px 15px;
            font-family: 'GongGothicMedium';
            border: 1px solid black;
            background-color: rgb(231, 231, 231);
            font-size: 15px;
            cursor: pointer;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="resources/css/menu.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/menu.jsp" />
    <div id="wrap">
        <div id="row1">
            <span id="pageTitle">신고 조회</span>
            <span id="datetime">날짜</span><!-- 임시 -->
            <!--<span id="datetime"><fmt:formatDate value="" pattern="yyyy-MM-dd hh:mm"/></span> 백엔드에서 값이 넘어와야 사용 가능! -->
        </div>
        <div id="row2">
        	<input type="text" name="id" value=""> <!-- 값 확인 후 hidden으로 바꿀 예정 -->
            <p class="title">| 신고인 기본 정보</p>
            <table>
                <tr>
                    <td class="infoT">이름</td>
                    <td></td>
                    <td class="infoT">전화번호</td>
                    <td></td>
                </tr>
            </table>
        </div>
        <div id="row3">
            <p class="title">| 신고 내용</p>
            <table>
                <tr>
                    <td class="infoT">범죄 유형</td>
                    <td></td>
                </tr>
                <tr>
                    <td class="infoT">위치</td>
                    <td></td>
                </tr>
                <tr>
                    <td class="infoT">상세 내용</td>
                    <td></td>
                </tr>
                <tr>
                    <td class="infoT">첨부 파일</td>
                    <td></td>
                </tr>
            </table>
        </div>
        <div id="bottomBtn">
            <a href=""><button class="btn">수정</button></a>
            <form action="" method="post" onsubmit="return confirm('정말 취소하시겠습니까?')">
            	<input type="hidden" name="id" value="" />
            	<button class="btn">삭제</button>
            </form>
        </div>
    </div> 
</body>
</html>