
package at.favre.lib;

import at.favre.lib.crypto.bcrypt.BCrypt;

public class PasswordUtil {
    public static String hashPassword(String password) {
        // Hash a password with a cost factor of 12
        return BCrypt.withDefaults().hashToString(12, password.toCharArray());
    }

    public static boolean verifyPassword(String password, String hashedPassword) {
        // Verify a password against a hash
        BCrypt.Result result = BCrypt.verifyer().verify(password.toCharArray(), hashedPassword);
        return result.verified;
    }
}
