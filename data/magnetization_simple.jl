using SocialSystems, JLD, PyPlot

## Setting the variables
###########################
N     = 100
βsize = 200
βrng  = linspace(10/βsize, 10, βsize)
ρsize = 200
ρrng  = linspace(1/ρsize, 1, ρsize)
ϵ 	  = 0.

mag   = zeros(βsize, ρsize)

## Evaluating the data points
################################
for βi in βrng for ρi in ρrng
    soc  = Society(n=N, ρ=ρi, ϵ=ϵ)
    iter, x = metropolis!(soc, β=βi)

    summag = 0
    for ti in 1:100
    	summag += abs(magnetization(soc, x));
    	metropolisstep!(soc, x, βi)
    end
    mag[findin(βrng, βi), findin(ρrng, ρi)] = summag / 100;

    println("Evaluated point β=$βi, ρ=$ρi")
end end

## Saving JLD file w/ results
################################
save( "data/magnetization_sweep/magnetization_$(βsize)_$(ρsize)_ϵ$(ϵsize).jld", "mag", mag)

## Some Plotting
###################

imshow(mag, extent=[0, 1, 0, 10], aspect="auto", origin="lower", interpolation="bicubic")
xlabel(L"\rho")
ylabel(L"\beta")
colorbar()
title(L"Magnetization, $\epsilon =  0.1," * "\\ $(βsize) \\times $(ρsize)" * L"$ points")

savefig( "data/magnetization_sweep/magnetization_$(βsize)_$(ρsize)_$(ϵsize)_rhobeta_eps01.png")