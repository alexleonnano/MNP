#
# Load libraries and functions
include("AuData.jl")
using .AuOpticalData
include("polar_qs.jl")
using .alpha_np
using Plots

# Load Au data
Au_nk, Au_ϵ = load_Au_data("Johnson.csv");

# Define constants
const ϵ0 = 8.854187817e-12;      # Vacuum permittivity (F/m)
const nm_to_m = 1e-9;            # nm to m

ε_m = 1.77;                     # Dielectric constant of medium (water)
n_m = sqrt(ε_m);                # Refractive index of medium

# Particle parameters
R_nm = 25.0;                   # Radius in nm
R = R_nm * nm_to_m;            # Convert radius to m

# Calculate σ for multiple radii
# Illumination wavelength
λ_nm = 400.0;
λ_m = λ_nm * nm_to_m;

# Radii range
radii_nm = 5:1.0:51.0;
radii_m = radii_nm .* nm_to_m;

# Calculate scattering cross sections
σ_scat = Float64[]

for R in radii_m
    α = polarizability(λ_m, R, ε_m, Au_ϵ)
    k = 2π * n_m / λ_m
    σ = (k^4) / (6π * ϵ0^2) * abs(α)^2
    push!(σ_scat, σ)
end

# Highlight radii of interest
h_r = [20, 30, 50, 80] # Highlighted radii in nm
h_i = findall(x -> x in h_r, radii_nm) # Find indices of the highlighted elements
h_σ = σ_scat[h_i] # Corresponding scattering cross sections
h_l = ["$(r) nm: $(round(σ * 1e18, sigdigits=3)) nm²" for (r, σ) in zip(h_r, h_σ)] # Create labels for highlighted points


# Plot scattering cross section vs radius
plt = plot(radii_nm, σ_scat .* 1e18, xlabel = "Radius (nm)", ylabel = "Scattering Cross Section (nm²)", title = "Scattering cross section at $(λ_nm) nm", legend = :topleft, label = "All radii")

# Highlight radius of interest
highlight_colors = [:red, :green, :blue, :yellow]
for (r, σ, lbl, c) in zip(h_r, h_σ, h_l, highlight_colors)
    scatter!(plt, [r], [σ * 1e18], color = c, markershape = :circle, label = lbl)
end

display(plt)
#########################################################################################
# Calculate σ vs λ
# Calculate scattering cross section (in m²)

# Wavelength range sweep
#λs_nm = 400.0:1.0:900.0;
#λs_m = λs_nm .* nm_to_m ;      # Convert wavelength range to m

#σ_scat = Float64[]

#for (λ_nm, λ_m) in zip(λs_nm, λs_m)
#    α = polarizability(λ_m, R, ε_m, Au_ϵ)  # use SI units
#    k = 2π * n_m / λ_m
#    σ = (k^4) / (6π * ϵ0^2) * abs(α)^2
#    push!(σ_scat, σ)
#end

# Plot & convert from m² to nm²
#plot(λs_nm, σ_scat .* 1e18, xlabel = "Wavelength (nm)", ylabel = "Scattering Cross Section (nm²)", title = "Scattering Cross Section vs Wavelength", legend = false)