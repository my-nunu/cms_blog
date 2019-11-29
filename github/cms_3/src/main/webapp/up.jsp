<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="u" method="post" enctype="multipart/form-data">
		<input type="file" name="myfile"><br>
		<button>提交</button>
	</form>
	<hr>
	<h1>分页</h1>
	<h5>本页数据</h5>
	<c:forEach items="${page.content}" var="a">
		${a.id }--${a.title }--${a.content }
	</c:forEach>
	
	<h5>分页插件</h5>
	<jsp:include page="four2.jsp">
		<jsp:param value="/toUp" name="url"/>
	</jsp:include>
	<hr>
	
	
	
	<img alt="没有图片" src="/down/2.jpg" width="20" height="20">
	
	
	
	
</body>
</html>