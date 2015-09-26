module SocialSystems

using StatsBase: weights, sample
using Distributions: MvNormal, rand
#using PyPlot, JLD

import Base: length, size, getindex, start, done, next, show

include("types.jl")
include("utils.jl")
include("dynamics.jl")
include("analysis.jl")


end #module
