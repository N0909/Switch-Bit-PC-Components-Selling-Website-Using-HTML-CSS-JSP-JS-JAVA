package com.switchbit.model;

public enum CartStatus {
	ACTIVE("active"),
	CHECKED_OUT("checked_out");
	private String action;
	
	CartStatus(String action) {
		this.action = action;
	}
	
	public String getAction() {
		return action;
	}
}
