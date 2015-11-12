export Vij, metropolisstep!, metropolis!

"""
`Vij{K,T}(i::MoralAgent{K,T}, j::MoralAgent{K,T}, x::MoralIssue{K,T})`

Cognitive cost MoralAgent `i` suffers when learning MoralAgent `j` opinion about MoralIssue `x`
"""
function Vij{K,T}(i::MoralAgent{K,T}, j::MoralAgent{K,T}, x::MoralIssue{K,T}, ρ::Float64, ϵ::Float64)
    γ = gammasoc(ρ)
    return -γ^2 * log( ϵ + (1 - 2ϵ) * 0.5 * erfc(-  sign(hopinion(j, x)) * hopinion(i, x) / γ /sqrt(2)) )
end

function metropolisstep!{N,K,T}(soc::Society{N,K,T}, x::MoralIssue{K,T}, β::Float64)
    i = rand(1:N)
    j = sample(weights(soc[i, :]))

    oldcost  = cognitivecost(soc, i, j, x)

    # Sample a a new MoralAgent using a MultivariateGaussian centered at the old Agent
    proposed = MoralAgent(rand(MvNormal(agents(soc,i).moralvalues, ones(5))))
    newcost  = cognitivecost(soc.cognitivecost, proposed, agents(soc, j), x, soc.ρ, soc.ϵ)

    ΔV = newcost - oldcost
    # transistion probability
    p_trans  =  (ΔV < 0 ? 1 : exp(-β*soc[i, j]*ΔV) )

    if rand() < p_trans
        insertagent!(soc, proposed, i)
        return proposed
    end

    return agents(soc, i)
end

function metropolis!{N,K,T}(soc::Society{N,K,T}; β = βDEF)
    # fix this later
    iter  = 150*length(soc)

    # The society discusses a single issue, some kind of Zeitgeist
    x = MoralIssue()

    for i in 1:iter
        # ignoring the MoralAgent 'metropolisstep()' outputs
        metropolisstep!(soc, x, β);
    end

    return iter, x
end
