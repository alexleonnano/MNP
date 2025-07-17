module AuOpticalData

using DelimitedFiles
using Interpolations

export load_Au_data, Au_nk, Au_ϵ

function load_Au_data(filepath)
    raw = readdlm(filepath, ',', skipstart=1)
    λ_um = raw[:, 1]
    n_vals = raw[:, 2]
    k_vals = raw[:, 3]

    λ_m = λ_um .* 1e-6  # microns → meters

    n_interp = LinearInterpolation(λ_m, n_vals)
    k_interp = LinearInterpolation(λ_m, k_vals)

    Au_nk(λ::Float64) = complex(n_interp(λ), k_interp(λ))
    Au_ϵ(λ::Float64) = Au_nk(λ)^2

    return Au_nk, Au_ϵ
end

end