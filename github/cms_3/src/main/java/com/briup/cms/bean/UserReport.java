package com.briup.cms.bean;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;

//举报
@Entity
@Data
public class UserReport implements Serializable{
	
	@Id
	@GeneratedValue
	private Integer id;
	private Integer userid;//用户id
	private Integer articleid;//文章id
	private String type;//举报文章类型
	private String reportcontent;//举报原因
	private Date reportdob;//举报时间
	private String title;//举报文章标题
	private String nickname;//举报的用户名
	private String resultcontent;//处理结果内容
	private Date resultdob;//处理时间
	private Integer state;//举报状态 
}
