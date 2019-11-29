<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% 
	String basePath = request.getScheme()+"://"+
			request.getServerName()+":"+
			request.getServerPort()+
			request.getContextPath()+"/";
%>    
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>看点资讯精选</title>
  <link rel="stylesheet" href="./static/bootstrap-3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="./static/css/index.css">
  <script src="./static/js/jquery-3.4.1.min.js"></script>
  <script src="./static/bootstrap-3.3.7/js/bootstrap.min.js"></script>
  <script src="./static/echarts-2.2.7/echarts-all.js"></script>
  <script type="text/javascript" src="./static/js/main.js"></script>
 <link rel="stylesheet" href="./static/css/reset.css">
<link rel="stylesheet" href="./static/css/style.css">
  <link rel="stylesheet" href="./static/css/layout.css">
	<script type="text/javascript">
	/*点击a标签去除默认事件  */
	$(function(){
		$(".nav_left a").on("click",function(event){
			hrefStr = this.getAttribute("href");
			console.log(hrefStr);
			event.preventDefault();
			$('.content').load(hrefStr);
		});
	$(".nav_left a:first").trigger("click");
});
</script>
</head>
<body>
  <!-- 外部容器 -->
  <div class="container-layout">
    <div class="top_bar"></div>
    <div class="wrap">
      <!-- 左侧导航 -->
      <div class="nav_left">
        <!-- 标题 -->
        <div class="title">
          <span class="glyphicon glyphicon-folder-open" aria-hidden="true"></span>看点资讯精选后台
        </div>
         <ul class="cd-accordion-menu animated">
          <li class="has-children">
            <input type="checkbox" name ="group-3" id="group-3" checked>
            <label for="group-3">栏目管理</label>

            <ul>
              <li><a href="user/showUserReleaseArticles">我的发布</a></li>
              <li><a href="admin/showCategoryList">栏目管理</a></li>
              <li><a href="admin/showArticleAdmin?state=0">待审核</a></li>
              <li><a href="admin/showArticleAdmin?state=1">正常资讯</a></li>
              <li><a href="admin/showReportArticles">举报待处理</a></li>
              <li><a href="admin/showProcessedArticles">已处理列表</a></li>
            </ul>
          </li>


        </ul>

      </div>
      <!-- 右侧内容 -->
      <div class="content_right">
        <div class="top_bar">
          <!-- 用户信息 -->
          <div class="user_info">
            <img src="${loginUser.img }" alt="没有" id="portraitPic">
            <span>${loginUser.nickname }</span>
          </div>
          <div class="login">
              <a href="user/logout">退出</a>
          </div>
        </div>
        <!-- 内容 -->
        <div class="content">

        </div>
      </div>
    </div>
  </div>

</body>
</html>