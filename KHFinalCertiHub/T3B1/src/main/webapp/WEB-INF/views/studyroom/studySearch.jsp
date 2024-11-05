<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>서티허브 - 스터디 그룹</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/static/css/studyroom/studySearch.css">
    <script src="${pageContext.request.contextPath}/resources/static/js/studyroom/studySearch.js"></script>
    <script src="${pageContext.request.contextPath}/resources/static/js/common/common.js"></script>
</head>
<body>
    <%@ include file="../common/header.jsp" %>

    <div class="wrapper padding">
        <div class="page-title font-size-title">스터디 그룹</div>
        <form class="search-section" onsubmit="return false;">
            <div class="search-form">
                <input type="text">
                <button class="rounded-circle" onclick="alert('클릭됨')">
                    <img src="<%=contextPath%>/resources/static/img/button/search_icon.png">
                </button> 
            </div>
        </form>

        <div class="board-title">
            <div class="page-title font-size-subtitle">
                스터디 그룹 모집&현황
            </div>
            <div class="search-option">
                <div class="custom-select"></div>
            </div>
        </div>

        <div class="board-content">
        </div>

        <div class="board-option">
            <button type="submit" class="btn btn-primary">
                <img src="${pageContext.request.contextPath}/resources/static/img/button/pencil_icon.png">
                글쓰기
            </button>
            <div class="pagination">
                <span class="page-arrow">&lt;</span>
                <span class="page-num">1</span>
                <span class="page-num active">2</span>
                <span class="page-num">3</span>
                <span class="page-num">4</span>
                <span class="page-num">5</span>
                <span class="page-arrow">&gt;</span>
            </div>
        </div>

    </div>

    <%@ include file="../common/footer.jsp" %>
</body>
</html>