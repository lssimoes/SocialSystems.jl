##############################
#  StaticAgentSociety Type   #
##############################

"""
    type StaticAgentSociety{N, K, T}

Type representing a generic Bayesian Agent Society

### Fields
* links  (Matrix{Bool}): N×N-matrix that describes the interactions of the agents of the society
* agents (Vector{MoralVector}): N-vector of the MoralVector{K, T}s of the StaticAgentSociety
* ρ (Float64): Cognitive Style of the agents
* ε (Float64): Distrust of the agents
"""
struct StaticAgentSociety{N, K, T <: Real} <: Society{N, K, T}
    links::Matrix{Bool}
    agents::Vector{MoralVector{K, T}}
    ρ::Float64
    ε::Float64
end


"""
    StaticAgentSociety()

Construct a random StaticAgentSociety with default size NSOC and parameters (ρDEF, εDEF).
The agents have the default number of components (KMORAL)
"""
StaticAgentSociety() = StaticAgentSociety{NSOC, KMORAL, Float64}(Matrix{Bool}(1 - eye(NSOC)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:NSOC], ρDEF, εDEF)


"""
    StaticAgentSociety(n::Int)

Construct a random StaticAgentSociety with size n and parameters (ρDEF, εDEF).
The agents have the default number of components (KMORAL)
"""
StaticAgentSociety(n::Int) = StaticAgentSociety{n, KMORAL, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:n], ρDEF, εDEF)


"""
    StaticAgentSociety(n::Int, k::Int)

Construct a random StaticAgentSociety with size n and parameters (ρDEF, εDEF).
The agents have k number of components
"""
StaticAgentSociety(n::Int, k::Int) = StaticAgentSociety{n, k, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{k, Float64}[MoralVector(k) for i in 1:n], ρDEF, εDEF)


"""
    StaticAgentSociety(n::Int, ρ::Float64, ε::Float64)

Construct a random StaticAgentSociety with size n and parameters (ρ, ε).
The agents have the default number of components (KMORAL)
"""
StaticAgentSociety(n::Int, ρ::Float64, ε::Float64) = StaticAgentSociety{n, KMORAL, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:n], ρ, ε)


# """
#    StaticAgentSociety(Jij::Matrix{Float64})

# Construct a random StaticAgentSociety with a square Jij interaction matrix
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


function show(io::IO, soc::StaticAgentSociety)
    N, K = size(soc)
    println(io, N, "-sized StaticAgentSociety on a ", K, "-dimensional Moral space")
    @printf io "ρ: %.4f\t ε: %.4f" soc.ρ soc.ε
end

######################################
#   StaticAgentSociety Definitions   #
######################################


"Computes `ρ` of a Society"
rhosoc(soc::StaticAgentSociety) = soc.ρ

"Computes `ε` of a Society"
epssoc(soc::StaticAgentSociety) = soc.ε

"Computes `γ` of a Society"
function gamsoc(soc::StaticAgentSociety) 
    ρ = rhosoc(soc)

    return sqrt(1 - ρ^2) / ρ
end

"""
    cogcost{K,T}(soc::StaticAgentSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

Cognitive cost MoralVector `soc[i]` suffers when learning MoralVector `soc[j]`'s opinion about MoralVector `x`
"""
function cogcost{N, K,T}(soc::StaticAgentSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})
    gam = gamsoc(soc)
    ε   = epssoc(soc)
    agi = soc[i]
    agj = soc[j]

    return -gam^2 * log( ε + (1 - 2ε) * 0.5 * erfc(-  sign(agj ⋅ x) * (agi ⋅ x) / gam /sqrt(2)) )
end

"""
    cogcost{K,T}(soc::StaticAgentSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

Cognitive cost MoralVector `agi` suffers when learning MoralVector `soc[i]`'s opinion about MoralVector `x`
"""
function cogcost{N, K,T}(agi::MoralVector{K,T}, soc::StaticAgentSociety{N, K, T}, j::Int, x::MoralVector{K,T})
    gam = gamsoc(soc)
    ε   = epssoc(soc)
    agj = soc[j]

    return -gam^2 * log( ε + (1 - 2ε) * 0.5 * erfc(-  sign(agj ⋅ x) * (agi ⋅ x) / gam /sqrt(2)) )
end
