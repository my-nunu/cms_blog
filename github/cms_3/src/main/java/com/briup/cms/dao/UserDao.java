package com.briup.cms.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import com.briup.cms.bean.User;

public interface UserDao extends JpaRepository<User, Integer>{
	
	public User findByAccount(String account);

	public User findByAccountAndPassword(String account, String password);

}
