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
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<title>个人中心</title>
<script src="bootstrap-3.3.7/jquery.min.js"></script>
<link rel="stylesheet" href="bootstrap-3.3.7/css/bootstrap.css">
<script src="bootstrap-3.3.7/js/bootstrap.js"></script>
<script>
	$(function() {
		/**
		 *原来判断是否登录  loginId只有登录后才存在 这样判断不靠谱，但是简单，怒存在直接跳转到show.jsp
		 */
		var loginId = $(".loginUserId").attr("id");
		if (!loginId) {
			window.location.replace("show.jsp");
		}
		/**
		 *修改密码
		 */
		updataPass();

		/**
		 *获取预定信息
		 */
		getReservation();

		/**
		 *按钮事件（点击为取消预定）
		 *on()方法说明：
		 *第一个参数：事件，click为点击事件
		 *第二个为选择器，选择要点击事件的标签
		 *第三个就是就是点击事件执行的函数
		 */
		$(document).on("click", ".cancelReservation", cancelReservation);
		/**
		 *获取用户信息-》编辑信息前。要先获取用户信息
		 */
		showUser();
		/**
		 *编辑信息（点击“提交”执行的函数）
		 */
		updataInformation();
	});
	/**
	 * 修改密码
	 */
	function updataPass() {
		$("#updataUserPass").click(function() {
			var userPass = $("#userPass").val();
			var newPass1 = $("#newPass1").val();
			var newPass2 = $("#newPass2").val();

			if (newPass1 != newPass2) {
				alert("两次新密码输入不一致");

			} else {

				$.ajax({
					url : "updataPass.do",
					type : "post",
					data : {
						pass : userPass,
						newPass : newPass1
					},
					dataType : "json",
					success : function(json) {
						if (json.static == "success") {
							/*
							 *修改成功后：
							 */
							//关闭静态框
							$('#modal-container-630938').modal('hide')
							alert("修改成功，请重新登录！");
							window.location.replace("show.jsp");
						} else {
							alert("修改失败，可能是密码错误。");
						}
					},

					error : function() {
						alert("发生系统级错误！");
					}
				});
			}

		});
	}
	/**
	 * 按用户id 获取自己的预定信息
	 */
	function getReservation() {
		$.ajax({
			url : "getReservation.do",
			type : "post",
			data : {
				userId : $(".loginUserId").attr("id")
			},
			dataType : "json",
			success : function(json) {
				//显示数据
				showReservation(json);
			},

			error : function() {
				alert("发生系统级错误！");
			}
		});
	}
	/**
	 * 显示预定信息
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
								html += '<td>         ';
								if (this.reservationStatic == "提交") {
									html += '	<button id="'+this.reservationId+'" hId="'+this.hotelId+'" class="btn btn-primary cancelReservation">取消</button>        ';
								} else if (this.reservationStatic == "已确认") {
									html += '<button type="button" class="btn btn-primary" disabled="disabled">已确认</button>';
								} else if (this.reservationStatic == "已取消") {
									html += '<button type="button" class="btn btn-danger" disabled="disabled">已被取消</button>';
								}
								html += '</td>         ';
								html += '</tr>                  ';
							});
		}

		$(".showReservation").append(html);
	}
	/**
	 * 取消预定
	 */
	function cancelReservation() {
		var reservationId = $(this).attr("id");
		//如果已经是“已取消”，则不操作
		if ($(".cancel" + reservationId).html() == "已取消") {
			return;
		}
		var hotelId = $(this).attr("hId");
		$.ajax({
			url : "cancelReservation.do",
			type : "post",
			data : {
				reservationId : reservationId,
				hotelId : hotelId
			},
			dataType : "json",
			success : function(json) {
				if (json.static == "success") {
					/*
					 *取消成功后，重新获取数据
					 */
					getReservation();
				} else {
					alert("取消失败");
				}
			},

			error : function() {
				alert("发生系统级错误！");
			}
		});

	}
	/**
	 * 显示用户数据
	 */
	function showUser() {

		$.ajax({
			url : "showUser.do",
			type : "post",
			data : {
				id : $(".loginUserId").attr("id"),

			},
			dataType : "json",
			success : function(json) {
				/*
				 *显示在对应的文本框中
				 */
				$(".userNickName").val(json.userNickName);
				$(".userSex").val(json.userSex);
				$(".userRealName").val(json.userRealName);
				/*
				 *要多返回的“生日”进行处理
				 *如：userBirthday=2018-1-1
				 *要分成年、月、日才可以显示在对应的文本框中（很坑爹，你为何要把三个年月日放进三个中……）
				 *
				 *用formattingDate()函数进行处理
				 */
				$("#J_Year").val(formattingDate(json.userBirthday, "year"));
				$("#J_Month").val(formattingDate(json.userBirthday, "month"));
				$("#J_Date").val(formattingDate(json.userBirthday, "date"));

				$(".userPhone").val(json.phone);

			},

			error : function() {

			}
		});
	}
	/**
	 * 格式化生日数据
	 */
	function formattingDate(date, typeDate) {
		var arr = date.split('-');
		if (typeDate == "year") {
			return arr[0];
		} else if (typeDate == "month") {
			return arr[1];
		} else if (typeDate == "date") {
			return arr[2];
		}
	}
	/**
	 * 编辑信息
	 */
	function updataInformation() {

		$(".updataInformation").click(function() {
			var userNickName = $(".userNickName").val();
			var userSex = $(".userSex").val();
			var userRealName = $(".userRealName").val();
			/*
			 *生日 （和上面同理，获取生日的时候，也要一个个获取，分别获取年、月、日后再进行拼接）
			 */
			var year = $("#J_Year").val();
			var month = $("#J_Month").val();
			var date = $("#J_Date").val();
			var userBirthday = year + "-" + month + "-" + date;

			var userPhone = $(".userPhone").val();

			$.ajax({
				url : "updataInformation.do",
				type : "post",
				data : {
					id : $(".loginUserId").attr("id"),
					userNickName : userNickName,
					userSex : userSex,
					userRealName : userRealName,
					userBirthday : userBirthday,
					phone : userPhone
				},
				dataType : "json",
				success : function(json) {
					if (json.static == "success") {
						/*
						 *提交成功后。重获取数据
						 */
						showUser();
					}

				},

				error : function() {
					alert("发生系统级错误！");
				}
			});
		});

	}

	/**
	 * 原有
	 */
	function xx() {
		$("#xinxi").removeClass("hide");
		$("#biaoge").addClass("hide");
		$("#bg").css("color", "black");
		$("#xx").css("color", "");
	}
	function bg() {
		$("#biaoge").removeClass("hide");
		$("#xinxi").addClass("hide");
		$("#xx").css("color", "black");
		$("#bg").css("color", "");
	}
</script>
</head>
<body>
	<div class="container" style="margin-top: 5%">
		<div class="row clearfix">
			<div class="col-md-3 column"
				style="text-align: center;border-right: solid 2px black">
				<div>
					<img style="width: 80px;height: 80px" alt="140x140"
						src="pic/timg.jpg" class="img-circle" />
					<p>
						<a href="show.jsp" style="color:black">点击返回首页</a>
					</p>
				</div>
				<a onclick="xx()" id="xx" role="button" class="btn"><h4>
						<span class="glyphicon glyphicon-edit"> 信息编辑</span>
					</h4></a><br> <a id="modal-630938" href="#modal-container-630938"
					role="button" class="btn" data-toggle="modal" style="color: black">
					<h4>
						<span class="glyphicon glyphicon-cog"> 修改密码</span>
					</h4>
				</a><br> <a onclick="bg()" id="bg" role="button" class="btn"
					style="color: black"><h4>
						<span class="glyphicon glyphicon-search"> 订单查询</span>
					</h4></a>
				<h4>
					<span class="glyphicon glyphicon-menu-left"> <a
						href="quit.do" id="${sessionScope.user.id}"
						userName="${sessionScope.user.user}" class="loginUserId">退出</a></span>
				</h4>
				<div class="modal fade" id="modal-container-630938" role="dialog"
					aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"
									aria-hidden="true">×</button>
								<h4 class="modal-title" id="myModalLabel">修改密码</h4>
							</div>
							<div class="modal-body">
								<div class=" col-md-6 col-sm-offset-3">
									<div class="form-horizontal">
										<div class="form-group  has-feedback">
											<div class="input-group">
												<span class="input-group-addon"><span
													class="glyphicon glyphicon-lock"></span></span> <input
													id="userPass" type="text" class="form-control"
													name="g_pass" aria-describedby="inputGroupSuccess1Status"
													placeholder="请输入原密码" required>
											</div>
										</div>
										<div class="form-group  has-feedback">
											<div class="input-group">
												<span class="input-group-addon"><span
													class="glyphicon glyphicon-lock"></span></span> <input
													id="newPass1" type="password" class="form-control"
													name="g_newPass"
													aria-describedby="inputGroupSuccess1Status"
													placeholder="请输入新密码" required>
											</div>
										</div>
										<div class="form-group  has-feedback">
											<div class="input-group">
												<span class="input-group-addon"><span
													class="glyphicon glyphicon-lock"></span></span> <input
													id="newPass2" type="password" class="form-control"
													name="againPass"
													aria-describedby="inputGroupSuccess1Status"
													placeholder="请输入新密码" required>
											</div>
										</div>
										<div class="form-group">
											<div class="col-sm-offset-2 col-sm-10">
												<button id="updataUserPass" class="btn btn-default">确认修改</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="modal-footer"></div>
						</div>
					</div>

				</div>
			</div>
			<div class="col-md-1 column"></div>
			<div class="col-md-8 column">
				<div class="row clearfix">
					<div id="xinxi" class="col-md-5 column"
						style="background-color: #d1d3d4;padding: 20px 50px 20px 50px">
						<div role="form">
							<div class="form-group">
								<label>用户昵称：</label><input type="text" name="g_name"
									class="form-control userNickName"
									aria-describedby="inputGroupSuccess1Status" required><br>
								<label>性别：</label><input type="text" name="g_sex"
									class="form-control userSex"
									aria-describedby="inputGroupSuccess1Status" required><br>
								<label>真实姓名：</label><input type="text" name="g_rname"
									class="form-control userRealName"
									aria-describedby="inputGroupSuccess1Status"><br> <label
									data-spm-anchor-id="0.0.0.i3.1b993d15p1p5Pm">生日：</label> <select
									id="J_Year" name="_fm.b._0.y"
									data-spm-anchor-id="0.0.0.i0.1b993d15p1p5Pm">
									<option value="1940">1940</option>
									<option value="1941">1941</option>
									<option value="1942">1942</option>
									<option value="1943">1943</option>
									<option value="1944">1944</option>
									<option value="1945">1945</option>
									<option value="1946">1946</option>
									<option value="1947">1947</option>
									<option value="1948">1948</option>
									<option value="1949">1949</option>
									<option value="1950">1950</option>
									<option value="1951">1951</option>
									<option value="1952">1952</option>
									<option value="1953">1953</option>
									<option value="1954">1954</option>
									<option value="1955">1955</option>
									<option value="1956">1956</option>
									<option value="1957">1957</option>
									<option value="1958">1958</option>
									<option value="1959">1959</option>
									<option value="1960">1960</option>
									<option value="1961">1961</option>
									<option value="1962">1962</option>
									<option value="1963">1963</option>
									<option value="1964">1964</option>
									<option value="1965">1965</option>
									<option value="1966">1966</option>
									<option value="1967">1967</option>
									<option value="1968">1968</option>
									<option value="1969">1969</option>
									<option value="1970">1970</option>
									<option value="1971">1971</option>
									<option value="1972">1972</option>
									<option value="1973">1973</option>
									<option value="1974">1974</option>
									<option value="1975">1975</option>
									<option value="1976">1976</option>
									<option value="1977">1977</option>
									<option value="1978">1978</option>
									<option value="1979">1979</option>
									<option value="1980">1980</option>
									<option value="1981">1981</option>
									<option value="1982">1982</option>
									<option value="1983">1983</option>
									<option value="1984">1984</option>
									<option value="1985">1985</option>
									<option value="1986">1986</option>
									<option value="1987">1987</option>
									<option value="1988">1988</option>
									<option value="1989">1989</option>
									<option value="1990">1990</option>
									<option value="1991">1991</option>
									<option value="1992">1992</option>
									<option value="1993">1993</option>
									<option value="1994">1994</option>
									<option value="1995">1995</option>
									<option value="1996">1996</option>
									<option value="1997">1997</option>
									<option value="1998">1998</option>
									<option value="1999">1999</option>
									<option value="2000">2000</option>
									<option value="2001">2001</option>
									<option value="2002">2002</option>
									<option value="2003">2003</option>
									<option value="2004">2004</option>
									<option value="2005">2005</option>
									<option value="2006">2006</option>
									<option value="2007">2007</option>
									<option value="2008">2008</option>
									<option value="2009">2009</option>
									<option value="2010">2010</option>
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
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
								</select><br> <label style="margin-top: 15px">联系方式：</label><input
									type="text" name="g_tel2" class="form-control userPhone"
									aria-describedby="inputGroupSuccess1Status"><br>
							</div>
							<button style="margin-left: 20px" type="submit"
								class="btn btn-default updataInformation">提交</button>
						</div>
					</div>
					<div id="biaoge" class="row clearfix hide" style="margin-top: 5px">
						<div class="col-md-12 column">
							<table class="table table-bordered table-hover">
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
			</div>
		</div>
	</div>
	</div>
</body>
</html>
