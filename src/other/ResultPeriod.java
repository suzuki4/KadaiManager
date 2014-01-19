package other;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class ResultPeriod {
	//field
	private Date startDate;
	private Date endDate;
	private String dateString;
	private int numberOfDate;
	
	//constructor
	public ResultPeriod(String period, SimpleDateFormat resultPeriodFormat) {
		//calendarを取得、日付未満はクリア
		Calendar calendar = Calendar.getInstance(Locale.JAPAN);
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);
		//periodによりフィールドに異なった値を代入
		switch(period) {
		case Period.LASTDAY:
			//endDate
			endDate = calendar.getTime();
			//startDate
			calendar.add(Calendar.DATE, -1);
			startDate = calendar.getTime();
			dateString = resultPeriodFormat.format(startDate);
			numberOfDate = 1;
			break;
		case Period.LASTWEEK:
			//startDate
			calendar.add(Calendar.DATE, - calendar.get(Calendar.DAY_OF_WEEK) + 2 - 7);
			startDate = calendar.getTime();
			dateString = resultPeriodFormat.format(startDate);
			//endDate
			calendar.add(Calendar.DATE, 6);
			dateString += " - " + resultPeriodFormat.format(calendar.getTime());
			calendar.add(Calendar.DATE, 1);
			endDate = calendar.getTime();
			numberOfDate = 7;
			break;
		case Period.LASTMONTH:
			calendar.set(Calendar.DATE, 1);
			//endDate
			endDate = calendar.getTime();
			calendar.add(Calendar.DATE, -1);
			String endDateString = resultPeriodFormat.format(calendar.getTime());
			//startDate
			calendar.set(Calendar.DATE, 1);
			startDate = calendar.getTime();
			dateString = resultPeriodFormat.format(startDate) + " - " + endDateString;
			numberOfDate = calendar.getActualMaximum(Calendar.DATE);
			break;
		}
	}
	
	//getter
	public Date getStartDate() {
		return startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public String getDateString() {
		return dateString;
	}
	
	public int getNumberOfDate() {
		return numberOfDate;
	}
	
}
