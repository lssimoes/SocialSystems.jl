include("../src/SocialSystems.jl")
using PyPlot, SocialSystems

ϵ = rand()
ρ = rand()
γ = sqrt((1-ρ^2)/ρ^2)

xi = [hamiltonian(Society(N), MoralIssue()) for N in 1:NSOC]
ti = collect(1:NSOC)

plot(ti, xi)
savefig("nolearning_increasinghamiltonian.png")
