module SocialSystems

using StatsBase: weights, sample
using Distributions: MvNormal, Normal, rand, pdf, cdf
# using PyPlot, JLD

# import Base: length, size, getindex, start, done, next, show

include("type/MoralIssue.jl")
include("type/AgentSociety.jl")
# include("types.jl")
# include("utils.jl")
# include("dynamics.jl")
# include("analysis.jl")


end #module
