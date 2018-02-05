module SocialSystems

using StatsBase: weights, sample
using Distributions: MvNormal, rand, Normal, cdf, pdf

import Base: +, -, *, length, size, getindex, setindex!, start, done, next, show, dot

# Utils Export
export randSphere, gammasoc, phi, G

# Types Export
export MoralVector, Society, BasicSociety, DistrustSociety
export agents, interactions, insertagent!, hamiltonian, magnetization, believeness, quadrupole, consensus
export epssoc, rhosoc, gammasoc, cogcost

# Dynamics Export
export metropolisStep!, metropolis!,
        discreteStep!, discreteEvol!, societyHistory!,
        computeDeltas

include("constants.jl")

include("utils.jl")

include("types/MoralVector.jl")
include("types/Society.jl")
include("types/BasicSociety.jl")
include("types/DistrustSociety.jl")

include("dynamics.jl")

end #module
