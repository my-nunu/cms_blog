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
  <title>首页</title>
  <link rel="stylesheet" href="./static/bootstrap-3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="./static/css/layout.css">
  <link rel="stylesheet" href="./static/css/index.css">
  <link rel="stylesheet" type="text/css" href="./static/css/zxf_page.css">

  <script src="./static/js/jquery-3.4.1.min.js"></script>
  <script src="./static/bootstrap-3.3.7/js/bootstrap.min.js"></script>
  <script src="./static/echarts-2.2.7/echarts-all.js"></script>
<script type="text/javascript" src="./static/js/zxf_page.js"></script>
<script type="text/javascript" src="./static/js/main.js"></script>
 <link rel="stylesheet" href="./static/css/reset.css">
<link rel="stylesheet" href="./static/css/style.css">
<!-- <link rel="stylesheet" href="static/bootstrap-3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="static/css/layout.css">
  <link rel="stylesheet" href="static/css/index.css">
  <link rel="stylesheet" type="text/css" href="./static/css/zxf_page.css">
  <link rel="stylesheet" type="text/css" href="static/css/publish.css">
  <script src="static/js/jquery-3.4.1.min.js"></script>
  <script src="static/bootstrap-3.3.7/js/bootstrap.min.js"></script>
  <script src="static/echarts-2.2.7/echarts-all.js"></script>
<script type="text/javascript" src="static/js/publish.js"></script>
<script type="text/javascript" src="static/js/wangEditor.js"></script>
<script type="text/javascript" src="static/js/main.js"></script>
<script type="text/javascript" src="./static/js/zxf_page.js"></script>
 <link rel="stylesheet" href="static/css/reset.css">
<link rel="stylesheet" href="static/css/style.css">
<link rel="stylesheet" type="text/css" href="static/css/show.css"> -->
<script type="text/javascript">
	/*点击a标签去除默认事件  */
	$(function(){
		$(".showLeft a").on("click",function(event){
			hrefStr = this.getAttribute("href");
			console.log(hrefStr);
			event.preventDefault();
			$('.content').load(hrefStr);
		});
	$("#recommend").trigger("click");
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
          <span class="glyphicon glyphicon-folder-open" aria-hidden="true"></span>看点资讯
        </div>

        <div class="showLeft">
              <ul class="cd-accordion-menu animated">
          <li class="has-children">
            <input type="checkbox" name ="group-1" id="group-1" checked>
            <label for="group-1">首页</label>

            <ul>
              <li><a href="user/showrecommendArticles" id="recommend">热点资讯推荐</a></li>
            </ul>
          </li>

          <li class="has-children">
            <input type="checkbox" name ="group-4" id="group-4">
            <label for="group-4">资讯栏目</label>

            <ul>
            <!--遍历生成栏目列表  -->
			<c:forEach items="${categoryList }" var="entry" varStatus="i">
              <li class="has-children">
                <input type="checkbox" name ="sub-group-3" id="sub-group-${i.count }">
                <label for="sub-group-${i.count }">${entry.key.name }</label>
                <ul>
                <!-- 
                	 在show.jsp页面点击左侧导航栏
 					根据分类ID查找所有文章信息,要求传参栏目级别：mark（值为1或者2），栏目ID：categoryId
 					将数据显示在右侧数据显示区域showArticleList.jsp
                 -->
                	<c:forEach items="${entry.value}" var="two">
	                  <li><a href="user/showArticleList?categoryId=${two.id }&mark=2">${two.name }</a></li>
	                </c:forEach>
                	<c:if test="${entry.key.id != 0 }">
	                  <li><a href="user/showArticleList?categoryId=${entry.key.id }&mark=1">全部</a></li>
                	</c:if>
                	<c:if test="${entry.key.id == 0 }">
	                  <li><a href="user/showArticleList?categoryId=${entry.key.id }&mark=2">全部</a></li>
                	</c:if>
                </ul>
              </li>
            </c:forEach>
            </ul>
            
          </li>

          <li class="has-children">
            <input type="checkbox" name ="group-3" id="group-3">
            <label for="group-3">个人管理</label>

            <ul>
              <li><a href="user/showUserReleaseArticles">我的发布</a></li>
              <li><a href="user/showHistoryArticles">浏览记录</a></li>
              <li><a href="user/showUserLikeArticles">我的点赞</a></li>
              <li><a href="user/showUserCollectionArticles">我的收藏</a></li>
              <li><a href="user/showUserReportArticles">我的举报</a></li>
              <li><a href="user/showUserInformation">个人信息</a></li>
            </ul>
          </li>


        </ul>

    </div>
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
         
          
			<script type="text/javascript" src="./static/js/basic.js"></script>
         <!-- 内容end -->
        </div>

      </div>
    </div>
  </div>


</body>

</html>