package com.admin.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.admin.page.Admin;

@Repository
public interface AdminDao {

	/**
	 * 查询用户
	 * 
	 * @param user
	 * @return
	 */
	public List<Admin> showAdmin(Admin admin);

}
