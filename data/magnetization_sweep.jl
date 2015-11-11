using SocialSystems, JLD, PyPlot

N     = 100
βsize = 8
βrng  = linspace(10/βsize, 10, βsize)
ρsize = 500
ρrng  = linspace(1/ρsize, 1, ρsize)
ϵsize = 100
ϵrng  = linspace(0.5/ϵsize, 0.5, ϵsize)

mag   = zeros(βsize, ρsize, ϵsize)

for βi in βrng for ρi in ρrng for ϵi in ϵrng
    soc  = Society(n=N, ρ=ρi, ϵ=ϵi)
    iter, x = metropolis!(soc, β=βi)

    mag[findin(βrng, βi), findin(ρrng, ρi), findin(ϵrng, ϵi)] = abs(magnetization(soc, x));

    println("Evaluated point β=$βi, ρ=$ρi, ϵ=$ϵi")
end end end

save( "data/magnetization_$(βsize)_$(ρsize)_$(ϵsize).jld", "mag", mag)

imshow(reshape(mag[:, :, findin(ϵrng, 0.1)], βsize, ρsize), extent=[0, 1, 0, 10], aspect="auto", origin="lower", interpolation="bicubic")
xlabel(L"\rho")
ylabel(L"\beta")
colorbar()
# title(L"Magnetization, $\epsilon =  0.1$, $βsize \times ρsize$ points")

savefig( "data/magnetization_$(βsize)_$(ρsize)_$(ϵsize)_rhobeta.png")

clf()

imshow(reshape(mag[:, findin(ρrng, 0.3), :], βsize, ϵsize), extent=[0, 0.5, 0, 10], aspect="auto", origin="lower", interpolation="bicubic")
xlabel(L"\epsilon")
ylabel(L"\beta")
colorbar()
# title(L"Magnetization, $\rho =  0.3$, $(βsize) \times $(ϵsize)$ points")

savefig( "data/magnetization_$(βsize)_$(ρsize)_$(ϵsize)_epsbeta.png")

clf()

imshow(reshape(mag[findin(βrng, 8.75), :, :], ρsize, ϵsize), extent=[0, 1, 0, 0.5], aspect="auto", origin="lower", interpolation="gaussian")
xlabel(L"\rho")
ylabel(L"\epsilon")
colorbar()
# title(L"Magnetization, $\beta =  5.0$, $(ρsize) \times $(ϵsize)$ points")

savefig( "data/magnetization_$(βsize)_$(ρsize)_$(ϵsize)_rhoeps.png")
