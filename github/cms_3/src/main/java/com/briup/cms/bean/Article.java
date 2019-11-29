package com.briup.cms.bean;


import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;
/**
 * 文章
 * */
@Data
@Entity
public class Article {
	@Id
	@GeneratedValue
	private Integer id;
	// 标题
	private String title;
	// 内容 : 包含html的内容
	private String content;
	// 简介 : 不包含html的内容
	private String summary;
	// 背景音乐路径
	private String music;
	// 视频资讯路径
	private String video;
	// 封面图片路径
	private String img;
	// 发布时间
	private Date dob;
	// 点赞量
	private Integer click;
	// 阅读量
	private Integer rea;
	// 收藏量
	private Integer collect;
	
	//所属栏目id
	private Integer categoryid;

	// 是否审核通过 : 0 未审核 , 1 审核通过 ,2 审核不通过  3,举报审核不通过
	private Integer state;
	
	// 作者 : 某一个用户的名字
	private String author;
	// 作者的 id : 后期用来查询当前文章属于哪个用户
	private Integer userid;
	//所属于的栏目名
	private String categoryname;
	
	
}
