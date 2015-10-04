export MoralAgent, MoralIssue, Society

##############################
#      Moral Agent Type      #
##############################

"""
`type MoralAgent{K, T <: Real}`

Type representing a Moral Agent

### Fields
* `moralvalues` (`Vector{T}`): K-vector with moral dimension values of the agent
"""
type MoralAgent{K, T <: Real}
    moralvalues::Vector{T}

    function call{T}(::Type{MoralAgent}, moral::Vector{T})
        normaliz = sqrt(moral⋅moral)
        sqrtk = sqrt(length(moral))

        new{length(moral), T}(sqrtk*moral/normaliz)
    end
end

##############################
#      Moral Issue Type      #
##############################

"""
`type MoralIssue{K, T <: Real}`

Type representing a Moral Issue

### Fields
* `moralvalues` (`Vector{T}`): K-vector with moral dimension values of the issue
"""
type MoralIssue{K, T <: Real}
    moralvalues::Vector{T}

    function call{T}(::Type{MoralIssue}, moral::Vector{T})
        normaliz = sqrt(moral⋅moral)
        sqrtk = sqrt(length(moral))

        new{length(moral), T}(sqrtk*moral/normaliz)
    end
end

##############################
#        Society Type        #
##############################

"""
`type Society{N, K, T}`

Type representing a Society

### Fields
* `cognitivecost` (`Function`): Function that describes the cognite cost of the agent
* `interactionmatrix` (`Matrix{T}`): N×N-matrix that describes the interactions of the agents of the society
* `agents` (`Vector{MoralAgent}`): N-vector of the `MoralAgent{K, T}`s of the Society
"""
type Society{N, K, T <: Real}
    cognitivecost::Function
    interactionmatrix::Matrix{Float64}
    agents::Vector{MoralAgent{K}}

    function call{K, T}(::Type{Society}, cognitivecost::Function,
                 interactionmatrix::Matrix{Float64},
                 agents::Vector{MoralAgent{K, T}})
        new{length(agents), K, T}(cognitivecost, interactionmatrix, agents)
    end
end

##############################
#  Moral Agent Constructors  #
##############################

"""
`MoralAgent()`

Construct a MoralAgent with a unitary random moral vector with default number of components (`KMORAL`).
"""
function MoralAgent()
    return MoralAgent(2rand(KMORAL)-1)
end

"""
`MoralAgent(n::Integer)`

Construct a MoralAgent with a unitary random moral vector with `n` components.
"""
function MoralAgent(n::Integer)
    return MoralAgent(2rand(n)-1)
end

##############################
#  Moral Issue Constructors  #
##############################

"""
`MoralIssue()`

Construct a MoralIssue with a unitary random moral vector with default number of components (`KMORAL`).
"""
function MoralIssue()
    return MoralIssue(2rand(KMORAL)-1)
end

"""
`MoralIssue(n::Integer)`

Construct a MoralIssue with a unitary random moral vector with `n` components.
"""
function MoralIssue(n::Integer)
    return MoralIssue(2rand(n)-1)
end

##############################
#    Society Constructors    #
##############################

"""
`Society()`

Construct a random Society with default size (`NSOC`) and default cognitive cost (`Vij`).
The agents have the default number of components (`KMORAL`)
"""
function Society()
    return Society(Vij, 1 - eye(NSOC), MoralAgent{KMORAL, Float64}[MoralAgent(KMORAL) for i in 1:NSOC])
end

"""
`Society(n::Integer)`

Construct a random Society with size `n` and default cognitive cost (`Vij`)
The agents have the default number of components (`KMORAL`)
"""
function Society(n::Integer)
    return Society(Vij, 1 - eye(n), MoralAgent{KMORAL, Float64}[MoralAgent(KMORAL) for i in 1:n])
end

"""
`Society(Jij::Matrix{Float64})`

Construct a random Society with a square `Jij` interaction matrix and default cognitive cost (`Vij`)
The agents have the default number of components (`KMORAL`)
"""
function Society(Jij::Matrix{Float64})
    n1, n2 = size(Jij)
    if n1 != n2 error("Given interaction matrix isn't square!") end

    return Society(Vij, Jij, MoralAgent{KMORAL, Float64}[MoralAgent(KMORAL) for i in 1:n1])
end

##############################
# Moral Agent Redefinitions  #
##############################

length(ag::MoralAgent) = length(ag.moralvalues)
size(ag::MoralAgent)   = size(ag.moralvalues)

getindex(ag::MoralAgent, i) = ag.moralvalues[i]

start(ag::MoralAgent)   = 1
done(ag::MoralAgent, s) = s > length(ag)
next(ag::MoralAgent, s) = (ag[s], s+1)

function show(io::IO, ag::MoralAgent)
    N = length(ag)
    println(io, N, "-dimensional Moral Agent:")
    for i in ag
        @printf io " %.5f\n" i
    end
end

##############################
# Moral Issue Redefinitions  #
##############################

length(missue::MoralIssue) = length(missue.moralvalues)
size(missue::MoralIssue)   = size(missue.moralvalues)

getindex(missue::MoralIssue, i) = missue.moralvalues[i]

start(missue::MoralIssue)   = 1
done(missue::MoralIssue, s) = s > length(missue)
next(missue::MoralIssue, s) = (missue[s], s+1)

function show(io::IO, missue::MoralIssue)
    N = length(missue)
    println(io, N, "-dimensional Moral Issue:")
    for i in missue
        @printf io " %.5f\n" i
    end
end

##############################
#    Society Redefinitions   #
##############################

length(soc::Society)    = length(soc.agents)
size(soc::Society)      = (length(soc.agents), length(soc.agents[1]))

getindex(soc::Society, i::Int64)                    = soc.interactionmatrix[i]
getindex(soc::Society, i::Int64, j::Int64)          = soc.interactionmatrix[i, j]
getindex(soc::Society, i::Int64, r::UnitRange)      = soc.interactionmatrix[i, r]
getindex(soc::Society, r::UnitRange, j::Int64)      = soc.interactionmatrix[r, j]
getindex(soc::Society, r::UnitRange, s::UnitRange)  = soc.interactionmatrix[r, s]
getindex(soc::Society, i::Int64, c::Colon)          = soc.interactionmatrix[i, c]
getindex(soc::Society, c::Colon, j::Int64)          = soc.interactionmatrix[c, j]
getindex(soc::Society, c::Colon, r::UnitRange)      = soc.interactionmatrix[c, r]
getindex(soc::Society, r::UnitRange, c::Colon)      = soc.interactionmatrix[r, c]

start(soc::Society)   = 1
done(soc::Society, s) = s > length(soc)
next(soc::Society, s) = (soc[s], s+1)

function show(io::IO, soc::Society)
    N, K = size(soc)
    println(io, N, "-sized Society on a ", K, "-dimensional Moral space")
    print(io, "Cognition Cost: ", soc.cognitivecost)
end
