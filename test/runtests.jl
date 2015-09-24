using SocialSystems, FactCheck

facts("SocialAgent") do
    context("Create an Agent") do
        @fact SocialAgent() --> not(nothing)
        @fact SocialAgent(2) --> not(nothing)
        @fact SocialAgent([1.,2,3]) --> not(nothing)
    end
end

facts("Society") do
    context("Create a Society") do
        @fact Society() --> not(nothing)
        @fact Society(3) --> not(nothing)
        @fact Society(rand(3,3)) --> not(nothing)
        @fact Society(rand(3,2)) --> nothing
    end
end
