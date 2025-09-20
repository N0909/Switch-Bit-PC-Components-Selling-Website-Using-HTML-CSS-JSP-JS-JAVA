package com.switchbit.util;

import java.util.List;

public class PaginatedResult<T> {
	private final List<T> items;
	private final int page;
	private final int pageSize;
	private final int total;
	
	public PaginatedResult(List<T> items,int page, int pageSize, int total) {
		this.items = items;
		this.page = page;
		this.pageSize = pageSize;
		this.total = total;
	}
	
	public List<T> getItems() {return items;}
	public int getPage() {return page;}
	public int getPageSize() {return pageSize;}
	public int getTotal() {return total;}
	public int getTotalPages() {
		if (pageSize<=0) return 0;
		return (int)Math.ceil((total*1.0)/pageSize);
	}
}
