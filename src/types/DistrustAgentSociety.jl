##############################
#  DistrustAgentSociety Type   #
##############################

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
    
#     self.w = w0[:]
#     self.C = C0[:]
#     self.mu = mu0[:]
#     self.s2 = s20[:]
#     self._initial_state = [w0[:], C0[:], mu0[:], s20[:]]
#     self.N, self.K = w0.shape
#     self._sqrtK = sqrt(self.K)
#     self.steps_taken = 1

#     interactionmatrix::Matrix{Bool}
#     agents::Matrix{}
#     ρ::Float64
#     ε::Float64

#     function call{K, T}(::Type{DistrustAgentSociety}, interactionmatrix::Matrix{Float64},
#                  agents::Vector{MoralVector{K, T}}, ρ::Float64, ε::Float64)
#         new{length(agents), K, T}(interactionmatrix, agents, ρ, ε)
#     end
# end

"""
    type DistrustAgentSociety{N, K, T}

Type representing a generic Bayesian Agent Society

### Fields
* interactionmatrix (Matrix{T}): N×N-matrix that describes the interactions of the agents of the society
* agents (Vector{MoralVector}): N-vector of the MoralVector{K, T}s of the DistrustAgentSociety
* #
* #
"""
struct DistrustAgentSociety{N, K, T <: Real} <: Society{N, K, T}
    interactions::Matrix{Bool}
    agents::Vector{MoralVector{K, T}}
    #
    #
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


# """
#   DistrustAgentSociety(Jij::Matrix{Float64})

# Construct a random DistrustAgentSociety with a square Jij interaction matrix and default cognitive cost (Vij)
# The agents have the default number of components (KMORAL)
# """
# function DistrustAgentSociety(Jij::Matrix{Float64}; ρ=ρDEF, ε=εDEF)
#     n1, n2 = size(Jij)
#     if n1 != n2 error("Given interaction matrix isn't square!") end

#     return DistrustAgentSociety(Jij, MoralVector{KMORAL, Float64}[MoralVector(k=KMORAL) for i in 1:n1], ρ, ε)
# end



######################################
#  DistrustAgentSociety Redefinitions  #
######################################

function show(io::IO, soc::DistrustAgentSociety)
    N, K = size(soc)
    println(io, N, "-sized DistrustAgentSociety on a ", K, "-dimensional Moral space")
    #@printf io "ρ: %.4f\t ε: %.4f" soc.ρ soc.ε
end
