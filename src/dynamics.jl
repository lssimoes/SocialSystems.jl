""" 
    metropolisStep!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T}, β::Float64)

Performs one metropolis step on Society soc using MoralVector x and temperature-like parameter β
"""
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

""" 
    metropolis!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K, T}; β::Float64 = βDEF)

Performs metropolis on Society soc using MoralVector x and optional temperature-like parameter β 
"""
function metropolis!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K, T}; β::Float64 = βDEF)
    # Maybe change this to a more fundamented convergence test
    # We could also argue that people have a maximum number of interactions in society
    iter  = 150*length(soc)

    for i in 1:iter
        # ignoring the MoralVector 'metropolisStep()' outputs
        metropolisStep!(soc, x, β);
    end

    return iter
end

""" 
    metropolis!{N,K,T}(soc::Society{N,K,T}; β::Float64 = βDEF)

Performs metropolis on Society soc using random MoralVectors and optional temperature-like parameter β 
"""
function metropolis!{N,K,T}(soc::Society{N,K,T}; β::Float64 = βDEF)
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

""" 
    discreteStep!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T}; freeze = :none, verbose = false)

Performs one discrete update step on Society soc using MoralVector x

* freeze: freezes the dynamics of one of more variables (:none, :variances, :distrust, :slowtrust, :slowopinion)
"""
function discreteStep!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T}; freeze = :none, verbose = false)
    i = rand(1:N)
    j = sample(weights(soc[i, :]))

    # i learns from j
    deltas = computeDeltas(soc, i, j, x)
    
    # update the parameters according to the 'freeze' keyword argument
    soc[i] = MoralVector(soc[i][:] + deltas[1])
    
    if freeze ∉ [:variances, :slowopinion]
        soc.C[i] += deltas[2]
    end
    
    if freeze ∉ [:distrust]
        soc.mu[i, j] += deltas[3]
    end
    
    if freeze ∉ [:variances, :distrust, :slowtrust]
        soc.s2[i, j] += deltas[4]
    end

    if verbose
        return (i, j, deltas...)
    end
    return i, j
end

""" 
    discreteEvol!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K, T}; freeze = :none)

Performs the discrete evolution on Society soc using MoralVector x

* freeze: freezes the dynamics of one of more variables (:none, :variances, :distrust, :slowtrust, :slowopinion)
"""
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

""" 
    discreteEvol!{N,K,T}(soc::Society{N,K,T}; freeze = :none)

Performs one discrete update step on Society soc using several random MoralVectors

* freeze: freezes the dynamics of one of more variables (:none, :variances, :distrust, :slowtrust, :slowopinion)
"""
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
    societyHistory(soc::DistrustAgentSociety, N::Int, P::Int; freeze = :none, sequential::Bool = false, verbose::Bool = false)

Performs the discrete update on Society soc using a number of P MoralVectors in N*P iterations

* freeze: freezes the dynamics of one of more variables (:none, :variances, :distrust, :slowtrust, :slowopinion)
* sequential: whether the random vectors are presented sequentially, one after the other, or in random order

Returns the history of the evolution and the deltas used in the evolution. IF verbose is set to true, also returns the order of the MoralVectors presented
"""
function societyHistory!(soc::DistrustAgentSociety, N::Int, P::Int; freeze = :none, sequential::Bool = false, verbose::Bool = false)
    xs   = [MoralVector() for i in 1:P];

    if sequential
         xi = repeat(xs, inner = N)
    else xi = rand(xs, N*P)
    end
   
    history = [deepcopy(pair)]
    deltas  = zeros(1, size(fieldnames(soc), 1) - 1)

    for i in 1:P*N
        deltasi = discreteStep!(pair, xi[i], freeze = freeze, verbose = true)[3:end]
        append!(history, [deepcopy(pair)])
        deltas = vcat(deltas, [deltasi...]')
    end

    if verbose
        return history, deltas, xi
    else return history, deltas
    end
end

"""
    computeDeltas{K, T}(agi::MoralVector{K, T}, agj::MoralVector{K, T}, x::MoralVector{K,T}, C::Matrix{Float64}, μ::Float64, s2::Float64)

Compute the evolution delta for each of the variables of an agent i listening agent j about issue x given all other parameters
"""
function computeDeltas{K, T}(agi::MoralVector{K, T}, agj::MoralVector{K, T}, x::MoralVector{K,T}, C::Matrix{Float64}, μ::Float64, s2::Float64)
    σ  = sign(agj ⋅ x)
    h  = agi ⋅ x
    Cx = C * x[:]
    γ  = x[:]' * C * x[:]

    Fw, Fϵ = modfunc(h*σ/γ, μ/sqrt(1 + s2))

    return  (Fw * σ * Cx / γ, 
            -Fw * (Fw + h*σ/γ) * Cx * Cx' / γ^2,
             Fϵ * s2 / sqrt(1 + s2),
            -Fϵ * (Fϵ + μ/sqrt(1 + s2)) * s2^2 / (1 + s2) )

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

    hσ1γ   = h*σ/γ
    μ1sqs2 = μ/sqrt(1 + s2)

    Fw, Fϵ = modfunc(hσ1γ, μ1sqs2)

    return  (Fw * σ * Cx / γ, 
            -Fw * (Fw + hσ1γ) * Cx * Cx' / γ^2,
             Fϵ * s2 / sqrt(1 + s2),
            -Fϵ * (Fϵ + μ1sqs2) * s2^2 / (1 + s2) )

end