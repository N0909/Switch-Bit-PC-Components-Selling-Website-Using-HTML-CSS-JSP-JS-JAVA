package com.switchbit.util;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.switchbit.exceptions.DataAccessException;

/**
 * DAO utility for generating sequential IDs from the database.
 * Uses stored procedures:
 *  - getCurrentId(name) → fetch current sequence value
 *  - updateId(name, val) → update sequence with new value
 */
public class IdGeneratorDAO {

    /**
     * Fetch the current sequence value without incrementing.
     * 
     * @param seqName the sequence name (e.g., "USER", "ORDER")
     * @return the current value
     */
    public static int getCurrentIdVal(String seqName) {
        int currentVal = -1;

        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall("{call getCurrentId(?)}")) {

            cs.setString(1, seqName);

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    currentVal = rs.getInt(1); // fetch first column
                }
            }

        } catch (SQLException e) {
            throw new DataAccessException("Failed to fetch current sequence for: " + seqName, e);
        }

        return currentVal;
    }

    /**
     * Fetch the next sequence value and update the database.
     * 
     * @param seqName the sequence name (e.g., "USER", "ORDER")
     * @return the incremented sequence value
     */
    public static void setNextIdVal(Connection conn,String seqName) {
        int currentVal = getCurrentIdVal(seqName);
        int nextVal = currentVal + 1;

        try ( CallableStatement cs = conn.prepareCall("{call updateId(?, ?)}")) {

            cs.setString(1, seqName);
            cs.setInt(2, nextVal);
            cs.executeUpdate();

        } catch (SQLException e) {
            throw new DataAccessException("Failed to update sequence for: " + seqName, e);
        }
    }
}
