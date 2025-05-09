document.addEventListener("DOMContentLoaded", function () {
    const map = L.map('map').setView([36.8065, 10.1815], 13); // Default coordinates for Tunisia (Tunis)
    
    // Add the OpenStreetMap tile layer
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 18,
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);
    
    // Create a marker and set it to the map
    const marker = L.marker([36.8065, 10.1815]).addTo(map);

    // Listen for map click event to update the marker and form fields
    map.on('click', function (e) {
        const lat = e.latlng.lat;
        const lon = e.latlng.lng;

        // Update the marker's position
        marker.setLatLng(e.latlng);
        map.setView(e.latlng, 15); // Move map to the clicked position

        // Use the Nominatim API to reverse geocode the coordinates
        fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}&addressdetails=1`)
            .then(res => res.json())
            .then(data => {
                if (data && data.address) {
                    // Populate the form fields with the address details
                    const address = data.address;
                    const formattedAddress = address.road + ", " + address.city + ", " + address.state + ", " + address.country;

                    // Set the address, city, and state in the form
                    document.getElementById('address-input').value = formattedAddress;
                    document.getElementById('city-input').value = address.city || '';
                    document.getElementById('state-input').value = address.state || '';
                    
                    // Set the latitude and longitude in hidden fields
                    document.getElementById('latitude-input').value = lat;
                    document.getElementById('longitude-input').value = lon;
                }
            });
    });

    // Handle the address input blur event as fallback for when the user enters address manually
    const addressInput = document.getElementById('address-input');
    addressInput.addEventListener('blur', function () {
        const address = this.value;
        if (!address) return;

        // Use the Nominatim API to geocode the address
        fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}`)
            .then(res => res.json())
            .then(data => {
                if (data.length === 0) return;

                const lat = parseFloat(data[0].lat);
                const lon = parseFloat(data[0].lon);

                // Set the latitude and longitude in the hidden inputs
                document.getElementById('latitude-input').value = lat;
                document.getElementById('longitude-input').value = lon;

                // Move the map to the new coordinates and update the marker
                map.setView([lat, lon], 15);
                marker.setLatLng([lat, lon]);
            });
    });
});

function toggleForms() {
    const width = window.innerWidth;
    if (width < 768) {
        const forms = document.querySelectorAll('.form-section');
        forms.forEach(form => {
            form.style.display = (form.style.display === 'none') ? 'block' : 'none';
        });
    }
}

document.addEventListener('DOMContentLoaded', function() {
    // Initialize map from Leaflet
    var map = L.map('map').setView([40.7128, -74.0060], 13);
    
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    
    var marker = L.marker([40.7128, -74.0060], {
        draggable: true
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
                }
            })
            .catch(error => console.error('Error:', error));
    });
    
    // Address search function
    document.getElementById('address-input').addEventListener('blur', function() {
        const address = this.value;
        if (address) {
            fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}`)
                .then(response => response.json())
                .then(data => {
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
                    }
                })
                .catch(error => console.error('Error:', error));
        }
    });
    
    // Toggle between login and register forms with animation
    window.toggleForms = function() {
        const forms = document.querySelectorAll('.form-section');
        
        forms.forEach(form => {
            form.style.transition = 'transform 0.5s ease, opacity 0.5s ease';
            form.style.transform = 'translateY(20px)';
            form.style.opacity = '0';
            
            setTimeout(() => {
                form.parentElement.classList.toggle('col-md-6');
                form.parentElement.classList.toggle('d-none');
                
                setTimeout(() => {
                    form.style.transform = 'translateY(0)';
                    form.style.opacity = '1';
                }, 100);
            }, 500);
        });
    };
    
    // Add pizza emoji animations
    function createFloatingPizzas() {
        const container = document.querySelector('.login-container');
        const pizzaCount = 6;
        
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
            const circle = document.createElement('span');
            circle.classList.add('circle-animation');
            
            const x = e.clientX - e.target.getBoundingClientRect().left;
            const y = e.clientY - e.target.getBoundingClientRect().top;
            
            circle.style.top = y + 'px';
            circle.style.left = x + 'px';
            
            this.appendChild(circle);
            
            setTimeout(() => circle.remove(), 500);
        });
    });
});

// Add additional CSS for the floating pizzas
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
`;

document.head.appendChild(additionalStyle);
