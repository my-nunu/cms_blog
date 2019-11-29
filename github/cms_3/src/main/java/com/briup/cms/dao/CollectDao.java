package com.briup.cms.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import com.briup.cms.bean.UserCollect;
import com.briup.cms.bean.UserLike;

//收藏的dao层
public interface CollectDao extends JpaRepository<UserCollect, Integer>{
	
	UserCollect findByUseridAndArticleid(Integer id, Integer articleId);

	@Transactional
	@Modifying
	@Query("update UserCollect set state = ?1 where userid=?2 and articleid=?3")
	void updateState(int state, Integer id, Integer articleId);

	List<UserCollect> findByUseridAndState(Integer userid, int state);
}
