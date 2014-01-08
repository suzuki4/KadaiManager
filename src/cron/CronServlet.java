package cron;

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

public class CronServlet extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		//StudentDataList取得
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery("select from " + StudentData.class.getName());
		List<StudentData> studentDataList = (List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute());
		//status取得
		query = pm.newQuery(StatusData.class);
		query.setFilter("id == 1");
		StatusData statusData = ((List<StatusData>)pm.detachCopyAll((List<StatusData>)query.execute())).get(0);
		pm.close();
		//restIds取得
		ArrayList<Long> restIds = null;
		if(statusData != null) restIds = statusData.getRestIds();
		//cronRunTime取得
		Date cronRunTime = new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 9);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");	
		String cronRunTimeString = sdf.format(cronRunTime);
		
		//件名・本文セット
		String subject = "エラー";
		String contents = "エラー";
		switch(request.getPathInfo()) {
		case "/2200":
			subject = "今日も頑張ろう";
			contents = "今日も報告実行・報告お願いします。頑張ろう！！";
			break;
		case "/2230":
			subject = "音読";
			contents = "やっていたら報告をしましょう。";
			break;
		case "/2300":
			subject = "音読だぞ";
			contents = "まだ報告がきていません。やりましょう。";
			break;
		case "/2330":
			subject = "コラ！";
			contents = "やってください！やってください！やってください！やってください！やってください！";
		}
		//メール送信
		Properties props = new Properties();
        Session session = Session.getDefaultInstance(props, null);
 
        try {
            Message msg = new MimeMessage(session);
 
            //発信元情報：メールアドレス、名前
            msg.setFrom(new InternetAddress("hiroaki.4.suzuki@gmail.com", "iikawa"));
 
            //送信先情報
            msg.addRecipient(Message.RecipientType.TO, new InternetAddress("hiroaki.4.suzuki@gmail.com", ""));
            
            //BCC
            StudentData data;
            int numberOfReport;
            for(int i = 0; i < studentDataList.size(); i++) {
            	data = studentDataList.get(i);
            	//reportがないなら0、あるならsize()
            	numberOfReport = 0;
            	if(data.getReportNameList() != null) numberOfReport = data.getReportNameList().size();
            	//reportがあり、cronRunTimeの日付と最新のreportFinishTimeの日付が一致するならメールしない（continue）
            	if(numberOfReport > 0 && sdf.format(data.getReportFinishTimeList().get(numberOfReport - 1)).equals(cronRunTimeString)) continue;
            	msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(studentDataList.get(i).getEmail(), "ID:" + studentDataList.get(i).getId()));
            }
            
            //タイトルと本文
            ((MimeMessage) msg).setSubject(subject, "Shift_JIS");
            msg.setText(contents);
            Transport.send(msg);
 
        } catch (AddressException e) {
            //アドレス不明時
        } catch (MessagingException e) {
            //接続失敗時の処理
        }
		
	}
}
