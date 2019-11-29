<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>展示</title>
  <link rel="stylesheet" href="../static/bootstrap-3.3.7/css/bootstrap.min.css">

  <script src="../static/js/jquery-3.4.1.min.js"></script>
  <script src="../static/bootstrap-3.3.7/js/bootstrap.min.js"></script>
  <script src="../static/echarts-2.2.7/echarts-all.js"></script>
<script type="text/javascript" src="../static/js/wangEditor.js"></script>
<script type="text/javascript" src="../static/js/main.js"></script>
<script type="text/javascript" src="../static/js/detail.js"></script>
<link rel="stylesheet" type="text/css" href="../static/css/detail.css">
 <link rel="stylesheet" href="../static/css/forum.css">
    <link rel="stylesheet" href="../static/css/common.css">
<script type="text/javascript">
	$(function(){
		//点赞
		$('.content_box #dz').on("click",function(){
			var islike = $("input[name=islike]").val();
			$.get("/user/likeArticle?articleId=${showArticle.id}&likeState="+islike,
			function(data){
				console.log(data);
				if(data == '1'){//以前没有点赞，现在点赞了
					$("#dz").attr("style","color:red")
					$("#likeNum").text(Number($("#likeNum").text())+1);
					$("input[name=islike]").val(1);
				}else{//以前点赞，现在取消点赞了
					$("#dz").removeAttr("style");
					$("#likeNum").text(Number($("#likeNum").text())-1);
					$("input[name=islike]").val(2);
				}
				//改为js操作图片转换与数量+-
				//location.reload(true);
			},"text");
		});
		
		// 收藏
		$('.content_box #sc').on("click",function(){
			var isCollection = $("input[name=isCollection]").val();
			$.get("/user/collectionArticle?articleId=${showArticle.id}&collectionState="+isCollection,
				function(data){
					if(data == '1'){//以前没有收藏，现在点收藏
						console.log("收藏成功");
						$("#sc").attr("style","color:red")
						$("#collNum").text(Number($("#collNum").text())+1);
						$("input[name=isCollection]").val(1);
					}else{//以前收藏，现在取消收藏
						console.log("取消收藏成功");
						$("#sc").removeAttr("style")
						$("#collNum").text(Number($("#collNum").text())-1);
						$("input[name=isCollection]").val(2);
					}
					/* location.reload(true); */
				},"text");
		});
		
		//举报
		$('#reportYes').click(function(){
			var reportType = $(".bs-example-modal-report input[name='reportType']:checked").val();
			var reportContent = $(".bs-example-modal-report textarea").val();
			var articleId = ${showArticle.id};
			console.log(reportType);
			console.log(reportContent);
			$.post("/user/reportArticle",
				{"articleid":articleId,
				"type":reportType,
				"reportcontent":reportContent
				},function(data){
					alert("举报成功");
					location.reload(true);
				}
			); 
		});
		
	});
</script>
</head>
<body>
  <!-- 外部容器 -->
  <div class="container-layout">
      <!-- 右侧内容 -->

        <!-- 内容 -->
        <div class="content_box">
          
          <h2 style="margin-bottom: 1em;margin-top: 1em;border-bottom: 1px solid #ccc;">看点咨询详情 / 正文</h2>
          <!-- 搜索end -->
          <h4 class="title_big">${showArticle.title }</h4>

          <div class="new_header">
                <div class="new_header">
                   <div>作者：<b>${showArticle.author }</b></div>&nbsp;&nbsp;&nbsp;&nbsp;
                  <div>发表时间：<b>${showArticle.dob }</b></div>
                </div>

               <div class="new_header">
               	<c:choose>
						<c:when test="${isLike != 1 }">
		                  <div id="dz">
						</c:when>
						<c:otherwise>
						  <div style="color:red" id="dz">
						</c:otherwise>
				</c:choose>
                  	<span class="glyphicon glyphicon-thumbs-up"></span>
                  	点赞<b id="likeNum">${showArticle.click }</b>
                  </div>&nbsp;&nbsp;&nbsp;&nbsp;
                 <input type="hidden" name="islike" value="${isLike }">
                  
                  
             	<c:choose>
					<c:when test="${isCollection !=1}">
	                  <div id="sc">
					</c:when>
					<c:otherwise>
					  <div style="color:red" id="sc">
					</c:otherwise>
				</c:choose> 
                  <span class="glyphicon glyphicon-star"></span>
                   	收藏<b id="collNum">${showArticle.collect }</b>
                  </div>&nbsp;&nbsp;&nbsp;&nbsp;
                  
                  <input type="hidden" name="isCollection" value="${isCollection }">
                  
                  <c:choose>
						<c:when test="${isReport == 0 }">
		                  <div data-toggle="modal" data-target=".bs-example-modal-report">
		                  <span class="glyphicon glyphicon-phone-alt"></span>
		                  	举报
		                  </div>
		                 </c:when>
		                 <c:otherwise>
		                 	<span style="color:red">已举报</span>
		                 </c:otherwise>
		           </c:choose>
              </div>
          </div>
          <div class="container_img_slide">
          <!--  下侧内容展示 -->
          </div>
           <div class="new_content">
                      <span class="creater_from">原创</span>
                      ${showArticle.content }
                 <!--视频  -->
				<c:if test="${showArticle.video != null }">
					<video src="${showArticle.video }" controls="controls"  id="v1">
					</video>
				</c:if>
          </div>

        </div>
        </div>


    </div>
  </div>
  <!--举报模态框  -->
<div class="modal fade bs-example-modal-report" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">不良信息举报</h4>
      </div>
      <div class="modal-body report_model_body">
          <div class="report_content">
            <div class="report_title_left">举报内容</div>
            <div class="report_content_right">
            	${showArticle.title }
            </div>
          </div>
          <div class="report_reason">
          <div class="report_title_left">举报原因</div>
            <div class="report_content_right">
                <label>侵权&nbsp;<input type="radio" name="reportType" value="侵权"></label>&nbsp;&nbsp;
               <label>抄袭&nbsp;<input type="radio" name="reportType" value="抄袭"></label>&nbsp;&nbsp;
                <label>非法&nbsp;<input type="radio" name="reportType" value="非法"></label>&nbsp;&nbsp;
                 <label>色情&nbsp;<input type="radio" name="reportType" value="色情"></label>&nbsp;&nbsp;
               <label>政治&nbsp;<input type="radio" name="reportType" value="政治"></label>&nbsp;&nbsp;
                <label>辱骂&nbsp;<input type="radio" name="reportType" value="辱骂"></label>&nbsp;&nbsp;
                <label>其他&nbsp;<input type="radio" name="reportType" value="其他" checked="checked"></label>&nbsp;&nbsp;
            </div>
          </div>
        <div class="report_reason_add">
        <div class="report_title_left">原因补充</div>
            <div class="report_content_right">
            <textarea class="text_reason_add" placeholder="请输入举报理由" id="TextareaBtn"></textarea>
            </div>
        </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" id="reportYes">举报</button>
      </div>
    </div><!-- /.modal-content -->
  </div>
  </div>

<script type="text/javascript" src="../static/js/jquery-3.4.1.min.js"></script>
<script type="text/javascript" src="../static/js/jquery.flexText.js"></script>
<!--textarea高度自适应-->
<script type="text/javascript">
    $(function () {
        $('.content').flexText();
    });
</script>
<!--textarea限制字数-->
<script type="text/javascript">
    function keyUP(t){
        var len = $(t).val().length;
        if(len > 139){
            $(t).val($(t).val().substring(0,140));
        }
    }
</script>
<!--点赞-->
<!-- <script type="text/javascript">
    $('.comment-show').on('click','.date-dz-z',function(){
        var zNum = $(this).find('.z-num').html();
        if($(this).is('.date-dz-z-click')){
            zNum--;
            $(this).removeClass('date-dz-z-click red');
            $(this).find('.z-num').html(zNum);
            $(this).find('.date-dz-z-click-red').removeClass('red');
        }else {
            zNum++;
            $(this).addClass('date-dz-z-click');
            $(this).find('.z-num').html(zNum);
            $(this).find('.date-dz-z-click-red').addClass('red');
        }
    })
</script> -->
</body>

</html>