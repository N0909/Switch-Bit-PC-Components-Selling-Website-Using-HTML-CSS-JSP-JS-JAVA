package com.switchbit.dto;
import com.switchbit.model.*;

public class UserWithPassword {
    private User user;
    private Password password;

    public UserWithPassword(User user, Password password) {
        this.user = user;
        this.password = password;
    }

    public User getUser() { return user; }
    public Password getPassword() { return password; }
}
