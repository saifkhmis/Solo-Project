package com.pizza.repository;



import java.util.List;


import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.pizza.models.Pizza;
import com.pizza.models.User;

@Repository
public interface PizzaRepository extends CrudRepository<Pizza, Long> {
    List<Pizza> findAll();
    List<Pizza> findAllByUser(User user);
    int countByUserId(Long userId);
    Pizza findByUserIdAndIsFavoriteTrue(Long userId);
 // Find pizzas by user ordered by creation date (newest first)
    List<Pizza> findByUserIdOrderByCreatedAtDesc(Long userId);
    List<Pizza> findByUserId(Long userId);
    int countByUserIdAndPurchasedTrue(Long userId);
    
}
