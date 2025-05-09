/**
 * 
 */
document.addEventListener('DOMContentLoaded', function() {
    // Add pizza emoji animations
    function createFloatingPizzas() {
        const container = document.querySelector('.login-container');
        const pizzaCount = 5;
        
        for (let i = 0; i < pizzaCount; i++) {
            const pizza = document.createElement('div');
            pizza.innerHTML = '🍕';
            pizza.className = 'floating-pizza';
            pizza.style.position = 'absolute';
            pizza.style.fontSize = `${Math.random() * 1.5 + 1}rem`;
            pizza.style.opacity = '0.6';
            pizza.style.zIndex = '-1';
            pizza.style.left = `${Math.random() * 100}%`;
            pizza.style.top = `${Math.random() * 100}%`;
            pizza.style.animation = `float ${Math.random() * 6 + 6}s infinite ease-in-out, 
                                     spin ${Math.random() * 10 + 10}s infinite linear ${Math.random() > 0.5 ? '' : 'reverse'}`;
            
            container.appendChild(pizza);
        }
    }
    
    // Add animation to form inputs
    const formControls = document.querySelectorAll('.form-control');
    formControls.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.classList.add('input-focused');
        });
        
        input.addEventListener('blur', function() {
            if (!this.value) {
                this.parentElement.classList.remove('input-focused');
            }
        });
    });
    
    // Create the floating pizzas
    createFloatingPizzas();
    
    // Add button click animation
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(button => {
        button.addEventListener('click', function(e) {
            // Only proceed with animation if it's not an actual form submission
            if (!e.target.type === 'submit') {
                const circle = document.createElement('span');
                circle.classList.add('circle-animation');
                
                const x = e.clientX - e.target.getBoundingClientRect().left;
                const y = e.clientY - e.target.getBoundingClientRect().top;
                
                circle.style.top = y + 'px';
                circle.style.left = x + 'px';
                
                this.appendChild(circle);
                
                setTimeout(() => circle.remove(), 500);
            }
        });
    });

    // Animate entrance of form
    const formSection = document.querySelector('.form-section');
    formSection.style.opacity = '0';
    formSection.style.transform = 'translateY(20px)';
    
    setTimeout(() => {
        formSection.style.transition = 'opacity 0.8s ease, transform 0.8s ease';
        formSection.style.opacity = '1';
        formSection.style.transform = 'translateY(0)';
    }, 100);
});

// Add additional animation CSS
const additionalStyle = document.createElement('style');
additionalStyle.textContent = `
    .floating-pizza {
        position: absolute;
        z-index: -1;
    }
    
    @keyframes float {
        0%, 100% {
            transform: translateY(0) rotate(0deg);
        }
        50% {
            transform: translateY(-20px) rotate(10deg);
        }
    }
    
    @keyframes spin {
        from {
            transform: rotate(0deg);
        }
        to {
            transform: rotate(360deg);
        }
    }
    
    .input-focused label {
        color: #e63946;
    }
    
    .circle-animation {
        position: absolute;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.3);
        transform: scale(0);
        animation: circleExpand 0.5s ease-out;
        pointer-events: none;
    }
    
    @keyframes circleExpand {
        to {
            transform: scale(3);
            opacity: 0;
        }
    }
    
    .alert {
        animation: fadeSlideIn 0.5s ease-out;
    }
    
    @keyframes fadeSlideIn {
        from {
            opacity: 0;
            transform: translateY(-10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
`;

document.head.appendChild(additionalStyle);