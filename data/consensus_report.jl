using SocialSystems, PyPlot

## Setting the variables
###########################
N     = 100
βsize = 3
βrng  = [0, 6., 18.]
ρsize = 3
ρrng  = 0.2:0.3:0.8
ϵsize = 3
ϵrng  = 0:0.2:0.4

pos = 1
## Evaluating the data points
################################
for βi in βrng for ρi in ρrng
    ϵi = 0.
    soc  = Society(n=N, ρ=ρi, ϵ=ϵi)
    iter, x = metropolis!(soc, β=βi)

    ψ = consensus(soc)

    for i in 1:N
        ψ[i, i] = 0.
    end

    vechist = reshape(ψ, N*N, 1)
    vechist = vechist[collect(vechist .!= 0.)]
    rnghist, ptshist = hist(vechist, -1:0.005:1)

    println("pos: $pos, $βi, $ρi")
    subplot(3,3,pos)
    bar(collect(rnghist)[2:end], ptshist, width=0.001, align="center", aa=false, edgecolor="#4d0099", alpha=0.4)

    axis("tight")
    xlim(-1,1)
    ylim(0,120)

    pos += 1
end end

savefig( "data/consensus_sweep/consensus_rhobeta.png")
