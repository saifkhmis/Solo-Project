package com.pizza.controllers;

import java.util.List;

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
        
        // Add favorite pizza to model if it exists
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
        
        // Get all pizza orders for this user (ordered newest first)
        List<Pizza> pizzaOrders = pizzaService.findByUserOrderByCreatedAt(userId);
        model.addAttribute("pizzaOrders", pizzaOrders);
        
        return "account.jsp";
    }
    
    @GetMapping("/account/update-profile")
    public String showUpdateProfile(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        User user = loginRegService.findById(userId);
        model.addAttribute("user", user);
        
        return "update-profile.jsp";
    }
    
    @PostMapping("/account/update-profile")
    public String processUpdateProfile(@Valid @ModelAttribute("user") User user,
                                      BindingResult result, HttpSession session,
                                      RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        if (result.hasErrors()) {
            return "update-profile.jsp";
        }
        
        // Update user information
        User updatedUser = loginRegService.updateUser(user);
        
        // Update session
        session.setAttribute("loggedInUser", updatedUser);
        
        redirectAttributes.addFlashAttribute("successMessage", "Your profile has been updated successfully!");
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
        
        // Instead of saving to database, store in session temporarily
        pizza.setUser(loggedInUser);
        
        // Calculate price before storing in session
        double price = pizzaService.calculatePrice(pizza);
        
        // Store pizza and price in session
        session.setAttribute("tempPizza", pizza);
        session.setAttribute("tempPrice", price);
        
        // Redirect to the order confirmation page without creating database entry
        return "redirect:/pizzas/confirm";
    }

    @GetMapping("/pizzas/confirm")
    public String confirmPizza(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        
        // Get pizza from session instead of database
        Pizza pizza = (Pizza) session.getAttribute("tempPizza");
        if (pizza == null) {
            return "redirect:/pizzas/new";
        }
        
        // Get price from session
        double price = (Double) session.getAttribute("tempPrice");
        
        model.addAttribute("pizza", pizza);
        model.addAttribute("price", price);
        
        return "confirmOrder.jsp";
    }

    @PostMapping("/pizzas/purchase")
    public String purchasePizza(HttpSession session, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        
        // Get pizza from session
        Pizza pizza = (Pizza) session.getAttribute("tempPizza");
        if (pizza == null) {
            return "redirect:/pizzas/new";
        }
        
        // Now actually save the pizza to database
        Pizza savedPizza = pizzaService.savePizza(pizza);
        
        // Mark as purchased
        pizzaService.markAsPurchased(savedPizza);
        
        // Clear temporary session data
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
        
        // Mark as purchased in your system
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
        
        // Create a new pizza with the same properties but don't save to DB yet
        Pizza newOrder = new Pizza();
        newOrder.setMethod(favoritePizza.getMethod());
        newOrder.setSize(favoritePizza.getSize());
        newOrder.setCrust(favoritePizza.getCrust());
        newOrder.setQuantity(favoritePizza.getQuantity());
        newOrder.setToppings(favoritePizza.getToppings());
        newOrder.setIsFavorite(false); // This one is not a favorite by default
        newOrder.setUser(loggedInUser);
        
        // Calculate price
        double price = pizzaService.calculatePrice(newOrder);
        
        // Store in session
        session.setAttribute("tempPizza", newOrder);
        session.setAttribute("tempPrice", price);
        
        // Redirect to confirmation page
        return "redirect:/pizzas/confirm";
    }
    
    // New methods for account management
    
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
        
        // Set as favorite (this will also unset any existing favorite)
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
        
        // Create a new pizza with the same properties
        Pizza newOrder = new Pizza();
        newOrder.setMethod(pizza.getMethod());
        newOrder.setSize(pizza.getSize());
        newOrder.setCrust(pizza.getCrust());
        newOrder.setQuantity(pizza.getQuantity());
        newOrder.setToppings(pizza.getToppings());
        newOrder.setIsFavorite(false); // This one is not a favorite by default
        newOrder.setUser(loggedInUser);
        
        // Calculate price
        double price = pizzaService.calculatePrice(newOrder);
        
        // Store in session
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
        
        // Delete the pizza
        pizzaService.delete(pizza);
        
        redirectAttributes.addFlashAttribute("successMessage", "Order deleted successfully!");
        return "redirect:/account";
    }
}