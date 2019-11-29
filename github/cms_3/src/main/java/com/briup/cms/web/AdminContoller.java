package com.briup.cms.web;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.briup.cms.bean.Article;
import com.briup.cms.bean.Category;
import com.briup.cms.bean.User;
import com.briup.cms.bean.UserReport;
import com.briup.cms.dao.ArticleDao;
import com.briup.cms.dao.CategoryDao;
import com.briup.cms.dao.ReportDao;
import com.briup.cms.dao.UserDao;

import io.swagger.annotations.ApiOperation;

/**
 * 管理员下的操作
 */
@Controller
@RequestMapping("/admin/")
public class AdminContoller {
	@Autowired
	private UserDao userDao;
	@Autowired
	private CategoryDao cateDao;
	@Autowired
	private ArticleDao arDao;
	@Autowired
	private ReportDao repDao;
	

/**
 *在每一个控制器执行前 都会 执行该方法，<br>
 *把数据库中最新的栏目信息查询放到模型中<br>
 *以便更新页面的显示<br>
 * */
@ModelAttribute(name = "categoryList")
public Map<Category, List<Category>> loadCategory() {
	List<Category> oneCate = cateDao.findByCategoryidIsNull();
	Map<Category, List<Category>> map = new HashMap<>();
	for(Category c: oneCate) {
		List<Category> twoCate = cateDao.findByCategoryid(c.getId());
		map.put(c, twoCate);
	}
	//app.setAttribute("categoryList", map);
	System.out.println("查询到 所有列表 "+map);
	return map;
}
	
	
	
	/**
	 * 传参要查看的资讯的状态,包括:0（待审核），1（审核通过），2（审核不通过），3（举报不通过），4（删除）
	 */
	@ApiOperation("传参要查看的资讯的状态")
	@RequestMapping(value = "/showArticleAdmin",method = RequestMethod.GET)
	public String showArticleAdmin(Integer state, Model model) {

		List<Article> articles = arDao.findByStateOrderByClickDesc(state);

		model.addAttribute("articles", articles);

		model.addAttribute("mark", state);// 页面上展示不同的图标

		articles.stream().forEach(System.out::println);

		if (state == 0) {
			System.out.println("待审核页面");
			return "/admin/page/ExamineingSub.jsp";
		} else if (state == 1) {
			System.out.println("正常资讯页面");
			return "/admin/page/ExaminedSub.jsp";
		} else {
			return "redirect:/index.jsp";
		}
	}

	/**
	 * 管理员 点击审核
	 * 
	 * @throws Exception
	 */
	@ApiOperation("管理员点击审核")
	@RequestMapping(value = "/examineArticle",method = RequestMethod.GET)
	public void examineArticle(String articleIds, Integer state, OutputStream out) throws Exception {

		if (articleIds.indexOf(",") != -1) {// 批量审核
			String[] split = articleIds.split(",");
			for (String id : split) {
				arDao.updateStateById(Integer.parseInt(id), state);
			}
		} else {// 审核一个
			int arid = Integer.parseInt(articleIds);
			arDao.updateStateById(arid, state);
		}
		out.write("ok".getBytes());
		out.flush();
		out.close();
	}

	/**
	 * 点击栏目管理
	 */
	@ApiOperation("点击栏目管理")
	@RequestMapping(value = "/showCategoryList",method = RequestMethod.GET)
	public String showCategoryList(@RequestParam(defaultValue = "0") Integer page,Model model) {

		PageRequest pageable = PageRequest.of(page, 1);
		Page<Category> list = cateDao.findAll(pageable);
		model.addAttribute("page", list);

		return "/admin/page/categoryListSub.jsp";
	}

	
	
	
	/**
	 * 添加栏目<br>
	 * 修改栏目<br>
	 * @param cate 没有id值 是保存  。有id值是 更新
	 * 本次是ajax请求 需要用输出流 向外写数据，不要返回逻辑视图<br>
	 * @throws Exception 
	 * */
	@ApiOperation("添加栏目")
	@RequestMapping(value = "/addCategory",method = RequestMethod.GET)
	public void addCategory(Category cate,String parentid,OutputStream out) throws Exception {
		System.out.println("添加 和修改 栏目 : "+parentid);
		if(parentid!=null && !"no".equals(parentid)) {
			cate.setCategoryid(Integer.parseInt(parentid));
		}
		
		//保存到数据库
		cateDao.save(cate);
		
		out.write("ok".getBytes());
		out.flush();
		out.close();
	}
	
	/**
	 * 删除 栏目<br>
	 * 批量删除栏目<br>
	 * 
	 *     如果勾选了一级栏目，<br>
	 *     那么一级栏目被删除的时候，<br>
	 *     需要同时删除一级栏目下的所有二级栏目<Br>
	 *     栏目被删除了 ，栏目下的文章也要被删除<br>
	 *     或者 : 栏目被删除 ，栏目下的文章 逻辑外键值设置为null<br>
	 * */
	@ApiOperation("删除栏目")
	@RequestMapping(value = "/deleteCategory",method = RequestMethod.GET)
	public void deleteCategory(String categoryIds) {
		
		//判断 是否包含 ,  如果有,号是批量删除
		if(categoryIds.indexOf(",")!=-1) {//批量删除
			//1,2,3,6,7
			
			String[] split = categoryIds.split(",");
			for(String cateid : split) {
				
				int id = Integer.parseInt(cateid);
				
				//文章信息 都删了
				arDao.deleteByOneCategoryId(id);
				arDao.deleteByTwoCategoryId(id);
				
				//删除二级栏目 通过一级栏目id
				cateDao.deleteByCategoryid(id);
				//删除一级栏目
				cateDao.deleteId(id);
			}
		}else {//单个删除
			int id = Integer.parseInt(categoryIds);
			
			//文章信息 都删了
			arDao.deleteByOneCategoryId(id);
			arDao.deleteByTwoCategoryId(id);
			
			//删除二级栏目 通过一级栏目id
			cateDao.deleteByCategoryid(id);
			//删除一级栏目
			cateDao.deleteId(id);
		}
	}
	
	
	
	/**
	 * 管理员 页面  ： 显示所有被用户举报 并且没有处理的 文章信息<br>
	 * */
	@ApiOperation("删除栏目")
	@RequestMapping(value = "/showReportArticles",method = RequestMethod.GET)
	public String showReportArticles(Model model) {
		//把所有用户举报了 并且没有处理的 举报信息 和 对应的文章查询出来。
		
		Map<Article, UserReport> map = new HashMap<>();
		//所有状态为新建状态的举报信息
		List<UserReport> urs = repDao.findByState(1);
		for(UserReport u : urs) {
			Article article = arDao.findById(u.getArticleid()).get();
			map.put(article, u);
		}
		model.addAttribute("map", map);
		return "/admin/page/reportArticlesSub.jsp";
	}
	
	/**
	 * 管理员  查看所有 的举报信息 点击查看按钮<br>
	 * 加载 当前文章的举报信息<br>
	 * */
	@ApiOperation("查看所有的举报信息")
	@RequestMapping(value = "/showReportMessages",method = RequestMethod.GET)//和User控制器中 showUserReportMessage功能一样，是重复的，后期删掉
	@ResponseBody
	public UserReport showReportMessages(
			Integer reportid,HttpSession session) {
		UserReport report = repDao.findById(reportid).get();
		return report;
	}
	
/**
 * 点击查看举报信息<Br>
 * 审核 通过 和 不通过<br>
 * @param ur 已经接受了页面传递  的  articleid+state+resultcontent
 * @throws IOException 
 * */
	@ApiOperation("查看举报信息")
@RequestMapping(value = "/handleReport",method = RequestMethod.GET)
public void handleReport(UserReport ur,HttpSession session,OutputStream out) throws IOException {
	System.out.println("数据 :"+ur);
	UserReport report = repDao.findById(ur.getId()).get();
	//设置处理日期
	report.setResultdob(new Date());
	//设置处理内容
	report.setResultcontent(ur.getResultcontent());
	//设置最新的状态
	report.setState(ur.getState());
	//更新到数据库
	repDao.save(report);
	
	out.write("ok".getBytes());
	out.flush();
	out.close();
	
}
	
	/**
	 * 点击查看已处理信息
	 * 通过文章状态码判断,不为1的都代表处理过
	 */
	@ApiOperation("查看已处理信息")
	@RequestMapping(value = "/showProcessedArticles",method = RequestMethod.GET)
	public String showProcessedArticles(Model model) {
		
		Map<Article, UserReport> map = new HashMap<>();
			List<UserReport> urs = repDao.findByState(2);
			List<UserReport> urs1 = repDao.findByState(3);
			List<UserReport> urs2 = repDao.findByState(4);
			for(UserReport u : urs) {
				Article article = arDao.findById(u.getArticleid()).get();
				map.put(article, u);
			}
			for(UserReport u : urs1) {
				Article article = arDao.findById(u.getArticleid()).get();
				map.put(article, u);
			}
			for(UserReport u : urs2) {
				Article article = arDao.findById(u.getArticleid()).get();
				map.put(article, u);
			}
			model.addAttribute("map", map);
		return "/admin/page/processedArticlesSub.jsp";
	}
	
	
	  
	
	
	
	
}
