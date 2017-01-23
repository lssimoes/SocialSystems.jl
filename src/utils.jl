export interactions, agents, insertagent!

function randSphere():
    return None

# ##############################
# #     Utilitary Functions    #
# ##############################

# gammasoc(ρ::Float64) = sqrt(1 - ρ^2) / ρ

# """
# `interactions(soc::Society)`

# Returns the `interactionmatrix` of a Society `soc`
# """
# interactions(soc::Society)     = soc.interactionmatrix

# """
# `agents(soc::Society)`

# Returns the `agents` vector of a Society `soc`
# """
# agents(soc::Society)           = soc.agents

# """
# `agents(soc::Society, i::Int64)`

# Returns the `i`th `agent` of a Society `soc`
# """
# agents(soc::Society, i::Int64) = soc.agents[i]

# """
# `insertagent!{N,K,T}(soc::Society{N,K,T}, proposed::MoralAgent{K,T}, i::Int64)`

# Insert new agent `proposed` at position `i` on Society `soc`
# """
# insertagent!{N, K, T}(soc::Society{N,K,T}, proposed::MoralAgent{K,T}, i::Int64) =
#     soc.agents[i] = proposed
