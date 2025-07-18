<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
	<header>
		<!-- 로고 클릭 시 이동 -->
		<sec:authorize access="hasRole('ROLE_ADMIN')">
		    <a href="${pageContext.request.contextPath}/admin/mainA"><img id="logo" src="/resources/img/crimelogo.png" alt="로고"></a>
		</sec:authorize>
		<sec:authorize access="!hasRole('ROLE_ADMIN')">
		    <a href="mainU"><img id="logo" src="/resources/img/crimelogo.png" alt="로고"></a>
		</sec:authorize>
        
        <!-- '범죄 예측' 메뉴 -->
		<sec:authorize access="hasRole('ROLE_ADMIN')">
		    <a class="txtmenu" href="${pageContext.request.contextPath}/admin/mainA">범죄 예측</a>
		</sec:authorize>
		<sec:authorize access="!hasRole('ROLE_ADMIN')">
		    <a class="txtmenu" href="mainU">범죄 예측</a>
		</sec:authorize>
		
		<!-- '범죄 신고' 메뉴 -->
        <sec:authorize access="!hasRole('ROLE_ADMIN') and !hasRole('ROLE_POLICE')">
		    <a class="txtmenu" href="receipt">범죄 신고</a>
		</sec:authorize>

        
        <!-- '신고 조회' 메뉴 -->
        <sec:authorize access="hasRole('ROLE_ADMIN')">
		    <a class="txtmenu" href="${pageContext.request.contextPath}/admin/listA">신고 조회</a>
		</sec:authorize>
		<sec:authorize access="hasRole('ROLE_POLICE')">
		    <a class="txtmenu" href="${pageContext.request.contextPath}/police/listP">신고 조회</a>
		</sec:authorize>
        
        <!-- 로그인하지 않은 경우 -->
	    <sec:authorize access="!isAuthenticated()">
	        <a href="login" id="admin">관리자</a>
	    </sec:authorize>
	
	    <!-- 로그인한 경우 -->
	    <sec:authorize access="isAuthenticated()">
	        <form action="${pageContext.request.contextPath}/logout" method="post" style="display:inline;">
	            <button type="submit" style="background:none; border:none; cursor:pointer; font-family: 'GongGothicMedium';" id="admin">로그아웃</button>
	        </form>
	    </sec:authorize>
	    
	    <!-- 햄버거 메뉴 아이콘 -->
        <div id="hamburger">
            &#9776; 
        </div>
    </header>