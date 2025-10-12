package com.switchbit.model;

import java.sql.Timestamp;

public class ReportStatus {
	private String report_status_id;
	private String report_id;
	private Timestamp updated_at;
	private Status status;
	
	 public enum Status {
	        OPEN("OPEN"),
	        RESOLVED("RESOLVED");

	        private final String value;

	        Status(String value) {
	            this.value = value;
	        }

	        public String getValue() {
	            return value;
	        }

	        public static Status fromString(String status) {
	            for (Status s : Status.values()) {
	                if (s.value.equalsIgnoreCase(status)) {
	                    return s;
	                }
	            }
	            throw new IllegalArgumentException("Unknown Status" + status);
	        }
	    }

	public ReportStatus() {
	}

	public ReportStatus(String report_status_id, String report_id, Timestamp updated_at, Status status) {
		this.report_status_id = report_status_id;
		this.report_id = report_id;
		this.updated_at = updated_at;
		this.status = status;
	}

	public String getReport_status_id() {
		return report_status_id;
	}

	public void setReport_status_id(String report_status_id) {
		this.report_status_id = report_status_id;
	}

	public String getReport_id() {
		return report_id;
	}

	public void setReport_id(String report_id) {
		this.report_id = report_id;
	}

	public Timestamp getUpdated_at() {
		return updated_at;
	}

	public void setUpdated_at(Timestamp updated_at) {
		this.updated_at = updated_at;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}
}