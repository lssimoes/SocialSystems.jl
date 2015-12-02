using SocialSystems, PyPlot

## Setting the variables
###########################
N     = 100
βsize = 10
βrng  = linspace(0, 20, βsize +1)
ρsize = 5
ρrng  = linspace(0, 1, ρsize + 1)
ϵsize = 5
ϵrng  = linspace(0, 0.5, ϵsize + 1)

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
    rnghist, ptshist = hist(vechist, -1:0.005:1)
    bar(collect(rnghist)[2:end], ptshist, width=0.001, align="center", aa=false, edgecolor="#4d0099")

    xlim(-1,1)
    xlabel(L"$\psi_{ij}$")
    title(L"$\mathrm{Histogram}: \beta = " * "$(βi), " * "\\ \\rho = " * "$(ρi), " * "\\ \\epsilon = " * "$(ϵi)" * L"$")

    savefig( "data/consensus_sweep/consensus_$(βi)_$(ρi)_$(ϵi).png")

    println("Evaluated point β=$βi, ρ=$ρi, ϵ=$ϵi")
    
    clf()
end end end
