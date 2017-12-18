################################
#  DistrustAgentSociety Type   #
################################

# struct DistrustAgentSociety{N, K, T <: Real}
#     """
#     ------
#     w0: array with shape (N, K) - opinion vector with
#     dimension K for N agents
#     C0: array with shape (N, K, K) - opinion uncertainty
#     for each agent
#     mu0: array with shape (N, N) - mistrust array for each agent
#     s20: array with shape (N, N) - mistrust uncertainty for each agent
#     """

"""
    type DistrustAgentSociety{N, K, T}

Type representing a generic Bayesian Agent Society

### Fields
* links (Matrix{T}): N×N-matrix that describes the interactions of the agents of the society
* agents (Vector{MoralVector}): N-vector of the MoralVector{K, T}s of the DistrustAgentSociety
* C (Vector{Matrix{Float64}}):
* mu (Vector{Vector{Float64}}):
* s2 (Vector{Vector{Float64}}):
"""
struct DistrustAgentSociety{N, K, T <: Real} <: Society{N, K, T}
    links::Matrix{Bool}
    agents::Vector{MoralVector{K, T}}
    C::Vector{Matrix{Float64}}
    mu::Matrix{Float64}
    s2::Matrix{Float64}
end


"""
    DistrustAgentSociety()

Construct a random DistrustAgentSociety with default size NSOC, cognitive cost (Vij) and parameters (ρDEF, εDEF).
The agents have the default number of components (KMORAL)
"""
DistrustAgentSociety() = DistrustAgentSociety{NSOC, KMORAL, Float64}(Matrix{Bool}(1 - eye(NSOC)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:NSOC], ρDEF, εDEF)

"""
    DistrustAgentSociety(n::Int, ρ::Float64, ε::Float64)

Construct a random DistrustAgentSociety with size n, cognitive cost (Vij) and parameters (ρ, ε).
The agents have the default number of components (KMORAL)
"""
DistrustAgentSociety(n::Int, ρ::Float64, ε::Float64) = DistrustAgentSociety{n, KMORAL, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:n], ρ, ε)


########################################
#  DistrustAgentSociety Redefinitions  #
########################################

function show(io::IO, soc::DistrustAgentSociety)
    N, K = size(soc)
    println(io, N, "-sized DistrustAgentSociety on a ", K, "-dimensional Moral space")
    #@printf io "ρ: %.4f\t ε: %.4f" soc.ρ soc.ε
end


########################################
#   DistrustAgentSociety Definitions   #
########################################


"Computes `ε` agent `i` in a Society has about agent `j`"
epssoc(soc::DistrustAgentSociety, i::Int, j::Int) = phi(soc.ε[i, j] / sqrt(1 + soc.s2[i, j]))

"Computes `γ` of agent `i` in a Society given MoralVector `x`"
gamsoc{K}(soc::DistrustAgentSociety{N, K, T}, i::Int, x::MoralVector{K, T}) = x' * soc.C[i] * x / K

"Computes `ρ` of agent `i` in a Society given MoralVector `x`"
rhosoc{K}(soc::DistrustAgentSociety{N, K, T}, i::Int, x::MoralVector{K, T}) = rhosoc(gamsoc(soc, i, x))


"""
    cogcost{K,T}(soc::DistrustAgentSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

Cognitive cost MoralVector `soc[i]` suffers when learning MoralVector `soc[j]`'s opinion about MoralVector `x`
"""
function cogcost{N, K,T}(soc::DistrustAgentSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})
    gam = gamsoc(soc, i, x)
    ε   = epssoc(soc, i, j)
    agi = soc[i]
    agj = soc[j]

    return log( ε + (1 - 2ε) * phi(-  sign(agj ⋅ x) * (agi ⋅ x) / gam) )
end

"""
    cogcost{K,T}(soc::DistrustAgentSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

Cognitive cost MoralVector `agi` suffers when learning MoralVector `soc[i]`'s opinion about MoralVector `x`
"""
function cogcost{N, K,T}(agi::MoralVector{K,T}, soc::DistrustAgentSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})
    gam = gamsoc(soc, i, x)
    ε   = epssoc(soc, i, j)
    agj = soc[j]

    return log( ε + (1 - 2ε) * phi(-  sign(agj ⋅ x) * (agi ⋅ x) / gam) )
end
