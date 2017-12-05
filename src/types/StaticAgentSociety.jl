##############################
#  StaticAgentSociety Type   #
##############################

"""
    type StaticAgentSociety{N, K, T}

Type representing a generic Bayesian Agent Society

### Fields
* interactionmatrix (Matrix{T}): N×N-matrix that describes the interactions of the agents of the society
* agents (Vector{MoralVector}): N-vector of the MoralVector{K, T}s of the StaticAgentSociety
* ρ (Float64): Cognitive Style of the agents
* ε (Float64): Distrust of the agents
"""
struct StaticAgentSociety{N, K, T <: Real}
    interactions::Matrix{Bool}
    agents::Vector{MoralVector{K, T}}
    ρ::Float64
    ε::Float64
end


"""
    StaticAgentSociety()

Construct a random StaticAgentSociety with default size NSOC, cognitive cost (Vij) and parameters (ρDEF, εDEF).
The agents have the default number of components (KMORAL)
"""
StaticAgentSociety() = StaticAgentSociety{NSOC, KMORAL, Float64}(Matrix{Bool}(1 - eye(NSOC)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:NSOC], ρDEF, εDEF)

"""
    StaticAgentSociety(n::Int, ρ::Float64, ε::Float64)

Construct a random StaticAgentSociety with size n, cognitive cost (Vij) and parameters (ρ, ε).
The agents have the default number of components (KMORAL)
"""
StaticAgentSociety(n::Int, ρ::Float64, ε::Float64) = StaticAgentSociety{n, KMORAL, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:n], ρ, ε)


# """
#    StaticAgentSociety(Jij::Matrix{Float64})

# Construct a random StaticAgentSociety with a square Jij interaction matrix and default cognitive cost (Vij)
# The agents have the default number of components (KMORAL)
# """
# function StaticAgentSociety(Jij::Matrix{Float64}; ρ=ρDEF, ε=εDEF)
#     n1, n2 = size(Jij)
#     if n1 != n2 error("Given interaction matrix isn't square!") end

#     return StaticAgentSociety{}(Jij, MoralVector{KMORAL, Float64}[MoralVector(k=KMORAL) for i in 1:n1], ρ, ε)
# end

# StaticAgentSociety(Jij::Matrix{T}) where {T <: Real} = StaticAgentSociety{NSOC, KMORAL, Float64}(Matrix{Bool}(Jij), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:NSOC], ρDEF, εDEF)


######################################
#  StaticAgentSociety Redefinitions  #
######################################

length(soc::StaticAgentSociety)    = length(soc.agents)
size(soc::StaticAgentSociety)      = (length(soc.agents), length(soc.agents[1]))

getindex(soc::StaticAgentSociety, i::Int64)                    = soc.interactionmatrix[i]
getindex(soc::StaticAgentSociety, i::Int64, j::Int64)          = soc.interactionmatrix[i, j]
getindex(soc::StaticAgentSociety, i::Int64, r::UnitRange)      = soc.interactionmatrix[i, r]
getindex(soc::StaticAgentSociety, r::UnitRange, j::Int64)      = soc.interactionmatrix[r, j]
getindex(soc::StaticAgentSociety, r::UnitRange, s::UnitRange)  = soc.interactionmatrix[r, s]
getindex(soc::StaticAgentSociety, i::Int64, c::Colon)          = soc.interactionmatrix[i, c]
getindex(soc::StaticAgentSociety, c::Colon, j::Int64)          = soc.interactionmatrix[c, j]
getindex(soc::StaticAgentSociety, c::Colon, r::UnitRange)      = soc.interactionmatrix[c, r]
getindex(soc::StaticAgentSociety, r::UnitRange, c::Colon)      = soc.interactionmatrix[r, c]

start(soc::StaticAgentSociety)   = 1
done(soc::StaticAgentSociety, s) = s > length(soc)
next(soc::StaticAgentSociety, s) = (soc[s], s+1)

function show(io::IO, soc::StaticAgentSociety)
    N, K = size(soc)
    println(io, N, "-sized StaticAgentSociety on a ", K, "-dimensional Moral space")
    @printf io "ρ: %.4f\t ε: %.4f" soc.ρ soc.ε
end
