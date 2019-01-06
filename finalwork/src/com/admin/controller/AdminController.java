package com.admin.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.admin.page.Admin;
import com.admin.service.AdminService;

@Controller
public class AdminController {

	@Autowired
	private AdminService adminService;

	@RequestMapping("/adminLogin.do")
	@ResponseBody
	public Object adminLogin(Admin admin) {

		Map<String, Object> map = adminService.adminLogin(admin);

		return map;
	}

	/**
	 * 退出
	 * 
	 * @return
	 */
	@RequestMapping("adminQuit.do")
	public Object exit() {
		adminService.quit();
		return "redirect:show.jsp";
	}
}
