export OMAgentSociety

##############################
#    BOMAgentSociety Type    #
##############################

"""
`type AgentSociety{N, K, T}`

Type representing a generic Bayesian Agent Society

### Fields
* `interactionmatrix` (`Matrix{T}`): N×N-matrix that describes the interactions of the agents of the society
* `agents` (`Vector{MoralAgent}`): N-vector of the `MoralAgent{K, T}`s of the BOMAgentSociety
* `ρ` (`Float64`): Cognitive Style of the agents
* `ϵ` (`Float64`): Distrust of the agents
"""
type BOMAgentSociety{N, K, T <: Real}
    """
    ------
    w0: array with shape (N, K) - opinion vector with
    dimension K for N agents
    C0: array with shape (N, K, K) - opinion uncertainty
    for each agent
    mu0: array with shape (N, N) - mistrust array for each agent
    s20: array with shape (N, N) - mistrust uncertainty for each agent
    """
    
    # self.w = w0[:]
    # self.C = C0[:]
    # self.mu = mu0[:]
    # self.s2 = s20[:]
    # self._initial_state = [w0[:], C0[:], mu0[:], s20[:]]
    # self.N, self.K = w0.shape
    # self._sqrtK = sqrt(self.K)
    # self.steps_taken = 1

    interactionmatrix::Matrix{Bool}
    agents::Matrix{}
    ρ::Float64
    ϵ::Float64

    function call{K, T}(::Type{BOMAgentSociety}, interactionmatrix::Matrix{Float64},
                 agents::Vector{MoralAgent{K, T}}, ρ::Float64, ϵ::Float64)
        new{length(agents), K, T}(interactionmatrix, agents, ρ, ϵ)
    end
end

 ################################
#  BOMAgentSociety Constructors  #
 ################################

"""
`BOMAgentSociety(;n=NSOC, ρ=ρDEF, ϵ=ϵDEF)`

Construct a random BOMAgentSociety with default size `NSOC`, cognitive cost (`Vij`) and parameters `(ρDEF, ϵDEF)`.
The agents have the default number of components (`KMORAL`)
"""
function BOMAgentSociety(;n=NSOC, ρ=ρDEF, ϵ=ϵDEF)
    return BOMAgentSociety(1 - eye(n), MoralAgent{KMORAL, Float64}[MoralAgent(k=KMORAL) for i in 1:n], ρ, ϵ)
end

"""
`BOMAgentSociety(Jij::Matrix{Float64})`

Construct a random BOMAgentSociety with a square `Jij` interaction matrix and default cognitive cost (`Vij`)
The agents have the default number of components (`KMORAL`)
"""
function BOMAgentSociety(Jij::Matrix{Float64}; ρ=ρDEF, ϵ=ϵDEF)
    n1, n2 = size(Jij)
    if n1 != n2 error("Given interaction matrix isn't square!") end

    return BOMAgentSociety(Jij, MoralAgent{KMORAL, Float64}[MoralAgent(k=KMORAL) for i in 1:n1], ρ, ϵ)
end



##############################
#    BOMAgentSociety Redefinitions   #
##############################

length(soc::BOMAgentSociety)    = length(soc.agents)
size(soc::BOMAgentSociety)      = (length(soc.agents), length(soc.agents[1]))

getindex(soc::BOMAgentSociety, i::Int64)                    = soc.interactionmatrix[i]
getindex(soc::BOMAgentSociety, i::Int64, j::Int64)          = soc.interactionmatrix[i, j]
getindex(soc::BOMAgentSociety, i::Int64, r::UnitRange)      = soc.interactionmatrix[i, r]
getindex(soc::BOMAgentSociety, r::UnitRange, j::Int64)      = soc.interactionmatrix[r, j]
getindex(soc::BOMAgentSociety, r::UnitRange, s::UnitRange)  = soc.interactionmatrix[r, s]
getindex(soc::BOMAgentSociety, i::Int64, c::Colon)          = soc.interactionmatrix[i, c]
getindex(soc::BOMAgentSociety, c::Colon, j::Int64)          = soc.interactionmatrix[c, j]
getindex(soc::BOMAgentSociety, c::Colon, r::UnitRange)      = soc.interactionmatrix[c, r]
getindex(soc::BOMAgentSociety, r::UnitRange, c::Colon)      = soc.interactionmatrix[r, c]

start(soc::BOMAgentSociety)   = 1
done(soc::BOMAgentSociety, s) = s > length(soc)
next(soc::BOMAgentSociety, s) = (soc[s], s+1)

function show(io::IO, soc::BOMAgentSociety)
    N, K = size(soc)
    println(io, N, "-sized BOMAgentSociety on a ", K, "-dimensional Moral space")
    @printf io "ρ: %.4f\t ϵ: %.4f" soc.ρ soc.ϵ
end
