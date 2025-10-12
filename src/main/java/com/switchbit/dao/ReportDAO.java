package com.switchbit.dao;

import com.switchbit.model.*;
import com.switchbit.dto.*;


import java.sql.*;
import java.util.*;


public class ReportDAO {
	
	public void addReport(Connection conn, Report report) throws SQLException {
		try (CallableStatement cs = conn.prepareCall("{call addReport(?, ?, ?, ?, ?)}");){
			cs.setString(1, report.getReport_id());
			cs.setString(2, report.getUser_id());
			cs.setString(3, report.getSubject());
			cs.setString(4, report.getMessage());
			cs.setTimestamp(5, report.getSubmitted_at());
			
			cs.executeUpdate();
		}
	}
	
	public void addReportStatus(Connection conn, ReportStatus status) throws SQLException {
		try (CallableStatement cs = conn.prepareCall("{call addReportStatus(?, ?, ?, ?)}");){
			cs.setString(1, status.getReport_status_id());
			cs.setString(2, status.getReport_id());
			cs.setTimestamp(3, status.getUpdated_at());
			cs.setString(4, status.getStatus().getValue());
			
			cs.executeUpdate();
		}
	}
	
	public List<ReportDTO> getReports(Connection conn) throws SQLException{
		List<ReportDTO> reports = new ArrayList<>();
		try (CallableStatement cs = conn.prepareCall("{call getReports()}");){
			try (ResultSet rs = cs.executeQuery()){
				while(rs.next()) {
					Report report = new Report(
								rs.getString("report_id"),
								rs.getString("user_id"),
								rs.getString("subject"),
								rs.getString("message"),
								rs.getString("response_message"),
								rs.getTimestamp("submitted_at")
							);
					ReportStatus reportStatus = new ReportStatus(
								rs.getString("report_status_id"),
								rs.getString("report_id"),
								rs.getTimestamp("updated_at"),
								ReportStatus.Status.fromString(rs.getString("status"))
							);
					reports.add(new ReportDTO(report, reportStatus));
				}
			}
		}
		return reports;
	}
	
	public List<ReportDTO> getReports(Connection conn, String user_id) throws SQLException{
		List<ReportDTO> reports = new ArrayList<>();
		try (CallableStatement cs = conn.prepareCall("{call getReportsByUser(?)}");){
			cs.setString(1, user_id);
			try (ResultSet rs = cs.executeQuery()){
				while (rs.next()) {
					Report report = new Report(
								rs.getString("report_id"),
								rs.getString("user_id"),
								rs.getString("subject"),
								rs.getString("message"),
								rs.getString("response_message"),
								rs.getTimestamp("submitted_at")
							);
					ReportStatus status = new ReportStatus(
								rs.getString("report_status_id"),
								rs.getString("report_id"),
								rs.getTimestamp("updated_at"),
								ReportStatus.Status.fromString(rs.getString("status"))
							);
					reports.add(new ReportDTO(report, status));
				}
			}
		}
		return reports;
	}
	
	public ReportDTO getReport(Connection conn, String report_id) throws SQLException{
		ReportDTO reportDTO = null;
		try (CallableStatement cs = conn.prepareCall("{call getReport(?)}");){
			cs.setString(1, report_id);
			try (ResultSet rs = cs.executeQuery()){
				if (rs.next()) {
					Report report = new Report(
							rs.getString("report_id"),
							rs.getString("user_id"),
							rs.getString("subject"),
							rs.getString("message"),
							rs.getString("response_message"),
							rs.getTimestamp("submitted_at")
						);
					ReportStatus status = new ReportStatus(
							rs.getString("report_status_id"),
							rs.getString("report_id"),
							rs.getTimestamp("updated_at"),
							ReportStatus.Status.fromString(rs.getString("status"))
						);
					reportDTO = new ReportDTO(report, status);
				}
			}
		}
		return reportDTO;
	}
	
	public void updateReportResponse(Connection conn, Report report) throws SQLException {
		try (CallableStatement cs = conn.prepareCall("{call updateReportResponse(?, ?)}");){
			cs.setString(1, report.getReport_id());
			cs.setString(2, report.getResponse_message());
			
			cs.executeUpdate();
		}
	}
	
	public void updateReportStatus(Connection conn, ReportStatus status) throws SQLException {
		try (CallableStatement cs = conn.prepareCall("{call updateReportStatus(?, ?, ?, ?)}");){
			cs.setString(1, status.getReport_status_id());
			cs.setString(2, status.getReport_id());
			cs.setTimestamp(3, status.getUpdated_at());
			cs.setString(4, status.getStatus().getValue());
			
			cs.executeUpdate();
		}
	}
	

}
