""" 
    randSphere(K::Int)
    
Returns a random K-vector from the unit sphere
"""
randSphere(K::Int) = normalize(randn(K))

"Computes `γ` from `ρ`"
gammasoc(ρ::Float64) = sqrt(1 - ρ^2) / ρ

"Computes `ρ` from `γ`"
rhosoc(γ::Float64)   = 1/ sqrt(1 + γ^2)

"The cumulative function of the Normal distribution"
phi(x::Real) = cdf(Normal(), x)

"The density function of the Normal distribution"
G(x::Real) = pdf(Normal(), x)