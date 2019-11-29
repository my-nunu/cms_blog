package com.briup.cms.bean;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;

/**
 * 
 * 栏目
 * */
@Data
@Entity
public class Category {
	@Id
	@GeneratedValue
	private Integer id;
	private String name;
	//栏目的描述信息
	private String info;
	//父级id
	private Integer categoryid;
	
}
