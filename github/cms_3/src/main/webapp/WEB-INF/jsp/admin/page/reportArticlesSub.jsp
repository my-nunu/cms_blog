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
	//点击  审核通过 按钮
	$('.passBtn').click(function(){
		alert("..通过..");
		var processContent = $(".modal textarea[name=processContent]").val();
		$.post("admin/handleReport",{
			"id":reportid,
			"state":2,
			"resultcontent":processContent
		},function(data){
			console.log(data);
			alert("审核正常");
			$('.content').load(hrefStr);
			$(".fade").prop("class","fade in");
		});
		
	});
	//点击  审核不通过 按钮
	$('.noPassBtn').click(function(){
		var processContent = $(".modal textarea[name=processContent]").val();
		$.post("admin/handleReport",{
			"id":reportid,
			"state":3,
			"resultcontent":processContent
		},function(data){
			console.log(data);
			alert("审核异常");
			$('.content').load(hrefStr);
			$(".fade").prop("class","fade in");
		});
	});

	//点击每行文章后面的  查看
	$('.tbl').on({
		click:function(){
			reportid = $(this).closest("tr").find("td:eq(0) input").val();
			$.post("admin/showReportMessages",
					{"reportid":reportid},
						function(data){
							console.log(data);
							$("#reportMessage tr").remove(":gt(0)");
							$("#reportMessage").append("<tr><td>"+data.type+"</td><td>"+data.reportcontent+"</td><td>"+data.reportdob+"</td><td>"+data.nickname+"</td><td>"+data.resultcontent+"</td><td>"+data.resultdob+"</td></tr>");
					});
			
		}
	},'button[title=点击]');

})
</script>
 <div class="title"> 举报待处理列表 </div>
          <!-- <div class="btns">
              <button type="button" class="btn btn-danger  btn-sm" data-toggle="modal" data-target=".bs-example-modal-del">批量删除</button>
          </div> -->
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
                <td>举报量</td>
                <th width="160px">举报信息查看</th>
              </tr>
            </thead>
            <tbody>
            	<c:forEach items="${map }" var="entry">
					<tr>
						<td><input type="checkbox" value="${entry.value.id }"></td>
						<td><a style="color:red" href="user/showArticle?articleId=${entry.key.id }" target="_blank">${entry.key.title }</a></td>
						<td>${entry.key.categoryname }</td>
						<td><fmt:formatDate value="${entry.key.dob }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td>${entry.key.music == null?"无":fn:substring(entry.key.music,44,-1) }</td>
						<td>${entry.key.rea }</td>
						<td>${entry.key.click }</td>
						<td>${entry.key.collect }</td>
						<td>3</td>
						<td>
							<button title="点击" type="button" class="btn btn-success btn-xs" data-toggle="modal" data-target=".bs-example-modal-edit">点击查看</button>
						</td>
					</tr>
				</c:forEach>
            </tbody>
          </table>
    
    <!--  举报信息模态框 -->
     <div class="modal fade bs-example-modal-edit" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
      <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="gridSystemModalLabel">查看举报待处理列表</h4>
              </div>
              <div class="modal-body">
                  <table class="table table-bordered" id="reportMessage">
                        <thead>
                          <tr>
                            <th>举报类型</th>
                            <th>举报内容</th>
                            <th>举报时间</th>
                            <th>举报用户</th>
                            <th>处理结果</th>
                            <th>处理时间</th>
                         </tr>
                      </thead>
                      <tbody>
                      
                      </tbody>
                  </table>
                  <div style="margin-bottom: 1em;">审核结果:</div>
                  <textarea name="processContent" id="" cols="100" rows="5"></textarea>
                  <div class="modal-footer">
                    <span class="messageSpan"></span>
                  </div>
                        </div>
                        <div class="modal-footer">
                         <button type="button" class="btn btn-success btn-sm passBtn" data-dismiss="modal">正常</button>
                          <button type="button" class="btn btn-danger btn-sm noPassBtn" data-dismiss="modal">异常</button>
                          <button type="button" class="btn btn-default btn-sm backBtn" data-dismiss="modal">取消</button>
                        </div>
                      </div>
      </div>
    </div>
