include("../src/SocialSystems.jl")

using SocialSystems, JLD

N = 120

for γi in 0:0.05:1 for ϵi in 0:0.05:1
    soc = Society(n=N, γ=γi, ϵ=ϵi)
    iter, socvar, hi = metropolis(soc)

    # ERROR: AssertionError: generic functions not supported
    @save "metroplot_n$(N)_gamma$(γi)_eps$(ϵi).jld" iter socvar hi
end end
