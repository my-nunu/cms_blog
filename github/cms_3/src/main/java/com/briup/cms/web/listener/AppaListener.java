package com.briup.cms.web.listener;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.springframework.beans.factory.annotation.Autowired;

import com.briup.cms.bean.Category;
import com.briup.cms.dao.CategoryDao;

@WebListener
public class AppaListener implements ServletContextListener {
	@Autowired
	private CategoryDao cateDao;
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		
		ServletContext app = sce.getServletContext();
		List<Category> oneCate = cateDao.findByCategoryidIsNull();
		
		Map<Category, List<Category>> map = new HashMap<>();
		
		for(Category c: oneCate) {
			List<Category> twoCate = cateDao.findByCategoryid(c.getId());
			map.put(c, twoCate);
		}
		app.setAttribute("categoryList", map);
		System.out.println("查询到 所有列表 "+map);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
