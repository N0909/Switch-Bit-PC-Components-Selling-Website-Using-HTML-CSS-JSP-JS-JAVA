import java.sql.*;

import com.switchbit.dao.UserDAO;
import com.switchbit.model.*;

public class Test {
	public static void main(String[] args) {
		UserDAO userdao = new UserDAO();
		User user = new User("USER001","TEST1","USER003@gmail.com","1234567890","DELHI",new Timestamp(System.currentTimeMillis()));
		Password user_pass = new Password("USER001","7878908",new Timestamp(System.currentTimeMillis()));
		userdao.addUser(user, user_pass);
		System.out.println("Executed");
	}

}
