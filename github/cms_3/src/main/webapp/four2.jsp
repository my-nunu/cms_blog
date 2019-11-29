<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div>
		<c:if test="${!page.first }">
			<a href="${param.url }?page=${page.number-1 }">上一页</a>&nbsp;
		</c:if>
		<c:forEach begin="0" end="${page.totalPages>0?page.totalPages-1:page.totalPages}"  var="i">
			<c:choose>
				<c:when test="${i==page.number }">
					<a href="${param.url }?page=${i }" style="color:red;">第${i+1 }页</a>&nbsp;
				</c:when>
				<c:otherwise>
					<a href="${param.url }?page=${i }" >第${i+1 }页</a>&nbsp;
				</c:otherwise>
			</c:choose>
		</c:forEach>
		<c:if test="${!page.last }">
			<a href="${param.url }?page=${page.number+1 }&${request.queryString}">下一页</a>&nbsp;
		</c:if>
		共${page.totalElements }条数据
	</div>