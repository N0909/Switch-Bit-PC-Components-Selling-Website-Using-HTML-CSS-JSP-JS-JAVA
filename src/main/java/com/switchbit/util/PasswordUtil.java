package com.switchbit.util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * Utility class for hashing and verifying passwords using bcrypt.
 */
public class PasswordUtil {

    /**
     * Hash a plaintext password using bcrypt.
     *
     * @param plainPassword The user's plaintext password
     * @return Bcrypt hashed password
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.withDefaults().hashToString(12, plainPassword.toCharArray());
    }

    /**
     * Verify a plaintext password against a bcrypt hashed password.
     *
     * @param plainPassword Plaintext password to verify
     * @param hashedPassword Bcrypt hashed password
     * @return true if passwords match, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        BCrypt.Result result = BCrypt.verifyer().verify(plainPassword.toCharArray(), hashedPassword);
        return result.verified;
    }
}


