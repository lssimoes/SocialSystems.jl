using FactCheck

facts("MoralVector") do
    context("Create an Vector") do
        @fact MoralVector() --> not(nothing)
        @fact MoralVector(2) --> not(nothing)
        @fact MoralVector([1.,2,3]) --> not(nothing)
    end
end

facts("BasicAgentSociety") do
    context("Create a BasicAgentSociety") do
        @fact BasicAgentSociety() --> not(nothing)
        # @fact BasicAgentSociety(3) --> not(nothing)
        # @fact BasicAgentSociety(rand(3,3)) --> not(nothing)
        # @fact BasicAgentSociety(rand(3,2)) --> nothing
    end
end
