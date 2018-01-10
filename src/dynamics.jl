function metropolisStep!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T}, β::Float64)
    i = rand(1:N)
    j = sample(weights(soc[i, :]))

    # Sample a 'proposed' MoralVector using a MultivariateGaussian centered at the old Agent
    propag   = MoralVector(rand(MvNormal(soc[i][:], ones(5))))
    newcost  = cogcost(propag, soc, i, j, x)

    ΔV = newcost - cogcost(soc, i, j, x)

    # transistion probability
    p_trans  =  (ΔV < 0 ? 1 : exp(-β*soc[i, j]*ΔV ) )

    # if (p = rand()) < p_trans
    if rand() < p_trans
        insertagent!(soc, propag, i)
        return propag
    end

    return i, p_trans
end

function metropolis!{N,K,T}(soc::Society{N,K,T}; β = βDEF)
    # Maybe change this to a more fundamented convergence test
    # We could also argue that people have a maximum number of interactions in society
    iter  = 150*length(soc)

    # The society discusses a single issue, some kind of Zeitgeist
    x = MoralVector()

    for i in 1:iter
        # ignoring the MoralVector 'metropolisStep()' outputs
        metropolisStep!(soc, x, β);
    end

    return iter, x
end

function metropolis!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K, T}; β = βDEF)
    # Maybe change this to a more fundamented convergence test
    # We could also argue that people have a maximum number of interactions in society
    iter  = 150*length(soc)

    for i in 1:iter
        # ignoring the MoralVector 'metropolisStep()' outputs
        metropolisStep!(soc, x, β);
    end

    return iter
end

function discreteStep!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T}; freeze = :none)
    i = rand(1:N)
    j = sample(weights(soc[i, :]))

    # i learns from j
    deltas = computeDeltas(soc, i, j, x)
    
    # update the parameters according to the 'freeze' keyword argument
    soc[i] = MoralVector(soc[i][:] + deltas[1])
    
    if freeze ∉ [:variances, :slowopinion]
        soc.C[i]     += deltas[2]
    end
    
    if freeze ∉ [:distrust]
        soc.mu[i, j] += deltas[3]
    end
    
    if freeze ∉ [:variances, :distrust, :slowtrust]
        soc.s2[i, j] += deltas[4]
    end

    return i, j
end

function discreteEvol!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K, T}; freeze = :none)
    # Maybe change this to a more fundamented convergence test
    # We could also argue that people have a maximum number of interactions in society
    iter  = 150*length(soc)

    for i in 1:iter
        # ignoring the indices 'discreteStep!' outputs
        discreteStep!(soc, x, freeze = freeze);
    end

    return iter
end

function discreteEvol!{N,K,T}(soc::Society{N,K,T}; freeze = :none)
    # Maybe change this to a more fundamented convergence test
    # We could also argue that people have a maximum number of interactions in society
    iter  = 150*length(soc)

    for i in 1:iter
        # ignoring the indices 'discreteStep!' outputs
        discreteStep!(soc, MoralVector(), freeze = freeze);
    end

    return iter
end

"""
    computeDeltas{N, K, T}(soc::DistrustAgentSociety{N,K,T}, i::Int, j::Int, x::MoralVector{K,T})

    Compute the evolution delta for each of the variables of an agent i from society soc listening agent j about issue x
"""
function computeDeltas{N, K, T}(soc::DistrustAgentSociety{N,K,T}, i::Int, j::Int, x::MoralVector{K,T})
    σ  = sign(soc[j] ⋅ x)
    h  = soc[i] ⋅ x
    C  = soc.C[i]
    Cx = C * x[:]
    γ  = gamsoc(soc, i, x)
    μ  = soc.mu[i, j]
    s2 = soc.s2[i, j]

    Fw, Fϵ = modfunc(h*σ/γ, μ/sqrt(1 + s2))

    return  (Fw * σ * Cx / γ, 
            -Fw * (Fw + h*σ/γ) * Cx * Cx' / γ^2,
             Fϵ * s2 / sqrt(1 + s2),
            -Fϵ * (Fϵ + μ/sqrt(1 + s2)) * (s2 / sqrt(1 + s2))^2 )

end
