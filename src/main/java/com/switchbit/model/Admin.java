package com.switchbit.model;
import java.sql.Timestamp;

public class Admin {
	private int admin_id;
	private String admin_username;
	private String password;
	private String email;
	private Timestamp created_at;
	
	public Admin() {}

	public Admin(int admin_id, String admin_username, String password, String email, Timestamp created_at) {
		this.admin_id = admin_id;
		this.admin_username = admin_username;
		this.password = password;
		this.email = email;
		this.created_at = created_at;
	}

	public int getAdmin_id() {
		return admin_id;
	}

	public String getAdmin_username() {
		return admin_username;
	}

	public String getPassword() {
		return password;
	}

	public String getEmail() {
		return email;
	}

	public Timestamp getCreated_at() {
		return created_at;
	}

	public void setAdmin_id(int admin_id) {
		this.admin_id = admin_id;
	}

	public void setAdmin_username(String admin_username) {
		this.admin_username = admin_username;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}
	
}
