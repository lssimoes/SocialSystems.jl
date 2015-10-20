export hamiltonian, cognitivecost, magnetization

"""
`cognitivecost{N,K,T}(agi::MoralAgent, agj::MoralAgent, x::MoralIssue{K,T}, ρ::Float64, ϵ::Float64)`

Evaluates the `cognitivecost` on agent `agi` of agent `agj`'s opinion about a MoralIssue `x`
"""
cognitivecost{K,T}(cogcost::Function, agi::MoralAgent{K,T}, agj::MoralAgent{K,T}, x::MoralIssue{K,T}, ρ::Float64, ϵ::Float64) =
    cogcost(agi, agj, x, ρ, ϵ)

"""
`cognitivecost{N,K,T}(soc::Society{N, K, T}, i::Int, j::Int, x::MoralIssue{K, T})`

Evaluates the `cognitivecost` of `soc` on agent `soc[i]` of agent `soc[j]`'s opinion about a MoralIssue `x`
"""
cognitivecost{N,K,T}(soc::Society{N, K, T}, i::Int, j::Int, x::MoralIssue{K, T}) =
    soc.cognitivecost(agents(soc, i), agents(soc, j), x, soc.ρ, soc.ϵ)

"""
`hamiltonian{N,K,T}(soc::Society{N,K,T}, x::MoralIssue{K,T})`

Evaluates the `hamiltonian`, that is, the total `social cost` of a Society given some Moral Issue `x`
"""
function hamiltonian{N,K,T}(soc::Society{N,K,T}, x::MoralIssue{K,T})
    hamil = 0
    for j in 1:N for i in 1:N
        Rij = soc[i, j]
        if Rij != 0 hamil += Rij*cognitivecost(soc,i,j,x) end
    end end

    return hamil
end

"""
`magnetization{N,K,T}(soc::Society{N,K,T}, x::MoralIssue{K,T})`

Evaluates the `magnetization` of a Society, that is, the total sum of the agents' opinions
"""
function magnetization{N,K,T}(soc::Society{N,K,T}, x::MoralIssue{K,T})
    mag = 0.
    
    for agi in agents(soc)
        mag += hopinion(agi, x)
    end

    return mag / N / sqrt(K)
end
