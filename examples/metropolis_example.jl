@everywhere begin
    include("src/SocialSystems.jl")
    using SocialSystems

    hi = zeros(20000)
    x = MoralIssue()
    soc = Society(200)
end

@parallel for i in 1:20000
    metropolisstep(soc, x)
    hi[i] = hamiltonian(soc, x)
end

using PyPlot
plot(collect(1:20000), hi)
savefig("metroplot.png")
