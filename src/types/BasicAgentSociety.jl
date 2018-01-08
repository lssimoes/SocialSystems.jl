##############################
#   BasicAgentSociety Type   #
##############################

"""
    type BasicAgentSociety{N, K, T}

Type representing a generic Bayesian Agent Society

### Fields
* links  (Matrix{Bool}): N×N-matrix that describes the interactions of the agents of the society
* agents (Vector{MoralVector}): N-vector of the MoralVector{K, T}s of the BasicAgentSociety
* ρ (Float64): Cognitive Style of the agents
* ε (Float64): Distrust of the agents
"""
struct BasicAgentSociety{N, K, T <: Real} <: Society{N, K, T}
    links::Matrix{Bool}
    agents::Vector{MoralVector{K, T}}
    ρ::Float64
    ε::Float64
end


"""
    BasicAgentSociety()

Construct a random BasicAgentSociety with default size NSOC and parameters (ρDEF, εDEF).
The agents have the default number of components (KMORAL)
"""
BasicAgentSociety() = BasicAgentSociety{NSOC, KMORAL, Float64}(Matrix{Bool}(1 - eye(NSOC)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:NSOC], ρDEF, εDEF)


"""
    BasicAgentSociety(n::Int)

Construct a random BasicAgentSociety with size n and parameters (ρDEF, εDEF).
The agents have the default number of components (KMORAL)
"""
BasicAgentSociety(n::Int) = BasicAgentSociety{n, KMORAL, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:n], ρDEF, εDEF)


"""
    BasicAgentSociety(n::Int, k::Int)

Construct a random BasicAgentSociety with size n and parameters (ρDEF, εDEF).
The agents have k number of components
"""
BasicAgentSociety(n::Int, k::Int) = BasicAgentSociety{n, k, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{k, Float64}[MoralVector(k) for i in 1:n], ρDEF, εDEF)


"""
    BasicAgentSociety(n::Int, ρ::Float64, ε::Float64)

Construct a random BasicAgentSociety with size n and parameters (ρ, ε).
The agents have the default number of components (KMORAL)
"""
BasicAgentSociety(n::Int, ρ::Float64, ε::Float64) = BasicAgentSociety{n, KMORAL, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:n], ρ, ε)


# """
#    BasicAgentSociety(Jij::Matrix{Float64})

# Construct a random BasicAgentSociety with a square Jij interaction matrix
# The agents have the default number of components (KMORAL)
# """
# function BasicAgentSociety(Jij::Matrix{Float64}; ρ=ρDEF, ε=εDEF)
#     n1, n2 = size(Jij)
#     if n1 != n2 error("Given interaction matrix isn't square!") end

#     return BasicAgentSociety{}(Jij, MoralVector{KMORAL, Float64}[MoralVector(k=KMORAL) for i in 1:n1], ρ, ε)
# end

# BasicAgentSociety(Jij::Matrix{T}) where {T <: Real} = BasicAgentSociety{NSOC, KMORAL, Float64}(Matrix{Bool}(Jij), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:NSOC], ρDEF, εDEF)


######################################
#   BasicAgentSociety Redefinitions  #
######################################


function show(io::IO, soc::BasicAgentSociety)
    N, K = size(soc)
    println(io, N, "-sized BasicAgentSociety on a ", K, "-dimensional Moral space")
    @printf io "ρ: %.4f\t ε: %.4f" soc.ρ soc.ε
end

######################################
#    BasicAgentSociety Definitions   #
######################################


"Computes `ε` of a Society"
epssoc(soc::BasicAgentSociety) = soc.ε

"Computes `ρ` of a Society"
rhosoc(soc::BasicAgentSociety) = soc.ρ

"Computes `γ` of a Society"
function gamsoc(soc::BasicAgentSociety) 
    ρ = rhosoc(soc)

    return sqrt(1 - ρ^2) / ρ
end

"""
    cogcost{K,T}(soc::BasicAgentSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

Cognitive cost MoralVector `soc[i]` suffers when learning MoralVector `soc[j]`'s opinion about MoralVector `x`
"""
function cogcost{N, K,T}(soc::BasicAgentSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})
    gam = gamsoc(soc)
    ε   = epssoc(soc)
    agi = soc[i]
    agj = soc[j]

    return - log( ε + (1 - 2ε) * phi(sign(agj ⋅ x) * (agi ⋅ x) / gam) )
end

"""
    cogcost{K,T}(soc::BasicAgentSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

Cognitive cost MoralVector `agi` suffers when learning MoralVector `soc[i]`'s opinion about MoralVector `x`
"""
function cogcost{N, K,T}(agi::MoralVector{K,T}, soc::BasicAgentSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})
    gam = gamsoc(soc)
    ε   = epssoc(soc)
    agj = soc[j]

    return - log( ε + (1 - 2ε) * phi(sign(agj ⋅ x) * (agi ⋅ x) / gam) )
end
