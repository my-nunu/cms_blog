package com.briup.cms.bean;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;

/**
 * 用户
 * */
@Data
@Entity
public class User {
	@Id
	@GeneratedValue
	private Integer id;
	//用户名:用于登入
	private String account;
	//密码
	private String password;
	//昵称
	private String nickname;
	//用户头像
	private String img;
	//是否为管理员 role = 0; 管理员;     role = 1; 普通用户
	private Integer role;
	
}
