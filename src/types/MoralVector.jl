##############################
#      Moral Vector Type     #
##############################

"""
    type MoralVector{K, T <: Real}

Type representing a Moral Vector

### Fields
* morals (Vector{T}): normalized K-vector representing the moral dimension values (or, moral vector)
"""
struct MoralVector{K, T <: Real}
    morals::Vector{T}
end

"""
    MoralVector(k::Int)

Construct a MoralVector with a random moral vector with default number of components k.
"""
MoralVector(k::Int) = MoralVector{k, Float64}(2rand(k) - 1)

"""
    MoralVector()

Construct a MoralVector with a random moral vector with default number of components KMORAL.
"""
MoralVector() = MoralVector{KMORAL, Float64}(2rand(KMORAL) - 1)

"""
    MoralVector(k::Int)

Construct a MoralVector with an input moral vector to be normalized.
"""
MoralVector(m::Vector{T}) where T <: Real = MoralVector{length(m), T}(normalize(m))

###############################
# Moral Vector Redefinitions  #
###############################

length(mvector::MoralVector) = length(mvector.morals)
size(mvector::MoralVector)   = size(mvector.morals)

getindex(mvector::MoralVector, i) = mvector.morals[i]

start(mvector::MoralVector)   = 1
done(mvector::MoralVector, s) = s > length(mvector)
next(mvector::MoralVector, s) = (mvector[s], s+1)

function show(io::IO, mvector::MoralVector)
    N = length(mvector)
    println(io, N, "-dimensional Moral Vector:")
    for i in mvector
        @printf io " %.5f\n" i
    end
end