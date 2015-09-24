export Vij, NSOC, KMORAL

γ = 1        # γ^2 = (1 - ρ^2)/ρ^2
ϵ = 0.5      # distrust of the agents
NSOC = 1000  # default size of the Society
KMORAL = 5   # default size of the Moral Space

"""
`Vij(n::Integer)`

Construct a random Society with a square `Rij` interaction matrix and default cognitive cost
"""
function Vij{K}(i::SocialAgent{K}, j::SocialAgent{K}, x::MoralIssue{K})

    return -γ^2 * log(ϵ + (1 - 2ϵ) * H(- τ(j, x) * sign(τ(i, x)) / γ) )
end
