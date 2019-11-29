package com.briup.cms.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import com.briup.cms.bean.Article;

public interface ArticleDao extends JpaRepository<Article, Integer>{
	
	//通过一级栏目id 查询所有的 文章
	@Query(value = "select * from article where state = 1 and  categoryid in (select id from category where categoryid = ?1)",nativeQuery = true)
	List<Article> findByOne(Integer categoryId);
	 /*
	 	
	 	一级栏目下 的所有二级栏目
	 	
	 	select id
	 	from category
	 	where categoryid = 1
	 	
	 	
	 	
	 	
	 
	 */


	List<Article> findByCategoryidAndState(Integer categoryId, int i);


	List<Article> findByUserid(Integer id);


	List<Article> findByStateOrderByClickDesc(int i);

	//使用id更新 文章的状态
	@Transactional
	@Modifying
	@Query("update Article set state=?2 where id = ?1")
	void updateStateById(int id, int state);

	/**
	  * 删除一级栏目的时候 级联删除一级栏目下所有的文章信息
	 * */
	@Transactional
	@Modifying
	@Query("delete Article where id in (select categoryid from Category where id = ?1)")
	void deleteByOneCategoryId(int i);

	/**
	 * 删除二级栏目下所有的文章信息<br>
	 * */
	@Transactional
	@Modifying
	@Query("delete Article where categoryid = ?1")
	void deleteByTwoCategoryId(int i);

	
	
	
	
	
	
	
	
	
}
