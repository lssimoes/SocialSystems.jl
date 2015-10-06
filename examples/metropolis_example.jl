include("src/SocialSystems.jl")

using SocialSystems, PyPlot

n=50
γ=1.8
ϵ=0.2

soc = Society(n=n, γ=γ, ϵ=ϵ)
iter, hi, variations = metropolis(soc)

plot(collect(1:iter), hi)
savefig("metroplot_n$(n)_gamma$(γ)_eps$(ϵ).png")
