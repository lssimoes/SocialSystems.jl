export SocialAgent, Society

##############################
#     Social Agent Type      #
##############################

"""
`type SocialAgent`

Type representing a Social Agent

### Fields
* `moralvalues` (`Vector{Float64}`): Vector with moral dimension values of the agent
"""
type SocialAgent{K}
    moralvalues::Vector{Float64}

    function call(::Type{SocialAgent}, moral::Vector{Float64})
        new{length(moral)}(moral)
    end
end

##############################
#      Moral Issue Type      #
##############################

"""
`type MoralIssue`

Type representing a Moral Issue

### Fields
* `moralvalues` (`Vector{Float64}`): Vector with moral dimension values of the issue
"""
type MoralIssue{K}
    moralvalues::Vector{Float64}

    function call(::Type{MoralIssue}, moral::Vector{Float64})
        new{length(moral)}(moral)
    end
end

##############################
#        Society Type        #
##############################

"""
`type Society`

Type representing a Society

### Fields
* `cognitivecost` (`Function`): Function that describes the cognite cost of the agent
* `interactionmatrix` (`Matrix{Float64}`): Matrix that describes the interactions of the agents of the society
* `agents` (`Vector{SocialAgent}`): Vector of the `SocialAgents` of the Society
"""
type Society{N, K}
    cognitivecost::Function
    interactionmatrix::Matrix{Float64}
    agents::Vector{SocialAgent{K}}

    function call{K}(::Type{Society}, cognitivecost::Function,
                 interactionmatrix::Matrix{Float64},
                 agents::Vector{SocialAgent{K}})
        new{length(agents), K}(cognitivecost, interactionmatrix, agents)
    end
end

##############################
#  Social Agent Constructors #
##############################

"""
`SocialAgent()`

Construct a SocialAgent with a unitary random moral vector with default number of components.
"""
function SocialAgent()
    return SocialAgent(rand(KMORAL))
end

"""
`SocialAgent(n::Integer)`

Construct a SocialAgent with a unitary random moral vector with `n` components.
"""
function SocialAgent(n::Integer)
    return SocialAgent(rand(n))
end

##############################
#  Moral Issue Constructors  #
##############################

"""
`MoralIssue()`

Construct a MoralIssue with a unitary random moral vector with default number of components.
"""
function MoralIssue()
    return MoralIssue(rand(KMORAL))
end

"""
`MoralIssue(n::Integer)`

Construct a MoralIssue with a unitary random moral vector with `n` components.
"""
function MoralIssue(n::Integer)
    return MoralIssue(rand(n))
end


##############################
#    Society Constructors    #
##############################

"""
`Society()`

Construct a random Society with default size and default cognitive cost
"""
function Society()
    return Society(Vij, 1 - eye(NSOC), SocialAgent{5}[SocialAgent(5) for i in 1:NSOC])
end

"""
`Society(n::Integer)`

Construct a random Society with size `n` and default cognitive cost
"""
function Society(n::Integer)
    return Society(Vij, 1 - eye(n), SocialAgent{5}[SocialAgent(5) for i in 1:n])
end

"""
`Society(n::Integer)`

Construct a random Society with a square `Rij` interaction matrix and default cognitive cost
"""
function Society(Rij::Matrix{Float64})
    n1, n2 = size(Rij)
    if n1 != n2 error("Given interaction matrix isn't square!") end

    return Society(Vij, Rij, SocialAgent{5}[SocialAgent(5) for i in 1:n1])
end

##############################
# Social Agent Redefinitions #
##############################

length(ag::SocialAgent) = length(ag.moralvalues)
size(ag::SocialAgent)   = size(ag.moralvalues)

getindex(ag::SocialAgent, i) = ag.moralvalues[i]

start(ag::SocialAgent)   = 1
done(ag::SocialAgent, s) = s > length(ag)
next(ag::SocialAgent, s) = (ag[s], s+1)

function show(io::IO, ag::SocialAgent)
    N = length(ag)
    println(io, N, "-dimensional Social Agent:")
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

getindex(soc::Society, i) = soc.agents[i]

start(soc::Society)   = 1
done(soc::Society, s) = s > length(soc)
next(soc::Society, s) = (soc[s], s+1)

function show(io::IO, soc::Society)
    N, K = size(soc)
    println(io, N, "-sized Society on a ", K, "-dimensional Moral space")
    print(io, "Cognition Cost: ", soc.cognitivecost)
end
