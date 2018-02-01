##############################
#   BasicSociety Type   #
##############################

"""
    type BasicSociety{N, K, T}

Type representing a generic Bayesian Agent Society

### Fields
* links  (Matrix{Bool}): N×N-matrix that describes the interactions of the agents of the society
* agents (Vector{MoralVector}): N-vector of the MoralVector{K, T}s of the BasicSociety
* ρ (Float64): Cognitive Style of the agents
* ε (Float64): Distrust of the agents
"""
struct BasicSociety{N, K, T <: Real} <: Society{N, K, T}
    links::Matrix{Bool}
    agents::Vector{MoralVector{K, T}}
    ρ::Float64
    ε::Float64
end


"""
    BasicSociety()

Construct a random BasicSociety with default size NSOC and parameters (ρDEF, εDEF).
The agents have the default number of components (KMORAL)
"""
BasicSociety() = BasicSociety{NSOC, KMORAL, Float64}(Matrix{Bool}(1 - eye(NSOC)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:NSOC], ρDEF, εDEF)


"""
    BasicSociety(n::Int)

Construct a random BasicSociety with size n and parameters (ρDEF, εDEF).
The agents have the default number of components (KMORAL)
"""
BasicSociety(n::Int) = BasicSociety{n, KMORAL, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:n], ρDEF, εDEF)


"""
    BasicSociety(n::Int, k::Int)

Construct a random BasicSociety with size n and parameters (ρDEF, εDEF).
The agents have k number of components
"""
BasicSociety(n::Int, k::Int) = BasicSociety{n, k, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{k, Float64}[MoralVector(k) for i in 1:n], ρDEF, εDEF)


"""
    BasicSociety(n::Int, ρ::Float64, ε::Float64)

Construct a random BasicSociety with size n and parameters (ρ, ε).
The agents have the default number of components (KMORAL)
"""
BasicSociety(n::Int, ρ::Float64, ε::Float64) = BasicSociety{n, KMORAL, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:n], ρ, ε)


# """
#    BasicSociety(Jij::Matrix{Float64})

# Construct a random BasicSociety with a square Jij interaction matrix
# The agents have the default number of components (KMORAL)
# """
# function BasicSociety(Jij::Matrix{Float64}; ρ=ρDEF, ε=εDEF)
#     n1, n2 = size(Jij)
#     if n1 != n2 error("Given interaction matrix isn't square!") end

#     return BasicSociety{}(Jij, MoralVector{KMORAL, Float64}[MoralVector(k=KMORAL) for i in 1:n1], ρ, ε)
# end

# BasicSociety(Jij::Matrix{T}) where {T <: Real} = BasicSociety{NSOC, KMORAL, Float64}(Matrix{Bool}(Jij), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:NSOC], ρDEF, εDEF)


######################################
#   BasicSociety Redefinitions  #
######################################


function show(io::IO, soc::BasicSociety)
    N, K = size(soc)
    println(io, N, "-sized BasicSociety on a ", K, "-dimensional Moral space")
    @printf io "ρ: %.4f\t ε: %.4f" soc.ρ soc.ε
end

######################################
#    BasicSociety Definitions   #
######################################


"Computes `ε` of a Society"
epssoc(soc::BasicSociety) = soc.ε

"Computes `ρ` of a Society"
rhosoc(soc::BasicSociety) = soc.ρ

"Computes `γ` of a Society"
function gamsoc(soc::BasicSociety) 
    ρ = rhosoc(soc)

    return sqrt(1 - ρ^2) / ρ
end

"""
    cogcost{K,T}(soc::BasicSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

Cognitive cost MoralVector `soc[i]` suffers when learning MoralVector `soc[j]`'s opinion about MoralVector `x`
"""
function cogcost{N, K,T}(soc::BasicSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})
    gam = gamsoc(soc)
    ε   = epssoc(soc)
    agi = soc[i]
    agj = soc[j]

    return - log( ε + (1 - 2ε) * phi(sign(agj ⋅ x) * (agi ⋅ x) / gam) )
end

"""
    cogcost{K,T}(soc::BasicSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

Cognitive cost MoralVector `agi` suffers when learning MoralVector `soc[i]`'s opinion about MoralVector `x`
"""
function cogcost{N, K,T}(agi::MoralVector{K,T}, soc::BasicSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})
    gam = gamsoc(soc)
    ε   = epssoc(soc)
    agj = soc[j]

    return - log( ε + (1 - 2ε) * phi(sign(agj ⋅ x) * (agi ⋅ x) / gam) )
end
