<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" type="text/css" href="static/css/person.css">
<script type="text/javascript">
	$(function(){
		$("#portrait").on("change",function(){
		    $("#filenameImg").html(this.files[0].name);
		    var imgFile = this.files[0];
		    var fr = new FileReader();
		    fr.onload = function() {
		        document.getElementById('portraitImage').src = fr.result;
		    };
		    fr.readAsDataURL(imgFile);
		});
		//确定提交修改
		$("#upsub").on("click",function(){
			var formData = new FormData();
			var account = $("input[name=account]").val();
			var nickname = $("input[name=nickname]").val();
			var password = $("input[name=password]").val();
			var picfile = $("input[name=picfile]")[0].files[0]; //获得文件上传的输入框的文件流
			formData.append('account',account);
			formData.append('nickname',nickname);
			formData.append('password',password);
			formData.append('picfile',picfile);
			$.ajax({
	    		async:false,
	    		url:"user/updateUserMessage",
	    		type:'POST',
	    		//不处理参数数据
	    		processData : false,
	    		//不设置，避免 JQuery操作影响服务器正常解析文件
	    		contentType : false,
	    		data:formData,
	    		dataType:"text",
	    		success:function(data){
	    			console.log(data);
	    			alert("修改成功");
	    			/* $("h2 a:last").trigger("click"); */
	    			var picSrc = $("#portraitPic").attr("src")+"?"+Math.random();
	    			console.log(picSrc);
	    			$("#portraitPic").attr("src",picSrc);

	    			$('.content').load(hrefStr);
					$(".fade").prop("class","fade in");
	    			
	    		}
	    	});
		});
	});
</script>
		<div class="search_bar">
              <span class="search_title">修改个人信息</span>&nbsp;&nbsp;
          </div>
          <!-- 搜索end -->
          <div class="news_list">
            <div class="login_container">
      			<div class="login_content">

	          <div class="signin">
	            <form>
	              <div class="form-group">
	                <label for="signinInputName">登录账号: </label>
	                <c:choose>
						<c:when test="${loginUser.account == null }">
			                <input name="account" type="text" class="form-control person_input"
			                id="signinInputName" placeholder="请设置初始登录账号名">
						</c:when>
						<c:otherwise>
			                <input name="account" type="text" class="form-control person_input"
			                id="signinInputName" value="${loginUser.account }" readonly="readonly">
						</c:otherwise>
					</c:choose>
	              </div>
	              <div class="form-group">
	                <label for="signinInputPassword">昵称: </label>
	                <input type="text" class="form-control person_input"
	                name="nickname" value="${loginUser.nickname }" id="signinInputPassword" placeholder="请输入密码">
	              </div>
	              <div class="form-group">
	                <label for="signinInputPassword ">新密码: </label>
	                <c:choose>
						<c:when test="${loginUser.password == null }">
			                <input name="password" type="password" class="form-control person_input"
			                id="signinInputPassword" placeholder="请设置初始密码">
						</c:when>
						<c:otherwise>
							<input name="password" type="password" class="form-control person_input"
			                id="signinInputPassword" placeholder="*****">
						</c:otherwise>
					</c:choose>
	              </div>
       	<div class="form-group">
       <!-- <label for="inputPassword3" class="col-sm-1 control-label">头像</label>
      <div class="col-sm-11">
       <div class="file-container" style="display:inline-block;position:relative;overflow: hidden;vertical-align:middle">
          <button class="btn btn-success fileinput-button" type="button">上传封面</button>
          <input name="titlePage" type="file" id="jobData" onchange="loadFileimg(this.files[0])" style="position:absolute;top:0;left:0;font-size:34px; opacity:0" accept=".png,.jpeg,.jpg,.gif">
      </div>
      <span id="filenameImg" style="vertical-align: middle">未上传文件</span>
      </div>
    </div> -->
		        <div class="form-group">
<!--                 <label for="signinInputPassword" class="col-sm-1 control-label">头像: </label>
 -->                <div class="imgContainer">
                    <div class="file-container" style="display:inline-block;position:relative;overflow: hidden;vertical-align:middle">
			          <button class="btn btn-success fileinput-button" id="upBtn" type="button">上传头像</button>
			          <input name="picfile" type="file" id="portrait" style="position:absolute;top:0;left:0;font-size:34px; opacity:0" accept=".png,.jpeg,.jpg,.gif">
      				</div>
      				<span id="filenameImg" style="vertical-align: middle">未上传文件</span>
                     <div class="radius_img"><img id="portraitImage" src="${loginUser.img }"></div>
                </div>

              </div>
		              <div class="Access" id="upsub">确定</div>
		            </form>
		            </div>
	      		</div>
			</div>
		</div>
