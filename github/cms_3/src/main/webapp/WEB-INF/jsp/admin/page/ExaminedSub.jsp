<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
    .tbl td {
      text-align: center;
    }
</style>
<script>
	$(function(){
		$('#deleteYes').click(function(){
			console.log("articleId："+articleId);
			if(articleId){
				$.post("user/deleteArticle",
						{"articleIds":articleId},
						function(data){
							console.log(data);
							alert("删除资讯成功");
							$('.content').load(hrefStr);
							$(".fade").prop("class","fade in");
						});
			}
		});
		//修改确定
		$('.modalUpdate .saveBtn').click(function(){
			var articleId = $(".modalUpdate input[name=articleId]").val();
			var categoryId = $(".modalUpdate select[name=categoryId]").val();
			console.log("articleId:"+articleId+",categoryId:"+categoryId);
			$.post("user/updateArticleServlet",
					{"articleId":articleId,
					 "categoryidname":categoryId
					},function(data){
						alert("修改成功");
					});
			
		});
		// 修改
		$('.tbl').on({
			click:function(){
				var articleId = $(this).closest("tr").find("td:eq(0) input").val();
				var articleTitle = $(this).closest("tr").find("td:eq(1)").text();
				var categoryId = $(this).attr("categoryId");
				$(".modalUpdate input[name=articleTitle]").val(articleTitle);
				$(".modalUpdate option[value="+categoryId+"]").prop("selected","selected");
				$(".modalUpdate input[name=articleId]").val(articleId);
				console.log(articleId+"--"+articleTitle+"--"+categoryId);
			} 
		},'button[title=修改]');
		// 删除
		$('.tbl').on({
			click:function(){
				articleId = $(this).closest("tr").find("td:eq(0) input").val();
			}
		},'button[title=删除]');
		
		//批量删除
		$("#batchDelBtn").on("click",function(){
			articleId = $('.tbl input[name=articleId]:checked').map(function(index,item) {
			      			return this.value;
			      		}).get().join(",");
		});
	});
</script>
	<div class="title">正常资讯列表 </div>
          <div class="btns">
              <!-- <button type="button" class="btn btn-primary  btn-sm"  data-toggle="modal" data-target=".bs-example-modal-add">发布</button> -->
              <button id="batchDelBtn" type="button" class="btn btn-danger  btn-sm" data-toggle="modal" data-target=".bs-example-modal-del">批量删除</button>
          </div>
          <table class="tbl">
            <thead>
              <tr>
                <th width="50px">选择</th>
                <th width="300px">标题</th>
                <th width="100px">栏目</th>
                <th width="160px">发布时间</th>
                <td>背景音乐</td>
                <th width="80px">阅读量</th>
                <th width="80px">点赞量</th>
                <th width="80px">收藏量</th>
                <th width="160px">操作</th>
              </tr>
            </thead>
            <tbody>
	           	<c:forEach items="${articles }" var="article">
					<tr>
						<td><input type="checkbox" value="${article.id }" name="articleId"></td>
						<td><a style="color:green" href="user/showArticle?articleId=${article.id }" target="_blank">${article.title }</a></td>
						<td>${article.categoryname }</td>
						<td><fmt:formatDate value="${article.dob }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td>${article.music == null?"无":fn:substring(article.music,23,-1) }</td>
						<td>${article.rea }</td>
						<td>${article.click }</td>
						<td>${article.collect }</td>
						<td>
							<button type="button" class="btn btn-success btn-xs" data-toggle="modal" data-target=".bs-example-modal-edit" 
							title="修改" categoryId=${article.categoryid }>修改</button>
			                <button type="button" class="btn btn-danger btn-xs" data-toggle="modal" data-target=".bs-example-modal-del" 
			                title="删除">删除</button>
						</td>
					</tr>
				</c:forEach>
            </tbody>
          </table>
  <!-- 添加模态框 -->
  <div class="modal fade bs-example-modal-add" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
      <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="gridSystemModalLabel">发布资讯</h4>
              </div>
              <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                      <label for="inputEmail3" class="col-sm-1 control-label">标题</label>
                      <div class="col-sm-11">
                        <input type="email" class="form-control" id="inputEmail3" placeholder="">
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-1 control-label">栏目</label>
                      <div class="col-sm-11">
                         <select class="form-control select_label" name="categoryId">
                        <!--遍历生成栏目列表  -->
                            <option selected="selected" value="0">其他111</option>
                              <optgroup label="一级分类1">

                                <option value="5">二级2</option>

                                <option value="6">二级3</option>

                                <option value="4">二级1</option>

                            </optgroup>

                              <optgroup label="一级分类2">

                                <option value="8">二级分类5</option>

                                <option value="7">二级分类4</option>

                                <option value="9">二级分类6</option>

                            </optgroup>

                              <optgroup label="一级分类3">

                                <option value="10">二级分类7</option>

                                <option value="12">二级分类9</option>

                                <option value="11">二级分类8</option>

                            </optgroup>

                         </select>
                      </div>
                    </div>
                    <div class="form-group">
                        <label for="inputPassword3" class="col-sm-1 control-label">内容</label>
                        <div class="col-sm-11">
                            <textarea class="form-control" rows="3"></textarea>
                        </div>
                      </div>
                  </form>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary btn-sm">保存</button>
              </div>
            </div><!-- /.modal-content -->
      </div>
    </div>
    
   <!--  修改 -->
     <div class="modal fade bs-example-modal-edit modalUpdate" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
      <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content" id="categoryModal">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="gridSystemModalLabel">修改资讯</h4>
              </div>
              <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                      <label for="inputEmail3" class="col-sm-1 control-label">标题</label>
                      <div class="col-sm-11">
                        <input disabled="disabled" type="text" name="articleTitle" class="form-control" id="inputEmail3" placeholder="">
                        <input type="hidden" name="articleId">
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
                <button type="button" class="btn btn-primary btn-sm saveBtn" data-dismiss="modal">保存</button>
                <button type="button" class="btn btn-default btn-sm backBtn" data-dismiss="modal">取消</button>
              </div>
      </div>
    </div>
    </div>
   <!--  删除 -->
<div class="modal fade bs-example-modal-del" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
    <div class="modal-body">确定删除吗？</div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal" id="deleteYes">确定</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" id="deleteNo">取消</button>
      </div>
    </div>
   </div>  
   </div>
     