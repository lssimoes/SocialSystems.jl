
""" 
    randSphere(K::Int)
    
Returns a random K-vector from the unit sphere
"""
randSphere(K::Int) = normalize(randn(K))

"Computes `γ` from `ρ`"
gammasoc(ρ::Float64) = sqrt(1 - ρ^2) / ρ
