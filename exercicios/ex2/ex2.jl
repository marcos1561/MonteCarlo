using Plots, Statistics
using MonteCarlo.Ehrenfest

function main()
    num_points = 100
    num_sims = 10
    n_range = 1:10
    
    times_arr = []
    avg_time = Vector{Float64}(undef, length(n_range))
    std_time = Vector{Float64}(undef, length(n_range))
    for (idx, n) in enumerate(n_range)
        times = time_back(n, num_points, num_sims)
        push!(times_arr, times)
        avg_time[idx] = mean(times)
        std_time[idx] = std(times)
    end

    scatter(avg_time,
        yaxis=:log,
        yerr=std_time,
        label="Numérico",
        xlabel="N",
        ylabel="<T_a>"
    )
    
    ns = LinRange(minimum(n_range), maximum(n_range), 100)
    plot!(ns, time_back_analytical(ns),
        label="Analítico",
        color="red",
    )

    # histogram(times_arr[end-1],
    #     xlabel="t",
    #     ylabel="Frequência"    
    # )

    savefig("exercicios/ex2/avg_time.png")
end
main()
