package com.switchbit.dto;
import com.switchbit.model.*;

public class CartItemDTO {
	private CartItem cartitem;
	private Product product;
	
	public CartItemDTO() {}
	
	public CartItemDTO(CartItem cartitem, Product product) {
		this.cartitem = cartitem;
		this.product = product;
	}
	
	public void setProduct(Product product) {
		this.product = product;
	}
	
	public void setCartItem(CartItem cartitem) {
		this.cartitem = cartitem;
	}
	
	public CartItem getCartItem() {
		return cartitem;
	}
	
	public Product getProduct() {
		return product;
	}
}
