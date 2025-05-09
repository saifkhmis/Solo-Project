package com.pizza.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pizza.models.Pizza;
import com.pizza.models.User;
import com.pizza.repository.PizzaRepository;

@Service
public class PizzaService {

    @Autowired
    private PizzaRepository pizzaRepo;

    public List<Pizza> all() {
        return pizzaRepo.findAll();
    }

    public Pizza create(Pizza pizza) {
        return pizzaRepo.save(pizza);
    }

    public Pizza find(Long id) {
        Optional<Pizza> result = pizzaRepo.findById(id);
        return result.orElse(null);
    }

    public Pizza update(Pizza pizza) {
        return pizzaRepo.save(pizza);
    }

    public void delete(Pizza pizza) {
        pizzaRepo.delete(pizza);
    }

    public List<Pizza> findByUser(User user) {
        return pizzaRepo.findAllByUser(user);
    }

    public int getOrderCountByUser(Long userId) {
        return pizzaRepo.countByUserId(userId);
    }

    public Pizza savePizza(Pizza pizza) {
        // If this pizza is being set as favorite, unset any existing favorites for this user
        if (pizza.getIsFavorite()) {
            // Find the current favorite pizza
            Pizza oldFavorite = getFavoriteByUser(pizza.getUser().getId());
            if (oldFavorite != null) {
                // Unmark it as favorite
                oldFavorite.setIsFavorite(false);
                pizzaRepo.save(oldFavorite);
            }
        }
        return pizzaRepo.save(pizza);
    }

    // Methods for favorite pizza
    public Pizza getFavoriteByUser(Long userId) {
        return pizzaRepo.findByUserIdAndIsFavoriteTrue(userId);
    }

    public Pizza reorderFavoritePizza(Long userId) {
        // Get the favorite pizza for this user
        Pizza favoritePizza = getFavoriteByUser(userId);

        if (favoritePizza != null) {
            // Create a new pizza with the same properties
            Pizza newPizza = new Pizza();
            newPizza.setMethod(favoritePizza.getMethod());
            newPizza.setSize(favoritePizza.getSize());
            newPizza.setCrust(favoritePizza.getCrust());
            newPizza.setQuantity(favoritePizza.getQuantity());
            newPizza.setToppings(favoritePizza.getToppings());
            newPizza.setIsFavorite(false); // This one is not a favorite by default
            newPizza.setUser(favoritePizza.getUser());

            return pizzaRepo.save(newPizza);
        }

        return null;
    }
    
    // Calculate pizza price based on size, toppings, etc.
    public double calculatePrice(Pizza pizza) {
        double basePrice = 0.0;
        
        // Set base price based on size
        if ("Small".equals(pizza.getSize())) {
            basePrice = 8.99;
        } else if ("Medium".equals(pizza.getSize())) {
            basePrice = 10.99;
        } else if ("Large".equals(pizza.getSize())) {
            basePrice = 12.99;
        }
        
        // Add cost for toppings (first topping is free, others are $0.75 each)
        List<String> toppings = pizza.getToppings();
        if (toppings != null && toppings.size() > 1) {
            basePrice += (toppings.size() - 1) * 0.75;
        }
        
        // Add delivery fee if applicable
        if ("Delivery".equals(pizza.getMethod())) {
            basePrice += 2.50;
        }
        
        // Multiply by quantity
        basePrice *= pizza.getQuantity();
        
        // Round to 2 decimal places
        return Math.round(basePrice * 100.0) / 100.0;
    }
    
    // Mark pizza as purchased
    public void markAsPurchased(Pizza pizza) {
        // In a real app, you might set a status field, record payment info, etc.
        // For now, we'll just save the pizza to demonstrate the flow
        pizzaRepo.save(pizza);
    }
    
    // Find pizzas by user ordered by creation date
    public List<Pizza> findByUserOrderByCreatedAt(Long userId) {
        return pizzaRepo.findByUserIdOrderByCreatedAtDesc(userId);
    }
}