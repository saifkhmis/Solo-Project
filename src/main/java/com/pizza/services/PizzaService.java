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
        if (pizza.getIsFavorite()) {
            Pizza oldFavorite = getFavoriteByUser(pizza.getUser().getId());
            if (oldFavorite != null) {
                oldFavorite.setIsFavorite(false);
                pizzaRepo.save(oldFavorite);
            }
        }
        return pizzaRepo.save(pizza);
    }
    public Pizza getFavoriteByUser(Long userId) {
        return pizzaRepo.findByUserIdAndIsFavoriteTrue(userId);
    }

    public Pizza reorderFavoritePizza(Long userId) {
        Pizza favoritePizza = getFavoriteByUser(userId);
        if (favoritePizza != null) {
            Pizza newPizza = new Pizza();
            newPizza.setMethod(favoritePizza.getMethod());
            newPizza.setSize(favoritePizza.getSize());
            newPizza.setCrust(favoritePizza.getCrust());
            newPizza.setQuantity(favoritePizza.getQuantity());
            newPizza.setToppings(favoritePizza.getToppings());
            newPizza.setIsFavorite(false);
            newPizza.setUser(favoritePizza.getUser());
            return pizzaRepo.save(newPizza);
        }

        return null;
    }
    public double calculatePrice(Pizza pizza) {
        double basePrice = 0.0;
        if ("Small".equals(pizza.getSize())) {
            basePrice = 8.99;
        } else if ("Medium".equals(pizza.getSize())) {
            basePrice = 10.99;
        } else if ("Large".equals(pizza.getSize())) {
            basePrice = 12.99;
        }
        List<String> toppings = pizza.getToppings();
        if (toppings != null && toppings.size() > 1) {
            basePrice += (toppings.size() - 1) * 0.75;
        }
        if ("Delivery".equals(pizza.getMethod())) {
            basePrice += 2.50;
        }
        basePrice *= pizza.getQuantity();
        return Math.round(basePrice * 100.0) / 100.0;
    }
    public void markAsPurchased(Pizza pizza) {
        pizzaRepo.save(pizza);
    }
    public List<Pizza> findByUserOrderByCreatedAt(Long userId) {
        return pizzaRepo.findByUserIdOrderByCreatedAtDesc(userId);
    }
}