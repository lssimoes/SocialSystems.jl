##################
#  Society Type  #
##################

abstract type Society{N, K, T} end


###########################
#  Society Redefinitions  #
###########################

length(soc::Society)       = length(soc.agents)
size(soc::Society)         = (length(soc.agents), length(soc.agents[1]))
size(soc::Society, i::Int) = size(soc)[i]

getindex(soc::Society, i::Int)                     = soc.agents[i]
getindex(soc::Society, c::Colon)                   = soc.agents[:]
getindex(soc::Society, c1::Colon, c2::Colon)       = soc.links[:, :]
endof(soc::Society)                                = soc.agents[end]


getindex(soc::Society, i::Int, j::Int)             = soc.links[i, j]
getindex(soc::Society, i::Int, r::UnitRange)       = soc.links[i, r]
getindex(soc::Society, r::UnitRange, j::Int)       = soc.links[r, j]
getindex(soc::Society, r::UnitRange, s::UnitRange) = soc.links[r, s]
getindex(soc::Society, i::Int, c::Colon)           = soc.links[i, c]
getindex(soc::Society, c::Colon, j::Int)           = soc.links[c, j]
getindex(soc::Society, c::Colon, r::UnitRange)     = soc.links[c, r]
getindex(soc::Society, r::UnitRange, c::Colon)     = soc.links[r, c]

setindex!(soc::Society, x::MoralVector, i::Int64) = 
    soc.agents[i] = x

start(soc::Society)        = 1
done(soc::Society, s::Int) = s > length(soc)
next(soc::Society, s::Int) = (soc[s], s+1)


#########################
#  Society Definitions  #
#########################

"""
    agents(soc::Society)

Returns the agents vector of a Society soc
"""
agents(soc::Society)           = soc[:]


"""
    agents(soc::Society, i::Int)

Returns the ith agent of a Society soc
"""
agents(soc::Society, i::Int) = soc[i]


"""
    interactions(soc::Society)

Returns the links of a Society soc
"""
interactions(soc::Society)     = soc.links


"""
    insertagent!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T}, i::Int)

Insert new agent x at position i in Society soc
"""
insertagent!{N, K, T}(soc::Society{N,K,T}, x::MoralVector{K,T}, i::Int) =
    soc.agents[i] = x


"""
    hamiltonian{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T})

Evaluates the hamiltonian, that is, the total social cost of a Society given some MoralVector x
"""
function hamiltonian{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T})
    hamil = 0

    for j in 1:N for i in 1:N
        Rij = soc[i, j]

        if Rij != 0 
            hamil += Rij*cogcost(soc,i,j,x) 
        end
    end end

    return hamil
end


"""
    magnetization{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T})

Evaluates the magnetization of a Society, that is, the total sum of the MoralVectors opinions
"""
function magnetization{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T})
    mag = 0.

    for agi in agents(soc)
        mag += agi ⋅ x
    end

    return mag / N 
end


"""
    believeness{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T})

Evaluates the believeness of a Society, that is, the sum of the absolute values of MoralVectors opinions
"""
function believeness{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T})
    bel = 0.

    for agi in agents(soc)
        bel += abs(agi ⋅ x)
    end

    return bel / N 
end


"""
    quadrupole{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T})

Evaluates the quadrupole of a Society, that is, something very nasty and obscure:

* \frac{1}{N^2 K} \sum_{\langle ij \rangle} R_{ij} j_i h_j
"""
function quadrupole{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T})
    qd = 0.

    for i in 1:N for j in (i+1):N
        qd += soc[i, j] * (soc[i] ⋅ x) * (soc[j] ⋅ x) 
    end end

    return qd / N^2 
end


"""
    consensus{N,K,T}(soc::Society{N,K,T}, i::Int, j::Int)

Evaluates the consensus of MoralVectors i and j within a Society, that is, the between the agents inner representations
"""
function consensus{N,K,T}(soc::Society{N,K,T}, i::Int, j::Int)
    if 0 < i <= N && 0 < j <= N
        return soc[i] ⋅ soc[j]
    else
        error("The indices given are out of range")
    end
end


"""
    consensus{N,K,T}(soc::Society{N,K,T})

Evaluates the consensus of a Society, that is, the matrix of the correlations between the MoralVectors inner representations
"""
function consensus{N,K,T}(soc::Society{N,K,T}; format = :none)
    ψ = zeros(N, N)

    for i in 1:N for j in (i+1):N
        ψ[i, j] = consensus(soc, i, j)
    end end

    if format == :ordered   
        return ψ[ψ .!= 0.]
    end
    return ψ
end
