package com.switchbit.util;

import java.util.List;

/**
 * A generic class to represent paginated results.
 * This is useful when fetching data in pages from a database or API.
 *
 * @param <T> The type of items being paginated
 */
public class PaginatedResult<T> {

    private final List<T> items;   // The list of items on the current page
    private final int page;        // Current page number (starting from 1)
    private final int pageSize;    // Number of items per page
    private final int total;       // Total number of items across all pages

    /**
     * Constructor to create a paginated result object.
     * 
     * @param items The items for the current page
     * @param page Current page number
     * @param pageSize Number of items per page
     * @param total Total number of items
     */
    public PaginatedResult(List<T> items, int page, int pageSize, int total) {
        this.items = items;
        this.page = page;
        this.pageSize = pageSize;
        this.total = total;
    }

    // Getter for items
    public List<T> getItems() { return items; }

    // Getter for current page number
    public int getPage() { return page; }

    // Getter for page size
    public int getPageSize() { return pageSize; }

    // Getter for total items
    public int getTotal() { return total; }

    /**
     * Calculates the total number of pages based on total items and page size.
     * 
     * @return total number of pages
     */
    public int getTotalPages() {
        if (pageSize <= 0) return 0; // Avoid division by zero
        return (int) Math.ceil((total * 1.0) / pageSize);
    }
}
