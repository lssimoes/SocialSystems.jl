using SocialSystems, JLD, PyPlot

N   = 100
mag = zeros(1000, 100, 10)

for βi in 0.01:0.01:10 for ρi in 0.01:0.01:1 for ϵi in 0.05:0.05:0.5
    soc  = Society(n=N, ρ=ρi, ϵ=ϵi)
    iter, x = metropolis!(soc, β=βi)

    mag[findin(0.01:0.01:10, βi), findin(0.01:0.01:1, ρi), findin(0.05:0.05:0.5, ϵi)] = abs(magnetization(soc, x));

    println("Evaluated point β=$βi, ρ=$ρi, ϵ=$ϵi")
end end end

save("data/magnetization_1000_100_10.jld", "mag", mag)

imshow(reshape(mag[:, :, findin(0.05:0.05:0.5, 0.1)], 1000, 100), extent=[0, 1, 0, 10], aspect="auto", interpolation="bicubic", origin="lower")
xlabel(L"\rho")
ylabel(L"\beta")
colorbar()

savefig("data/magnetization_1000_100_10_rhobeta.png")
