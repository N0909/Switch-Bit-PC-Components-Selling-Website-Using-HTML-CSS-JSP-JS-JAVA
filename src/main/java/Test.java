import java.sql.*;

import com.switchbit.util.*;
import com.switchbit.dao.ProductDAO;
import com.switchbit.dao.UserDAO;
import com.switchbit.dto.UserWithPassword;
import com.switchbit.exceptions.AuthenticationException;
import com.switchbit.exceptions.DuplicateResourceException;
import com.switchbit.model.*;
import com.switchbit.service.UserService;
import com.switchbit.util.PasswordUtil;
import com.switchbit.model.Product;
import com.switchbit.dao.ProductDAO;

public class Test {
	public static void main(String[] args) {
		ProductDAO productDAO = new ProductDAO();
		
		try {
			Connection conn = DBConnection.getConnection();
			for (Product product: productDAO.searchProducts(conn,"intel processors")) {
				System.out.println(product.toString());
			}
			
		}catch(SQLException e) {
			System.out.println(e);
		}
	}

}
