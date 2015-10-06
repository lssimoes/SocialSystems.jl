export NSOC, KMORAL, βDEF, γDEF, ϵDEF
export interactions, agents, insertagent!

##############################
#          Constants         #
##############################

NSOC = 1000  # default size of the Society
KMORAL = 5   # default size of the Moral Space

βDEF = 10.0     # social pressure
γDEF = sqrt(3)  # γ^2 = (1 - ρ^2)/ρ^2 # cognitive style
ϵDEF = 0.1      # distrust of the agents

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
