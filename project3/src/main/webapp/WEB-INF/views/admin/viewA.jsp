<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신고 조회 | 관리자</title>
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
        #stateWrap{
            margin-top: 15px;
            font-size: 16px;
        }
        #state{
            border: none;
            font-family: 'GongGothicMedium';
            font-size: 16px;
        }
        table{
            border: 1px solid black;
            border-collapse: collapse;
            width: 100%;
        }
        td{
            border: 1px solid black;
            padding: 10px;
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
            justify-content: center;
        }
        .btn{
            padding: 10px 15px;
            font-family: 'GongGothicMedium';
            font-size: 15px;
            cursor: pointer;
            color: whitesmoke;
            /* border-radius: 10px; */
        }
        #confirm{
            border: 1px solid rgb(4, 80, 54);
            background-color: rgb(16, 124, 88);
        }
        #hold{
            border: 1px solid rgb(0, 26, 82);
            background-color: rgb(16, 50, 124);  
        }
        #delete{
            border: 1px solid rgb(80, 4, 4);
            background-color: rgb(124, 16, 16);   
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="../resources/css/menu.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/menu.jsp" />
    <div id="wrap">
        <div id="row1">
            <span id="pageTitle">신고 조회 | 관리자</span>            
			<span id="datetime">
			  <fmt:formatDate value="${createdDate}" pattern="yyyy-MM-dd HH:mm"/>
			</span>
        </div>
        <div id="row2">
        	<input type="hidden" name="id" value="${report.id}" />
            <div id="stateWrap">
        	    <span id="stateTxt">확인 상태: </span>
                <input type="text" name="state" id="state" value="${report.state}">
            </div>
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
                    <td>
				    	${report.si}
				    	<c:if test="${not empty report.gu and report.gu ne 'null'}"> ${report.gu}</c:if>
				  	</td>
                </tr>
                <tr>
                    <td class="infoT">상세 위치</td>
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
	        			
	        			<img src="/image/${uuid}" width="600" height="400" style="object-fit:cover; border:1px solid #ccc;" 
	         				onerror="this.style.display='none';" alt="${orig}" title="${orig}" />
	        			
	        			<a href="/download?uuid=${uuid}&name=${orig}">${orig}</a><br/>
      				</c:forEach>
                    </td>
                </tr>
            </table>
        </div>
        <div id="bottomBtn">
            <button class="btn" id="confirm">확인</button>
            <button class="btn" id="hold">보류</button>
            <form action="/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?')">
			  <input type="hidden" name="id" value="${report.id}" />
			  <button class="btn" id="delete">삭제</button>
			</form>
        </div>
    </div> 
<script>
$(document).ready(function(){
    // 기본 상태 설정
    //updateState('미확인');

    $('#confirm').on('click', function(){
        changeStateOnServer('확인완료');
    });

    $('#hold').on('click', function(){
        changeStateOnServer('확인필요');
    });

    function updateState(state){
        $('#state').val(state);
        let color = 'black';
        if(state === '확인완료') color = 'green';
        else if(state === '확인필요') color = 'blue';

        $('#state').css('color', color);
    }

    function changeStateOnServer(newState){
        const reportId = "${report.id}";  // 서버에서 렌더링된 id 값

        $.ajax({
            type: "POST", // 또는 PATCH, PUT 등
            url: "/updateState", // 서버에 만든 상태 변경 API 엔드포인트
            data: { id: reportId, state: newState },
            success: function(response){
                updateState(newState); // 화면에도 반영
            },
            error: function(){
                alert('상태 변경에 실패했습니다.');
            }
        });
    }
});
</script>
</body>
</html>