
import math

# Constants
G = 6.67430e-11  # Gravitational constant (m^3 kg^-1 s^-2)
c = 2.99792458e8 # Speed of light (m/s)

# Function to calculate Schwarzschild Radius
def schwarzschild_radius(mass):
    # Rs = 2GM/c^2
    return (2 * G * mass) / (c**2)

# Function to calculate Gravitational Time Dilation (simplified for weak fields)
def gravitational_time_dilation(h, M, R):
    # Approximate formula for weak gravitational fields
    # dt_prime = dt * (1 + (GM / (R*c^2)) - (GM / ((R+h)*c^2)))
    # This is a simplified approach, actual calculation is more complex
    # For a more accurate calculation, one would need to integrate over the gravitational potential
    # Here, we'll just show the factor by which time slows down at a certain height h above a mass M at radius R
    
    # Factor = sqrt(1 - (2GM / (rc^2)))
    # Let's calculate the time dilation factor at radius R and R+h
    
    # Time dilation factor at radius r
    def time_dilation_factor(r, M_central):
        if r <= 2 * G * M_central / c**2: # Check if within Schwarzschild radius
            return float('inf') # Or handle as appropriate for a black hole
        return math.sqrt(1 - (2 * G * M_central) / (r * c**2))

    factor_R = time_dilation_factor(R, M)
    factor_R_plus_h = time_dilation_factor(R + h, M)
    
    # The ratio of time elapsed at height h to time elapsed at radius R
    # A larger factor means time passes slower
    if factor_R_plus_h == 0 or factor_R == 0: # Avoid division by zero
        return 0
    return factor_R / factor_R_plus_h

# Example usage:
# Mass of the Sun (kg)
M_sun = 1.989e30
# Radius of the Sun (m)
R_sun = 6.957e8

# Mass of Earth (kg)
M_earth = 5.972e24
# Radius of Earth (m)
R_earth = 6.371e6

print(f"Schwarzschild Radius of the Sun: {schwarzschild_radius(M_sun):.2e} meters")
print(f"Schwarzschild Radius of the Earth: {schwarzschild_radius(M_earth):.2e} meters")

# Example for gravitational time dilation near Earth's surface
h_observer = 10000 # height of observer in meters (e.g., on a mountain or satellite)

# Time dilation factor (how much slower time passes at R compared to R+h)
# A value > 1 means time at R is slower than at R+h
# For weak fields, this factor will be very close to 1
time_dilation_ratio = gravitational_time_dilation(h_observer, M_earth, R_earth)
print(f"Gravitational Time Dilation Ratio (R_earth / (R_earth + h_observer)): {time_dilation_ratio}")
print(f"This means time at Earth's surface (R_earth) passes approximately {((time_dilation_ratio - 1) * 24 * 3600):.9f} seconds slower per day compared to {h_observer}m above.")
