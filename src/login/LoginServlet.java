package login;

import java.io.IOException;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;
import javax.jdo.Query;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import org.apache.jasper.tagplugins.jstl.core.Out;

import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

import database.*;

public class LoginServlet extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		//index.jspから飛んできた
		Long id = Long.parseLong(request.getParameter("id"));
		String pass = request.getParameter("pass");	
		
        //Dispatch準備
        RequestDispatcher dispatcher;
        
        //データストア内のID検索
   		//data取得
        try {
	        PersistenceManager pm = PMF.get().getPersistenceManager();
			Query query = pm.newQuery(StudentData.class);
			query.setFilter("id == " + id);
			StudentData data = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
			pm.close();
	    	//パスチェック
	    	if(data.getPass().equals(pass)) {
	    		dispatcher = request.getRequestDispatcher("/report.jsp");
	    		request.setAttribute("id", id);
	       	 	dispatcher.forward(request, response);
	        }
        } catch(Exception e) {
        	
        }
   	 	dispatcher = request.getRequestDispatcher("/index.jsp");
   	 	request.setAttribute("fail", "ログインエラー");
   	 	dispatcher.forward(request, response);
	}
}
