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
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<title>系统首页</title>
<script src="bootstrap-3.3.7/jquery.min.js"></script>
<link rel="stylesheet" href="bootstrap-3.3.7/css/bootstrap.css">
<script src="bootstrap-3.3.7/js/bootstrap.js"></script>
<script>
	$(function() {

		/**
		 *获取酒店信息
		 */
		getHotel();
		/**
		 *登录
		 */
		login();
		/**
		 *点击预定。弹出静态框前的准备（显示房间类型和价格） 点击不同的“预定”显示不同类容
		 *第一个参数：事件，click为点击事件
		 *第二个为选择器，选择要点击事件的标签
		 *第三个就是就是点击事件执行的函数
		 */

		$(document).on("click", ".getReservation", getReservation);

		/**
		 *点击静态框中的确定按钮
		 */
		addReservation();
		/**
		 * 管理员登录
		 */
		adminLogin();

	});
	/**
	 * 获取酒店信息
	 */
	function getHotel() {
		$(".ifShow").hide().html("数据加载中……………………").fadeIn(1000);

		$.ajax({
			url : "getHotel.do",
			type : "get",
			dataType : "json",
			success : function(json) {

				$(".ifShow").html("");
				//显示数据
				showHotel(json);
			},

			error : function() {
				alert("发生系统级错误！");
			}
		});

	}
	/**
	 *登录
	 */
	function login() {
		$("#userLogin").click(function() {
			var user = $("#userName").val();
			var pass = $("#userPass").val();
			if (user == "") {
				alert("用户名不能为空")
				return;
			}
			if (pass == "") {
				alert("密码不能为空")
				return;
			}

			$.ajax({
				url : "login.do",
				type : "post",
				dataType : "json",
				data : {
					user : $("#userName").val(),
					pass : $("#userPass").val(),
				},
				success : function(json) {
					if (json.static == "true") {

						//关闭静态宽
						$("#myModal").modal("hide");
						//刷新页面
						window.location.reload();
					} else {
						alert(json.msg);
					}
				},
				error : function() {
					alert("发生系统级错误！");
				}
			});
		});
	}

	/**
	 *显示数据
	 */
	function showHotel(data) {
		//移除原有

		var html = "";
		if (data && data.length > 0) {

			$(data)
					.each(
							function() {
								html += '<div class="row clearfix" style="margin-top: 20px">                                  ';
								html += '	<div class="col-md-6 column" style="text-align: center">                            ';
								html += '		<img style="height:160px;width: 280px" alt="'+this.hotelType+'"                         ';
				html+='			src="'+this.hotelImg+'" />                                                        ';
								html += '	</div>                                                                              ';
								html += '	<div class="col-md-6 column"                                                        ';
				html+='		style="border-bottom:2px dashed #bdcbc2">                                       ';
								html += '		<h4>                                                                            ';
								html += '			<li class="hotelType'+this.hotelId+'">'
										+ this.hotelType
										+ '：</li>                                                       ';
								html += '		</h4>                                                                           ';

								html += '		<h5>                                                                            ';
								html += '			<span class="glyphicon glyphicon-hand-right" aria-hidden="true"></span>     ';
								html += '			可住'
										+ this.hotelPeople
										+ '人<br> <span class="glyphicon glyphicon-ok-circle"                     ';
				html+='				aria-hidden="true"></span> '
										+ format(this.hotelWindow)
										+ '窗<br> <span                          ';
				html+='				class="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>    ';
								html += '			'
										+ format(this.hotelBreakfas)
										+ '早餐<br> <span class="glyphicon glyphicon-ok-circle"                      ';
				html+='				aria-hidden="true"></span> '
										+ format(this.hotelToilet)
										+ '独卫，24小时提供热水<br> <span             ';
				html+='				class="glyphicon glyphicon-ok-circle" aria-hidden="true"></span>        ';
								html += '			'
										+ this.hotelOther
										+ '<br>                                          ';
								html += '		剩余房间数：        <span class="hotelNum'+this.hotelId+'"> '
										+ this.hotelNumber
										+ '</span><br>                                                                ';
								html += '		</h5>                                                                           ';
								html += '		<div style="margin-left: 240px">                                                ';
								html += '			<button type="button" class="btn btn-default"                               ';
				html+='				>                           ';
								html += '				<span id="'+this.hotelId +'" class="glyphicon glyphicon-yen getReservation" aria-hidden="true"><span class="hotelPrice'+this.hotelId+'">'
										+ this.hotelPrice + '</span>元/夜       ';
								html += '					预订</span>                                                         ';
								html += '			</button>                                                                   ';
								html += '		</div>                                                                          ';
								html += '	</div>                                                                              ';
								html += '</div>                                                                               ';

							});
		}

		$(".addHotel").append(html);

	}

	/**
	 * 格式化数据
	 *传入1返回“有”  （如数据库中的h_window为1时，即为“有”）
	 */
	function format(num) {
		if (num == 1) {
			return "有";
		} else {
			return "无";
		}
	}
	/**
	 *预定准备
	 */
	function getReservation() {
		var LoginId = $(".loginUserId").attr("id");
		if (!LoginId) {
			alert("请先登录");
			return;
		}

		var id = $(this).attr("id");
		$(".reservationHotelId").html(id);
		$(".reservationType").html($(".hotelType" + id).html())
		$(".reservationPrice").html($(".hotelPrice" + id).html())
		$("#bookModal").modal("show");
	}
	/**
	 *开始预定
	 */
	function addReservation() {
		$(".addReservation").click(function() {
			//刷新页面
			window.location.reload();
			var hotelId = $(".reservationHotelId").html();
			var hotelType = $(".reservationType").html();
			var hotelPrice = $(".reservationPrice").html();

			var reservationName = $(".reservationName").val();
			var reservationPhone = $(".reservationPhone").val();
			/*
			 *入住时间
			 */
			var inTimeYear = $("#J_Year").val();
			var inTimeMonth = $("#J_Month").val();
			var inTimeDate = $("#J_Date").val();
			var inTime = inTimeYear + "-" + inTimeMonth + "-" + inTimeDate;

			/*
			 *离店时间（获取时间的时候，要一个个获取，分别获取年、月、日后再进行拼接，很坑爹）
			 */
			var outTimeYear = $("#Year").val();
			var outTimeMonth = $("#Month").val();
			var outTimeDate = $("#Date").val();
			var outTime = inTimeYear + "-" + outTimeMonth + "-" + outTimeDate;
			/*
			 *数量
			 */
			var hotelNum = $(".hotelNum" + hotelId).html();

			/*
			 *
			 */
			var userId = $(".loginUserId").attr("id");

			$.ajax({
				url : "addReservation.do",
				type : "post",
				dataType : "json",
				data : {
					hotelId : hotelId,

					reservationStart : inTime,
					userId : userId,
					reservationEnd : outTime,
					hotelPrice : hotelPrice,
					hotelType : hotelType,
					reservationStatic : "提交",
					reservationName : reservationName,
					reservationPhone : reservationPhone,
					hotelNum : hotelNum
				},
				success : function(json) {
					if (json == 1) {
						$("#bookModal").modal("hide")
						alert("预定成功");
						//刷新页面
						window.location.reload();
					} else {
						alert("预定失败");
					}
				},
				error : function() {

				}
			});

		});
	}
	/**
	 * 管理员登录
	 */
	function adminLogin() {
		$(".adminLogin").click(function() {
			var adminName = $("#adminName").val();
			var adminPass = $("#adminPass").val();
			if (adminName == "") {
				alert("用户名不能为空")
				return;
			}
			if (adminPass == "") {
				alert("密码不能为空")
				return;
			}

			$.ajax({
				url : "adminLogin.do",
				type : "post",
				dataType : "json",
				data : {
					adminName : adminName,
					adminPass : adminPass
				},
				success : function(json) {
					if (json.static == "true") {

						//关闭静态宽
						$("#maneModal").modal("hide");
						window.location.replace("manager.jsp");
					} else {
						alert(json.msg);
					}
				},
				error : function() {

				}
			});
		});
	}
</script>
</head>
<body>

	<div class="container">
		<div class="row clearfix">
			<div class="col-md-12 column">
				<h1 class="text-center">起名字真的太难了那就随便叫吧</h1>
				<nav class="navbar navbar-default" role="navigation">
				<div class="collapse navbar-collapse"
					id="bs-example-navbar-collapse-1">
					<ul class="nav navbar-nav">
						<li class="active"><a><span
								class="glyphicon glyphicon-home" aria-hidden="true"></span>网站首页</a>
						</li>
						<li><a href="#">这是啥</a></li>
						<li><a href="#">我也不知道</a></li>
						<li><a href="#">名字瞎起的</a></li>
						<li><a href="#">有用的话</a></li>
						<li><a href="#">那就再说吧</a></li>


						<c:choose>
							<c:when test="${!empty sessionScope.admin }">
								<li><a class="user" name="mane" href="manager.jsp">进去管理员页面</a></li>
							</c:when>

							<c:otherwise>
								<li><span class="hide mana">${mana}</span> <a class="user"
									name="mane" data-toggle="modal" data-target="#maneModal">管理员入口</a>
								</li>
							</c:otherwise>
						</c:choose>
					</ul>
					<ul class="nav navbar-nav navbar-right">
						<li><a>欢迎来到%￥@#￥@！#</a></li>
					</ul>
				</div>
				</nav>
			</div>
			<div class="row clearfix">
				<div class="col-md-8 column addHotel">

					<div class="row clearfix ">

						<div class="col-md-12 column ">
							<h4 style="text-align: center;">
								<span class="ifshow"></span>
							</h4>


						</div>
					</div>
					<!--  
					<div class="row clearfix" style="margin-top: 20px">
						<div class="col-md-6 column" style="text-align: center">
							<img style="height:160px;width: 280px" alt="标准双人间"
								src="pic/two.jpg" />
						</div>
						<div class="col-md-6 column"
							style="border-bottom:2px dashed #bdcbc2">
							<h4>
								<li>标准双人间：</li>
							</h4>
							<h5>
								<span class="glyphicon glyphicon-hand-right" aria-hidden="true"></span>
								可住2人<br> <span class="glyphicon glyphicon-ok-circle"
									aria-hidden="true"></span> 有窗，2层<br> <span
									class="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
								不含早<br> <span class="glyphicon glyphicon-ok-circle"
									aria-hidden="true"></span> 有独卫，24小时提供热水<br> <span
									class="glyphicon glyphicon-ok-circle" aria-hidden="true"></span>
								有空调、电视，且24小时不断网<br>
							</h5>
							<div style="margin-left: 240px">
								<button type="button" class="btn btn-default"
									data-toggle="modal" data-target="#bookModal">
									<span class="glyphicon glyphicon-yen" aria-hidden="true">178元/夜
										预订</span>
								</button>
							</div>
						</div>
					</div>
					<div class="row clearfix" style="margin-top: 20px">
						<div class="col-md-6 column" style="text-align: center">
							<img style="height:160px;width: 280px" alt="大床房"
								src="pic/big.jpg" />
						</div>
						<div class="col-md-6 column"
							style="border-bottom:2px dashed #bdcbc2">
							<h4>
								<li>大床房：</li>
							</h4>
							<h5>
								<span class="glyphicon glyphicon-hand-right" aria-hidden="true"></span>
								可住2人<br> <span class="glyphicon glyphicon-ok-circle"
									aria-hidden="true"></span> 有窗，2-3层<br> <span
									class="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
								不含早<br> <span class="glyphicon glyphicon-ok-circle"
									aria-hidden="true"></span> 有独卫，24小时提供热水<br> <span
									class="glyphicon glyphicon-ok-circle" aria-hidden="true"></span>
								有空调、电视，且24小时不断网<br>
							</h5>
							<div style="margin-left: 240px">
								<button type="button" class="btn btn-default"
									data-toggle="modal" data-target="#bookModal">
									<span class="glyphicon glyphicon-yen" aria-hidden="true">168元/夜
										预订</span>
								</button>
							</div>
						</div>
					</div>
					<div class="row clearfix" style="margin-top: 20px">
						<div class="col-md-6 column" style="text-align: center">
							<img style="height:160px;width: 280px" alt="商务间"
								src="pic/ecnomy.jpg" />
						</div>
						<div class="col-md-6 column"
							style="border-bottom:2px dashed #bdcbc2">
							<h4>
								<li>商务间：</li>
							</h4>
							<h5>
								<span class="glyphicon glyphicon-hand-right" aria-hidden="true"></span>
								可住2人<br> <span class="glyphicon glyphicon-ok-circle"
									aria-hidden="true"></span> 有窗，3-4层<br> <span
									class="glyphicon glyphicon-ok-circle" aria-hidden="true"></span>
								含早<br> <span class="glyphicon glyphicon-ok-circle"
									aria-hidden="true"></span> 有独卫，24小时提供热水<br> <span
									class="glyphicon glyphicon-ok-circle" aria-hidden="true"></span>
								有空调、电视，且24小时不断网<br>
							</h5>
							<div style="margin-left: 240px">
								<button type="button" class="btn btn-default"
									data-toggle="modal" data-target="#bookModal">
									<span class="glyphicon glyphicon-yen" aria-hidden="true">198元/夜
										预订</span>
								</button>
							</div>
						</div>
					</div>
					<div class="row clearfix" style="margin-top: 20px">
						<div class="col-md-6 column" style="text-align: center">
							<img style="height:160px;width: 280px" alt="豪华套间"
								src="pic/super.jpg" />
						</div>
						<div class="col-md-6 column"
							style="border-bottom:2px dashed #bdcbc2">
							<h4>
								<li>豪华套间：</li>
							</h4>
							<h5>
								<span class="glyphicon glyphicon-hand-right" aria-hidden="true"></span>
								可住2人<br> <span class="glyphicon glyphicon-ok-circle"
									aria-hidden="true"></span> 有窗，4层<br> <span
									class="glyphicon glyphicon-ok-circle" aria-hidden="true"></span>
								含早，有独立客厅<br> <span class="glyphicon glyphicon-ok-circle"
									aria-hidden="true"></span> 有独卫，24小时提供热水<br> <span
									class="glyphicon glyphicon-ok-circle" aria-hidden="true"></span>
								有空调、电视，且24小时不断网<br>
							</h5>
							<div style="margin-left: 240px">
								<button type="button" class="btn btn-default"
									data-toggle="modal" data-target="#bookModal">
									<span class="glyphicon glyphicon-yen" aria-hidden="true">288元/夜
										预订</span>
								</button>
							</div>
						</div>
					</div>
					-->
				</div>
				<div class="col-md-4 column" style="position:relative">
					<div class="row clearfix">
						<div class="col-md-2 column"></div>
						<div class="col-md-8 column">
							<div style="text-align: center">
								<img style="width: 80px;height: 80px" alt="140x140"
									src="pic/timg.jpg" class="img-circle" />
							</div>
							<div class="row clearfix" style="margin-top: 10px">

								<c:choose>
									<c:when test="${!empty sessionScope.user }">
										<div id="ii" style="text-align: center">
											<button class="btn btn-default">
												<span class="glyphicon glyphicon-user"> <a
													href="person.jsp" id="${sessionScope.user.id}"
													userName="${sessionScope.user.user}" class="loginUserId">个人中心</a>
												</span>
											</button>
											<button class="btn btn-default">
												<span class="glyphicon glyphicon-off"><a
													href="quit.do">退出</a></span>
											</button>
										</div>
									</c:when>

									<c:otherwise>
										<div id="dd">
											<div class="col-md-5 column" style="margin-left: 35px">
												<span class="hide ifSuccess">${success}</span>
												<button id="user" type="button" class="btn btn-default "
													data-toggle="modal" data-target="#myModal">登录</button>
											</div>
											<div class="col-md-2 column"></div>
											<div class="col-md-5 column">
												<button type="button" class="btn btn-default"
													onclick="window.open('reg.jsp')">注册</button>
											</div>
										</div>
									</c:otherwise>
								</c:choose>




							</div>
						</div>
						<div class="col-md-2 column"></div>
					</div>
					<div class="row clearfix" style="margin-top:30px;margin-left: 30px">
						<div class="col-md-12 column">
							<h4>
								<ul>
									<li>我也不知道这块要做什么内容</li>
									<li>那就随便写一点吧</li>
									<li>等我有想法了再做修改吧</li>
									<li>今天仰恩风很大</li>
									<li>差点就被吹走了</li>
									<li>然而我很清楚</li>
									<li>就算树都吹倒了</li>
									<li>我也吹不走</li>
									<li>好像还是很空</li>
									<li>那就多写两句吧</li>
									<li>晚安</li>
									<li>好梦</li>
									<li>good night</li>
								</ul>
							</h4>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
			aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">用户登录</h4>
					</div>
					<div class="modal-body">
						<div class=" col-md-6 col-sm-offset-3">
							<div class="form-horizontal" action="login.do" method="post">
								<div class="form-group  has-feedback">
									<div class="input-group">
										<span class="input-group-addon"><span
											class="glyphicon glyphicon-user"></span></span> <input type="text"
											class="form-control" id="userName" name="g_tel"
											aria-describedby="inputGroupSuccess1Status"
											placeholder="请输入账号" required>
									</div>
								</div>
								<div class="form-group  has-feedback">
									<div class="input-group">
										<span class="input-group-addon"><span
											class="glyphicon glyphicon-lock"></span></span> <input
											type="password" class="form-control" id="userPass"
											name="g_pass" aria-describedby="inputGroupSuccess1Status"
											placeholder="请输入密码" required>
									</div>
								</div>
								<div class="form-group">
									<div class="col-sm-offset-2 col-sm-10">
										<button type="submit" id="userLogin" class="btn btn-default">登录</button>
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer"></div>
					</div>
				</div>
			</div>
		</div>
		<span class="hide mana">${mana}</span>
		<div class="modal fade" id="maneModal" tabindex="-1" role="dialog"
			aria-labelledby="maneModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="maneModalLabel">管理员登录</h4>
					</div>
					<div class="modal-body">
						<div class=" col-md-6 col-sm-offset-3">
							<div class="form-horizontal">
								<div class="form-group  has-feedback">
									<div class="input-group">
										<span class="input-group-addon"><span
											class="glyphicon glyphicon-user"></span></span> <input type="text"
											class="form-control" id="adminName" name="m_num"
											aria-describedby="inputGroupSuccess1Status"
											placeholder="请输入管理员帐号" required>
									</div>
								</div>
								<div class="form-group  has-feedback">
									<div class="input-group">
										<span class="input-group-addon"><span
											class="glyphicon glyphicon-lock"></span></span> <input
											type="password" class="form-control" id="adminPass"
											name="m_pwd" aria-describedby="inputGroupSuccess1Status"
											placeholder="请输入密码" required>
									</div>
								</div>
								<div class="form-group">
									<div class="col-sm-offset-2 col-sm-10">
										<button class="btn btn-default adminLogin">登录</button>
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer"></div>
					</div>
				</div>
			</div>
		</div>
		<div class="modal fade" id="bookModal" tabindex="-1" role="dialog"
			aria-labelledby="bookModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="bookModalLabel">房间预订</h4>
					</div>
					<div class="modal-body">
						<div class=" col-md-6 col-sm-offset-3">
							<div class="form-horizontal"">
								<div class="form-group  has-feedback">
									<div class="input-group">
										<span class="reservationHotelId hide"></span> <label>房间类型：<span
											class="reservationType"><span></label> <br> <label>价格：<span
											class="reservationPrice"><span></label>
									</div>
								</div>
								<div class="form-group  has-feedback">
									<div class="input-group">
										<label>入住人姓名：</label> <input type="text"
											class="form-control reservationName" name="g_name"
											aria-describedby="inputGroupSuccess1Status"
											placeholder="请输入入住人姓名" required>
									</div>
								</div>
								<div class="form-group  has-feedback">
									<div class="input-group">
										<label>入住人联系方式：</label> <input type="text"
											class="form-control reservationPhone" name="g_tell"
											aria-describedby="inputGroupSuccess1Status"
											placeholder="请输入入住人联系方式">
									</div>
								</div>
								<div class="form-group  has-feedback">
									<div class="input-group">
										<label data-spm-anchor-id="inTime">入住时间：</label> <select
											id="J_Year" name="_fm.b._0.y" data-spm-anchor-id="inTime">

											<option value="2018">2018</option>
											<option value="2019">2019</option>
										</select> <select id="J_Month" name="_fm.b._0.m">

											<option value="1">1</option>
											<option value="2">2</option>
											<option value="3">3</option>
											<option value="4">4</option>
											<option value="5">5</option>
											<option value="6">6</option>
											<option value="7">7</option>
											<option value="8">8</option>
											<option value="9">9</option>
											<option value="10">10</option>
											<option value="11">11</option>
											<option value="12">12</option>
										</select> <select id="J_Date" name="_fm.b._0.d">

											<option value="1">1</option>
											<option value="2">2</option>
											<option value="3">3</option>
											<option value="4">4</option>
											<option value="5">5</option>
											<option value="6">6</option>
											<option value="7">7</option>
											<option value="8">8</option>
											<option value="9">9</option>
											<option value="10">10</option>
											<option value="11">11</option>
											<option value="12">12</option>
											<option value="13">13</option>
											<option value="14">14</option>
											<option value="15">15</option>
											<option value="16">16</option>
											<option value="17">17</option>
											<option value="18">18</option>
											<option value="19">19</option>
											<option value="20">20</option>
											<option value="21">21</option>
											<option value="22">22</option>
											<option value="23">23</option>
											<option value="24">24</option>
											<option value="25">25</option>
											<option value="26">26</option>
											<option value="27">27</option>
											<option value="28">28</option>
											<option value="29">29</option>
											<option value="30">30</option>
											<option value="31">31</option>
										</select><br>
									</div>
								</div>
								<div class="form-group  has-feedback">
									<div class="input-group">
										<label data-spm-anchor-id="outTime">离店时间：</label> <select
											id="Year" name="_fm.b._0.y" data-spm-anchor-id="outTime">

											<option value="2018">2018</option>
											<option value="2018">2019</option>
										</select> <select id="Month" name="_fm.b._0.m">

											<option value="1">1</option>
											<option value="2">2</option>
											<option value="3">3</option>
											<option value="4">4</option>
											<option value="5">5</option>
											<option value="6">6</option>
											<option value="7">7</option>
											<option value="8">8</option>
											<option value="9">9</option>
											<option value="10">10</option>
											<option value="11">11</option>
											<option value="12">12</option>
										</select> <select id="Date" name="_fm.b._0.d">

											<option value="1">1</option>
											<option value="2">2</option>
											<option value="3">3</option>
											<option value="4">4</option>
											<option value="5">5</option>
											<option value="6">6</option>
											<option value="7">7</option>
											<option value="8">8</option>
											<option value="9">9</option>
											<option value="10">10</option>
											<option value="11">11</option>
											<option value="12">12</option>
											<option value="13">13</option>
											<option value="14">14</option>
											<option value="15">15</option>
											<option value="16">16</option>
											<option value="17">17</option>
											<option value="18">18</option>
											<option value="19">19</option>
											<option value="20">20</option>
											<option value="21">21</option>
											<option value="22">22</option>
											<option value="23">23</option>
											<option value="24">24</option>
											<option value="25">25</option>
											<option value="26">26</option>
											<option value="27">27</option>
											<option value="28">28</option>
											<option value="29">29</option>
											<option value="30">30</option>
											<option value="31">31</option>
										</select><br>
									</div>
								</div>
								<div class="form-group">
									<div class="col-sm-offset-2 col-sm-10">
										<button type="submit" class="btn btn-primary addReservation">确认预订</button>
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
