package com.briup.cms.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.briup.cms.bean.UserReport;

//举报的dao层
public interface ReportDao extends JpaRepository<UserReport, Integer>{


	List<UserReport> findByUserid(Integer id);

	UserReport findByUseridAndArticleid(Integer id, Integer articleid);

	List<UserReport> findByState(int i);

}
