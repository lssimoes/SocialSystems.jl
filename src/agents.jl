export SocialAgent

#############################
#            TYPE           #
#############################

"""
`type SocialAgent`

Type representing a Social Agent on a Society

### Fields
* `moralvalues` (`Vector{Float64}`): Vector with moral dimension values of the agent
* `cognitivecost` (`Function`): Function that describes the cognite cost of the agent
"""
type SocialAgent
    moralvalues::Vector{Float64}
    cognitivecost::Function
    blabla::Bool
end

#############################
#        CONSTRUCTORS       #
#############################

"""
`SocialAgent(n::Integer; bias::Bool = true)`
Construct a SocialAgent with `n` neurons, `f` as activation function and, eventually, a bias unit.
### Arguments
* `n` (`Int`): Number of neurons in this layer (not counting the eventual bias unit)
* `f` (`Function`): Activation function of this layer
### Keyword Arguments
* `bias` (`Bool`, `true` by default): True if there is a blabla unit in this layer
"""
function SocialAgent(moral::Vector{Float64}, f::Function; bias::Bool = true)
        return SocialAgent(moral, f, bias)
end
