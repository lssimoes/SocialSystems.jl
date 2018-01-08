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

function discreteStep!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T})
    i = rand(1:N)
    j = sample(weights(soc[i, :]))

    # i learns from j
    updateparams!(soc, i, j, x)

    return i, j
end

function discreteEvol!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K, T})
    # Maybe change this to a more fundamented convergence test
    # We could also argue that people have a maximum number of interactions in society
    iter  = 150*length(soc)

    for i in 1:iter
        # ignoring the MoralVector 'metropolisStep()' outputs
        discreteStep!(soc, x);
    end

    return iter
end

function updateparams!{N, K, T}(soc::DistrustAgentSociety{N,K,T}, i::Int, j::Int, x::MoralVector{K,T})
    σ  = sign(soc[j] ⋅ x)
    h  = soc[i] ⋅ x
    C  = soc.C[i]
    γ  = gamsoc(soc, i, x)
    μ  = soc.mu[i, j]
    s2 = soc.s2[i, j]

    phiϵ = epssoc(soc, i, j)
    phiw = phi(σ * h / γ)
    Z    = phiϵ + phiw - 2*phiϵ*phiw
    
    E  = - log(Z)
    Fw = (1 - phiϵ) * G(h/γ) / Z
    Fϵ = (1 - phiw) * G(μ/sqrt(1 + s2)) / Z

    soc[i]        = MoralVector(soc[i][:] + σ * Fw * C * x[:])
    soc.C[i]     -= Fw * (Fw + h*σ/γ) * C * (x[:] * x[:]') * C

    soc.mu[i, j] += s2   * Fϵ * μ / (1 + s2)
    soc.s2[i, j] -= s2^4 * Fϵ * (Fϵ + 1) * μ^2 / (1 + s2)^2
end
