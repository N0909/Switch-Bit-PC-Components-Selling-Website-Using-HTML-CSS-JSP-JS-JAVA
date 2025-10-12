package com.switchbit.model;

import java.sql.Timestamp;

public class Report {
	private String report_id;
	private String user_id;
	private String subject;
	private String message;
	private String response_message;
	private Timestamp submitted_at;

	public Report() {
	}

	public Report(String report_id, String user_id, String subject, String message, String response_message, Timestamp submitted_at) {
		this.report_id = report_id;
		this.user_id = user_id;
		this.subject = subject;
		this.message = message;
		this.response_message = response_message;
		this.submitted_at = submitted_at;
	}

	public String getReport_id() {
		return report_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public String getSubject() {
		return subject;
	}

	public String getMessage() {
		return message;
	}

	public String getResponse_message() {
		return response_message;
	}

	public Timestamp getSubmitted_at() {
		return submitted_at;
	}

	public void setReport_id(String report_id) {
		this.report_id = report_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public void setResponse_message(String response_message) {
		this.response_message = response_message;
	}

	public void setSubmitted_at(Timestamp submitted_at) {
		this.submitted_at = submitted_at;
	}

	
}