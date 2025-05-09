package com.pizza.services;

import java.util.Optional;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import com.pizza.models.LoginUser;
import com.pizza.models.User;
import com.pizza.repository.UserRepository;


@Service
public class LoginAndRegisterService {
    
    @Autowired
    private UserRepository userRepo;
    
    public User register(User newUser, BindingResult result) {
        Optional<User> potentialUser = userRepo.findByEmail(newUser.getEmail());
        if(potentialUser.isPresent()) {
            result.rejectValue("email", "Matches", "An account with that email already exists!");
        }
        
        if(!newUser.getPassword().equals(newUser.getConfirm())) {
            result.rejectValue("confirm", "Matches", "The Confirm Password must match Password!");
        }
        
        if(result.hasErrors()) {
            return null;
        }
        
        String hashedPw = BCrypt.hashpw(newUser.getPassword(), BCrypt.gensalt());
        newUser.setPassword(hashedPw);
        return userRepo.save(newUser);
    }
    
    public User login(LoginUser loginUser, BindingResult result) {
        Optional<User> potentialUser = userRepo.findByEmail(loginUser.getEmail());
        if(!potentialUser.isPresent()) {
            result.rejectValue("email", "Matches", "Unknown email!");
            return null;
        }

        User user = potentialUser.get();
        if(!BCrypt.checkpw(loginUser.getPassword(), user.getPassword())) {
            result.rejectValue("password", "Matches", "Invalid password!");
            return null;
        }

        return user;
    }
    
    public User findById(Long id) {
        Optional<User> potentialUser = userRepo.findById(id);
        return potentialUser.orElse(null);
    }
    
    
    public User updateAddress(Long userId, String address, String city, String state, Double latitude, Double longitude) {
        Optional<User> optionalUser = userRepo.findById(userId);
        if(optionalUser.isPresent()) {
            User user = optionalUser.get();
            user.setAddress(address);
            user.setCity(city);
            user.setState(state);
            user.setLatitude(latitude);
            user.setLongitude(longitude);
            return userRepo.save(user);
        }
        return null;
    }
    public User updateUser(User user) {
        return userRepo.save(user);
    }

    public boolean updatePassword(Long userId, String currentPassword, String newPassword) {
        Optional<User> optionalUser = userRepo.findById(userId);
        if (optionalUser.isEmpty()) {
            return false;
        }
        User user = optionalUser.get();
        if (!BCrypt.checkpw(currentPassword, user.getPassword())) {
            return false;
        }
        String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        user.setPassword(hashedNewPassword);
        userRepo.save(user);
        return true;
    }
}
