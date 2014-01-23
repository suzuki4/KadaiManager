package database;

import other.InputCheck;

import java.io.IOException;
import java.util.*;

import javax.jdo.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class StudentDataAddServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;   
	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain");
        resp.getWriter().println("no url...");
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //PMFセットしておく
    	PersistenceManager pm;
    	
    	//入力をチェック
        String message = "";
        //idをチェック
        String idString = request.getParameter("id");
        Long id = -1L;
        if(InputCheck.isId(idString)) {
        	id = Long.parseLong(idString);
        	//dataにIDがあるかチェック
        	pm = PMF.get().getPersistenceManager();
        	Query query = pm.newQuery(StudentData.class);
        	query.setFilter("id == " + id);
        	if(!((List<StudentData>) query.execute()).isEmpty()) {
            	message += "使用済みIDなので別IDを入力すること！\n";        		
        	}
        	pm.close();
        } else {
        	message += "生徒IDは半角数値にすること！\n";
    	}
        //userNameをチェック
        String userName = request.getParameter("userName");
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
        String gradeString = request.getParameter("grade");
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
        //入力ミスがある場合
        if(!message.equals("")) {
        	//フォームのバリューを持たせるためにリクエストに返してあげる
        	request.setAttribute("inputId", idString);
        	request.setAttribute("inputUserName", userName);
        	request.setAttribute("inputGrade", gradeString);
        	request.setAttribute("inputEmail", email);
            dispatch(request, response, message);
        //入力が正しい場合
        } else {
	        StudentData data = new StudentData(id, userName, pass, grade, email);
	        data.setReportNameList(new ArrayList<String>());
	        data.setReportMinutesList(new ArrayList<Integer>());
	        data.setReportFinishTimeList(new ArrayList<Date>());
	        pm = PMF.get().getPersistenceManager();
	        pm.makePersistent(data);
	        pm.close();
	        //登録メール送信
	        String contents = userName + " 様\n"
	        				+ "\n"
	        				+ "飯川です。課題管理システムへようこそ！\n"
							+ "メールアドレスを新しく登録しました。\n"
	        				+ "あなたのログインIDは「" + id + "」です。\n"
	        				+ "初期パスワードは飯川までお尋ねください。\n"
							+ "身に覚えがない人は以下のアドレスまでご連絡ください。\n"
							+ "\n"
							+ "fukasawa@reorjuku.jp"
							;
	        new other.registerMail(email, "Registration", contents).sendMail();
	        dispatch(request, response, "生徒データの追加成功");
        }
    }
    
    //dispatcherメソッド
    void dispatch(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
    	RequestDispatcher dispatcher;
        dispatcher = request.getRequestDispatcher("add.jsp");
    	request.setAttribute("info", message);
    	dispatcher.forward(request, response);
    } 
}
