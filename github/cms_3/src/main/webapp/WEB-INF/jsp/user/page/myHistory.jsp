<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
  <link rel="stylesheet" type="text/css" href="static/css/publish.css">
  <!-- 
<script type="text/javascript" src="static/js/publish.js"></script>
<script type="text/javascript" src="static/js/wangEditor.js"></script> -->
	<div class="search_bar">
      <span class="search_title">浏览记录</span>&nbsp;&nbsp;
    </div>
          <!-- 搜索end -->
          <div class="news_list">
           <table class="tbl">
            <thead>
              <tr>
				<th>资讯题目</th>
				<th>作者</th>
				<th>所属栏目</th>
				<th>发布时间</th>
				<th>背景音乐</th>
				<th>阅读量</th>
				<th>点赞量</th>
				<th>收藏量</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${historyArticles }" var="article">
					<tr>
						<td><a style="color:gray" href="user/showArticle?articleId=${article.id }" target="_blank">${article.title }</a></td>
						<td>${article.author }</td>
						<td>${article.categoryname }</td>
						<td><fmt:formatDate value="${article.dob }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td>${article.music == null?"无":fn:substring(article.music,23,-1) }</td>
						<td>${article.rea }</td>
						<td>${article.click }</td>
						<td>${article.collect }</td>
					</tr>
			 </c:forEach>
            </tbody>
          </table>
     </div>