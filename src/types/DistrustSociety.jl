################################
#  DistrustSociety Type   #
################################

# struct DistrustSociety{N, K, T <: Real}
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
    type DistrustSociety{N, K, T}

Type representing a generic Bayesian Agent Society

### Fields
* links (Matrix{T}): N×N-matrix that describes the interactions of the agents of the society
* agents (Vector{MoralVector}): N-vector of the MoralVector{K, T}s of the DistrustSociety
* C (Vector{Matrix{Float64}}):
* mu (Matrix{Float64}):
* s2 (Matrix{Float64}):
"""
struct DistrustSociety{N, K, T <: Real} <: Society{N, K, T}
    links::Matrix{Bool}
    agents::Vector{MoralVector{K, T}}
    C::Vector{Matrix{Float64}}
    mu::Matrix{Float64}
    s2::Matrix{Float64}
end


"""
    DistrustSociety()

Construct a random DistrustSociety with default size NSOC
The agents have the default number of components (KMORAL)
"""
DistrustSociety() = 
    DistrustSociety{NSOC, KMORAL, Float64}(Matrix{Bool}(1 - eye(NSOC)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:NSOC], 
                                                [λDEF*eye(KMORAL) for i in 1:NSOC], zeros(NSOC, NSOC), s2DEF*ones(NSOC, NSOC))

"""
    DistrustSociety(n::Int)

Construct a random DistrustSociety with size n
The agents have the default number of components (KMORAL)
"""
DistrustSociety(n::Int; λ::Float64 = λDEF, μ::Float64 = μDEF, s2::Float64 = s2DEF) = 
    DistrustSociety{n, KMORAL, Float64}(Matrix{Bool}(1 - eye(n)), MoralVector{KMORAL, Float64}[MoralVector() for i in 1:n], 
                                             [λ*eye(KMORAL) for i in 1:n], μ*ones(n, n), s2*ones(n, n))


"""
    DistrustSociety(n::Int)

Construct a random DistrustSociety with agents agentArray
The agents have the default number of components (KMORAL)
"""
DistrustSociety{K, T}(agentArray::Vector{MoralVector{K, T}}; λ::Float64 = λDEF, μ::Float64 = μDEF, s2::Float64 = s2DEF) = 
    DistrustSociety{length(agentArray), K, T}(Matrix{Bool}(1 - eye(length(agentArray))), deepcopy(agentArray), 
                                                  [λ*eye(KMORAL) for i in 1:length(agentArray)], μ*ones(length(agentArray), length(agentArray)), s2*ones(length(agentArray), length(agentArray)))


########################################
#  DistrustSociety Redefinitions  #
########################################

function show(io::IO, soc::DistrustSociety)
    N, K = size(soc)
    print(io, N, "-sized DistrustSociety on a ", K, "-dimensional Moral space")
    #@printf io "ρ: %.4f\t ε: %.4f" soc.ρ soc.ε
end


########################################
#   DistrustSociety Definitions   #
########################################


""" 
    epssoc(soc::DistrustSociety, i::Int, j::Int) 

Computes `ε` agent `i` in a Society has about agent `j` 
"""
epssoc(soc::DistrustSociety, i::Int, j::Int) = phi(soc.mu[i, j] / sqrt(1 + soc.s2[i, j]))

""" 
    epssoc(soc::DistrustSociety) 

Computes the matrix of distrust `ε` in a Society 
"""
epssoc{N, K, T}(soc::DistrustSociety{N, K, T}) = [epssoc(soc, i, j) for i in 1:N, j in 1:N]

"Computes `γ` of agent `i` in a Society given MoralVector `x`"
gamsoc{N, K, T}(soc::DistrustSociety{N, K, T}, i::Int, x::MoralVector{K, T}) = sqrt(x[:]' * soc.C[i] * x[:])

"Computes `ρ` of agent `i` in a Society given MoralVector `x`"
rhosoc{N, K, T}(soc::DistrustSociety{N, K, T}, i::Int, x::MoralVector{K, T}) = rhosoc(gamsoc(soc, i, x))


"""
    cogcost{K,T}(soc::DistrustSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

Cognitive cost MoralVector `soc[i]` suffers when learning MoralVector `soc[j]`'s opinion about MoralVector `x`
"""
function cogcost{N, K,T}(soc::DistrustSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})
    gam = gamsoc(soc, i, x)
    ε   = epssoc(soc, i, j)
    agi = soc[i]
    agj = soc[j]

    return - log( ε + (1 - 2ε) * phi(sign(agj ⋅ x) * (agi ⋅ x) / gam) )
end

# """
#     cogcost{K,T}(soc::DistrustSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})

# Cognitive cost MoralVector `agi` suffers when learning MoralVector `soc[i]`'s opinion about MoralVector `x`
# """
# function cogcost{N, K,T}(agi::MoralVector{K,T}, soc::DistrustSociety{N, K, T}, i::Int, j::Int, x::MoralVector{K,T})
#     gam = gamsoc(soc, i, x)
#     ε   = epssoc(soc, i, j)
#     agj = soc[j]

#     return - log( ε + (1 - 2ε) * phi(sign(agj ⋅ x) * (agi ⋅ x) / gam) )
# end

"Returns the two modulation functions: Fw and Fϵ"
function modfunc{N, K, T}(soc::DistrustSociety{N,K,T}, i::Int, j::Int, x::MoralVector{K,T})
    σ  = sign(soc[j] ⋅ x)
    h  = soc[i] ⋅ x
    γ  = gamsoc(soc, i, x)
    μ  = soc.mu[i, j]
    s2 = soc.s2[i, j]

    hσ1γ   = h*σ/γ
    μ1sqs2 = μ/sqrt(1 + s2)

    phiϵ = phi(μ1sqs2)
    phiw = phi(hσ1γ)
    Z    = phiϵ + phiw - 2*phiϵ*phiw
    
    Fw = (1 - 2phiϵ) * G(hσ1γ) / Z 
    Fϵ = (1 - 2phiw) * G(μ1sqs2) / Z

    return (Fw, Fϵ)
end
