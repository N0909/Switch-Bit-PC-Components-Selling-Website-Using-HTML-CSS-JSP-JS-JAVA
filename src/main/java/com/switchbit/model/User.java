package com.switchbit.model;
import java.sql.Timestamp;

public class User {
	
	// UserId:- Unique Id of User
	private String userId;
	// UserName:- Name of User
	private String userName;
	// UserEmail:- Email of User
	private String userEmail;
	// UserPhone:- PhoneNumber of User
	private String userPhone;
	// UserAddress:- Resident Address of User
	private String userAddress;
	// RegDate:- Date on which userRegister
	private Timestamp reg_date;
	
	// Default Constructor
	public User() {}

	// Argument Constructor
	public User(String userId, 
			String userName, 
			String userEmail,
			String userPhone, 			String userAddress,
			Timestamp reg_date) {
		this.userId = userId;
		this.userName = userName;
		this.userEmail = userEmail;
		this.userPhone = userPhone;
		this.userAddress = userAddress;
		this.reg_date = reg_date;
	}

	// getters and setters
	
	public String getUserId() {
		return userId;
	}

	public String getUserName() {
		return userName;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public String getUserPhone() {
		return userPhone;
	}

	public String getUserAddress() {
		return userAddress;
	}

	public Timestamp getReg_date() {
		return reg_date;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}

	public void setUserAddress(String userAddress) {
		this.userAddress = userAddress;
	}
	
	public void setRegDate(Timestamp reg_date) {
		this.reg_date = reg_date;
	}

	@Override
	public String toString() {
		return "User [userId=" + userId 
				+ ", userName=" + userName 
				+ ", userEmail=" + userEmail 
				+ ", userPhone=" + userPhone 
				+ ", userAddress=" + userAddress 
				+ ", reg_date=" + reg_date + "]";
	}
}
