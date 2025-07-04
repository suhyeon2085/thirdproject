<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신고 조회</title>
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
        .btn{
            padding: 10px 15px;
            font-family: 'GongGothicMedium';
            border: 1px solid black;
            background-color: rgb(231, 231, 231);
            font-size: 15px;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
    <div id="wrap">
        <div id="row1">
            <p id="pageTitle">신고 조회</p>
        </div>
        <div id="row2">
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
            <a href=""><button class="btn">삭제</button></a>
        </div>
    </div>  
</body>
</html>