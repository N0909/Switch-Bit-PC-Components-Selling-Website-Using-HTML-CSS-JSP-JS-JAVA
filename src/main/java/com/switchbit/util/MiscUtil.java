package com.switchbit.util;

import com.switchbit.dto.CartDTO;
import com.switchbit.dto.CartItemDTO;
import com.switchbit.model.CartItem;

/**
 * Utility class for miscellaneous helper functions.
 */
public class MiscUtil {

    /**
     * Generates the next ID by incrementing the numeric part of an existing ID.
     *
     * @param prefix The prefix string (e.g., "USR").
     * @param id     The current ID string (e.g., "USR0009").
     * @return The next ID with the same prefix and zero-padded numeric part (e.g., "USR0010").
     */
    public static String idGenerator(String prefix, String id) {
        // Extract the numeric part of the ID (everything after the prefix)
        String numericPart = id.substring(prefix.length());

        // Parse to int and increment
        int nextNumber = Integer.parseInt(numericPart) + 1;

        // Preserve the same length with zero-padding
        String paddedNumber = String.format("%0" + numericPart.length() + "d", nextNumber);

        // Return prefix + padded number
        return prefix + paddedNumber;
    }

    /**
     * Generates the next ID by replacing the numeric suffix of an ID with a provided number.
     *
     * Example: id="USR0009", next=25 → "USR0025"
     *
     * @param id   The current ID string (e.g., "USR0009").
     * @param next The new numeric part to insert (e.g., 25).
     * @return A new ID with the same prefix and zero-padded numeric part (e.g., "USR0025").
     */
    public static String idGenerator(String id, int next) {
        // Find the first digit index (start of numeric part)
        int firstDigitIndex = -1;
        for (int i = 0; i < id.length(); i++) {
            if (Character.isDigit(id.charAt(i))) {
                firstDigitIndex = i;
                break;
            }
        }

        if (firstDigitIndex == -1) {
            throw new IllegalArgumentException("ID does not contain a numeric part: " + id);
        }

        // Extract prefix and numeric part
        String prefix = id.substring(0, firstDigitIndex);
        String numericPart = id.substring(firstDigitIndex);

        // Format the new number with the same width (zero-padded)
        String paddedNumber = String.format("%0" + numericPart.length() + "d", next);

        return prefix + paddedNumber;
    }
    
    /**
     * Calculates the total cost of all items in the cart.
     * 
     * @param dto The CartDTO object containing all cart items and their details
     * @return total The calculated total price of the cart
     */
    public static double CalcuateTotal(CartDTO dto) {
        double total = 0; // Variable to store the total cart value

        // Loop through each item in the cart
        for (CartItemDTO item : dto.getItems()) {
            // Multiply product price by its quantity and add to total
            total += item.getCartItem().getQuantity() * item.getProduct().getPrice();
        }

        // Return the final calculated total
        return total;
    }

}
