module SocialSystems

#using PyPlot, JLD

import Base: length, size, getindex, start, done, next, show

include("types.jl")
include("utils.jl")
include("analysis.jl")

end #module
