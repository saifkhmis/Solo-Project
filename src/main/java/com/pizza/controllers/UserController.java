package com.pizza.controllers;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pizza.models.LoginUser;
import com.pizza.models.Pizza;
import com.pizza.models.User;
import com.pizza.services.LoginAndRegisterService;
import com.pizza.services.PizzaService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class UserController {

    @Autowired
    private LoginAndRegisterService loginRegService;
    
    @Autowired
    private PizzaService pizzaService;
    
    @ModelAttribute
    public void addGlobalAttributes(Model model, HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int orderCount = 0;
        if (loggedInUser != null) {
            orderCount = pizzaService.getOrderCountByUser(loggedInUser.getId());
        }
        model.addAttribute("cartCount", orderCount);
    }

    @GetMapping("/")
    public String rootRedirect() {
        return "redirect:/login";
    }

    @GetMapping("/register")
    public String showRegister(Model model) {
        model.addAttribute("newUser", new User());
        return "register.jsp";
    }

    @PostMapping("/register")
    public String processRegister(@Valid @ModelAttribute("newUser") User newUser,
                                  BindingResult result, HttpSession session, Model model) {
        User registeredUser = loginRegService.register(newUser, result);
        if (result.hasErrors()) {
            return "register.jsp";
        }
        session.setAttribute("userId", registeredUser.getId());
        session.setAttribute("loggedInUser", registeredUser);
        return "redirect:/home";
    }

    @GetMapping("/login")
    public String showLogin(Model model) {
        model.addAttribute("newLogin", new LoginUser());
        return "login.jsp";
    }

    @PostMapping("/login")
    public String processLogin(@Valid @ModelAttribute("newLogin") LoginUser newLogin,
                               BindingResult result, HttpSession session, Model model) {
        User existingUser = loginRegService.login(newLogin, result);
        if (result.hasErrors()) {
            return "login.jsp";
        }
        session.setAttribute("userId", existingUser.getId());
        session.setAttribute("loggedInUser", existingUser);
        return "redirect:/home";
    }

    @GetMapping("/home")
    public String showHome(HttpSession session, Model model) {
        Long id = (Long) session.getAttribute("userId");
        if (id == null) {
            return "redirect:/login";
        }
        User user = loginRegService.findById(id);
        model.addAttribute("user", user);
        Pizza favoritePizza = pizzaService.getFavoriteByUser(id);
        if (favoritePizza != null) {
            model.addAttribute("favoritePizza", favoritePizza);
        }
        
        return "home.jsp";
    }

    @GetMapping("/logout")
    public String logoutUser(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/account")
    public String accountPage(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        User user = loginRegService.findById(userId);
        model.addAttribute("user", user);
        List<Pizza> pizzaOrders = pizzaService.findByUserOrderByCreatedAt(userId);
        model.addAttribute("pizzaOrders", pizzaOrders);
        
        return "account.jsp";
    }
    
    @GetMapping("/pizzas/edit/{id}")
    public String editPizza(@PathVariable("id") Long id, Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        Pizza pizza = pizzaService.find(id);
        if (pizza == null || !pizza.getUser().getId().equals(userId)) {
            return "redirect:/account";
        }
        
        model.addAttribute("pizza", pizza);
        return "editPizza.jsp";
    }

    @PostMapping("/pizzas/update/{id}")
    public String updatePizza(@PathVariable("id") Long id, 
                             @Valid @ModelAttribute("pizza") Pizza pizza,
                             BindingResult result,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        if (result.hasErrors()) {
            return "editPizza.jsp";
        }
        
        Pizza existingPizza = pizzaService.find(id);
        if (existingPizza == null || !existingPizza.getUser().getId().equals(userId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Pizza not found or not authorized.");
            return "redirect:/account";
        }
        existingPizza.setMethod(pizza.getMethod());
        existingPizza.setSize(pizza.getSize());
        existingPizza.setCrust(pizza.getCrust());
        existingPizza.setQuantity(pizza.getQuantity());
        existingPizza.setToppings(pizza.getToppings());
        pizzaService.savePizza(existingPizza);
        redirectAttributes.addFlashAttribute("successMessage", "Pizza updated successfully!");
        return "redirect:/account";
    }

    @GetMapping("/pizzas/new")
    public String newPizza(@ModelAttribute("pizza") Pizza pizza, Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        User user = loginRegService.findById(userId);
        model.addAttribute("user", user);
        return "pizzaForm.jsp";
    }

    @PostMapping("/pizzas/new")
    public String createPizza(@Valid @ModelAttribute("pizza") Pizza pizza, 
                             BindingResult result, 
                             HttpSession session,
                             Model model) {
        
        if (result.hasErrors()) {
            return "pizzaForm.jsp";
        }
        
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
            return "redirect:/login";
        }
        pizza.setUser(loggedInUser);
        double price = pizzaService.calculatePrice(pizza);
        session.setAttribute("tempPizza", pizza);
        session.setAttribute("tempPrice", price);
        return "redirect:/pizzas/confirm";
    }

    @GetMapping("/pizzas/confirm")
    public String confirmPizza(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        Pizza pizza = (Pizza) session.getAttribute("tempPizza");
        if (pizza == null) {
            return "redirect:/pizzas/new";
        }
        double price = (Double) session.getAttribute("tempPrice");
        
        model.addAttribute("pizza", pizza);
        model.addAttribute("price", price);
        return "confirmOrder.jsp";
    }

    @PostMapping("/pizzas/purchase")
    public String purchasePizza(HttpSession session, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        Pizza pizza = (Pizza) session.getAttribute("tempPizza");
        if (pizza == null) {
            return "redirect:/pizzas/new";
        }
        Pizza savedPizza = pizzaService.savePizza(pizza);
        pizzaService.markAsPurchased(savedPizza);
        session.removeAttribute("tempPizza");
        session.removeAttribute("tempPrice");
        redirectAttributes.addFlashAttribute("successMessage", "Your pizza has been purchased successfully!");
        return "redirect:/home";
    }
    
    @PostMapping("/pizzas/purchase/{id}")
    public String purchasePizza(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        
        Pizza pizza = pizzaService.find(id);
        if (pizza == null || !pizza.getUser().getId().equals(userId)) {
            return "redirect:/home";
        }
        pizzaService.markAsPurchased(pizza);
        redirectAttributes.addFlashAttribute("successMessage", "Your pizza has been purchased successfully!");
        return "redirect:/home";
    }

    @GetMapping("/reorder-favorite")
    public String reorderFavorite(HttpSession session, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        Pizza favoritePizza = pizzaService.getFavoriteByUser(userId);
        
        if (favoritePizza == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "You don't have a favorite pizza yet! Create one first.");
            return "redirect:/home";
        }
        Pizza newOrder = new Pizza();
        newOrder.setMethod(favoritePizza.getMethod());
        newOrder.setSize(favoritePizza.getSize());
        newOrder.setCrust(favoritePizza.getCrust());
        newOrder.setQuantity(favoritePizza.getQuantity());
        newOrder.setToppings(favoritePizza.getToppings());
        newOrder.setIsFavorite(false);
        newOrder.setUser(loggedInUser);
        double price = pizzaService.calculatePrice(newOrder);
        session.setAttribute("tempPizza", newOrder);
        session.setAttribute("tempPrice", price);
        return "redirect:/pizzas/confirm";
    }
    
    @PostMapping("/pizzas/set-favorite/{id}")
    public String setFavoritePizza(@PathVariable("id") Long pizzaId, HttpSession session, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        Pizza pizza = pizzaService.find(pizzaId);
        if (pizza == null || !pizza.getUser().getId().equals(userId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Pizza not found or not authorized.");
            return "redirect:/account";
        }
        pizza.setIsFavorite(true);
        pizzaService.savePizza(pizza);
        
        redirectAttributes.addFlashAttribute("successMessage", "Your favorite pizza has been updated!");
        return "redirect:/account";
    }
    
    @PostMapping("/pizzas/reorder/{id}")
    public String reorderPizza(@PathVariable("id") Long pizzaId, HttpSession session, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        Pizza pizza = pizzaService.find(pizzaId);
        if (pizza == null || !pizza.getUser().getId().equals(userId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Pizza not found or not authorized.");
            return "redirect:/account";
        }
        
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        Pizza newOrder = new Pizza();
        newOrder.setMethod(pizza.getMethod());
        newOrder.setSize(pizza.getSize());
        newOrder.setCrust(pizza.getCrust());
        newOrder.setQuantity(pizza.getQuantity());
        newOrder.setToppings(pizza.getToppings());
        newOrder.setIsFavorite(false);
        newOrder.setUser(loggedInUser);
        double price = pizzaService.calculatePrice(newOrder);
        session.setAttribute("tempPizza", newOrder);
        session.setAttribute("tempPrice", price);        
        return "redirect:/pizzas/confirm";
    }
    
    @PostMapping("/pizzas/delete/{id}")
    public String deletePizza(@PathVariable("id") Long pizzaId, HttpSession session, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        Pizza pizza = pizzaService.find(pizzaId);
        if (pizza == null || !pizza.getUser().getId().equals(userId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Pizza not found or not authorized.");
            return "redirect:/account";
        }
        pizzaService.delete(pizza);
        
        redirectAttributes.addFlashAttribute("successMessage", "Order deleted successfully!");
        return "redirect:/account";
    }
    
    
    @GetMapping("/surprise-pizza")
    public String surprisePizza(HttpSession session, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        Pizza randomPizza = new Pizza();
        String[] methods = {"Pickup", "Delivery"};
        randomPizza.setMethod(methods[(int) (Math.random() * methods.length)]);
        String[] sizes = {"Small", "Medium", "Large"};
        randomPizza.setSize(sizes[(int) (Math.random() * sizes.length)]);
        String[] crusts = {"Thin", "Regular", "Deep Dish", "Stuffed"};
        randomPizza.setCrust(crusts[(int) (Math.random() * crusts.length)]);
        randomPizza.setQuantity((int) (Math.random() * 3) + 1);
        String[] allToppings = {"Cheese", "Pepperoni", "Sausage", "Mushrooms", "Onions", 
                              "Green Peppers", "Black Olives", "Bacon", "Ham", "Pineapple"};
        List<String> selectedToppings = new ArrayList<>();
        selectedToppings.add("Cheese");
        int numExtraToppings = (int) (Math.random() * 5);
        Set<Integer> usedIndices = new HashSet<>();
        for (int i = 0; i < numExtraToppings; i++) {
            int index;
            do {
                index = (int) (Math.random() * (allToppings.length - 1)) + 1;
            } while (usedIndices.contains(index));
            
            usedIndices.add(index);
            selectedToppings.add(allToppings[index]);
        }
        randomPizza.setToppings(selectedToppings);
        randomPizza.setIsFavorite(false);
        randomPizza.setUser(loggedInUser);
        double price = pizzaService.calculatePrice(randomPizza);
        session.setAttribute("tempPizza", randomPizza);
        session.setAttribute("tempPrice", price);
        
        return "redirect:/pizzas/confirm";
    }
}