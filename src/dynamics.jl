""" 
    metropolisStep!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T}, β::Float64)

Performs one metropolis step on Society soc using MoralVector x and temperature-like parameter β
"""
function metropolisStep!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T}, β::Float64)
    i = rand(1:N)
    j = sample(weights(soc[i, :]))

    # Sample a 'proposed' MoralVector using a MultivariateGaussian centered at the old Agent
    proposed = MoralVector(rand(MvNormal(soc[i][:], ones(5))))
    newcost  = cogcost(proposed, soc, i, j, x)

    ΔV = newcost - cogcost(soc, i, j, x)

    # transistion probability
    p_trans  =  (ΔV < 0 ? 1 : exp(-β*soc[i, j]*ΔV ) )

    # if (p = rand()) < p_trans
    if rand() < p_trans
        insertagent!(soc, proposed, i)
        return proposed
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
    discreteStep!{N,K,T}(soc::DistrustSociety{N,K,T}, x::MoralVector{K,T}; freeze = :none, verbose = false)

Performs one discrete update step on Society soc using MoralVector x

* freeze: freezes the dynamics of one of more variables (:none, :variances, :distrust, :slowtrust, :slowopinion)
"""
function discreteStep!{N,K,T}(soc::DistrustSociety{N,K,T}, x::MoralVector{K,T}; freeze = :none, verbose = false)
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
    discreteStep!{N,K,T}(soc::BasicSociety{N,K,T}, x::MoralVector{K,T}; freeze = :none, verbose = false)

Performs one discrete update step on Society soc using MoralVector x
"""
function discreteStep!{N,K,T}(soc::BasicSociety{N,K,T}, x::MoralVector{K,T}; verbose = false, freeze = :none)
    i = rand(1:N)
    j = sample(weights(soc[i, :]))

    # i learns from j
    delta = computeDeltas(soc, i, j, x)
    
    # update the parameters 
    soc[i] = MoralVector(soc[i][:] + delta)
    
    if verbose
        return (i, j, delta)
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
    societyHistory(soc::DistrustSociety, N::Int, P::Int; freeze = :none, sequential::Bool = false, verbose::Bool = false)

Performs the discrete update on Society soc using a number of P MoralVectors in N*P iterations

* freeze: freezes the dynamics of one of more variables (:none, :variances, :distrust, :slowtrust, :slowopinion)
* sequential: whether the random vectors are presented sequentially, one after the other, or in random order

Returns the history of the evolution and the deltas used in the evolution. If verbose is set to true, also returns the order of the MoralVectors presented
"""
function societyHistory!(soc::DistrustSociety, N::Int, P::Int; freeze = :none, sequential::Bool = false, verbose::Bool = false)
    xs   = [MoralVector() for i in 1:P];

    if sequential && N > 1
         xi = repeat(xs, inner = N)
    else xi = rand(xs, N*P)
    end
   
    history = [deepcopy(soc)]
    deltas  = zeros(1, size(fieldnames(soc), 1) - 1)

    for i in 1:P*N
        deltasi = discreteStep!(soc, xi[i], freeze = freeze, verbose = true)[3:end]
        append!(history, [deepcopy(soc)])
        deltas = vcat(deltas, [deltasi...]')
    end

    if verbose
        return history, deltas, xi
    else return history, deltas
    end
end

""" 
    societyHistory(soc::BasicSociety, N::Int, P::Int; issues = :none, freeze = :none, sequential::Bool = false, verbose::Bool = false)

Performs the discrete update on Society soc using a number of P MoralVectors in N*P iterations

* freeze: freezes the dynamics of one of more variables (:none, :variances, :distrust, :slowtrust, :slowopinion)
* sequential: whether the random vectors are presented sequentially, one after the other, or in random order

Returns the history of the evolution and the deltas used in the evolution. If verbose is set to true, also returns the order of the MoralVectors presented
"""
function societyHistory!(soc::BasicSociety, N::Int, P::Int; issues = :none, sequential::Bool = false, verbose::Bool = false)
    if typeof(issues) == Matrix{Float64} && size(issues, 2) == size(soc, 2)
         xs = [MoralVector(issues[i, :]) for i in rand(1:size(issues, 1), P)]
    else xs = [MoralVector() for i in 1:P];
    end 

    if sequential && N > 1
         xi = repeat(xs, inner = N)
    else xi = rand(xs, N*P)
    end
   
    history = [deepcopy(soc)]
    deltas  = zeros(1, size(fieldnames(soc), 1) - 3)

    for i in 1:P*N
        dW = discreteStep!(soc, xi[i], freeze = :none, verbose = true)[3]
        append!(history, [deepcopy(soc)])
        deltas = vcat(deltas, [dW]')
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
    γ  = sqrt(x[:]' * C * x[:])

    Fw, Fϵ = modfunc(h*σ/γ, μ/sqrt(1 + s2))

    return  (Fw * σ * Cx / γ, 
            -Fw * (Fw + h*σ/γ) * Cx * Cx' / γ^2,
             Fϵ * s2 / sqrt(1 + s2),
            -Fϵ * (Fϵ + μ/sqrt(1 + s2)) * s2^2 / (1 + s2) )

end

"""
    computeDeltas{N, K, T}(soc::DistrustSociety{N,K,T}, i::Int, j::Int, x::MoralVector{K,T})

Compute the evolution delta for each of the variables of an agent i from society soc listening agent j about issue x
"""
function computeDeltas{N, K, T}(soc::DistrustSociety{N,K,T}, i::Int, j::Int, x::MoralVector{K,T})
    σ  = sign(soc[j] ⋅ x)
    h  = soc[i] ⋅ x
    C  = soc.C[i]
    Cx = C * x[:]
    γ  = gammasoc(soc, i, x)
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

"""
    computeDeltas{N, K, T}(soc::BasicSociety{N,K,T}, i::Int, j::Int, x::MoralVector{K,T})

Compute the evolution delta for each of the variables of an agent i from society soc listening agent j about issue x
"""
function computeDeltas{N, K, T}(soc::BasicSociety{N,K,T}, i::Int, j::Int, x::MoralVector{K,T})
    σj  = sign(soc[j] ⋅ x)
    hi  = soc[i] ⋅ x
    γi  = gammasoc(soc, i) #, x)
    ϵij = epssoc(soc, i, j)

    hσ1γ = hi*σj/γi
    phiw = phi(hσ1γ)

    Z    = ϵij + phiw - 2*ϵij*phiw
    
    ret = (1 - 2ϵij) * G(hσ1γ) * σj * γi * x[:] / Z 
    if any(isnan.(ret))
        return 0.
    end
    return ret

end

"""
    pickIssue{N, K, T}(soc::DistrustSociety{N, K, T}, i::Int; err::Float64 = 1e-4, niter::Int = 500, α::Float64 = 0.1, verbose = false)

Pick a specific issue x trying to maximize the change in trust of agent-listener i
"""
function pickIssue{N, K, T}(soc::DistrustSociety{N, K, T}, i::Int;
                  err::Float64 = 1e-4, niter::Int = 500, α::Float64 = 0.1, verbose = false)

    w = soc[i]
    C = soc.C[i]

    x = - sqrt(K)*w

    t = 1.
    n = 0.

    if verbose xs = zeros(K+1, niter) end

    @inbounds while t > err && n < niter  

        h = w ⋅ x
        Γ = x ⋅ (C * x)/K

        xnew = α .* x + (1 - α) .* (2 .* (C * x) ./ Γ .- K .* w ./ h)

        t = norm(xnew - x)
        n += 1.

        if verbose 
            xs[1:K, Int(n)] = xnew
            xs[K+1, Int(n)] = t
        end

        x = sqrt(K) * normalize(xnew[:])
    end
    
    if verbose
        return xs[:, 1:Int(n)], n
    end

    return x
end

"""
    pickIssue(w::Vector{Float64}, C::Matrix{Float64}; err::Float64 = 1e-4, niter::Int = 500, α::Float64 = 0.1, verbose = false)

Pick a specific issue x trying to maximize the change in trust of agent-listener w which has covariance-doubts C
"""
function pickIssue(w::Vector{Float64}, C::Matrix{Float64};
                  err::Float64 = 1e-4, niter::Int = 500, α::Float64 = 0.1, verbose = false)
    t = 1.
    n = 0.

    K = length(w)
    x = - w

    if ! issymmetric(C) error("Fix entries of C. It is not symmetric") end

    xnew = zeros(x)

    if verbose xs = zeros(K+1, niter) end

    @inbounds while t > err && n < niter  

        h = w ⋅ x
        Γ = x ⋅ (C * x)/K

        xnew = α .* x + (1 - α) .* (2 .* (C * x) ./ Γ .- K .* w ./ h)

        t = norm(xnew - x)
        n += 1.

        if verbose 
            xs[1:K, Int(n)] = xnew
            xs[K+1, Int(n)] = t
        end

        x = sqrt(K) * normalize(xnew[:])
    end
    
    if verbose
        return xs, n
    end

    return x, n
end