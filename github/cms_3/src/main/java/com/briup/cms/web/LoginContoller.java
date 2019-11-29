package com.briup.cms.web;

import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.data.web.SpringDataWebProperties.Sort;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;
import org.springframework.data.domain.ExampleMatcher.StringMatcher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.briup.cms.bean.Article;
import com.briup.cms.bean.User;
import com.briup.cms.dao.ArticleDao;
import com.briup.cms.dao.CategoryDao;
import com.briup.cms.dao.UserDao;

import io.swagger.annotations.ApiOperation;
/**
 * 注册登入操作
 * */
@Controller
public class LoginContoller {

	@Autowired
	private UserDao userDao;
	@Autowired
	private CategoryDao cateDao;
	@Autowired
	private ArticleDao arDao;
	
	@RequestMapping(value = "/findUserByAccount",method = RequestMethod.GET)
	public void findUserByAccount(String account,OutputStream out) throws Exception {
		User user = userDao.findByAccount(account);
		if(user==null) {
			out.write("ok".getBytes());
		}else {
			out.write("error".getBytes());
		}
		out.flush();
		out.close();
	}
	
	@RequestMapping(value = "/register",method = RequestMethod.POST)
	public String register(User u,Model model) {
		u.setNickname(u.getAccount());
		userDao.save(u);
		return "redirect:/login.jsp";
	}
	
	@RequestMapping(value = "/login",method = RequestMethod.POST)
	public String login(User u,RedirectAttributes ra,HttpSession session) {
		
		User user = userDao.findByAccountAndPassword(u.getAccount(),u.getPassword());
		if(user==null) {
			//用户名或密码错误 登入失败
			ra.addFlashAttribute("msg", "用户名或密码错误");
			return "redirect:/login.jsp";
		}
		session.setAttribute("loginUser", user);
		return "redirect:/user_page";
	}
	
	@RequestMapping(value = "/user_page",method = RequestMethod.GET)
	public String user_page(HttpSession session) {
		Object loginUser = session.getAttribute("loginUser");
		if(loginUser!=null) {
			User u = (User) loginUser;
			if(u.getRole()==0) {//管理员
				return "/admin/adminIndex.jsp";
			}else {//普通用户
				return "/user/userIndex.jsp";
			}
		}
		return "redirect:/login.jsp";
	}
	
	
	
	
	
	
	//测试分页
	@ApiOperation("测试分页")
	@RequestMapping(value = "/toUp",method = RequestMethod.GET)
	public String toUp(@RequestParam(defaultValue = "0") Integer page,Model model) {
		PageRequest pageable = PageRequest.of(page, 1);
		
		//查找id位1的用户下 所有的文章
		Article a = new Article();
		a.setUserid(1);
		
		
		 ExampleMatcher matcher = ExampleMatcher
				 	.matching().withMatcher("userid", ExampleMatcher.GenericPropertyMatchers.startsWith()).withIgnoreNullValues();
		
		Example<Article> e = Example.of(a,matcher);
		Page<Article> list = arDao.findAll(e, pageable);
		model.addAttribute("page", list);
		return "forward:/up.jsp";
	}
	
	//测试 上传图片
	@ApiOperation("上传图片")
	@RequestMapping(value = "/u",method = RequestMethod.GET)
	public String u(HttpServletRequest request) throws Exception {
		Part part = request.getPart("myfile");
		
		part.write("D://a.jpg");
		
		return "redirect:/up.jsp";
	}
	
	
	
	@RequestMapping(value = "/path",method = RequestMethod.GET)
	public String path(HttpServletRequest request) {
		String realPath = request.getRealPath("/");
		System.out.println("测试路径:"+realPath);
		
		return "redirect:/up.jsp";
	}
	
	
	
	
	
	
	@RequestMapping(value = "/del",method = RequestMethod.GET)
	public String del() {
		cateDao.deleteByCategoryid(1);
		return "redirect:/index.jsp";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
