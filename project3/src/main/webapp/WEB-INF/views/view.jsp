<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
        #state{
            border: none;
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
            
<span id="datetime">
  <fmt:formatDate value="${createdDate}" pattern="yyyy-MM-dd HH:mm"/>
</span>

        </div>
        <div id="row2">
        	<input type="hidden" name="id" value="${report.id}" />
        	<span id="stateTxt">확인 상태: </span><input type="text" name="state" id="state" value="">
            <p class="title">| 신고인 기본 정보</p>
            <table>
                <tr>
                    <td class="infoT">이름</td>
                    <td>${report.name}</td>
                    <td class="infoT">전화번호</td>
                    <td>${report.phone}</td>
                </tr>
            </table>
        </div>
        <div id="row3">
            <p class="title">| 신고 내용</p>
            <table>
                <tr>
                    <td class="infoT">범죄 유형</td>
                    <td>${report.crimeType}</td>
                </tr>
                <tr>
                    <td class="infoT">위치</td>
                    <td>${report.location}</td>
                </tr>
                <tr>
                    <td class="infoT">상세 내용</td>
                    <td>${report.content}</td>
                </tr>
                <tr>
                    <td class="infoT">첨부 파일</td>
                    <td>
                    <c:forEach var="uuid" items="${fn:split(report.storedName, ';')}" varStatus="i">
        <c:set var="orig" value="${fn:split(report.origName, ';')[i.index]}" />
        <a href="/download?uuid=${uuid}&name=${orig}">${orig}</a><br/>
      </c:forEach>
                    </td>
                </tr>
            </table>
        </div>
        <div id="bottomBtn">
            <a href="modify"><button class="btn">수정</button></a>
            <form action="/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?')">
  <input type="hidden" name="id" value="${report.id}" />
  <button class="btn">삭제</button>
</form>
        </div>
    </div> 
</body>
</html>