# Social Systems - Statistical Mechanics

Simple modelling of some types of social systems using Statistical Mechanis and MCMC Simulations.

Install the package running:

```julia
julia> Pkg.clone(Pkg.clone("https://github.com/kaslusimoes/SocialSystems.jl.git"))
```

## A simple example

```julia
julia> using SocialSystems, PyPlot

julia> n   = 50
julia> γ   = 1.8
julia> ϵ   = 0.2

julia> soc     = Society(n=n, γ=γ, ϵ=ϵ)
julia> iter, x = metropolis!(soc)

julia> hi = zeros(200)
julia> for i in 1:200
           metropolisstep!(soc, x);
           hi[i] = hamiltonian(soc, x)
       end

julia> hj = hi - mean(hi)
julia> plot(collect(1:200), hj/(maximum(hj) - minimum(hj)))

```
