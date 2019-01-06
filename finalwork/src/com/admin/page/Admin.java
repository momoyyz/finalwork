package com.admin.page;

public class Admin {
	private int id;
	private String AdminName;// 用户名
	private String AdminPass;// 密码

	public String getAdminName() {
		return AdminName;
	}

	public void setAdminName(String adminName) {
		AdminName = adminName;
	}

	public String getAdminPass() {
		return AdminPass;
	}

	public void setAdminPass(String adminPass) {
		AdminPass = adminPass;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

}
