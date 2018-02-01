using FactCheck

facts("MoralVector") do
    context("Create an Vector") do
        @fact MoralVector() --> not(nothing)
        @fact MoralVector(2) --> not(nothing)
        @fact MoralVector([1.,2,3]) --> not(nothing)
    end
end

facts("BasicSociety") do
    context("Create a BasicSociety") do
        @fact BasicSociety() --> not(nothing)
        # @fact BasicSociety(3) --> not(nothing)
        # @fact BasicSociety(rand(3,3)) --> not(nothing)
        # @fact BasicSociety(rand(3,2)) --> nothing
    end
end
