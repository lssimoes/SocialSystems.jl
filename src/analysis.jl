export hamiltonian

cognitivecost{N,K}(soc::Society{N,K}, i::Int64, j::Int64, x::MoralIssue{K}) = soc.cognitivecost(agents(soc, i), agents(soc, j), x)

"""
`hamiltonian{N,K}(soc::Society{N,K}, x::MoralIssue{K})`

Evaluates the `hamiltonian`, that is, the total `social cost` of a Society given some Moral Issue `x`
"""
function hamiltonian{N,K}(soc::Society{N,K}, x::MoralIssue{K})
    hamil = 0
    for j in 1:N for i in 1:N
        Rij = soc[i, j]
        if Rij != 0 hamil += Rij*cognitivecost(soc,i,j,x) end
    end end

    return hamil
end
