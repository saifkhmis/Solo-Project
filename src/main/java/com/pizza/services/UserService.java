package com.pizza.services;



import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pizza.models.User;
import com.pizza.repository.UserRepository;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepo;

    public User find(Long id) {
        Optional<User> result = userRepo.findById(id);
        return result.orElse(null);
    }
}
