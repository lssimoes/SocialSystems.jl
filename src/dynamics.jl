export hopinion, Vij, metropolisstep

"""
`hopinion{K,T}(i::MoralAgent{K,T}, x::MoralIssue{K,T})`

MoralAgent `i` opinion about MoralIssue `x`
"""
hopinion{K,T}(i::MoralAgent{K,T}, x::MoralIssue{K,T}) = (i.moralvalues ⋅ x.moralvalues) / sqrt(K)

"""
`Vij{K,T}(i::MoralAgent{K,T}, j::MoralAgent{K,T}, x::MoralIssue{K,T})`

Cognitive cost MoralAgent `i` suffers when learning MoralAgent `j` opinion about MoralIssue `x`
"""
function Vij{K,T}(i::MoralAgent{K,T}, j::MoralAgent{K,T}, x::MoralIssue{K,T})
    return -γ^2 * log( ϵ + (1 - 2ϵ) * 0.5 * erfc(-  sign(hopinion(j, x)) * hopinion(i, x) / γ /sqrt(2)) )
end

function metropolisstep{N,K,T}(soc::Society{N,K,T}, x::MoralIssue{K,T})
    i = rand(1:N)
    j = sample(weights(soc[i, :]))

    oldcost     = cognitivecost(soc, i, j, x)

    # Sample a a new MoralAgent using a MultivariateGaussian centered at the old Agent
    proposed = MoralAgent(rand(MvNormal(agents(soc,i).moralvalues, ones(5))))
    newcost  = cognitivecost(proposed, soc, j, x)

    ΔV = newcost - oldcost
    # transistion probability
    p_trans  =  (ΔV < 0 ? 1 : exp(-β*soc[i, j]*ΔV) )

    if rand() < p_trans
        insertagent!(soc, proposed, i)
        return proposed
    end

    return agents(soc, i)
end

function metropolis{N,K,T}(soc::Society{N,K,T})
    # fix this later
    iter = 20000
    variations = MoralAgent[]
    x = MoralIssue()

    for i in 1:iter
        push!(variations, metropolisstep(soc, x))
    end
end
