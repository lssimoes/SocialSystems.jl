export hamiltonian, cognitivecost

# change this design..
cognitivecost{N,K,T}(soc::Society{N,K,T}, i::Int64, j::Int64, x::MoralIssue{K,T}) = soc.cognitivecost(agents(soc, i), agents(soc, j), x)
cognitivecost{N,K,T}(ag::MoralAgent, soc::Society{N,K,T}, j::Int64, x::MoralIssue{K,T}) = soc.cognitivecost(ag, agents(soc, j), x)

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
