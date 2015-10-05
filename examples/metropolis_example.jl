using SocialSystems

hi = zeros(2000)
x = MoralIssue()
soc = Society(20)

for i in 1:2000
    metropolisstep(soc, x)
    hi[i] = hamiltonian(soc, x)
end

using PyPlot
plot(collect(1:2000), hi)
savefig("metroplot.png")
