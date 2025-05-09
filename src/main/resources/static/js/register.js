/**
 * 
 */
document.addEventListener('DOMContentLoaded', function() {
    // Initialize map from Leaflet
    var map = L.map('map').setView([40.7128, -74.0060], 13);
    
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    
    var marker = L.marker([40.7128, -74.0060], {
        draggable: true,
        icon: L.divIcon({
            className: 'pizza-marker',
            html: '🍕',
            iconSize: [30, 30],
            iconAnchor: [15, 15]
        })
    }).addTo(map);
    
    // Update form fields when marker is moved
    marker.on('dragend', function(e) {
        var position = marker.getLatLng();
        document.getElementById('latitude-input').value = position.lat;
        document.getElementById('longitude-input').value = position.lng;
        
        // Reverse geocoding to get address
        fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.lat}&lon=${position.lng}`)
            .then(response => response.json())
            .then(data => {
                if (data.address) {
                    document.getElementById('address-input').value = data.address.road || '';
                    document.getElementById('city-input').value = data.address.city || data.address.town || '';
                    document.getElementById('state-input').value = data.address.state || '';
                    
                    // Add pulse animation to updated fields
                    ['address-input', 'city-input', 'state-input'].forEach(id => {
                        const el = document.getElementById(id);
                        el.classList.add('field-updated');
                        setTimeout(() => el.classList.remove('field-updated'), 1000);
                    });
                }
            })
            .catch(error => console.error('Error:', error));
    });
    
    // Address search function
    document.getElementById('address-input').addEventListener('blur', function() {
        const address = this.value;
        if (address) {
            showSpinner();
            
            fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}`)
                .then(response => response.json())
                .then(data => {
                    hideSpinner();
                    
                    if (data && data.length > 0) {
                        const lat = parseFloat(data[0].lat);
                        const lon = parseFloat(data[0].lon);
                        
                        map.setView([lat, lon], 15);
                        marker.setLatLng([lat, lon]);
                        
                        document.getElementById('latitude-input').value = lat;
                        document.getElementById('longitude-input').value = lon;
                        
                        // Fill city and state if they're empty
                        if (!document.getElementById('city-input').value) {
                            document.getElementById('city-input').value = data[0].address?.city || 
                                data[0].address?.town || '';
                        }
                        if (!document.getElementById('state-input').value) {
                            document.getElementById('state-input').value = data[0].address?.state || '';
                        }
                        
                        // Add pulse animation to updated fields
                        ['city-input', 'state-input'].forEach(id => {
                            const el = document.getElementById(id);
                            if (el.value) {
                                el.classList.add('field-updated');
                                setTimeout(() => el.classList.remove('field-updated'), 1000);
                            }
                        });
                    }
                })
                .catch(error => {
                    hideSpinner();
                    console.error('Error:', error);
                });
        }
    });
    
    // Show loading spinner on map
    function showSpinner() {
        const spinner = document.createElement('div');
        spinner.className = 'map-spinner';
        spinner.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="sr-only">Loading...</span></div>';
        document.getElementById('map').appendChild(spinner);
    }
    
    // Hide loading spinner
    function hideSpinner() {
        const spinner = document.querySelector('.map-spinner');
        if (spinner) spinner.remove();
    }
    
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
    
    // Add pulse animation to map when focused
    document.getElementById('map').addEventListener('click', function() {
        this.classList.add('map-focused');
        setTimeout(() => this.classList.remove('map-focused'), 1000);
    });
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
    
    .pizza-marker {
        font-size: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: transform 0.3s ease;
    }
    
    .pizza-marker:hover {
        transform: scale(1.2) rotate(20deg);
    }
    
    .map-spinner {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(255, 255, 255, 0.7);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }
    
    .field-updated {
        animation: pulse 1s ease;
    }
    
    @keyframes pulse {
        0% {
            box-shadow: 0 0 0 0 rgba(230, 57, 70, 0.4);
        }
        70% {
            box-shadow: 0 0 0 10px rgba(230, 57, 70, 0);
        }
        100% {
            box-shadow: 0 0 0 0 rgba(230, 57, 70, 0);
        }
    }
    
    .map-focused {
        animation: mapPulse 1s ease;
    }
    
    @keyframes mapPulse {
        0% {
            box-shadow: 0 0 0 0 rgba(230, 57, 70, 0.4);
        }
        70% {
            box-shadow: 0 0 0 10px rgba(230, 57, 70, 0);
        }
        100% {
            box-shadow: 0 0 0 0 rgba(230, 57, 70, 0);
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