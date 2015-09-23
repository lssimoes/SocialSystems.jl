export SocialAgent

#############################
#            TYPE           #
#############################

"""
`type SocialAgent`

Type representing a Social Agent

### Fields
* `moralvalues` (`Vector{Float64}`): Vector with moral dimension values of the agent
* `cognitivecost` (`Function`): Function that describes the cognite cost of the agent
"""
type SocialAgent{N}
    moralvalues::Vector{Float64}
end

"""
`type Society`

Type representing a Society

### Fields
* `cognitivecost` (`Function`): Function that describes the cognite cost of the agent
"""
type Society{N}
    cognitivecost::Function
    cognitivematrix::Matrix{Float64}
    interactionmatrix::Matrix{Float64}
    agents::Vector{SocialAgent}
end

#############################
#        CONSTRUCTORS       #
#############################

"""
`SocialAgent(moral::Vector{Float64})`

Construct a SocialAgent with a given `moral` vector.
"""
function SocialAgent(moral::Vector{Float64})
    return SocialAgent{length(moral)}(moral)
end

"""
`SocialAgent(n::Integer)`

Construct a SocialAgent with a unitary random moral vector.
"""
function SocialAgent(n::Integer)
    return SocialAgent{n}(rand(n))
end

"""
`Society(n::Integer)`

Construct a random Society with size `n` and default cognitive cost
"""
function Society(n::Integer)
    Rij = 1 - eye(N)

    for j in size(Rij, 2) for i in size(Rij, 1)
        Vij[i][j] = defaultcogcost(i,j)
    end end

    return Society{n}(defaultcogcost, Vij , Rij, SocialAgent{5}[SocialAgent(5) for i in 1:n])
