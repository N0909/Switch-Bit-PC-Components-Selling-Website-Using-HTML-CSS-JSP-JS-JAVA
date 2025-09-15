package com.switchbit.util;
import at.favre.lib.crypto.bcrypt.BCrypt;



public class PasswordUtil {
	
	/**
     * Hash a plaintext password using bcrypt.
     *
     * @param plainPassword the user's plaintext password
     * @return bcrypt hashed password
     */
	
	public static String hashPassword(String plainPassword) {
		return BCrypt.withDefaults().hashToString(12, plainPassword.toCharArray());
	}
	
	public static boolean verifyPassword(String plainPassword, String hashedPassword) {
		BCrypt.Result result  = BCrypt.verifyer().verify(plainPassword.toCharArray(), hashedPassword);
		return result.verified;
	}
}
