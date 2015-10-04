export NSOC, KMORAL
export interactions, agents, insertagent!

##############################
#          Constants         #
##############################

γ = sqrt(3)  # γ^2 = (1 - ρ^2)/ρ^2 # cognitive style
ϵ = 0.2      # distrust of the agents
β = 0.5      # social pressure
NSOC = 1000  # default size of the Society
KMORAL = 5   # default size of the Moral Space

##############################
#     Utilitary Functions    #
##############################

"""
`interactions(soc::Society)`

Returns the `interactionmatrix` of a Society `soc`
"""
interactions(soc::Society)     = soc.interactionmatrix

"""
`agents(soc::Society)`

Returns the `agents` vector of a Society `soc`
"""
agents(soc::Society)           = soc.agents

"""
`agents(soc::Society, i::Int64)`

Returns the `i`th `agent` of a Society `soc`
"""
agents(soc::Society, i::Int64) = soc.agents[i]

"""
`insertagent!{N,K,T}(soc::Society{N,K,T}, proposed::MoralAgent{K,T}, i::Int64)`

Insert new agent `proposed` at position `i` on Society `soc`
"""
insertagent!{N, K, T}(soc::Society{N,K,T}, proposed::MoralAgent{K,T}, i::Int64) =
    soc.agents[i] = proposed
