package com.switchbit.service;

import com.switchbit.model.*;
import com.switchbit.util.DBConnection;
import com.switchbit.util.IdGeneratorDAO;
import com.switchbit.util.MiscUtil;
import com.switchbit.dto.*;
import com.switchbit.exceptions.*;

import java.sql.*;
import java.util.List;

import com.switchbit.dao.*;

public class ReportService {
	private ReportDAO reportDAO;
	
	public ReportService() {
		this.reportDAO = new ReportDAO();
	}
	
	public void addReport(Report report) throws RollBackException, DataAccessException, CloseConnectionException {
		Connection conn = null;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			
			ReportStatus status = new ReportStatus();
			
			int report_id_val = IdGeneratorDAO.getCurrentIdVal(conn, "reports");
			int report_status_id_val = IdGeneratorDAO.getCurrentIdVal(conn, "report_status");
			
			String report_id = MiscUtil.idGenerator("RP0000", report_id_val);
			String report_status_id = MiscUtil.idGenerator("RS0000", report_status_id_val);
			
			report.setReport_id(report_id);
			report.setSubmitted_at(new Timestamp(System.currentTimeMillis()));
			
			status.setReport_status_id(report_status_id);
			status.setUpdated_at(new Timestamp(System.currentTimeMillis()));
			status.setReport_id(report_id);
			status.setStatus(ReportStatus.Status.OPEN);
			
			reportDAO.addReport(conn, report);
			reportDAO.addReportStatus(conn, status);
			
			IdGeneratorDAO.setNextIdVal(conn, "reports", report_id_val);
			IdGeneratorDAO.setNextIdVal(conn, "report_status", report_status_id_val);
			
			
			conn.commit();
		}catch(SQLException e) {
			if (conn!=null) {
				try {
					conn.rollback();
				}catch(SQLException e2) {
					throw new RollBackException("Failed to rollback transaction", e2);
				}
				throw new DataAccessException("Failed to add report. Internal Error", e);
			}
		}finally {
			if (conn!=null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				}catch(SQLException e){
					throw new CloseConnectionException("Failed to close Connection", e);
				}
			}
		}
	}
	
	public List<ReportDTO> getReports() throws DataAccessException{
		try(Connection conn = DBConnection.getConnection()){
			return reportDAO.getReports(conn);
		}catch(SQLException e) {
			throw new DataAccessException("Failed to get reports. Internal Error", e);
		}
	}
	
	public List<ReportDTO> getReports(String user_id) throws DataAccessException{
		try(Connection conn = DBConnection.getConnection()){
			return reportDAO.getReports(conn,user_id);
		}catch(SQLException e) {
			throw new DataAccessException("Failed to get reports. Internal Error", e);
		}
	}
	
	public ReportDTO getReport(String report_id) throws DataAccessException{
		try(Connection conn = DBConnection.getConnection()){
			return reportDAO.getReport(conn, report_id);
		}catch(SQLException e) {
			throw new DataAccessException("Failed to get report. Internal Error", e);
		}
	}
	
	public void updateReportResponse(Report report) throws RollBackException, DataAccessException, CloseConnectionException {
		Connection conn = null;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			
			reportDAO.updateReportResponse(conn, report);
			
			conn.commit();
		}catch(SQLException e) {
			if (conn!=null) {
				try {
					conn.rollback();
				}catch(SQLException e2) {
					throw new RollBackException("Failed to rollback transaction", e2);
				}
				throw new DataAccessException("Failed to update response. Internal Error", e);
			}
		}finally {
			if (conn!=null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				}catch(SQLException e){
					throw new CloseConnectionException("Failed to close Connection", e);
				}
			}
		}
	}
	
	
	public void updateReportStatus(ReportStatus status) throws RollBackException, DataAccessException, CloseConnectionException {
		Connection conn = null;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			
			status.setUpdated_at(new Timestamp(System.currentTimeMillis()));
			reportDAO.updateReportStatus(conn, status);
		}catch(SQLException e) {
			if (conn!=null) {
				try {
					conn.rollback();
				}catch(SQLException e2) {
					throw new RollBackException("Failed to rollback transaction", e2);
				}
				throw new DataAccessException("Failed to update report Status. Internal Error", e);
			}
		}finally {
			if (conn!=null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				}catch(SQLException e){
					throw new CloseConnectionException("Failed to close Connection", e);
				}
			}
		}
	}

}
