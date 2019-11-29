<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" type="text/css" href="./static/css/checkout.css">
<script>
$(function(){
	$('#deleteYes').click(function(){
		console.log("articleId："+articleId);
		if(articleId){
			$.post("admin/examineArticle",
					{"articleIds":articleId,
					"state":1
					},
					function(data){
						console.log(data);
						alert("审核通过");
						$('.content').load(hrefStr);
						$(".fade").prop("class","fade in");
					});
		}
	});
	$('#deleteNo').click(function(){
		console.log("articleId："+articleId);
		if(articleId){
			$.post("admin/examineArticle",
					{"articleIds":articleId,
					"state":2
					},
					function(data){
						console.log(data);
						alert("审核不通过");
						$('.content').load(hrefStr);
					});
		}
	});
	// 审核
	$('.ex').on({
		click:function(){
			articleId = $(this).closest("tr").find("td:eq(0) input").val();
		}
	});
	
	//批量审核
	$("#batchExBtn").on("click",function(){
		articleId = $('.tbl input[name=articleId]:checked').map(function(index,item) {
		      			return this.value;
		      		}).get().join(",");
	});
 })
</script>
<div class="title"> 待审核列表 </div>
      <div class="btns">
          <button id="batchExBtn" type="button" class="btn btn-primary  btn-sm"  data-toggle="modal" data-target=".bs-example-modal-check">批量审核</button>
      </div>
          <table class="tbl" style="text-align: center">
            <thead>
              <tr>
                <th width="50px">编号</th>
                <th width="200px">文章标题</th>
                <th width="200px">所属栏目</th>
                <th>发布时间</th>
                <th>背景音乐</th>
                <th>作者</th>
                <th width="160px">操作</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${articles }" var="article">
				<tr>
					<td><input name="articleId" type="checkbox" value="${article.id }"></td>
					<td style="color: red"><a style="color: red" href="user/showArticle?articleId=${article.id }" target="_blank">${article.title }</a></td>
					<td>${article.categoryname}</td>
					<td><fmt:formatDate value="${article.dob }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
					<td>${article.music == null?"无":fn:substring(article.music,44,-1) }</td>
					<td>${article.author }</td>
					<td>
						<button type="button" class="btn btn-success btn-xs ex" data-toggle="modal" data-target=".bs-example-modal-check">审核</button>
					</td>
				</tr>
			 </c:forEach>
            </tbody>
          </table>
   <!-- 模态框 -->
  <div class="modal fade bs-example-modal-check" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
      <div class="modal-dialog modal-md" role="document">
          <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="gridSystemModalLabel">资讯审核</h4>
              </div>
              <div class="modal-body">
                <div class="btns_check">
                      <button type="button" class="btn btn-success" id="deleteYes" data-dismiss="modal">审核通过</button>&nbsp;&nbsp;
                      <button type="button" class="btn btn-danger" id="deleteNo" data-dismiss="modal">审核不通过</button>&nbsp;&nbsp;
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">取消</button>
              </div>
            </div><!-- /.modal-content -->
      </div>
    </div>