using SocialSystems, JLD, PyPlot

N = 100

for ρi in 0:0.05:0.95 for ϵi in 0:0.05:0.5 for βi in 0.5:0.5:20
    soc  = Society(n=N, ρ=ρi, ϵ=ϵi)
    iter, x = metropolis!(soc, β=βi)

    dir  = "data/metropolis_sweep"
    file = "metroplot_n$(N)_rho$(ρi)_eps$(ϵi)_beta$(βi)"

    # ERROR: AssertionError: generic functions not supported
    # so I need to split the Society type on its' many fields
    save("$dir/$file.jld", "socagents", soc.agents, "socinteractions",
         soc.interactionmatrix, "socρ", soc.ρ, "socϵ", soc.ϵ, "socissue", x) # compress=true?

    mi = zeros(200)
    for i in 1:200
        metropolisstep!(soc, x, βi);
        mi[i] = magnetization(soc, x)
    end

    plot(collect(1:200), round(mi,3))
    ylim(-1., 1.)

    println("Saving figure $file.png")

    savefig("$dir/$file.png")
    clf()

end end end
