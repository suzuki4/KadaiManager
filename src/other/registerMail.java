package other;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class registerMail {
	//field
	String email;
	String subject;
	String contents;
	//field メール送信
	Properties props;
    Session session;
    
    //constructor
    public registerMail(String email, String subject, String contents) {
    	this.email = email;
    	this.subject = subject;
    	this.contents = contents;
    	this.props = new Properties();
    	this.session = Session.getDefaultInstance(props, null);
    }
    
    public void sendMail() {
	    try {
	    	Message msg = new MimeMessage(session);
		    //発信元情報：メールアドレス、名前
		    msg.setFrom(new InternetAddress("filmlife1226@gmail.com", "iikawa"));
		    //送信先情報
		    msg.addRecipient(Message.RecipientType.TO, new InternetAddress(email, ""));
		    //タイトルと本文
		    ((MimeMessage) msg).setSubject(subject, "Shift_JIS");
		    msg.setText(contents);
		    //送信！
		    Transport.send(msg);
	    } catch (AddressException e) {
	        //アドレス不明時
	    } catch (MessagingException e) {
	        //接続失敗時の処理
	    } catch (UnsupportedEncodingException e) {
			// TODO 自動生成された catch ブロック
		}
    }
}
