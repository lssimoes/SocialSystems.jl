export NSOC, KMORAL
export interactions, agents

##############################
#          Constants         #
##############################

γ = sqrt(3)  # γ^2 = (1 - ρ^2)/ρ^2
ϵ = 0.2      # distrust of the agents
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
`insertagent!{N,K}(soc::Society{N,K}, proposed::MoralAgent{K}, i::Int64)`

Insert new agent `proposed` at position `i` on SOciety `soc`
"""
insertagent!{N,K}(soc::Society{N,K}, proposed::MoralAgent{K}, i::Int64)
    soc.agents[i] = proposed
