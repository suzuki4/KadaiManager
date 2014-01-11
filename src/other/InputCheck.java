package other;

public class InputCheck {
	 //ê≥ãKï\åª
    public static final String MATCH_ALPHA = "^[a-zA-Z]+$";
    public static final String MATCH_NUMBER = "^[0-9]+$";
    public static final String MATCH_PASSWORD = "^[a-zA-z0-9]+$";
    public static final String MATCH_GRADE = "[1-9]\\d{3}";
    public static final String MATCH_MAIL = "([a-zA-Z0-9][a-zA-Z0-9_.+\\-]*)@(([a-zA-Z0-9][a-zA-Z0-9_\\-]+\\.)+[a-zA-Z]{2,6})";
    
    public static boolean isId(String id) {
    	if(id.matches(MATCH_NUMBER)) return true;
        return false;
    }
    
    public static boolean isUserName(String userName) {
    	if(userName != null && !userName.equals("")) return true;
    	return false;
    }
    
    public static boolean isPassWord(String passWord) {
    	if(passWord.matches(MATCH_PASSWORD)) return true;
        return false;
    }
    
    public static boolean isGrade(String grade) {
    	if(grade.matches(MATCH_GRADE)) return true;
        return false;
    }
    
    public static boolean isEmail(String email) {
    	if(email.matches(MATCH_MAIL)) return true;
        return false;
    }
    
}
