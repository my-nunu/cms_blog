<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!--搜索start  -->
         <div class="search_bar">
              <span class="search_title">热点资讯推荐</span>
          </div>
			<!--展示阅读量最高的三篇资讯  -->
 			<div class="news_list">
	            <ul class="list-group">
		            <c:forEach items="${recommendArticles }" var="article">
		                <li class="list-group-item">
		                    <div class="media">
		                    <div class="media-left">
		                      <c:if test="${article.img != null }">
			                      <a href="#" class="media-object">
									<img src="${article.img }" alt="没图">
		                      	</a>
		                    </c:if>
		                    <c:if test="${article.video !=null }">
		                      <a href="#" class="media-object">
		                        <video src="${article.video}" width="320" height="240" controls="controls"></video>
		                      </a>
		                    </c:if>
		                    </div>
		                    <div class="media-body">
		                      <a class="media-heading title_news" href="user/showArticle?articleId=${article.id }" target="_blank">
		                      ${article.title }</a>
		                      <div class="media_content">${article.summary }</div>
		                      
		                      <div class="media_option">
		                        <div>阅读量:<b>${article.rea }</b></div>
		                        <div>点赞量:<b>${article.click }</b></div>
		                        <div>收藏量:<b>${article.collect }</b></div>
		                        <div>发布时间:<b>${article.dob }</b></div>
		
		                      </div>
		                    </div>
		
		                  </div>
		                </li>
		            </c:forEach>
	             </ul>
	       </div>
