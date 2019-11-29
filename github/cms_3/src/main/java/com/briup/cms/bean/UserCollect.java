package com.briup.cms.bean;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;
//收藏
@Data
@Entity
@Table(name = "usercollect")
public class UserCollect implements Serializable{
	
	@Id
	@GeneratedValue
	private Integer id;
	//文章id : 逻辑外键
	private Integer articleid;
	//用户id : 逻辑外键 
	private Integer userid;
	//收藏的状态 1收藏 
	private Integer state;

}
