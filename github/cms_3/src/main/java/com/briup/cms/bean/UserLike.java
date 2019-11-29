package com.briup.cms.bean;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

//点赞
@Data
@Entity
@Table(name = "userlike")
public class UserLike implements Serializable{
	@Id
	@GeneratedValue
	private Integer id;
	//文章id : 逻辑外键
	private Integer articleid;
	//用户id : 逻辑外键 
	private Integer userid;
	//点赞的状态: 1 点赞   2 没有点赞
	private Integer state;
	
}












