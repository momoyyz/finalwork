package com.user.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.omg.CORBA.UserException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.user.dao.UserDao;
import com.user.page.UserPage;

@Service
public class UserService {

	@Autowired
	private UserDao userDao;

	@Autowired
	private HttpSession session;

	/**
	 * 用户登录
	 * 
	 * @param user
	 * @return
	 */
	public Map<String, Object> loginService(UserPage user) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 查询用户
		List<UserPage> userLisy = userDao.showUser(user);
		// 查询到一条记录，说明登录成功
		if (userLisy.size() == 1) {
			session.setAttribute("user", userLisy.get(0));
			session.setMaxInactiveInterval(60 * 5);
			map.put("user", userLisy.get(0));
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
		if (session.getAttribute("user") != null) {
			session.invalidate();
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 修改密码
	 * 
	 * @param user
	 * @return
	 * @throws UserException
	 */
	public Boolean updataPass(UserPage user) {

		/*
		 * 获取session中的用户名
		 */
		@SuppressWarnings("unchecked")
		UserPage sessionUser = (UserPage) session.getAttribute("user");
		System.out.println("sessionUser:::::::::" + sessionUser);
		user.setId(sessionUser.getId());

		// 修改密码
		int num = userDao.updataPass(user);
		if (num == 1) {
			/*
			 * 清楚session
			 */
			session.invalidate();
			return true;
		}
		return false;

	}

	/**
	 * 修改信息
	 * 
	 * @param user
	 * @return
	 */
	public int updataInformation(UserPage user) {
		return userDao.updataInformation(user);
	}

	/**
	 * 查询信息
	 * 
	 * @param user
	 * @return
	 */
	public UserPage showUser(UserPage user) {
		return userDao.showUser(user).get(0);
	}

	/**
	 * 查询信息
	 * 
	 * @param user
	 * @return
	 */
	public int addUser(UserPage user) {
		return userDao.addUser(user);
	}
}
