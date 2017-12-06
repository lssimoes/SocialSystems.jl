using FactCheck

facts("MoralVector") do
    context("Create an Vector") do
        @fact MoralVector() --> not(nothing)
        @fact MoralVector(2) --> not(nothing)
        @fact MoralVector([1.,2,3]) --> not(nothing)
    end
end

facts("StaticAgentSociety") do
    context("Create a StaticAgentSociety") do
        @fact StaticAgentSociety() --> not(nothing)
        # @fact StaticAgentSociety(3) --> not(nothing)
        # @fact StaticAgentSociety(rand(3,3)) --> not(nothing)
        # @fact StaticAgentSociety(rand(3,2)) --> nothing
    end
end
