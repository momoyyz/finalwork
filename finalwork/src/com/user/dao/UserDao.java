package com.user.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.user.page.UserPage;

@Repository
public interface UserDao {

	/**
	 * 注册(新增)
	 * 
	 * @param user
	 */
	public int addUser(UserPage user);

	/**
	 * 查询用户
	 * 
	 * @param user
	 * @return
	 */
	public List<UserPage> showUser(UserPage user);

	/**
	 * 修改密码
	 * 
	 * @param user
	 * @return
	 */
	public int updataPass(UserPage user);

	/**
	 * 编辑信息
	 * 
	 * @param user
	 * @return
	 */
	public int updataInformation(UserPage user);

}
