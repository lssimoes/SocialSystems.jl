export NSOC, KMORAL
export τ, Vij

γ = sqrt(3)  # γ^2 = (1 - ρ^2)/ρ^2
ϵ = 0.2      # distrust of the agents
NSOC = 1000  # default size of the Society
KMORAL = 5   # default size of the Moral Space

"""
`τ{K}(i::SocialAgent{K}, x::MoralIssue{K})`

SocialAgent `i` opinion about MoralIssue `x`
"""
τ{K}(i::SocialAgent{K}, x::MoralIssue{K}) = (i.moralvalues ⋅ x.moralvalues) / sqrt(K)

"""
`Vij{K}(i::SocialAgent{K}, j::SocialAgent{K}, x::MoralIssue{K})`

Cognitive cost SocialAgent `i` suffers when learning SocialAgent `j` opinion about MoralIssue `x`
"""
function Vij{K}(i::SocialAgent{K}, j::SocialAgent{K}, x::MoralIssue{K})
    return -γ^2 * log(ϵ + (1 - 2ϵ) * erfc(- τ(j, x) * sign(τ(i, x)) / γ) / sqrt(8))
end
