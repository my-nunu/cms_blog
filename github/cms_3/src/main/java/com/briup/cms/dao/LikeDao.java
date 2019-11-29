package com.briup.cms.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import com.briup.cms.bean.UserLike;

//点赞 的 dao层
public interface LikeDao 
	extends JpaRepository<UserLike, Integer>{
	/**
	 * 通过用户id 和文章id 查询历史点赞信息
	 * */
	UserLike findByUseridAndArticleid(Integer id, Integer articleId);
	
	/**
	 * 使用用户id 和 文章 id  更新状态<br>
	 * state 1 : 点赞<br>
	 * state 2 : 未点赞<br>
	 * */
	@Transactional
	@Modifying
	@Query("update UserLike set state = ?1 where userid=?2 and articleid=?3")
	void updateState(int state, Integer id, Integer articleId);

	List<UserLike> findByUseridAndState(Integer userid, int state);
	
	
	
	
	
	
	
	
}
