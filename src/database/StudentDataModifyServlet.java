package database;

import other.InputCheck;

import java.io.IOException;
import java.util.*;

import javax.jdo.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class StudentDataModifyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;   
	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain");
        resp.getWriter().println("no url...");
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {    	
    	//有るならmanagerLoginを受け取ってsetAttribute
    	if(request.getParameter("managerLogin") != null) {
    		request.setAttribute("managerLogin", request.getParameter("managerLogin"));
    	}
    	//PMFセットしておく
    	PersistenceManager pm;
    	Query query;
    	//studentDataをセットしておく
    	StudentData data = null;
    	
    //入力をチェック
        String message = "";
       //idをチェック
        String idString = "";
        Long id = -1L;
        //id変更ある場合（id飛んできて、かつoldIdでない場合）
        if(request.getParameter("id") != null && !request.getParameter("id").equals(request.getParameter("oldId"))) {
	        idString = request.getParameter("id");
	        if(InputCheck.isId(idString)) {
	        	id = Long.parseLong(idString);
	        	//dataにIDがあるかチェック
	        	pm = PMF.get().getPersistenceManager();
	        	query = pm.newQuery(StudentData.class);
	        	query.setFilter("id == " + id);
	        	if(!((List<StudentData>) query.execute()).isEmpty()) {
	            	message += "使用済みIDなので別IDを入力すること！\n";        		
	        	}
	        	pm.close();
	        } else {
	        	message += "生徒IDは半角数値にすること！\n";
	    	}
	    //id変更ない場合
        } else {
	        idString = request.getParameter("oldId");        	
	        id = Long.parseLong(idString);
	        //data取得
	    	pm = PMF.get().getPersistenceManager();
	    	query = pm.newQuery(StudentData.class);
	    	query.setFilter("id == " + id);
	    	data = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
	    	pm.close();
        }
        //userNameをチェック
        String userName = request.getParameter("userName") != null ? request.getParameter("userName") : data.getUserName();
        if(!InputCheck.isUserName(userName)) {
        	message += "生徒名を入れること！\n";
        }
        //passをチェック
        String pass = request.getParameter("pass");
        if(!InputCheck.isPassWord(pass)) {
        	message += "パスワードは半角英数・数字のみを使うこと！\n";
        } else if(pass.length() < 4) {
        	message += "パスワードは4文字以上にすること！\n";
        }
        //gradeをチェック
        String gradeString = request.getParameter("grade") != null ? request.getParameter("grade") : String.valueOf(data.getGrade());
        int grade = -1;
        if(InputCheck.isGrade(gradeString)) {
        	grade  = Integer.parseInt(gradeString);
        } else {
        	message += "学年は4桁の半角数値にすること！\n";
    	}
        //emailをチェック
        String email = request.getParameter("email");
        if(!InputCheck.isEmail(email)) {
        	message += "Eメールを見直すこと！\n";
        }
    	//フォームのバリューを持たせるためにリクエストに返してあげる
    	request.setAttribute("inputId", idString);
    	request.setAttribute("inputPass", pass);
    	request.setAttribute("inputUserName", userName);
    	request.setAttribute("inputGrade", gradeString);
    	request.setAttribute("inputEmail", email);
        //入力ミスがある場合
        if(!message.equals("")) {
            dispatch(request, response, message);
        //入力が正しい場合
        } else {
        	pm = PMF.get().getPersistenceManager();
        	data = (StudentData)pm.getObjectById(StudentData.class, id);
	        data.setPass(pass);
	        data.setUserName(userName);
	        data.setGrade(grade);
	        data.setEmail(email);
	       	//id更新時は古いデータを削除
	    	if(request.getParameter("id") != null && !request.getParameter("id").equals(request.getParameter("oldId"))) {
		    	data = (StudentData)pm.getObjectById(StudentData.class, Long.parseLong(request.getParameter("oldId")));
		    	pm.deletePersistent(data);
	    	}
	        pm.close();
	        dispatch(request, response, "生徒データの修正成功");
        }
    }
    
    //dispatcherメソッド
    void dispatch(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
    	RequestDispatcher dispatcher;
        dispatcher = request.getRequestDispatcher("modify.jsp");
    	request.setAttribute("info", message);
    	dispatcher.forward(request, response);
    } 
}
