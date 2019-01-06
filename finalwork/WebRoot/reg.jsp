<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<link rel="icon" href="../../../../favicon.ico">
<title>用户注册</title>
<script src="bootstrap-3.3.7/jquery.min.js"></script>
<link rel="stylesheet" href="bootstrap-3.3.7/css/bootstrap.css">
<script src="bootstrap-3.3.7/js/bootstrap.js"></script>
<script>
	$(function() {
		/**
		*注册
		*/
		addUser();
		
		
		/**
		*原有
		*/
		if ($(".no").html() == "false") {
			$("#tel").removeClass("hide");
		}
		if ($(".noo").html() == "false") {
			$("#pwd").removeClass("hide");
		}
	});

/**
 * 注册
 */
function addUser() {
	$(".addUser").click(function () {
		var userName=$("#userName").val();
		var userPass1=$("#userPass1").val();
		var userPass2=$("#userPass2").val();
		if(!userName){
			alert("用户名不能为空");
			return;
		}
		if(!userPass1){
			alert("密码不能为空");
			return;
		}
		if(!userPass2){
			alert("确认密码不能为空");
			return;
		}
		if(userPass1!=userPass2){
			alert("两次密码要一致")
		}
		$.ajax({
			url : "reg.do",
			type : "post",
			dataType : "json",
			data : {
				user : userName,
				pass : userPass1
			},
			success : function(json) {
				if (json.static == "success") {
					alert("注册功能！")
					window.location.replace("show.jsp");
				} else {
					alert("注册失败！");
				}
			},
			error : function() {
				alert("发送系统级错误！");
			}
		});
	});
}
</script>
</head>
<body
	style="background-image:url('pic/yyyy.jpg'); background-size: cover">
	<div class="container">
		<div class="row">
			<div class="col-md-4 col-md-offset-4"
				style="background-color: rgba(102,102,102,0.42);padding: 10px 50px 50px 50px ; margin-top: 5%">
				<div class="form-horizontal" action="reg.do" method="post">
					<h1 class="h3 mb-3 font-weight-normal">请输入以下信息完成注册：</h1>
					<br>
					<h5>					
						用户名：<input type="text" name="g_name" id="userName" class="form-control"
							aria-describedby="inputGroupSuccess1Status" placeholder="请设置用户昵称"
							required><br> 
						登录密码：<input id="userPass1" type="password"
							name="g_pass" class="form-control"
							aria-describedby="inputGroupSuccess1Status" placeholder="请设置登录密码"
							required><br> 
						确认密码：<input  id="userPass2" type="password"
							name="againPass" class="form-control"
							aria-describedby="inputGroupSuccess1Status"
							placeholder="请再次输入登录密码" required><br>
					</h5>
					<span class="hide noo">${notequl}</span>
					<!-- 确认密码不一致的提示框 -->
					<div id="pwd" class="alert alert-danger alert-dismissible hide"
						role="alert">
						<button type="button" class="close" data-dismiss="alert"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<strong><span
							class="glyphicon glyphicon-exclamation-sign"></span></strong>两次输入的密码不一致
					</div>
					<button class="btn btn-block btn-default addUser" type=submit>注册</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
