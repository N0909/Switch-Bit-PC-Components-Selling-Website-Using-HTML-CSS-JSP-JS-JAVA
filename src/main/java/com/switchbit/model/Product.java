package com.switchbit.model;
import java.sql.Timestamp;
import com.switchbit.model.Category;

public class Product {
	private String product_id;
	private String product_name;
	private String description;
	private double price;
	private int stock_quantity;
	private Category category;
	private String product_img;
	private Timestamp last_updated;
	
	public Product() {}

	public Product(String product_id, String product_name, String description, double price, int stock_quantity,
			Category category, String product_img, Timestamp last_updated) {
		this.product_id = product_id;
		this.product_name = product_name;
		this.description = description;
		this.price = price;
		this.stock_quantity = stock_quantity;
		this.category = category;
		this.product_img = product_img;
		this.last_updated = last_updated;
	}

	public String getProduct_id() {
		return product_id;
	}

	public String getProduct_name() {
		return product_name;
	}

	public String getDescription() {
		return description;
	}

	public double getPrice() {
		return price;
	}

	public int getStock_quantity() {
		return stock_quantity;
	}

	public Category getCategory() {
		return category;
	}

	public String getProduct_img() {
		return product_img;
	}

	public Timestamp getLast_updated() {
		return last_updated;
	}

	public void setProduct_id(String product_id) {
		this.product_id = product_id;
	}

	public void setProduct_name(String product_name) {
		this.product_name = product_name;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public void setStock_quantity(int stock_quantity) {
		this.stock_quantity = stock_quantity;
	}

	public void setCategory(Category category) {
		this.category = category;
	}

	public void setProduct_img(String product_img) {
		this.product_img = product_img;
	}

	public void setLast_updated(Timestamp last_updated) {
		this.last_updated = last_updated;
	}

	@Override
	public String toString() {
		return "Product [product_id=" + product_id + ", product_name=" + product_name + ", description=" + description
				+ ", price=" + price + ", stock_quantity=" + stock_quantity + ", category=" + category
				+ ", product_img=" + product_img + ", last_updated=" + last_updated + "]";
	}
	
	
	
}
