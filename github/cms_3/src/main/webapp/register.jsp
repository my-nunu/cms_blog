<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>登录</title>
  <link rel="stylesheet" href="./static/bootstrap-3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="./static/css/login.css">
  <link rel="stylesheet" href="./static/css/index.css">
  <script src="./static/js/jquery-3.4.1.min.js"></script>
  <script src="./static/bootstrap-3.3.7/js/bootstrap.min.js"></script>
 <!--  <script src="./static/echarts-2.2.7/echarts-all.js"></script> -->
 <link rel="stylesheet" type="text/css" href="./static/css/login.css">
 <link rel="stylesheet" type="text/css" href="./static/icon/iconfont.css">
 <script type="text/javascript">
		$(function(){
			$("#regBtn").on("click",function(event){
				event.preventDefault();
				//账号
				var account = $("#f2 input[name=account]").val();
				var password = $("#f2 input[name=password]").val();
				var rePassword = $("#f2 input[name=rePassword]").val();
				console.log(account+"--"+password+"--"+rePassword);
				if(!account || !password || password != rePassword){
					alert("用户名密码未输入或不一致，请重新输入");
				}else{
					$.post("findUserByAccount",{
						"account":account,
					},function(data){
						if(data=="ok"){
							$("#f2").submit();
						}else{
							alert("用户名重复请重新输入");
						}
					});
				}
			});
		})
	</script>
</head>
<body>

  <div class="login_container">
      <div class="login_content">
          <div class="tabs_title">
            <h1>
            <!-- <span >登录</span>
            <span class="active-title">注册</span> -->
            <a href="login">登录</a>
            <a href="register" class="active-title">注册</a>
            </h1>
          </div>
          <div class="signin">
            <form action="register" method="post" id="f2">
              <div class="form-group">
                <label for="signinInputName">账号: </label>
                <input type="text" class="form-control"
                name="account" id="signinInputName" placeholder="请输入账号">
              </div>
              <div class="form-group">
                <label for="signinInputPassword">密码: </label>
                <input type="password" class="form-control"
                name="password" id="signinInputPassword" placeholder="请输入密码">
              </div>
              <div class="form-group">
                <label for="signinInputPassword">确认密码: </label>
                <input type="password" class="form-control"
                name="rePassword" id="signinInputPassword" placeholder="请输入密码">
              </div>
              <div class="forget">
                  <!-- <label>
                   <input type="checkbox" checked="checked" class="auto-cbx" id="auto-signin">七天内自动登录
                  </label>

                  <a href="/user/newforgot" class="rlf-forget r" target="_blank" hidefocus="true">找回密码</a> -->
              </div>
              <div class="Access"><a href="register" id="regBtn">确定</a></div>
            </form>
            </div>

           <!--  第三种方式 -->
           <div class="third_content">
      <div>
         <!--  <img src="./static/images/QQ.png" alt="">
          <img src="./static/images/weibo.png" alt="">
          <img src="./static/images/weixin.png" alt=""> -->
         <a class="icon_font" href="${baiduAuthUrl }"> <span class="iconfont icon-baidu1"></span></a>
          <a class="icon_font" href="//www.imooc.com/help/detail/127"><span class="iconfont icon-weibo"></span></a>
          <a class="icon_font" href="//www.imooc.com/help/detail/127"> <span class="iconfont icon-qq"></span></a>
          <a class="icon_font" href="//www.imooc.com/help/detail/127"> <span class="iconfont icon-weixin"></span></a>
        </div>
           </div>
      </div>


  </div>

</body>
</html>
