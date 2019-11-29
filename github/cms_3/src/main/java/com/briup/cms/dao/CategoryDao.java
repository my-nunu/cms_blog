package com.briup.cms.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import com.briup.cms.bean.Category;

public interface CategoryDao extends JpaRepository<Category, Integer>{

	List<Category> findByCategoryidIsNull();

	List<Category> findByCategoryid(Integer id);
	
	//categoryId一级栏目id
	@Transactional
	@Modifying
	void deleteByCategoryid(Integer categoryId);

	
	@Transactional
	@Modifying
	@Query("delete Category where id = ?1")
	void deleteId(int id);
	
	
	
	
	
	
	
}
