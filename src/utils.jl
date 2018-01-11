""" 
    randSphere(K::Int)
    
Returns a random K-vector from the unit sphere
"""
randSphere(K::Int) = normalize(randn(K))

"Computes `γ` from `ρ`"
gammasoc(ρ::Float64) = sqrt(1 - ρ^2) / ρ

"Computes `ρ` from `γ`"
rhosoc(γ::Float64)   = 1/ sqrt(1 + γ^2)

"Computes `ϵ` from `μ` and `s^2`"
epssoc(μ::Float64, s2::Float64) = phi(μ/sqrt(1+s2))

"The cumulative function of the Normal distribution"
phi(x::Real) = cdf(Normal(), x)

"The density function of the Normal distribution"
G(x::Real) = pdf(Normal(), x)

"Returns the two modulation functions: Fw and Fϵ"
function modfunc(hσ1γ::Float64, μ1sqs2::Float64)
    phiϵ = phi(μ1sqs2)
    phiw = phi(hσ1γ)
    Z    = phiϵ + phiw - 2*phiϵ*phiw
    
    Fw = (1 - 2phiϵ) * G(hσ1γ) / Z 
    Fϵ = (1 - 2phiw) * G(μ1sqs2) / Z

    return (Fw, Fϵ)
end
