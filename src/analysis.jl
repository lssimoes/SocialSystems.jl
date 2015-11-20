export hopinion, cognitivecost, hamiltonian,
       magnetization, believeness, quadrupole, consensus

"""
`hopinion{K,T}(i::MoralAgent{K,T}, x::MoralIssue{K,T})`

MoralAgent `i` opinion about MoralIssue `x`
"""
hopinion{K,T}(i::MoralAgent{K,T}, x::MoralIssue{K,T}) = (i.moralvalues ⋅ x.moralvalues) / sqrt(K)

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

Evaluates the `hamiltonian`, that is, the total `social cost` of a Society given some MoralIssue `x`
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

Evaluates the `magnetization` of a Society, that is, the total sum of the MoralAgents opinions
"""
function magnetization{N,K,T}(soc::Society{N,K,T}, x::MoralIssue{K,T})
    mag = 0.

    for agi in agents(soc)
        mag += hopinion(agi, x)
    end

    return mag / N / sqrt(K)
end

"""
`believeness{N,K,T}(soc::Society{N,K,T}, x::MoralIssue{K,T})`

Evaluates the `believeness` of a Society, that is, the sum of the absolute values of MoralAgents opinions
"""
function believeness{N,K,T}(soc::Society{N,K,T}, x::MoralIssue{K,T})
    bel = 0.

    for agi in agents(soc)
        bel += abs(hopinion(agi, x))
    end

    return bel / N / sqrt(K)
end

"""
`quadrupole{N,K,T}(soc::Society{N,K,T}, x::MoralIssue{K,T})`

Evaluates the `quadrupole` of a Society, that is, something very nasty and obscure:

* \frac{1}{N^2 K} \sum_{\langle ij \rangle} R_{ij} j_i h_j
"""
function quadrupole{N,K,T}(soc::Society{N,K,T}, x::MoralIssue{K,T})
    qd = 0.

    for i in 1:N for j in (i+1):N
        qd += hopinion(agents(soc, i), x) * hopinion(agents(soc, j), x) * soc[i, j]
    end end

    return qd / N^2 / K
end

"""
`consensus{N,K,T}(soc::Society{N,K,T}, i::Int, j::Int)`

Evaluates the `consensus` of MoralAgents `i` and `j` within a Society, that is, the between the agents inner representations
"""
function consensus{N,K,T}(soc::Society{N,K,T}, i::Int, j::Int)
    if 0 < i <= N && 0 < j <= N
        return agents(soc, i).moralvalues ⋅ agents(soc,j).moralvalues / K
    else
        error("The indices given are out of range")
    end
end
"""
`consensus{N,K,T}(soc::Society{N,K,T})`

Evaluates the `consensus` of a Society, that is, the matrix of the correlations between the MoralAgents inner representations
"""
function consensus{N,K,T}(soc::Society{N,K,T})
    ψ = zeros(N, N)

    for i in 1:N for j in (i+1):N
        ψ[i, j] = consensus(soc, i, j)
    end end

    return ψ
end
