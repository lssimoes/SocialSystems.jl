using SocialSystems, JLD, PyPlot

N = 120

for γi in 0:0.1:1.5 for ϵi in 0:0.1:1
    soc  = Society(n=N, γ=γi, ϵ=ϵi)
    iter, x = metropolis!(soc)

    # ERROR: AssertionError: generic functions not supported
    # so I need to split the Society type on its' many fields
    @save "metropolis_sweep/metroplot_n$(N)_gamma$(γi)_eps$(ϵi).jld" iter soc.agents soc.interactionmatrix soc.γ soc.ϵ x

    hi = zeros(200)
    for i in 1:200
        metropolisstep!(soc, x);
        hi[i] = hamiltonian(soc, x)
    end

    hj = hi - mean(hi)
    plot(collect(1:200), hj/(maximum(hj) - minimum(hj)))

end end
