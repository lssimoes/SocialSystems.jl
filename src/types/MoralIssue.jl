export MoralIssue

##############################
#      Moral Issue Type      #
##############################

"""
`type MoralIssue{K, T <: Real}`

Type representing a Moral Issue

### Fields
* `moralvalues` (`Vector{T}`): K-vector with moral dimension values of the issue
"""
type MoralIssue{K, T <: Real}
    moralvalues::Vector{T}

    function call{T}(::Type{MoralIssue}, moral::Vector{T})
        normaliz = sqrt(moral⋅moral)
        sqrtk = sqrt(length(moral))

        new{length(moral), T}(sqrtk*moral/normaliz)
    end
end


##############################
#  Moral Issue Constructors  #
##############################

"""
`MoralIssue(;k=KMORAL)`

Construct a MoralIssue with a random moral vector with default number of components `KMORAL`.
"""
function MoralIssue(;k=KMORAL)
    return MoralIssue(2rand(k)-1)
end


##############################
# Moral Issue Redefinitions  #
##############################

length(missue::MoralIssue) = length(missue.moralvalues)
size(missue::MoralIssue)   = size(missue.moralvalues)

getindex(missue::MoralIssue, i) = missue.moralvalues[i]

start(missue::MoralIssue)   = 1
done(missue::MoralIssue, s) = s > length(missue)
next(missue::MoralIssue, s) = (missue[s], s+1)

function show(io::IO, missue::MoralIssue)
    N = length(missue)
    println(io, N, "-dimensional Moral Issue:")
    for i in missue
        @printf io " %.5f\n" i
    end
end