# Social Systems - Statistical Mechanics

Simple modelling of some types of social systems using Statistical Mechanis and MCMC Simulations.

'''julia
using SocialSystems, PyPlot

n=50
γ=1.8
ϵ=0.2

soc = Society(n=n, γ=γ, ϵ=ϵ)
iter, hi, variations = metropolis(soc)

plot(collect(1:iter), hi)
'''
