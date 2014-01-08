package database;

import java.io.Serializable;
import java.util.ArrayList;

import javax.jdo.annotations.*;

@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class StatusData implements Serializable {
	private static final long serialVersionUID = 1L;

	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Long id;

	@Persistent
	private ArrayList<Long> restIds;

	public StatusData(Long id) {
		super();
		this.id = id;
		this.restIds = new ArrayList<Long>();
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ArrayList<Long> getRestIds() {
		return restIds;
	}

	public void setRestIds(ArrayList<Long> restIds) {
		this.restIds = restIds;
	}
	
}
