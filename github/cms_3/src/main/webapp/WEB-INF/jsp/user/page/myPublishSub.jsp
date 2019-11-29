<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
  <link rel="stylesheet" type="text/css" href="static/css/publish.css">
<script type="text/javascript" src="static/js/publish.js"></script>
<script type="text/javascript" src="static/js/wangEditor.js"></script>
<script type="text/javascript">
	$(function(){
			var E = window.wangEditor;
		    var editor = new E('#edit_tool');
			//创建编辑器
		    editor.customConfig.uploadImgServer = 'user/editorUploadImage';
	   		editor.customConfig.uploadFileName = 'file';
		    editor.create();
			//发布图文资讯
			$("#btn1").on("click",function(){
				console.log("内容:"+editor.txt.text().substr(0,55));
				var formData = new FormData();
				var title = $(".bs-example-modal-lg input[name=title]").val();
				var categoryId = $(".bs-example-modal-lg select[name=category]").val();
				var music = $('.bs-example-modal-lg input[name=music]')[0].files[0]; //获得文件上传的输入框的文件流
				var video = $('.bs-example-modal-lg input[name=video]')[0].files[0]; //获得文件上传的输入框的文件流
				var titlePage1 = $('.bs-example-modal-lg input[name=titlePage]')[0].files[0]; //获得文件上传的输入框的文件流
				formData.append('title',title);
				formData.append('categoryidname',categoryId);
				formData.append('content',editor.txt.html());
				formData.append('summary',editor.txt.text().substr(0,300));
				formData.append('musicFile',music);
				formData.append('videoFile',video);
				formData.append('titlePageFile',titlePage1);
				$.ajax({
		    		async:false,
		    		url:"user/userReleaseArticles",
		    		type:'POST',
		    		//不处理参数数据
		    		processData : false,
		    		//不设置，避免 JQuery操作影响服务器正常解析文件
		    		contentType : false,
		    		data:formData,
		    		dataType:"text",
		    		success:function(data){
		    			console.log(data);
		    			alert("发布成功");
		    			$('.content').load(hrefStr);
						$(".fade").prop("class","fade in");
		    		}
		    	});
			});
			
			//发布视频资讯 
			$("#btn2").on("click",function(){
				var formData = new FormData();
				var title = $(".bs-example-modal-video input[name=title]").val();
				var categoryId = $(".bs-example-modal-video select[name=category]").val();
				var video = $(".bs-example-modal-video input[name=video]")[0].files[0]; //获得文件上传的输入框的文件流
				formData.append('type',1);
				formData.append('title',title);
				formData.append('categoryidname',categoryId);
				formData.append('videoFile',video);
				$.ajax({
		    		async:false,
		    		url:"user/userReleaseArticles",
		    		type:'POST',
		    		//不处理参数数据
		    		processData : false,
		    		//不设置，避免 JQuery操作影响服务器正常解析文件
		    		contentType : false,
		    		data:formData,
		    		dataType:"text",
		    		success:function(data){
		    			alert("发布成功");
		    			$('.content').load(hrefStr);
		    		}
		    	});
			});
			$('.updateArticle').on("click",function(){
				var articleName = $(this).closest("tr").find("td:eq(1)").text();
				var articleId = $(this).attr("articleId");
				var categoryId = $(this).attr("categoryId");
				$(".bs-example-modal-edit input[name=articleName]").val(articleName);
				$(".bs-example-modal-edit option[value="+categoryId+"]").prop("selected","selected");
				$(".bs-example-modal-edit input[name=articleId]").val(articleId);
		});
		//修改框确定后的处理：
		$("#btn3").on("click",function(event){
			var articleId = $("input[name=articleId]").val();
			var categoryId = $(".bs-example-modal-edit select[name=categoryId]").val();
			console.log("articleId:"+articleId+",categoryId:"+categoryId);
			$.post("user/updateArticleServlet",
					{"articleId":articleId,
					 "categoryidname":categoryId
					},function(data){
						alert("修改成功");
						$('.content').load(hrefStr);
					});
		});
		//点击删除
		$('.deleteDel').on("click",function(){
			articleId = $(this).closest("tr").find("td:eq(0) input").val();;
		});
		//点击批量删除
		$("#batchDeleteDel").on("click",function(){
			articleId = $('table input[name=articleId]:checked').map(function(index,item) {
			      			return this.value;
			      		}).get().join(",");
		});
		//确认删除
		$('.deleteYesDel').click(function(){
			console.log("articleId："+articleId);
			if(articleId){
				$.post("user/deleteArticle",
						{"articleIds":articleId},
						function(data){
							console.log(data);
							alert("删除成功");
							$('.content').load(hrefStr);
						});
			}
		});	
		
	});
</script>
          <div class="search_bar">

              <span class="search_title">我的发布</span>&nbsp;&nbsp;
              <button id="batchDeleteDel" type="button" class="btn btn-danger  btn-sm" data-toggle="modal" data-target=".bs-example-modal-s2">批量删除</button>&nbsp;&nbsp;

              <button type="button" class="btn btn-success btn-md" data-toggle="modal" data-target=".bs-example-modal-lg">
                  <span class="glyphicon glyphicon-file" aria-hidden="true"></span> 发布图文
              </button>&nbsp;&nbsp;

                 <!--  发布文章model -->
              <button type="button" class="btn btn-success btn-md" data-toggle="modal" data-target=".bs-example-modal-video">
                  <span class="glyphicon glyphicon-film" aria-hidden="true"></span> 发布视频
              </button>

          </div>
          <!-- 搜索end -->
          <div class="news_list">
                <table class="tbl">
            <thead>
              <tr>
                <th width="50px">选择</th>
                <th width="200px">标题</th>
                <th width="200px">栏目</th>
                <th>发布时间</th>
                <th>背景音乐</th>
                <th>阅读量</th>
                <th>点赞量</th>
                <th>收藏量</th>
                <th>状态</th>
                <th width="160px">操作</th>
              </tr>
            </thead>
            <tbody>
            <c:forEach items="${myArticles }" var="article">
            	<tr>
            		<td><input type="checkbox" value="${article.id }" name="articleId" ${article.state != 4 ?'':"disabled='disabled'" }></td>
					<td><a style="color:gray" href="user/showArticle?articleId=${article.id }" target="_blank">${article.title }</a></td>
					<td>${article.categoryname }</td>
					<td>${article.dob }</td>
					<td>${article.music == null?"无":fn:substring(article.music,23,-1) }</td>
					<td>${article.rea }</td>
					<td>${article.click }</td>
					<td>${article.collect }</td>
	                <td>
	                	<c:choose>
								<c:when test="${article.state == 0}">
									未审核
								</c:when>
								<c:when test="${article.state == 1}">
									正常
								</c:when>
								<c:when test="${article.state == 2}">
									<span class="readed tag_read">审核不通过</span>
								</c:when>
								<c:when test="${article.state == 3}">
									<span class="reading tag_read">举报审核不通过</span>
								</c:when>
							</c:choose>
	                </td>
	                <td class="optior">
	                  <span title="修改" articleId="${article.id }" categoryId="${article.categoryid }" class="updateArticle glyphicon glyphicon-edit edit_icon" aria-hidden="true" data-toggle="modal" data-target=".bs-example-modal-edit"></span>
	                  <span title="删除"  articleId="${article.id }"  class="deleteDel glyphicon glyphicon-trash del_icon" aria-hidden="true" data-toggle="modal" data-target=".bs-example-modal-del"></span>&nbsp;&nbsp;
	                </td>
              </tr>
             </c:forEach>
            </tbody>
          </table>
           </div>		
    
     <!-- 修改 -->
<div class="modal fade bs-example-modal-edit" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">修改资讯信息</h4>
      </div>
      <div class="modal-body">

       <form class="form-horizontal">
                    <div class="form-group">
                      <label for="inputEmail3" class="col-sm-1 control-label">标题</label>
                      <div class="col-sm-11">
                        <input type="text" class="form-control title_input" id="inputEmail3" 
                        name="articleName" readonly="readonly">
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-1 control-label">栏目</label>
                      <div class="col-sm-11">
                         <select class="form-control select_label" name="categoryId">
                       <!--遍历生成栏目列表  -->
							<c:forEach items="${categoryList }" var="category">
								<c:choose>
									<c:when test="${category.key.id != 0}">
										<optgroup label="${category.key.name }">
											<c:forEach items="${category.value }" var="subCategory">
												<option value="${subCategory.id }-${subCategory.name }">${subCategory.name }</option>
											</c:forEach>
										</optgroup>
									</c:when>
									<c:otherwise>
										<option value="${category.key.id }-${category.key.name }">${category.key.name }</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
                         </select>
                      </div>
                    </div>
                  </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        <button id="btn3" type="button" class="btn btn-primary" data-dismiss="modal">确定</button>
      </div>
    </div><!-- /.modal-content -->
  </div>
  </div>
  <!-- 批量删除model -->
  <div class="modal fade bs-example-modal-s2" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
        <div class="modal-body">确定删除吗？</div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
          <button type="button" class="deleteYesDel btn btn-primary" data-dismiss="modal">确定</button>
        </div>
      </div>
      </div>
    </div>
<!-- 删除model -->
<div class="modal fade bs-example-modal-del" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
    <div class="modal-body">确定删除吗？</div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        <button type="button" class="deleteYesDel btn btn-primary" data-dismiss="modal">确定</button>
      </div>
    </div>

  </div>
</div>
<!-- 发布视频 -->
<div class="modal fade bs-example-modal-video" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
      <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="gridSystemModalLabel">发布视频</h4>
          </div>
          <div class="modal-body">
        <form class="form-horizontal">
          <div class="form-group">
            <label for="inputEmail3" class="col-sm-1 control-label">标题</label>
            <div class="col-sm-11">
              <input type="text" name="title"  class="form-control title_input" id="inputEmail3" placeholder="请输入资讯标题">
            </div>
          </div>
          <div class="form-group">
            <label for="inputPassword3" class="col-sm-1 control-label">栏目</label>
            <div class="col-sm-11">
               <select class="form-control select_label" name="category">
              <!--遍历生成栏目列表  -->
                 <c:forEach items="${categoryList }" var="category">
					<c:choose>
						<c:when test="${category.key.id != 0}">
							<optgroup label="${category.key.name }">
								<c:forEach items="${category.value }" var="subCategory">
									<option value="${subCategory.id }-${subCategory.name }">${subCategory.name }</option>
								</c:forEach>
							</optgroup>
						</c:when>
						<c:otherwise>
							<option value="${category.key.id }-${category.key.name }">${category.key.name }</option>
						</c:otherwise>
					</c:choose>
				</c:forEach>

               </select>
            </div>
          </div>
             <div class="form-group">
              <label for="inputPassword3" class="col-sm-1 control-label">视频</label>
              <div class="col-sm-11">
                   <div class="file-container" style="display:inline-block;position:relative;overflow: hidden;vertical-align:middle">
                  <button class="btn btn-success fileinput-button" type="button">上传视频</button>
                  <input name="video" type="file" id="jobData" onchange="publishVideo(this.files[0])" style="position:absolute;top:0;left:0;font-size:34px; opacity:0" accept=".mp4">
              </div>
              <span id="publishVideo" style="vertical-align: middle">未上传文件</span>
              </div>
            </div>
        </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            <button type="button" class="btn btn-primary" data-dismiss="modal" id="btn2">发布</button>
          </div>
        </div>
      </div>
  </div>
 <!--  发布图文model -->
<div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">发布图文</h4>
      </div>
      <div class="modal-body">
        <form class="form-horizontal">
          <div class="form-group">
            <label for="inputEmail3" class="col-sm-1 control-label">标题</label>
            <div class="col-sm-11">
              <input type="text" name="title" class="form-control title_input" id="inputEmail3" placeholder="请输入资讯标题">
            </div>
          </div>
          <div class="form-group">
            <label for="inputPassword3" class="col-sm-1 control-label">栏目</label>
            <div class="col-sm-11">
               <select class="form-control select_label" name="category">
					<!--遍历生成栏目列表  -->
					<c:forEach items="${categoryList }" var="category">
						<c:choose>
							<c:when test="${category.key.id != 0}">
								<optgroup label="${category.key.name }">
									<c:forEach items="${category.value }" var="subCategory">
										<option value="${subCategory.id }-${subCategory.name }">${subCategory.name }</option>
									</c:forEach>
								</optgroup>
							</c:when>
							<c:otherwise>
								<option value="${category.key.id }-${category.key.name }">${category.key.name }</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
               </select>
            </div>
          </div>
          	 <div class="form-group">
               <label for="inputPassword3" class="col-sm-1 control-label">封面</label>
              <div class="col-sm-11">
               <div class="file-container" style="display:inline-block;position:relative;overflow: hidden;vertical-align:middle">
                  <button class="btn btn-success fileinput-button" type="button">上传封面</button>
                  <input name="titlePage" type="file" id="jobData" onchange="loadFileimg(this.files[0])" style="position:absolute;top:0;left:0;font-size:34px; opacity:0" accept=".png,.jpeg,.jpg">
              </div>
              <span id="filenameImg" style="vertical-align: middle">未上传文件</span>
              </div>
            </div>
             <div class="form-group">
              <label for="inputPassword3" class="col-sm-1 control-label">视频</label>
              <div class="col-sm-11">
                   <div class="file-container" style="display:inline-block;position:relative;overflow: hidden;vertical-align:middle">
                  <button class="btn btn-success fileinput-button" type="button">上传视频</button>
                  <input name="video" type="file" id="jobData" onchange="loadFile(this.files[0])" style="position:absolute;top:0;left:0;font-size:34px; opacity:0" accept=".mp4">
              </div>
              <span id="filename" style="vertical-align: middle">未上传文件</span>
              </div>
            </div>
            <div class="form-group">
              <label for="inputPassword3" class="col-sm-1 control-label">音乐</label>
              <div class="col-sm-11">
                  <div class="file-container" style="display:inline-block;position:relative;overflow: hidden;vertical-align:middle">
                  <button class="btn btn-success fileinput-button" type="button">上传音乐</button>
                  <input name="music" type="file" id="jobData" onchange="loadmusicFile(this.files[0])" style="position:absolute;top:0;left:0;font-size:34px; opacity:0" accept=".mp3">
              </div>
              <span id="filenameMusic" style="vertical-align: middle">未上传文件</span>
              </div>
            </div>
           
        </form>
        <div class="row edit" id="edit_tool"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" id="btn1">发布</button>
      </div>
    </div>
  </div>
</div>