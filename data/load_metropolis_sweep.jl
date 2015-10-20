using SocialSystems, JLD, PyPlot

N = 100

for ρi in 0:0.05:0.95 for ϵi in 0:0.05:0.5 for βi in 0.5:0.5:20
    dir  = "data/metropolis_sweep"
    file = "metroplot_n$(N)_rho$(ρi)_eps$(ϵi)_beta$(βi)"

    @load "$dir/$file.jld"
    soc = Society(Vij, socinteractions, socagents, socρ, socϵ);

    # do whatever you want to do from now on
    mi = zeros(200);
    for i in 1:200
        metropolisstep!(soc, socissue, βi);
        mi[i] = magnetization(soc, socissue)
    end

    # maybe some magnetization plots
    plot(collect(1:200), round(mi, 3))
    ylim(-1., 1.)

    savefig("$dir/$file.png")
    clf()

end end end
