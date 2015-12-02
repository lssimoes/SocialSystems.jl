# Social Systems - Statistical Mechanics

Simple modelling of some types of social systems using Statistical Mechanis and MCMC Simulations.

Install the package running:

```julia
julia> Pkg.clone("https://github.com/kaslusimoes/SocialSystems.jl.git")
```

## A simple example

```julia
julia> using SocialSystems, PyPlot

julia> n   = 100
julia> ρ   = 0.2
julia> ϵ   = 0.1

julia> soc     = Society(n=n, ρ=ρ, ϵ=ϵ)
julia> iter, x = metropolis!(soc, β=15.)

julia> mi = zeros(200)
julia> for i in 1:200
            metropolisstep!(soc, x, 15.);
            mi[i] = magnetization(soc, x)        
       end
```
