<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
$(function(){
	$('#deleteYes').click(function(){
		if(categoryId != ""){
			$.post("admin/deleteCategory",
					{"categoryIds":categoryId},
					function(data){
						console.log(data);
						alert("删除栏目成功");
						$('.content').load(hrefStr);
						$(".fade").prop("class","fade in");
					});
		}
	});
	//修改
	$('.saveBtn').click(function(){
		var categoryName = $("input[name=categoryNameUp]").val();
		var categoryIdUp = $("input[name=categoryIdUp]").val();
		var description = $("textarea[name=infoContentUp]").val();
		console.log("categoryName:"+categoryName+",categoryIdUp:"+categoryIdUp+",description"+description);
		$.post("admin/addCategory",
				{"name":categoryName,
				 "id":categoryIdUp,
				 "info":description
				},function(data){
					console.log(data);
					alert("修改栏目成功");
					$('.content').load(hrefStr);
				});
	});
	//新增
	$('.saveBtnTwo').click(function(){
		var name = $("input[name=categoryNameAdd]").val();
		var parent_id = $("select[name=infoCategoryAdd]").val();
		var description = $("textarea[name=infoContentAdd]").val();
		console.log("name:"+name+",parent_id:"+parent_id+",description"+description);
		$.post("admin/addCategory",
				{"name":name,
				 "parentid":parent_id,
				 "info":description
				},function(data){
					console.log(data);
					alert("添加栏目成功");
					$('.content').load(hrefStr);
				});
	});
	$('.tbl').on({
		click:function(){
			var categoryIdUp = $(this).attr("categoryId");
			var categoryName = $(this).closest("tr").find("td:eq(1)").text();
			var description = $(this).attr("description");
			var parentId = $(this).attr("parentId");
			$(".modelUpdate input[name=categoryIdUp]").val(categoryIdUp);
			$(".modelUpdate input[name=categoryNameUp]").val(categoryName);
			if(parentId){
				$(".modelUpdate option[value="+parentId+"]").prop("selected","selected");
			}else{
				$(".modelUpdate option[value=no]").prop("selected","selected");
			}
			$(".modelUpdate textarea[name=infoContentUp]").val(description);
		} 
	},'button[title=修改]');
	$('.tbl').on({
		click:function(){
			categoryId = $(this).attr("categoryId");
		} 
	},'button[title=删除]');
	
	$("#batchDelBtn").on("click",function(){
		categoryId = $('.tbl input[name=categoryId]:checked').map(function(index,item) {
		      			return this.value;
		      		}).get().join(",");
		console.log(categoryId);
	});
})
</script>
 <link rel="stylesheet" href="./static/css/layout.css">
<style>
    .tbl td {
      text-align: center;
    }
  </style>
<div class="title"> 栏目列表 </div>
          <div class="btns">
              <button type="button" class="btn btn-primary  btn-sm"  data-toggle="modal" data-target=".bs-example-modal-add">添加栏目</button>
              <button type="button" class="btn btn-danger  btn-sm" data-toggle="modal" data-target=".bs-example-modal-del" id="batchDelBtn">批量删除</button>
          </div>
          <table class="tbl">
            <thead>
              <tr>
                <th >勾选</th>
                <th >标题</th>
                <th width="300px">栏目描述</th>
                <th >所属栏目</th>
                <th >操作</th>
              </tr>
            </thead>
            <tbody>
            <c:forEach items="${categoryList }" var="category" varStatus="i">
				<tr>
					<td><input type="checkbox" value="${category.key.id }" name="categoryId"></td>
					<td>${category.key.name }</td>
					<td>${category.key.info }</td>
					<td>无</td>
					<td>
						<button type="button" class="btn btn-success btn-xs" data-toggle="modal" data-target=".bs-example-modal-edit"
						 title="修改" categoryId="${category.key.id }" description="${category.key.info }">修改</button>
		                  <button type="button" class="btn btn-danger btn-xs" data-toggle="modal" data-target=".bs-example-modal-del" 
		                  title="删除" categoryId="${category.key.id }">删除</button>
					</td>
				</tr>
				<c:forEach items="${category.value }" var="subCategory">
					<tr>
						<td><input type="checkbox" value="${subCategory.id }" name="categoryId"></td>
						<td>${subCategory.name }</td>
						<td>${subCategory.info }</td>
						<td>${category.key.name }</td>
						<td>
							<button type="button" class="btn btn-success btn-xs" data-toggle="modal" data-target=".bs-example-modal-edit"
							 title="修改" categoryId="${subCategory.id }" description="${subCategory.info }" parentId="${category.key.id }">修改</button>
			                  <button type="button" class="btn btn-danger btn-xs" data-toggle="modal" data-target=".bs-example-modal-del" 
			                  title="删除" categoryId="${subCategory.id }">删除</button>
						</td>
					</tr>
				</c:forEach>
			</c:forEach>
           </tbody>
         </table>
  		<!-- 分页插件 -->
  		<jsp:include page="/four2.jsp">
			<jsp:param value="/admin/showCategoryList" name="url"/>
		</jsp:include>
  		
  <!-- 添加模态框 -->
  <div class="modal fade bs-example-modal-add" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
      <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="gridSystemModalLabel">发布栏目信息</h4>
              </div>
              <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                      <label for="inputEmail3" class="col-sm-1 control-label">标题</label>
                      <div class="col-sm-11">
                        <input name="categoryNameAdd" type="text" class="form-control" id="inputEmail3" placeholder="">
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-1 control-label">栏目</label>
                      <div class="col-sm-11">
                         <select name="infoCategoryAdd" class="form-control select_label">
                       		<option value="no">请选择父栏目</option>
							<!--遍历生成栏目列表  -->
							<c:forEach items="${categoryList }" var="category">
								<c:if test="${category.key.id != 0}">
									<option value="${category.key.id }">${category.key.name }</option>
								</c:if>
							</c:forEach>
                         </select>
                      </div>
                    </div>
                    <div class="form-group">
                        <label for="inputPassword3" class="col-sm-1 control-label">内容</label>
                        <div class="col-sm-11">
                            <textarea name="infoContentAdd" class="form-control" rows="3"></textarea>
                        </div>
                      </div>
                  </form>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-sm saveBtnTwo" data-dismiss="modal">保存</button>
                <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">取消</button>
              </div>
            </div><!-- /.modal-content -->
      </div>
    </div>
   <!--  修改 -->
     <div class="modal fade bs-example-modal-edit modelUpdate" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
      <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="gridSystemModalLabel">编辑栏目信息</h4>
              </div>
              <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                      <label for="inputEmail3" class="col-sm-1 control-label">标题</label>
                      <div class="col-sm-11">
                        <input name="categoryNameUp" type="text" class="form-control" id="inputEmail3" placeholder="">
                        <input type="hidden" name="categoryIdUp">
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-1 control-label">栏目</label>
                      <div class="col-sm-11">
                         <select class="form-control select_label" name="infoCategoryUp" disabled="disabled">
							<option value="no">无</option>
							<!--遍历生成栏目列表  -->
							<c:forEach items="${categoryList }" var="category">
								<option value="${category.key.id }">${category.key.name }</option>
							</c:forEach>
                         </select>
                      </div>
                    </div>
                    <div class="form-group">
                        <label for="inputPassword3" class="col-sm-1 control-label">内容</label>
                        <div class="col-sm-11">
                            <textarea name="infoContentUp" class="form-control" rows="3"></textarea>
                        </div>
                      </div>
                  </form>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-sm saveBtn" data-dismiss="modal">保存</button>
                <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">取消</button>
              </div>
            </div><!-- /.modal-content -->
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