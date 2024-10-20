using Plots, Statistics
using MonteCarlo.AreaEstimator

function explore_n(n_range, num_sims, x_lims, y_lims, func, to_pi)
    pi_mean = Vector{Float64}(undef, length(n_range))
    pi_std = Vector{Float64}(undef, length(n_range))
    for (idx, n) in enumerate(n_range)
        areas = Vector{Float64}(undef, num_sims)
        for sim_i in 1:num_sims
            areas[sim_i] = estimate_area(x_lims, y_lims, func, n)
        end
        pi_est = to_pi(areas)
        pi_mean[idx] = mean(pi_est)
        pi_std[idx] = std(pi_est)
    end

    return pi_mean, pi_std
end


function buffon(num_points)
    func(x) = sin(x)
    x_lims = [0, π]
    y_lims = [0, 1]

    to_pi(x) = x .* π/2

    # pi_mean, pi_std = explore_n(n_range, num_sims, x_lims, y_lims, func, to_pi)
    # data = (mean=pi_mean, std=pi_std)
    # return data    
    
    area = estimate_area_hist(x_lims, y_lims, func, num_points)
    return to_pi.(area)
end

function circle(num_points)
    func(x) = (1 - x^2)^(0.5)
    x_lims = [0, 1]
    y_lims = [0, 1]

    to_pi(x) = x .* 4
    
    # pi_mean, pi_std = explore_n(n_range, num_sims, x_lims, y_lims, func, to_pi)
    # data = (mean=pi_mean, std=pi_std)
    # return data
    
    area = estimate_area_hist(x_lims, y_lims, func, num_points)
    return to_pi.(area)
end

function error_plot(buffon_data, circle_data)
    plot((buffon_data .- π).^2,
        xaxis=:log, yaxis=:log, label="buffon",
    )
    plot!((circle_data .- π).^2,
        xaxis=:log, yaxis=:log, label="circle",
    )

    ylabel!("Erro")
    xlabel!("N")
end

function pi_estimate_plot(init_cut, buffon_data, circle_data)
    num_points = length(buffon_data)
    n_range = init_cut:num_points

    plot(n_range, buffon_data[init_cut:end], label="buffon")
    plot!(n_range, circle_data[init_cut:end], label="circle")
    plot!([n_range[1], n_range[end]], [π, π], label="π", color="black")
    
    xlabel!("N")
    ylabel!("Estimativa de π")
end

function main()
    num_points = 10000

    buffon_data = buffon(num_points)
    circle_data = circle(num_points)

    pi_estimate_plot(100, buffon_data, circle_data)
    # savefig("exercicios/ex7-8/estimativa.png")
    
    error_plot(buffon_data, circle_data)
    # savefig("exercicios/ex7-8/erro.png")
end
main()