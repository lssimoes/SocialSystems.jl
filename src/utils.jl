γ = 1        # γ^2 = (1 - ρ^2)/ρ^2
ϵ = 0.5      # distrust of the agents
NSOC = 1000  # default size of the Society

defaultcogcost(i, j, x) = -γ^2 * log(ϵ + (1 - 2ϵ) * H(- τ(j, x) * sign(τ(i, x)) / γ) )
