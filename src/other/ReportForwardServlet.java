package other;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;
import javax.jdo.Query;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

import database.*;

public class ReportForwardServlet extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		//無理やりIDとパス取得
		String idString = request.getPathInfo();
		int index = idString.indexOf('-');
		int passHash = Integer.parseInt(idString.substring(index + 1, idString.length()));
		idString = idString.substring(1,index);
		response.getWriter().println(idString);
		response.getWriter().println(passHash);
		//data取得
		PersistenceManagerFactory factory = PMF.get();
        PersistenceManager manager = factory.getPersistenceManager();
        StudentData data = (StudentData)manager.getObjectById(StudentData.class,Long.parseLong(idString));        	
    	//パスチェック
    	if(data.getPass().hashCode() == passHash) {
			//report.jspに飛ばす
    		manager.close();
			RequestDispatcher dispatcher = request.getRequestDispatcher("/report.jsp");
	   	 	request.setAttribute("id", Long.parseLong(idString));
	   	 	request.setAttribute("managerLogin", "true");
	   	 	dispatcher.forward(request, response);
    	}
    	manager.close();
    	response.getWriter().println("エラー");
	}
}
