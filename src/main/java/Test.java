import java.sql.*;
import com.switchbit.util.*;

import com.switchbit.dao.UserDAO;
import com.switchbit.dto.UserWithPassword;
import com.switchbit.exceptions.AuthenticationException;
import com.switchbit.exceptions.DuplicateResourceException;
import com.switchbit.model.*;
import com.switchbit.service.UserService;
import com.switchbit.util.PasswordUtil;

public class Test {
	
	public static void main(String[] args) {
		UserService service = new UserService();
		
		// "USR00001","N","meetnikhhil@gmail.com","8368872770","L-4/282",
		
		try {
			
			User user = service.verifyUser("8368872770", "7878908");
			System.out.println(user.getUserName());
			
		} catch (AuthenticationException e) {
			// TODO Auto-generated catch block
			System.out.print(e);
		}
		
		
				
	}

}
