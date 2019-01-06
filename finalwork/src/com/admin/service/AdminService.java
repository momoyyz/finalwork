package com.admin.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.admin.dao.AdminDao;
import com.admin.page.Admin;

@Service
public class AdminService {

	@Autowired
	private AdminDao adminDao;

	@Autowired
	private HttpSession session;

	/**
	 * 用户登录
	 * 
	 * @param user
	 * @return
	 */
	public Map<String, Object> adminLogin(Admin admin) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 查询用户
		List<Admin> adminLisy = adminDao.showAdmin(admin);
		// 查询到一条记录，说明登录成功
		if (adminLisy.size() == 1) {
			session.setAttribute("admin", adminLisy.get(0));
			session.setMaxInactiveInterval(60 * 5);
			map.put("user", adminLisy.get(0));
			map.put("static", "true");
			map.put("msg", "登录成功");
		} else {
			map.put("static", "false");
			map.put("msg", "用户名或密码错误");
		}
		return map;

	}

	/**
	 * 退出
	 * 
	 * @return
	 */
	public boolean quit() {
		if (session.getAttribute("admin") != null) {
			session.invalidate();
			return true;
		} else {
			return false;
		}
	}

}
