package login;

import java.io.IOException;

import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

import database.*;

public class LoginServlet extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		//index.jspから飛んできた
		String id = request.getParameter("id");
		String pass = request.getParameter("pass");	
		
		//データストアアクセス準備
		PersistenceManagerFactory factory = PMF.get();
        PersistenceManager manager = factory.getPersistenceManager();
        StudentData data = null;
        
        //Dispatch準備
        RequestDispatcher dispatcher;
        
        //データストア内のID検索
        try {
        	data = (StudentData)manager.getObjectById(StudentData.class,Long.parseLong(id));        	
        	//パスチェック
        	if(data.getPass().equals(pass)) {
        		/*
        		//セッション作成
        		HttpSession session = request.getSession();
        		session.setAttribute("data", data);
        		manager.close();
        		//dispatcher = request.getRequestDispatcher("report.jsp");
           	 	//dispatcher.forward(request, response);
        		session.setAttribute("test", "testtest");
        		java.util.logging.Logger.getLogger(LoginServlet.class.getName()).warning(session.getId());
        		response.sendRedirect("/report.jsp");
        		*/
        		manager.close();
        		dispatcher = request.getRequestDispatcher("report.jsp");
        		request.setAttribute("id", Integer.parseInt(id));
           	 	dispatcher.forward(request, response);
            }
        } catch(Exception e) {
        	
        }       	
        manager.close();
   	 	dispatcher = request.getRequestDispatcher("index.jsp");
   	 	request.setAttribute("fail", "ログイン失敗");
   	 	dispatcher.forward(request, response);
	}
}
