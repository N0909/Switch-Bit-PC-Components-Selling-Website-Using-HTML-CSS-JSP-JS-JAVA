import java.sql.*;
import java.util.ArrayList;

import com.switchbit.util.*;
import com.switchbit.dao.CartDAO;
import com.switchbit.dao.ProductDAO;
import com.switchbit.dao.UserDAO;
import com.switchbit.dto.UserWithPassword;
import com.switchbit.exceptions.*;
import com.switchbit.model.*;
import com.switchbit.service.*;
import com.switchbit.service.ProductService;
import com.switchbit.dao.ProductDAO;

public class Test {
	public static void main(String[] args) {
		CartService cart_service = new CartService();
		UserService user_service = new UserService();
		ProductService prod_service = new ProductService();
		CartDAO cart_dao = new CartDAO();
		
		try {
			Connection conn = DBConnection.getConnection();
			Cart cart = new Cart();
			CartItem cartItem = new CartItem();
			Product product = prod_service.getProduct("PROD002");
			User user = user_service.verifyUser("USR00001", "1234567890");
            			
			cart.setCart_id("CART0000");
			cart.setUser(user);
			cart.setCreated_at(new Timestamp(System.currentTimeMillis()));

			cartItem.setCart_item_id("CI000");
			cartItem.setCart(cart);
			cartItem.setProduct(product);
			cartItem.setQuantity(5);
			
			cart_service.updateCartItemQuantity(cartItem);
			
			System.out.println("Successfully delted Cart item");
		} catch (AuthenticationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvalidUserException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (RollBackException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (CloseConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
