##############################
#      Moral Vector Type     #
##############################

"""
    type MoralVector{K, T <: Real}

Type representing a Moral Vector

### Fields
* `morals` (Vector{T}): normalized `K`-vector representing the moral dimension values (or, moral vector)
"""
struct MoralVector{K, T <: Real}
    morals::Vector{T}
end


"""
    MoralVector()

Construct a MoralVector with a random moral vector with default number of components `KMORAL`.
"""
MoralVector() = MoralVector{KMORAL, Float64}(randSphere(KMORAL))


"""
    MoralVector(k::Int)

Construct a MoralVector with a random moral vector with default number of components `k`.
"""
MoralVector(k::Int) = MoralVector{k, Float64}(randSphere(k))


"""
    MoralVector(m::Vector{T})

Construct a MoralVector with an input moral vector `m` to be normalized.
"""
MoralVector(m::Vector{T}) where T <: Real = MoralVector{length(m), T}(normalize(m))


###############################
# Moral Vector Redefinitions  #
###############################

length(mvector::MoralVector) = length(mvector.morals)
size(mvector::MoralVector)   = size(mvector.morals)

getindex(mvector::MoralVector, i::Int)   = mvector.morals[i]
getindex(mvector::MoralVector, c::Colon) = mvector.morals[:]

start(mvector::MoralVector)        = 1
done(mvector::MoralVector, s::Int) = s > length(mvector)
next(mvector::MoralVector, s::Int) = (mvector[s], s+1)

dot{K,T}(i::MoralVector{K,T}, j::MoralVector{K,T}) = (i[:] ⋅ j[:])

function show(io::IO, mvector::MoralVector)
    N = length(mvector)
    print(io, N, "-dimensional Moral Vector:")
    for i in mvector
        @printf io "\n %.5f" i
    end
end

+(mvector::MoralVector, nvector::MoralVector) = MoralVector(mvector[:] + nvector[:])
-(mvector::MoralVector, nvector::MoralVector) = MoralVector(mvector[:] - nvector[:])
-(mvector::MoralVector) = MoralVector(-mvector[:])

# need a better way to sum weigthed MoralVector's
*(p::T, mvector::MoralVector{K, T}) where {T <: Real, K} = p*mvector[:]

###############################
#  Moral Vector Definitions   #
###############################

"""
    consensus(ags::Vector{MoralVector}, i::Int, j::Int)

Evaluates the consensus of MoralVectors i and j from a Vector of MoralVectors
"""
function consensus(ags::Vector{MoralVector{K, T}}, i::Int, j::Int) where {T <: Real, K}
    N = length(ags)
    if 0 < i <= N && 0 < j <= N
        return ags[i] ⋅ ags[j]
    else
        error("The indices given are out of range")
    end
end


"""
    consensus(ags::::Vector{MoralVector})

Evaluates the consensus of Vector of MoralVectors, that is, the matrix of the correlations between the MoralVectors inner representations
"""
function consensus(ags::Vector{MoralVector{K, T}}; format = :none) where {T <: Real, K}
    N = length(ags)
    ψ = zeros(N, N)

    for i in 1:N for j in (i+1):N
        ψ[i, j] = consensus(ags, i, j)
    end end

    if format == :ordered   
        return ψ[ψ .!= 0.]
    end
    return ψ
end
