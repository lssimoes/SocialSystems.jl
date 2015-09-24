export τ, Vij, NSOC, KMORAL

γ = 1        # γ^2 = (1 - ρ^2)/ρ^2
ϵ = 0.5      # distrust of the agents
NSOC = 1000  # default size of the Society
KMORAL = 5   # default size of the Moral Space

"""
`τ{K}(i::SocialAgent{K}, x::MoralIssue{K})`

SocialAgent `i` about MoralIssue `x`
"""
τ{K}(i::SocialAgent{K}, x::MoralIssue{K}) = (i.moralvalues ⋅ x.moralvalues) / sqrt(K)

"""
`Vij{K}(i::SocialAgent{K}, j::SocialAgent{K}, x::MoralIssue{K})`

Cognitive cost SocialAgent `i` suffers when learning SocialAgent `j` opinion about MoralIssue `x`
"""
function Vij{K}(i::SocialAgent{K}, j::SocialAgent{K}, x::MoralIssue{K})
    return -γ^2 * log(ϵ + (1 - 2ϵ) * erfc(- τ(j, x) * sign(τ(i, x)) / γ) / sqrt(8))
end


1/sqrt(2pi) int
