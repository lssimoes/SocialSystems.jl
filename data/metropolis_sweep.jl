using SocialSystems, JLD, PyPlot

N = 100

for ρi in 0:0.05:0.95 for ϵi in 0:0.05:0.5 for βi in 0.5:0.5:20
    soc  = Society(n=N, ρ=ρi, ϵ=ϵi)
    iter, x = metropolis!(soc)

    dir  = "data/metropolis_sweep"
    file = "metroplot_n$(N)_gamma$(ρi)_eps$(ϵi)_beta$(βi)"

    # ERROR: AssertionError: generic functions not supported
    # so I need to split the Society type on its' many fields
    @save "$dir/$file.jld" iter soc.agents soc.interactionmatrix soc.ρ soc.ϵ x

    mi = zeros(200)
    for i in 1:200
        metropolisstep!(soc, x);
        mi[i] = magnetization(soc, x)
    end

    plot(collect(1:200), mi)
    ylim(-1., 1.)

    savefig("$dir/$file.png")

end end end
