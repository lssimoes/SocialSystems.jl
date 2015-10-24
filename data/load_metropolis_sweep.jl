using SocialSystems, JLD, PyPlot

N   = 100
βi  = 10.
mag = zeros(20, 11)
dir  = "data/metropolis_sweep"

for ρi in 0:0.05:0.95 for ϵi in 0:0.05:0.5
    file = "metroplot_n$(N)_rho$(ρi)_eps$(ϵi)_beta$(βi)"

    d = load("$dir/$file.jld")
    soc = Society(Vij, d["socinteractions"], d["socagents"], d["socρ"], d["socϵ"]);

    mag[findin(0:0.05:0.95, ρi), findin(0:0.05:0.5, ϵi)] = magnetization(soc, socissue)

end end

imshow(mag, extent=[0, 1, 0, 0.5])
colorbar()

savefig("$dir/magnetization.png")
