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
    <title>신고 조회 | 파출소</title>
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
        #nowWrap{
            margin-top: 15px;
            margin-bottom: 50px;
            font-size: 18px;
        }
        #nowWrap input{
        	width: 150px;
        }
        #station, #state{
            border: none;
            font-family: 'GongGothicMedium';
            font-size: 18px;
        }
        table{
            border: 1px solid black;
            border-collapse: collapse;
            width: 100%;
        }
        td{
            border: 1px solid black;
            padding: 10px;
            word-break: keep-all; /* 단어 단위로 줄바꿈 */
            white-space: normal; /* 기본 줄바꿈 허용 */
            overflow-wrap: break-word; /* 긴 단어가 있으면 자동 줄바꿈 */
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
        .fileimg{
        	object-fit: cover;
        	border: 1px solid #ccc;
			width: 100%;
			height: auto;
        }
        .btn{
            padding: 10px 15px;
            font-family: 'GongGothicMedium';
            font-size: 15px;
            cursor: pointer;
            color: whitesmoke;
            /* border-radius: 10px; */
        }
        #move{
            border: 1px solid rgb(172, 75, 20);
            background-color: rgb(218, 125, 72);
        }
        #need_support{
            border: 1px solid rgb(72, 3, 78);
            background-color: rgb(115, 16, 124);  
        }
        #end{
            border: 1px solid black;
            background-color: black;   
        }
        @media screen and (max-width: 1080px){
        	#wrap{
                padding: 5% 15%;
            }
        }
        @media screen and (max-width: 480px){
		    #wrap{
                padding: 5% 10%;
            }
            #row1, #row1 span{
            	display:block;
            }
            #datetime{
            	margin-top: 10px; 
            }
		}
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="../resources/css/menu.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/menu.jsp" />
    <div id="wrap">
        <div id="row1">
            <span id="pageTitle">신고 조회 | 파출소</span>            
			<span id="datetime">
			  <fmt:formatDate value="${report.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
			</span>
        </div>
        <div id="row2">
        	<input type="hidden" name="id" value="${report.id}" />
        	<div id="nowWrap">
	            <div>
	        	    <span class="title">| 배정된 파출소: </span>
	                <input type="text" name="station" id="station" value="${report.station}" readonly>
	            </div>
	            <div>
	        	    <span class="title">| 진행 상태: </span>
	                <input type="text" name="state" id="state" value="${report.state}">
	            </div>
            </div>
            <p class="title">| 신고인 기본 정보</p>
            <table>
            	<tbody id="infoTable">
                <tr>
                    <td class="infoT">이름</td>
                    <td id="name">${report.name}</td>
                    <td class="infoT">전화번호</td>
                    <td id="phone">${report.phone}</td>
                </tr>
                <tr>
                	<td class="infoT">현재 위치</td>
                    <td colspan="3">${report.myLoc1}</td>
                </tr>
                <tr>
                	<td class="infoT">상세 주소</td>
                    <td colspan="3">${report.myLoc2}</td>
                </tr>
                </tbody>
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
                    <td class="infoT">신고할 위치</td>
                    <td>
                    <c:choose>
				        <c:when test="${not empty fn:trim(report.si) 
				                       and fn:trim(report.si) ne 'none' 
				                       and fn:trim(report.si) ne 'null'}">
				            <c:out value="${report.si}" />
				            <c:if test="${not empty fn:trim(report.gu) 
				                        and fn:trim(report.gu) ne 'none' 
				                        and fn:trim(report.gu) ne 'null'}">
				                &nbsp;<c:out value="${report.gu}" />
				            </c:if>
				        </c:when>
				        <c:otherwise>
				            현재 위치와 동일
				        </c:otherwise>
				    </c:choose>
				  	</td>
                </tr>
                <tr>
                    <td class="infoT">상세 주소</td>
				    <td>
				        <c:choose>
				            <c:when test="${not empty fn:trim(report.location) 
				                           and fn:trim(report.location) ne 'null'}">
				                <c:out value="${report.location}" />
				            </c:when>
				            <c:otherwise>
				                현재 위치와 동일
				            </c:otherwise>
				        </c:choose>
				    </td>
                </tr>
                <tr>
                    <td class="infoT">상세 내용</td>
                    <td>${report.content}</td>
                </tr>
                <tr>
                    <td class="infoT">첨부 파일</td>
                    <td>
                    <c:if test="${empty report.storedName or report.storedName eq 'undefined'}">
					        없음
					    </c:if>
					    <c:if test="${not empty report.storedName and report.storedName ne 'undefined'}">
					        <c:forEach var="uuid" items="${fn:split(report.storedName, ';')}" varStatus="i">
					            <c:set var="orig" value="${fn:split(report.origName, ';')[i.index]}" />
					            
					            <img class="fileimg" src="/image/${uuid}" 
					                onerror="this.style.display='none';" alt="${orig}" title="${orig}" />
					            
					            <a href="/download?uuid=${uuid}&name=${orig}">${orig}</a><br/>
					        </c:forEach>
					    </c:if>
                    </td>
                </tr>
            </table>
        </div>
        <div id="bottomBtn">
            <button class="btn" id="move">출동</button>
            <button class="btn" id="need_support">지원 요청</button>
            <button class="btn" id="end">상황 종료</button>
        </div>
    </div> 
<script>
document.addEventListener("DOMContentLoaded", function () {
	// 전화번호 형식
    const phoneElement = document.getElementById("phone");
    const phoneRaw = phoneElement.textContent.trim();
    if (phoneRaw.length === 11) {
        phoneElement.textContent = phoneRaw.slice(0, 3) + '-' + phoneRaw.slice(3, 7) + '-' + phoneRaw.slice(7);
    }
    
    const tableBody = document.getElementById("infoTable");
    const originalHTML = tableBody.innerHTML;  // 원래 구조 저장
    
    function restructureTable() {
        const tableBody = document.getElementById("infoTable");
        if (window.innerWidth <= 480) {
            if (tableBody.dataset.modified !== "true") {
                // 기존 셀에서 값을 가져와서 사용
                const name = document.getElementById("name").textContent.trim();
                const phone = phoneElement.textContent.trim();

                tableBody.innerHTML = `
                    <tr>
                        <td class="infoT">이름</td>
                        <td>\${name}</td>
                    </tr>
                    <tr>
                        <td class="infoT">전화번호</td>
                        <td>\${phone}</td>
                    </tr>
                `;
                tableBody.dataset.modified = "true";
            }
        } else {
            if (tableBody.dataset.modified === "true") {
                tableBody.innerHTML = originalHTML;
                tableBody.dataset.modified = "false";
            }
        }
    }

    restructureTable(); // 첫 로드 시 실행
    window.addEventListener("resize", restructureTable); // 화면 크기 변경 시 실행
});

$(document).ready(function(){
    // 기본 상태 설정
//    updateState('배정');

    $('#move').on('click', function(){
        changeStateOnServer('출동');
    });

    $('#need_support').on('click', function(){
        changeStateOnServer('지원 요청');
    });
    
    $('#end').on('click', function(){
        changeStateOnServer('상황 종료');
    });

    function updateState(state){
        $('#state').val(state);
        let color = 'green';
        if(state === '출동') color = 'orange';
        else if(state === '지원 요청') color = 'purple';
        else if(state === '지원 완료') color = 'blue';
        else if(state === '지원 완료') color = 'blue';
        else if(state === '상황 종료') color = 'gray';

        $('#state').css('color', color);
    }

    function changeStateOnServer(newState){
        const reportId = "${report.id}";  // 서버에서 렌더링된 id 값

        $.ajax({
            type: "POST", // 또는 PATCH, PUT 등
            url: "${pageContext.request.contextPath}/police/updateState", // 서버에 만든 상태 변경 API 엔드포인트
            data: { id: reportId, state: newState },
            success: function(response){
                updateState(newState); // 화면에도 반영
                alert('상태가 변경되었습니다.');
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