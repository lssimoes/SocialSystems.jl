using SocialSystems, PyPlot

## Setting the variables
###########################
N     = 100
βsize = 10
βrng  = linspace(20/βsize, 20, βsize)
ρsize = 5
ρrng  = linspace(1/ρsize, 1, ρsize)
ϵsize = 5
ϵrng  = linspace(0.5/ϵsize, 0.5, ϵsize)

## Evaluating the data points
################################
for βi in βrng for ρi in ρrng for ϵi in ϵrng
    soc  = Society(n=N, ρ=ρi, ϵ=ϵi)
    iter, x = metropolis!(soc, β=βi)

    ψ = consensus(soc)
    
    for i in 1:N
        ψ[i, i] = 0.
    end
    
    vechist = reshape(ψ, N*N, 1)
    vechist = vechist[collect(vechist .!= 0.)]
    rnghist, ptshist = hist(vechist, 0:0.01:1)
    bar(collect(rnghist)[2:end], ptshist, width=0.005, align="center")

    xlim(0,1)
    xlabel(L"$\psi_{ij}$")
    title(L"$\mathrm{Histogram}: \beta = " * "$(βi), " * "\\ \\rho = " * "$(ρi), " * "\\ \\epsilon = " * "$(ϵi)" * L"$")

    savefig( "data/consensus_sweep/consensus_$(βi)_$(ρi)_$(ϵi).png")

    println("Evaluated point β=$βi, ρ=$ρi, ϵ=$ϵi")
    
    clf()
end end end
