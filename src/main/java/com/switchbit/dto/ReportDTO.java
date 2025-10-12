package com.switchbit.dto;

import com.switchbit.model.*;

public class ReportDTO {
	
	private Report report;
	private ReportStatus reportStatus;
	
	public ReportDTO() {}
	
	public ReportDTO(Report report, ReportStatus reportStatus) {
		this.report = report;
		this.reportStatus = reportStatus;
	}

	public Report getReport() {
		return report;
	}

	public ReportStatus getReportStatus() {
		return reportStatus;
	}

	public void setReport(Report report) {
		this.report = report;
	}

	public void setReportStatus(ReportStatus reportStatus) {
		this.reportStatus = reportStatus;
	}
	
}
