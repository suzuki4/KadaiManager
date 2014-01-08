package database;

import javax.jdo.JDOHelper;
import javax.jdo.PersistenceManagerFactory;

public class PMF {
	private static final PersistenceManagerFactory factory = JDOHelper.getPersistenceManagerFactory("transactions-optional");
	private PMF(){}
	public static PersistenceManagerFactory get(){
		return factory;
	}
}
