<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<title>信息管理页面</title>
<script src="bootstrap-3.3.7/jquery.min.js"></script>
<link rel="stylesheet" href="bootstrap-3.3.7/css/bootstrap.css">
<script src="bootstrap-3.3.7/js/bootstrap.js"></script>
<script type="text/javascript">
	$(function() {
		/**
		 *原来判断是否登录  loginAdminName只有登录后才存在 这样判断不靠谱，但是简单，怒存在直接跳转到show.jsp
		 */
		var loginAdminName = $("#loginAdminName").attr("adminName");
		if (!loginAdminName) {
			window.location.replace("show.jsp");
		}
		/**
		 *获取全部预定信息
		 */
		getReservation(loginAdminName);
		/**
		 *按钮事件（点击为已确认）
		 *on()方法说明：
		 *第一个参数：事件，click为点击事件
		 *第二个为选择器，选择要点击事件的标签
		 *第三个就是就是点击事件执行的函数
		 */
		$(document).on("click", ".confirmReservation", confirmReservation);
	})
	function getReservation(loginAdminName) {
		/*
		 *存在用户名后才获取数据
		 */
		if (!loginAdminName) {
			return;
		}
		$.ajax({
			url : "getReservation.do",
			type : "post",
			dataType : "json",
			success : function(json) {
				/*
				 *显示数据
				 */
				showReservation(json);
			},

			error : function() {
				alert("发生系统级错误！");
			}
		});
	}
	/**
	 * 显示数据
	 */
	function showReservation(data) {
		//移除原有
		$(".showReservation tr").remove();
		var html = "";
		if (data && data.length > 0) {
			var i = 1;
			$(data)
					.each(
							function() {
								html += '<tr>                   ';
								html += '	<td>' + i++ + '</td>            ';
								html += '	<td>' + this.hotelType
										+ '</td>            ';
								html += '	<td>' + this.reservationName
										+ '</td> ';
								html += '	<td>' + this.reservationPhone
										+ '</td>   ';
								html += '	<td>' + this.reservationEnd
										+ '</td>         ';
								html += '	<td>' + this.reservationStart
										+ '</td>   ';
								html += '	<td class="cancel'+this.reservationId+'">'
										+ this.reservationStatic
										+ '</td>      ';
								html += '	<td>' + this.reservationUpTime
										+ '</td>         ';
								html += '	<td>';
								if (this.reservationStatic == "提交") {
									html += '<button type="button" class="btn btn-primary confirmReservation" id="'+this.reservationId+'" hId="'+this.hotelId+'">确认</button>';
								} else if (this.reservationStatic == "已确认") {
									html += '<button type="button" class="btn btn-primary" disabled="disabled">已确认</button>';
								} else if (this.reservationStatic == "已取消") {
									html += '<button type="button" class="btn btn-danger" disabled="disabled">已被取消</button>';
								}

								html += '</td>         ';
								html += '</tr>                  ';
							});
		} else {
			html += '<tr>                   ';
			html += '	<td colspan="9" style="text-align: center;">无数据</td> ';
			html += '</tr> ';
		}

		$(".showReservation").append(html);
	}
/**
 * 点击“确定”后执行的函数
 */
	function confirmReservation() {
		var reservationId = $(this).attr("id");
		var hotelId = $(this).attr("hId");
		$.ajax({
			url : "confirmReservation.do",
			type : "post",
			data : {
				reservationId : reservationId,
				hotelId : hotelId
			},
			dataType : "json",
			success : function(json) {
				if (json.static == "success") {
					/*
					*确认成功后，重新获取数据
					*/
					getReservation(loginAdminName);
				} else {
					alert("取消失败");
				}
			},

			error : function() {
				alert("发生系统级错误！");
			}
		});

	}
</script>


</head>
<body>
	<div class="container" style="margin-top: 50px">
		<div class="row clearfix">
			<div class="col-md-12 column">
				<div class="tabbable" id="tabs-190188">
					<ul class="nav nav-tabs">
						<li class="active"><a href="#panel-3083" data-toggle="tab">预订信息管理</a>
						</li>
						<li><a href="show.jsp">返回首页</a></li>
						<c:choose>
							<c:when test="${!empty sessionScope.admin }">
								<li><a href="adminQuit.do" id="loginAdminName"
									adminname="${sessionScope.admin.adminName}">退出管理</a></li>
							</c:when>

							<c:otherwise>
								<li><a href="show.jsp">返回首页进行登录</a></li>
							</c:otherwise>
						</c:choose>





					</ul>
					<div class="tab-content">
						<div class="tab-pane active" id="panel-3083"></div>
						<div class="tab-pane" id="panel-149858"></div>
					</div>
				</div>
				<table class="table table-hover table-bordered"
					style="margin-top:10px">
					<thead>
						<tr>

							<th width="5">序号</th>
							<th width="15">房间类型</th>
							<th width="15">预留姓名</th>
							<th width="15">联系方式</th>
							<th width="10">入住时间</th>
							<th width="10">离店时间</th>
							<th width="10">订单状态</th>
							<th width="10">提交时间</th>
							<th width="10">取消</th>

						</tr>
					</thead>
					<tbody class="showReservation">


					</tbody>
				</table>
				<div style="text-align: center">
					<ul class="pagination">
						<li><a href="#">上一页</a></li>

						<li><a href="#">下一页</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
