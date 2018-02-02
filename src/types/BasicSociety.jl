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
    ρ::Vector{Float64}
    ε::Matrix{Float64}
end


"""
    BasicSociety()

Construct a random BasicSociety with default size NSOC and parameters (ρDEF, εDEF).
The agents have the default number of components (KMORAL)
"""
BasicSociety() = 
    BasicSociety{NSOC, KMORAL, Float64}(Matrix{Bool}(1 - eye(NSOC)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:NSOC], ρDEF*ones(NSOC), εDEF*(ones(NSOC, NSOC) - eye(NSOC, NSOC)))


"""
    BasicSociety(n::Int)

Construct a random BasicSociety with size n and parameters (ρDEF, εDEF).
The agents have the default number of components (KMORAL)
"""
BasicSociety(n::Int) = 
    BasicSociety{n, KMORAL, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:n], ρDEF*ones(n), εDEF*(ones(n, n) - eye(n, n)))


"""
    BasicSociety(n::Int, k::Int)

Construct a random BasicSociety with size n and parameters (ρDEF, εDEF).
The agents have k number of components
"""
BasicSociety(n::Int, k::Int) = 
    BasicSociety{n, k, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{k, Float64}[MoralVector(k) for i in 1:n], ρDEF*ones(n), εDEF*(ones(n, n) - eye(n, n)))


"""
    BasicSociety(n::Int, ρ::Float64, ε::Float64)

Construct a random BasicSociety with size n and parameters (ρ, ε).
The agents have the default number of components (KMORAL)
"""
BasicSociety(n::Int, ρ::Vector{Float64}, ε::Matrix{Float64}) = 
    BasicSociety{n, KMORAL, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:n], ρ, ε)


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
    # @printf io "ρ: %.4f\t ε: %.4f" soc.ρ soc.ε
end

######################################
#    BasicSociety Definitions   #
######################################


""" 
    epssoc(soc::BasicSociety, i::Int, j::Int) 

Computes `ε` agent `i` in a Society has about agent `j` 
"""
epssoc(soc::BasicSociety, i::Int, j::Int) = soc.ε[i, j]

""" 
    epssoc(soc::BasicSociety) 

Computes the matrix of distrust `ε` in a Society 
"""
epssoc{N, K, T}(soc::BasicSociety{N, K, T}) = [epssoc(soc, i, j) for i in 1:N, j in 1:N]

"Computes `ρ` of agent `i` in a Society"
rhosoc(soc::BasicSociety, i::Int) = soc.ρ[i]

"Computes `γ` of agent `i` in a Society"
gamsoc(soc::BasicSociety, i::Int) = gamsoc(rhosoc(soc, i))

"Computes `γ` of agent `i` in a Society given MoralVector `x`"
gamsoc{N, K, T}(soc::BasicSociety{N, K, T}, i::Int, x::MoralVector{K, T}) = sqrt(x[:]' * soc.C[i] * x[:])

"Computes `ρ` of agent `i` in a Society given MoralVector `x`"
rhosoc{N, K, T}(soc::BasicSociety{N, K, T}, i::Int, x::MoralVector{K, T}) = rhosoc(gamsoc(soc, i, x))


"""
    cogcost{K,T}(soc::BasicSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

Cognitive cost MoralVector `soc[i]` suffers when learning MoralVector `soc[j]`'s opinion about MoralVector `x`
"""
function cogcost{N, K,T}(soc::BasicSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})
    γi  = gamsoc(soc, i)
    εij = epssoc(soc, i, j)
    agi = soc[i]
    agj = soc[j]

    return - log( εij + (1 - 2εij) * phi(sign(agj ⋅ x) * (agi ⋅ x) / γi) )
end

"""
    cogcost{K,T}(soc::BasicSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

Cognitive cost MoralVector `agi` suffers when learning MoralVector `soc[i]`'s opinion about MoralVector `x`
"""
function cogcost{N, K,T}(agi::MoralVector{K,T}, soc::BasicSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})
    γi  = gamsoc(soc, i)
    εij = epssoc(soc, i, j)
    agj = soc[j]

    return - log( εij + (1 - 2εij) * phi(sign(agj ⋅ x) * (agi ⋅ x) / γi) )
end
