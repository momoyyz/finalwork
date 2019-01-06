package com.user.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.user.page.UserPage;
import com.user.service.UserService;
import com.utils.JsonUtil;

@Controller
public class UserController {

	@Autowired
	private UserService userService;

	@RequestMapping("/login.do")
	@ResponseBody
	public Object login(UserPage user) {

		Map<String, Object> map = userService.loginService(user);

		return map;
	}

	/**
	 * 退出
	 * 
	 * @return
	 */
	@RequestMapping("quit.do")
	public Object exit() {
		userService.quit();

		return "redirect:show.jsp";
	}

	@RequestMapping("updataPass.do")
	@ResponseBody
	public Object updataPass(UserPage user) {
		String data = "";

		try {
			Map<String, Object> map = new HashMap<String, Object>();
			if (userService.updataPass(user)) {
				map.put("static", "success");
			} else {
				map.put("static", "error");
			}
			data = JsonUtil.toJson(map);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return data;
	}

	@RequestMapping("updataInformation.do")
	@ResponseBody
	public Object updataInformation(UserPage user) {
		String data = "";

		try {
			Map<String, Object> map = new HashMap<String, Object>();
			if (userService.updataInformation(user) == 1) {
				map.put("static", "success");
			} else {
				map.put("static", "error");
			}
			data = JsonUtil.toJson(map);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return data;
	}

	@RequestMapping("showUser.do")
	@ResponseBody
	public UserPage showUser(UserPage user) {
		return userService.showUser(user);
	}

	/**
	 * 注册
	 * 
	 * @param user
	 * @return
	 */
	@RequestMapping("reg.do")
	@ResponseBody
	public Object reg(UserPage user) {
		String data = "";

		try {
			Map<String, Object> map = new HashMap<String, Object>();
			if (userService.addUser(user) == 1) {
				map.put("static", "success");
			} else {
				map.put("static", "error");
			}
			data = JsonUtil.toJson(map);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return data;
	}
}
