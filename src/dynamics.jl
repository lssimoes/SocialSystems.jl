function metropolisstep!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K,T}, β::Float64)
    i = rand(1:N)
    j = sample(weights(soc[i, :]))

    # Sample a 'proposed' MoralVector using a MultivariateGaussian centered at the old Agent
    propag   = MoralVector(rand(MvNormal(soc[i][:], ones(5))))
    newcost  = cogcost(propag, soc, j, x)

    ΔV = newcost - cogcost(soc, i, j, x)

    # transistion probability
    p_trans  =  (ΔV < 0 ? 1 : exp(-β*soc[i, j]*ΔV ) )

    if rand() < p_trans
        insertagent!(soc, propag, i)
        return propag
    end

    return soc[i]
end

function metropolis!{N,K,T}(soc::Society{N,K,T}; β = βDEF)
    # Maybe change this to a more fundamented convergence test
    # We could also argue that people have a maximum number of interactions in society
    iter  = 150*length(soc)

    # The society discusses a single issue, some kind of Zeitgeist
    x = MoralVector()

    for i in 1:iter
        # ignoring the MoralVector 'metropolisstep()' outputs
        metropolisstep!(soc, x, β);
    end

    return iter, x
end

function metropolis!{N,K,T}(soc::Society{N,K,T}, x::MoralVector{K, T}; β = βDEF)
    # Maybe change this to a more fundamented convergence test
    # We could also argue that people have a maximum number of interactions in society
    iter  = 150*length(soc)

    for i in 1:iter
        # ignoring the MoralVector 'metropolisstep()' outputs
        metropolisstep!(soc, x, β);
    end

    return iter
end

