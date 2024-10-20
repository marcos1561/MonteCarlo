using Plots
using MonteCarlo.Ehrenfest

function load_binomial_probs()
    x_list = []
    y_list = []
    for line in readlines("exercicios/ex3/data.txt")
        x, y = [parse(Float64, i) for i in split(line, " ")]
        push!(x_list, x)
        push!(y_list, y)
    end
    
    return (x=x_list, y=y_list)
end

function states_freq_analytical(n_max)
    na_range = Vector(0:n_max)
    probs = Vector{Float64}(undef, length(na_range))
    
    n_half = trunc(Int, n_max/2)
    
    idx_middle = findfirst(x -> x==n_half, na_range)
    probs[idx_middle] = 1
    
    idx = idx_middle - 1
    while idx > 0
        na = na_range[idx]
        probs[idx] = na / (n_max - na + 1) * probs[idx + 1]
    
        idx -= 1
    end
    
    idx = idx_middle + 1
    while idx <= (n_max + 1)
        na = na_range[idx]
        probs[idx] = (n_max - na) / (na + 1) * probs[idx - 1]
        
        idx += 1
    end

    probs ./= sum(probs)
    return na_range, probs
end

function main()
    n = 100
    transient_steps = 2000
    collect_steps = 10000

    states_freq1 = stationary_states_freq(n, transient_steps, collect_steps)
    states_freq2 = stationary_states_freq(n, transient_steps, collect_steps)
    
    states1 = collect(keys(states_freq1))
    freq1 = collect(values(states_freq1))
    sim_probs1 = freq1 ./ collect_steps
    
    states2 = collect(keys(states_freq2))
    freq2 = collect(values(states_freq2))
    sim_probs2 = freq2 ./ collect_steps
    
    # na_range, analytical_probs = states_freq_analytical(n)
    na_range, analytical_probs = load_binomial_probs()

    plot(na_range, analytical_probs, 
        label="Analítico", 
        xlims=(30, 70),
        yaxis=:log,
    )
    scatter!(states1, sim_probs1, label="Numérico (1)")
    scatter!(states2, sim_probs2, label="Numérico (2)")
    
    ylims!(0, maximum(vcat(sim_probs1, sim_probs2)*1.1))

    xlabel!("N_a")
    ylabel!("Probabilidade")

    savefig("exercicios/ex3/probs.png")
end
main()