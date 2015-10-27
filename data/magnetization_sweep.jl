using SocialSystems, JLD, PyPlot

N = 100
ϵ = 0.1

mag = zeros(1000, 1000)

for ρi in 0:0.001:0.999 for βi in 0.01:0.01:10
    soc  = Society(n=N, ρ=ρi, ϵ=ϵ)
    iter, x = metropolis!(soc, β=βi)

    mag[findin(0.01:0.01:10, βi), findin(0:0.001:0.999, ρi)] = abs(magnetization(soc, x))

    println("Evaluated point ρ=$ρi, β=$βi")
end end

save("data/magnetization.jld", "mag", mag)

imshow(mag, extent=[0, 1, 0, 10], aspect="auto", interpolation="nearest", origin="lower")
xlabel(L"\rho")
ylabel(L"\beta")
colorbar()

savefig("data/magnetization_eps0.1.png")
