module SocialSystems

using StatsBase: weights, sample
# using Distributions: MvNormal, Normal, rand, pdf, cdf

import Base: length, size, getindex, start, done, next, show, dot

# Utils Export
export randSphere, gammasoc

# Types Export
export MoralVector, Society, StaticAgentSociety#, DistrustAgentSociety
export agents, interactions, insertagent!, hamiltonian, magnetization, believeness, quadrupole, consensus
export rhosoc, epssoc, cogcost

# Dynamics Export
export metropolisstep!, metropolis!

include("constants.jl")

include("utils.jl")

include("types/MoralVector.jl")
include("types/Society.jl")
include("types/StaticAgentSociety.jl")
#include("types/DistrustAgentSociety.jl")

include("dynamics.jl")

end #module
