export τ, Vij

"""
`τ{K}(i::MoralAgent{K}, x::MoralIssue{K})`

MoralAgent `i` opinion about MoralIssue `x`
"""
τ{K}(i::MoralAgent{K}, x::MoralIssue{K}) = (i.moralvalues ⋅ x.moralvalues) / sqrt(K)

"""
`Vij{K}(i::MoralAgent{K}, j::MoralAgent{K}, x::MoralIssue{K})`

Cognitive cost MoralAgent `i` suffers when learning MoralAgent `j` opinion about MoralIssue `x`
"""
function Vij{K}(i::MoralAgent{K}, j::MoralAgent{K}, x::MoralIssue{K})
    return -γ^2 * log(ϵ + (1 - 2ϵ) * erfc(- τ(j, x) * sign(τ(i, x)) / γ) / sqrt(8))
end

function mcstep{N,K}(soc::Society{N,K}, x::MoralIssue{K})
    i = rand(1:N)
    j = sample(weights(soc[i, :]))

    oldcost     = cognitivecost(soc, i, j, x)

    proposed = MoralAgent(rand(MvNormal(agents(soc,i).moralvalues, ones(5))))
    newcost  = cognitivecost(proposed, soc, j, x)

    ΔV = newcost - oldcost
    p_trans  =  (ΔV < 0 ? 1 : exp(-β*soc[i, j]*ΔV) )

    if rand() < p_trans
        insertagent!(soc, proposed, i)
        return proposed
    end

    return agents(soc, i)
end
