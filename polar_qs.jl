# Function to calculate the Polarizability α
module alpha_np

export polarizability, σ_SI

const ϵ0 = 8.854187817e-12  # Vacuum permittivity (F/m)

function polarizability(λ_m, R, ε_m, Au_ϵ)
    ε = Au_ϵ(λ_m)                              # dielectric function in m
    α_vol = 4π * R^3 * (ε - ε_m) / (ε + 2ε_m)
    α_SI = ϵ0 * α_vol   # Multiply by ϵ0 to get SI 
    return α_SI
end

end