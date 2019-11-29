package com.briup.cms.web;

import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.briup.cms.bean.Article;
import com.briup.cms.bean.Category;
import com.briup.cms.bean.User;
import com.briup.cms.bean.UserCollect;
import com.briup.cms.bean.UserLike;
import com.briup.cms.bean.UserReport;
import com.briup.cms.dao.ArticleDao;
import com.briup.cms.dao.CategoryDao;
import com.briup.cms.dao.CollectDao;
import com.briup.cms.dao.LikeDao;
import com.briup.cms.dao.ReportDao;
import com.briup.cms.dao.UserDao;

import io.swagger.annotations.ApiOperation;
/**
 * 普通用户下的操作
 * */
@Controller
@RequestMapping("/user/")
public class UserController {
	@Autowired
	private UserDao userDao;
	@Autowired
	private CategoryDao cateDao;
	@Autowired
	private ArticleDao arDao;
	@Autowired
	private LikeDao likeDao;//点赞 dao
	@Autowired
	private CollectDao collDao;//收藏 dao
	@Autowired
	private ReportDao  repDao;//举报 dao
	
	
	
	
	/**
	 *在每一个控制器执行前 都会 执行该方法，<br>
	 *把数据库中最新的栏目信息查询放到模型中<br>
	 *以便更新页面的显示<br>
	 * */
	@ModelAttribute("categoryList")
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
	 * 点击二级栏目:查询对应所有文章
	 * */
	@ApiOperation("点击二级栏目:查询对应所有文章")
	@RequestMapping(value = "/showArticleList",method = RequestMethod.GET)
	public String showArticleList(String mark,Integer categoryId,HttpSession session,Model model) {
		List<Article> list = null;
		if("1".equals(mark)) {//这里的categoryId是一级栏目的id
			list = arDao.findByOne(categoryId);
			System.out.println(categoryId+"一级栏目下所有 文章 : "+list);
		}else {//这里的categoryId是二级栏目的id
			list = arDao.findByCategoryidAndState(categoryId,1);
			System.out.println(categoryId+"二级栏目下所有 文章 : "+list);
		}
		model.addAttribute("articleList", list);
		return "/user/page/articleListSub.jsp";
	}
	
	
	/**
	 * 点击我的发布
	 * */
	@ApiOperation("我的发布")
	@RequestMapping(value = "/showUserReleaseArticles",method = RequestMethod.GET)
	public String showUserReleaseArticles(HttpSession session,Model model) {
		User loginUser = (User) session.getAttribute("loginUser");
		List<Article> list = arDao.findByUserid(loginUser.getId());
		model.addAttribute("myArticles", list);
		return "/user/page/myPublishSub.jsp";
	}
	
	/**
	 * 点击热点资讯推荐
	 * */
	@ApiOperation("热点资讯推荐")
	@RequestMapping(value = "/showrecommendArticles",method = RequestMethod.GET)
	public String showrecommendArticles(HttpSession session,Model model) {
		// arDao.findAll(Sort.by("click").descending());
		List<Article> recommendArticles = arDao.findByStateOrderByClickDesc(1);
		
		model.addAttribute("recommendArticles", recommendArticles);
		return "/user/page/recommendSub.jsp";
	}
	/**
	 * 点击浏览文章<br>
	 * 需要 更新 文章的点击量<br>
	 * 需要使用Ｃｏｏｋｉｅ记录　历史浏览记录<br>
	 * cookie 的设计: history_用户id = 文章id,文章id,文章id,文章id
	 * 	value 值为 一个字符串，保存多个文章id值，使用英文,号隔开, 在左侧的是最新阅读的文章。
	 * 扩展点:管理员查看 点击量不加，普通用户查看才加
	 * */
	@ApiOperation("浏览文章")
	@RequestMapping(value = "/showArticle",method = RequestMethod.GET)
	public String showArticle(HttpServletRequest request,HttpServletResponse response,String articleId) throws UnsupportedEncodingException {
		
		User loginUser = (User) request.getSession().getAttribute("loginUser");
		//通过id查询的文章信息
		Article showArticle = arDao.findById(Integer.parseInt(articleId)).get();
		//更新文章的点击量 +1
		showArticle.setRea(showArticle.getRea()+1);
		arDao.save(showArticle);//更新
		
		System.out.println(articleId+"查找到的资讯"+showArticle);
		request.setAttribute("showArticle", showArticle);
		
		//---浏览记录
		Cookie[] cookies = request.getCookies();
		//应该添加的cookie值;
		String newValue = articleId;
		if(cookies!=null) {
			for(Cookie cookie : cookies) {
				if(cookie.getName().equals("history_"+loginUser.getId())) {
					//获取 以前的 历史 浏览 记录     2,3,4
					String historyValue = URLDecoder.decode(cookie.getValue(), "utf-8");
//					System.out.println("有浏览记录cookie，旧的："+historyValue);
					//替换字符串中已存在的cookie值，如第一次执行:2,或者多次执行后 1,5,6,2
					if(historyValue.equals(articleId)) {
//						System.out.println("才第二次访问，且与第一次访问相同的情况");
						newValue = historyValue;
//						historyCookie = new Cookie("history_"+loginUser.getId(), historyValue);
					}else if(historyValue.startsWith(articleId+",")) {
						//浏览记录不只一个，articleId在最左边的情况
						//不做处理
//						System.out.println("本身就是最新的");
						newValue = historyValue;
					}else if(historyValue.endsWith(","+articleId)) {
//						System.out.println("本身是最旧的");
						//浏览记录不只一个，articleId在最右边的情况
						//删除最后的，添加到最左边 1,2,3,4,5 
						newValue = articleId+","+historyValue.substring(0, historyValue.length()-1-articleId.length());
					}else{
//						System.out.println("在中间或者没有重复的");
						//浏览记录不只一个，articleId在中间的情况,或者没有重复
						newValue = articleId+","+historyValue.replace(","+articleId+",", ",");
					}
//					System.out.println("新的："+newValue);
					break;
				}
			}
		}
		Cookie historyCookie = 
			new Cookie("history_"+loginUser.getId(), 
					URLEncoder.encode(newValue, "utf-8"));
		
		historyCookie.setPath(request.getContextPath());
		historyCookie.setMaxAge(60*60*24*30);
		response.addCookie(historyCookie);
		
		
		
		//使用 用户id 和 文章id 查询 桥表 点赞表  得到点赞对象
		UserLike like = likeDao.findByUseridAndArticleid(
				loginUser.getId(), showArticle.getId());
		if(like==null) {
			//用户对该文章 是否点赞: 1 点赞   2 没有点赞
			request.setAttribute("isLike", 2);
		}else {
			request.setAttribute("isLike", like.getState());
		}
		
		
		//使用用户id 和 文章 id  查询桥表  收藏表 得到收藏对象
		UserCollect coll = collDao.findByUseridAndArticleid(loginUser.getId(),showArticle.getId());
		if(coll==null) {
			//用户对该文章 是否收藏: 1 收藏    2 没有收藏
			request.setAttribute("isCollection", 2);
		}else {
			request.setAttribute("isCollection", coll.getState());
		}
		
		//用户对该文章 是否举报: 0 没有举报   其他 举报
		request.setAttribute("isReport", 0);
		
		
		//---浏览记录
		return "/user/articleDetail.jsp";
	}
	
	/**
	 * 点击浏览记录
	 * @throws Exception 
	 * */
	@ApiOperation("浏览文章")
	@RequestMapping(value = "/showHistoryArticles",method = RequestMethod.GET)
	public String showHistoryArticles(HttpServletRequest request) throws Exception {
		User loginUser = (User) request.getSession().getAttribute("loginUser");
		Cookie[] cookies = request.getCookies();
		String historyValue = null;
		if(cookies!=null) {
			for(Cookie cookie : cookies) {
				if(cookie.getName().equals("history_"+loginUser.getId())) {
					historyValue = URLDecoder.decode(cookie.getValue(), "utf-8");
					break;
				}
			}
		}
		System.out.println("historyValue:"+historyValue);
		if(historyValue != null) {
			
			String[] articleIds = historyValue.split(",");
			//历史文章
			List<Article> articles = new ArrayList<>();
			for(String articleId : articleIds) {
				System.out.println(articleId);
				Article article = arDao.findById(Integer.parseInt(articleId)).get();
				if(article!=null) {
					articles.add(article);
				}
			}
			request.setAttribute("historyArticles", articles);
		}
		return "/user/page/myHistory.jsp";
	}
	/**
	 * 显示个人信息
	 * */
	@ApiOperation("显示个人信息")
	@RequestMapping(value = "/showUserInformation",method = RequestMethod.GET)
	public String showUserInformation() {
		return "/user/page/MyInformation.jsp";
	}
	/**
	 * 更新用户信息
	 * @throws ServletException 
	 * @throws IOException 
	 * */
	@ApiOperation("更新用户信息")
	@RequestMapping(value = "/updateUserMessage",method = RequestMethod.GET)
	public void updateUserMessage(User user,HttpServletRequest request,OutputStream out) throws Exception {
		User loginUser = (User) request.getSession().getAttribute("loginUser");
		loginUser.setAccount(user.getAccount());
		loginUser.setNickname(user.getNickname());
		
		if(user.getPassword()!=null && !"".equals(user.getPassword())) {
			loginUser.setPassword(user.getPassword());
		}
		//D:\item\workspace\cms_3\src\main\webapp\
		String realPath = request.getRealPath("/")+"\\down\\";
		
		Part part = request.getPart("picfile");
		if(part!=null) {
			String	fileName = realPath+loginUser.getId()+".jpg";
			System.out.println("文件保存地址 : "+fileName);
			loginUser.setImg("/down/"+loginUser.getId()+".jpg");
			part.write(fileName);
		}
		System.out.println("更新用户数据 : "+loginUser);
		//更新用户信息
		userDao.save(loginUser);
		
		out.write("ok".getBytes());
		out.flush();
		out.close();
	}
	
	
	
	/**
	 * 发布图文 文章
	 * @throws  
	 * @throws Exception 
	 * */
	@ApiOperation("发布图文文章")
	@RequestMapping(value = "/userReleaseArticles",method = RequestMethod.POST)
	public void userReleaseArticles(String categoryidname,Article article,HttpServletRequest request,OutputStream out) throws Exception {
		
		User user = (User) request.getSession().getAttribute("loginUser");
		
		 
		Part music = request.getPart("musicFile");
		Part video = request.getPart("videoFile");
		Part titlePage = request.getPart("titlePageFile");
		
		
		//D:\item\workspace\cms_3\src\main\webapp\
		String realPath = request.getRealPath("/")+"articleFile\\";
		if(music!=null && music.getSubmittedFileName()!=null) {
			//保存音乐到本地
			String name = music.getSubmittedFileName();
			String substring = name.substring(name.indexOf("."));
			
			String musicFileName = UUID.randomUUID().toString()+substring;
			music.write(realPath+musicFileName);
			System.out.println("音乐的文件地址 :"+realPath+musicFileName);
			article.setMusic("/articleFile/"+musicFileName);
		}
		if(video!=null && video.getSubmittedFileName()!=null) {
			//保存视频到本地
			String name = video.getSubmittedFileName();
			String substring = name.substring(name.indexOf("."));
			
			String videoFileName = UUID.randomUUID().toString()+substring;
			video.write(realPath+videoFileName);
			System.out.println("视频的文件地址 :"+realPath+videoFileName);
			article.setVideo("/articleFile/"+videoFileName);
		}
		if(titlePage!=null && titlePage.getSubmittedFileName()!=null) {
			//保存 背景图片 到本地
			String name = titlePage.getSubmittedFileName();
			String substring = name.substring(name.indexOf("."));
			String titlePageFileName = UUID.randomUUID().toString()+substring;
			titlePage.write(realPath+titlePageFileName);
			System.out.println("背景图片的文件地址 :"+realPath+titlePageFileName);
			article.setImg("/articleFile/"+titlePageFileName);
		}
		
		article.setDob(new Date());
		article.setClick(0);
		article.setRea(0);
		article.setCollect(0);
		article.setState(0);//未审核
		article.setAuthor(user.getNickname());
		article.setUserid(user.getId());
		String[] split = categoryidname.split("-");
		article.setCategoryid(Integer.parseInt(split[0]));
		article.setCategoryname(split[1]);
		
		System.out.println("新发布的 图文 : "+article);
		
		arDao.save(article);
		
		
		out.write("ok".getBytes());
		out.flush();
		out.close();
	}
	
	
	/**
	 * 修改文章信息
	 * @throws IOException 
	 * */
	@ApiOperation("修改文章信息")
	@RequestMapping(value = "/updateArticleServlet",method = RequestMethod.GET)
	public void updateArticleServlet(Integer articleId,String categoryidname,OutputStream out) throws IOException {
		System.out.println("修改:"+articleId+"---"+categoryidname);
		//categoryidname = 12-电影
		//分隔栏目id 和栏目名字
		String[] split = categoryidname.split("-");
		//通过文章id值查询到 文章信息
		Article article = arDao.findById(articleId).get();
		//更新文章的 栏目id 和 文章的栏目名字
		article.setCategoryid(Integer.parseInt(split[0]));
		article.setCategoryname(split[1]);
		//更新文章信息到数据库
		arDao.save(article);
		//写回到 ajax 的回调函数
		out.write("ok".getBytes());
		out.flush();
		out.close();
	}
	
	/**
	 * 删除文章
	 * @throws IOException 
	 * */
	@ApiOperation("删除文章")
	@RequestMapping(value = "/deleteArticle",method = RequestMethod.GET)
	public void deleteArticle(String articleIds ,OutputStream out) throws IOException {
		if(articleIds.indexOf(",")!=-1) {//批量删除
			//获得本次所有被删除的 文章id 
			String[] split = articleIds.split(",");
			
			for(String id : split) {
				arDao.deleteById(Integer.parseInt(id));
			}
		}else {//删除一个
			int arid = Integer.parseInt(articleIds);
			arDao.deleteById(arid);
		}
		out.write("ok".getBytes());
		out.flush();
		out.close();
	}
	
	//退出 
	@ApiOperation("退出")
		@RequestMapping("/logout")
		public String logout(HttpSession sessoin) {
			sessoin.removeAttribute("loginUser");
			return "redirect:/index.jsp";
		}
	
		
	/**
	 * 点赞 和 取消点赞<br>
	 * 点赞 : out输出流 返回 "1"
	 * 取消点赞 : out输出流 返回 "2" <br>
	 * @param likeState 1 当前是点赞状态，用户再点一下是取消点赞
	 * @param likeState 2 当前是未点赞状态，用户再点一下是点赞
	 * @throws IOException 
	 *   
	 * 
	 * */	
	@ApiOperation("点赞和取消点赞")
	@RequestMapping(value = "/likeArticle",method = RequestMethod.GET)
	public void likeArticle(
			Integer articleId,
			Integer likeState,
			OutputStream out,
			HttpSession session) throws IOException {
		
		//获得用户id:登入成功以后 就会放到用户到session中
		User loginUser = (User) session.getAttribute("loginUser");
		if(likeState==1) {//当前是点赞状态，用户再点一下是取消点赞
			//2 状态            用户 id			文章id
			likeDao.updateState(2,loginUser.getId(),articleId);
			
			//取消点赞  文章对象中的 点赞数--
			Article article = arDao.findById(articleId).get();
			article.setClick(article.getClick()-1);
			arDao.save(article);
			
			
			out.write("2".getBytes());
			out.flush();
			out.close();
			
		}else {//当前是未点赞状态，用户再点一下是点赞
			
			//查询数据库中是否有当前用户对当前文章的历史点赞信息
			UserLike like = 
					likeDao.findByUseridAndArticleid(loginUser.getId(),articleId);
			if(like==null) {//有可能用户第一次看这个文章，没有历史点赞信息
				like = new UserLike();
				like.setArticleid(articleId);
				like.setUserid(loginUser.getId());
			}
			like.setState(1);
			//保存或者更新到数据库
			likeDao.save(like);
			
			//点赞  文章对象中的 点赞数++
			Article article = arDao.findById(articleId).get();
			article.setClick(article.getClick()+1);
			arDao.save(article);
			
			
			out.write("1".getBytes());
			out.flush();
			out.close();
		}
		
		
		
		
	}
		
		
		
	/**
	 * 用户 点击 我的点赞<br>
	 * 查看 所有已经点赞的文章<br>
	 * 
	 * */
	@ApiOperation("展示我的点赞")
	@RequestMapping(value = "/showUserLikeArticles",method = RequestMethod.GET)
	public String showUserLikeArticles(HttpSession session,Model model) {
		//获取登入的用户信息
		User loginUser = (User) session.getAttribute("loginUser");
		
		//当前登入的用户 在 userLike表中 有多少点赞信息？
		List<UserLike> list = 
			likeDao.findByUseridAndState(loginUser.getId(),1);
		//创建一个 集合 存放所有点赞的文章信息
		List<Article> articleList = new ArrayList<>();
		//遍历list集合 得到所有点赞的文章id信息，使用id查询数据库
		
		for(UserLike ul : list) {
			Article article = arDao.findById(ul.getArticleid()).get();
			articleList.add(article);
		}
		//放到模型中
		model.addAttribute("articleList",articleList);
		
		return "/user/page/myLike.jsp";
	}
	
		
	/**
	 * 文章详情页面 点击收藏<br>
	 * @throws IOException 
	 * */
	@ApiOperation("文章详情页面点击收藏")
	@RequestMapping(value = "/collectionArticle",method = RequestMethod.GET)
	public void collectionArticle(Integer articleId,Integer collectionState,OutputStream out,HttpSession session) throws IOException {
		//获得用户id:登入成功以后 就会放到用户到session中
		User loginUser = (User) session.getAttribute("loginUser");
		if(collectionState==1) {//当前是收藏状态，用户再点一下是取消收藏
			//2 状态            用户 id			文章id
			collDao.updateState(2,loginUser.getId(),articleId);
			
			//取消收藏  文章对象中的 收藏数--
			Article article = arDao.findById(articleId).get();
			article.setCollect(article.getCollect()-1);
			arDao.save(article);
			
			
			out.write("2".getBytes());
			out.flush();
			out.close();
			
			
		}else {//当前是没有收藏状态，用户再点一下是收藏

			//查询数据库中是否有当前用户对当前文章的历史点赞信息
			UserCollect coll = 
				collDao.findByUseridAndArticleid(loginUser.getId(),articleId);
			if(coll==null) {//有可能用户第一次看这个文章，没有历史点赞信息
				coll = new UserCollect();
				coll.setArticleid(articleId);
				coll.setUserid(loginUser.getId());
			}
			coll.setState(1);
			//保存或者更新到数据库
			collDao.save(coll);
			
			//收藏  文章对象中的 收藏数++
			Article article = arDao.findById(articleId).get();
			article.setCollect(article.getCollect()+1);
			arDao.save(article);
			
			
			out.write("1".getBytes());
			out.flush();
			out.close();
		}
	}
	/**
	 * 用户登入 点击 我的收藏
	 * */
	@ApiOperation("我的收藏")
	@RequestMapping(value = "/showUserCollectionArticles",method = RequestMethod.GET)
	public String showUserCollectionArticles(HttpSession session,Model model) {
		//获取登入的用户信息
		User loginUser = (User) session.getAttribute("loginUser");
		
		//当前登入的用户 在 userLike表中 有多少点赞信息？
		List<UserCollect> list = 
			collDao.findByUseridAndState(loginUser.getId(),1);
		//创建一个 集合 存放所有点赞的文章信息
		List<Article> articleColl = new ArrayList<>();
		//遍历list集合 得到所有点赞的文章id信息，使用id查询数据库
		
		for(UserCollect ul : list) {
			Article article = arDao.findById(ul.getArticleid()).get();
			articleColl.add(article);
		}
		//放到模型中
		model.addAttribute("articleColl",articleColl);
		
		return "/user/page/myCollection.jsp";
		
	}
		
		
	/**
	 * 文章详情界面 点击  举报<br>
	 * 在数据库 UserReport 对应的表中 保存一条数据 即为 举报<br>
	 * @param ur 对象 用于接受ajax请求中携带的参数<br>	
	 * 			 ur对象中有 articleid+type+reportcontent属性值<br>
	 * @throws IOException 
	 * */	
	@ApiOperation("举报")
	@RequestMapping(value = "/reportArticle",method = RequestMethod.GET)
	public void reportArticle(UserReport ur,HttpSession session,OutputStream out) throws IOException {
		//获得 登入的 用户信息
		User loginUser = (User) session.getAttribute("loginUser");
		
		ur.setUserid(loginUser.getId());
		ur.setNickname(loginUser.getNickname());
		
		ur.setReportdob(new Date());
		//被举报的文章的标题
		Article article = arDao.findById(ur.getArticleid()).get();
		ur.setTitle(article.getTitle());
		//1 新建状态 
		ur.setState(1);
		
		repDao.save(ur);
		
		//因为 当前请求 是ajax 所以 输出流 写回一点数据
		out.write("ok".getBytes());
		out.flush();
		out.close();
		
	}
	
	
	/**
	 * 用户首页 点击我的举报<br>
	 * 
	 * */
	@ApiOperation("我的举报")
	@RequestMapping(value = "/showUserReportArticles",method = RequestMethod.GET)
	public String showUserReportArticles(HttpSession session,Model model) {
		
		User loginUser = (User) session.getAttribute("loginUser");
		
		Map<Article, UserReport> map = new HashMap<>();
		//当前用户有哪些举报信息？ 举报信息在UserReport表中
		List<UserReport> repList = repDao.findByUserid(loginUser.getId());
		for(UserReport r : repList) {
			Article article = arDao.findById(r.getArticleid()).get();
			map.put(article, r);
		}
		//把数据放到模型中
		model.addAttribute("map", map);
		
		return "/user/page/myReport.jsp";
	}
	
	/**
	 * 点击 处理 或者 为 处理 <Br>
	 * 给跳出的弹框准备数据<br>
	 * */
	@RequestMapping(value = "/showUserReportMessage",method = RequestMethod.GET)
	@ResponseBody
	public UserReport showUserReportMessage(
				Integer articleId,HttpSession session) {
		//查询到对应的一个UserReport对象?
		//只有通过用户id 和 文章id 才能唯一查到 一个 ＵｓｅｒＲｅｐｏｒｔ对象
		User loginUser = (User) session.getAttribute("loginUser");
		
		UserReport ur = 
		  repDao.findByUseridAndArticleid(loginUser.getId(),articleId);
		System.out.println(articleId+"--"+loginUser.getId()+"----"+ur);
		return ur;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
		
		
	
}
