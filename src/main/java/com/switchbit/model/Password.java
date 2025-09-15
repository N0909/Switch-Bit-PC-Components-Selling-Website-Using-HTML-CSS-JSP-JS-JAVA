package com.switchbit.model;
import java.sql.Timestamp;
public class Password {
	
	// UserId:- Id of user
	private String user_id;
	// UserPassword:- password of user
	private String password;
	private Timestamp last_updated;
	
	
	public Password() {}


	public Password(String user_id, String password, Timestamp last_updated) {
		this.user_id = user_id;
		this.password = password;
		this.last_updated = last_updated;
	}

	
	// Getters and Setters
	public String getUser_id() {
		return user_id;
	}


	public String getPassword() {
		return password;
	}


	public Timestamp getLast_updated() {
		return last_updated;
	}


	public void setPassword(String password) {
		this.password = password;
	}


	public void setLast_updated(Timestamp last_updated) {
		this.last_updated = last_updated;
	}
	
	
	
}
