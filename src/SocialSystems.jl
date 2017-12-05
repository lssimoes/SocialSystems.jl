module SocialSystems

# using StatsBase: weights, sample
# using Distributions: MvNormal, Normal, rand, pdf, cdf

import Base: length, size, getindex, start, done, next, show


export MoralVector, StaticAgentSociety#, DistrustAgentSociety


include("constants.jl")
include("types/MoralVector.jl")
include("types/StaticAgentSociety.jl")
#include("types/DistrustAgentSociety.jl")
# include("utils.jl")
# include("dynamics.jl")
# include("analysis.jl")

end #module
