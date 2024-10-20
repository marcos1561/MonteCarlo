module MonteCarlo

export Ehrenfest

module Ehrenfest
    using Statistics
    
    export simulate, analytical 
    export time_back, time_back_analytical  
    export stationary_states_freq

    mutable struct Urn
        n::Int
        no::Int
    end
    function Urn(no)
        return Urn(no, no)
    end

    function step!(urn::Urn)
        if rand() < urn.n/urn.no 
            urn.n -= 1
        else
            urn.n += 1
        end
    end

    function simulate(no, num_steps)
        urn = Urn(no)

        history = Vector{Int}(undef, num_steps + 1)
        history[1] = no
        for i in 2:(num_steps+1)
            step!(urn)
            history[i] = urn.n
        end

        return history
    end

    function analytical(t, n)
        return @. n/2 + n/2 * (1- 2/n)^t
    end

    function time_back(no, num_points, num_sims)
        mean_time = Vector{Float64}(undef, num_sims)
        for sim_i in 1:num_sims
            times = Vector{Float64}(undef, num_points)
            for ti in 1:num_points
                urn = Urn(no)
                step!(urn)
                time_back = 1
                while urn.n != urn.no
                    step!(urn)
                    time_back += 1
                end

                times[ti] = time_back
            end
            mean_time[sim_i] = mean(times)
        end

        return mean_time
    end

    function time_back_analytical(n)
        return @. 2^n
    end

    function stationary_states_freq(no, transient_steps, collet_steps)
        urn = Urn(no)

        for _ in 1:transient_steps
            step!(urn)
        end

        states_freq = zeros(Int, no+1)
        states_freq = Dict{Int, Int}(i => 0 for i in 0:no)
        
        for _ in 1:collet_steps
            for _ in 1:rand(1000:1100)
                step!(urn)
            end

            states_freq[urn.n] += 1
        end

        return states_freq
    end
end

module AreaEstimator

export estimate_area, estimate_area_hist

function estimate_area(x_lims, y_lims, func, num_points)
    xs = rand(Float64, num_points) .* (x_lims[2] - x_lims[1]) .+ x_lims[1]
    ys = rand(Float64, num_points) .* (y_lims[2] - y_lims[1]) .+ y_lims[1]

    num_inside = 0
    for i in 1:num_points
        if func(xs[i]) > ys[i]
            num_inside += 1
        end
    end

    area_t = (x_lims[2] - x_lims[1]) * (y_lims[2] - y_lims[1])
    curve_area = area_t * num_inside / num_points
    return curve_area
end

function estimate_area_hist(x_lims, y_lims, func, num_points)
    xs = rand(Float64, num_points) .* (x_lims[2] - x_lims[1]) .+ x_lims[1]
    ys = rand(Float64, num_points) .* (y_lims[2] - y_lims[1]) .+ y_lims[1]

    curve_area = Vector{Float64}(undef, num_points)
    area_t = (x_lims[2] - x_lims[1]) * (y_lims[2] - y_lims[1])
    
    num_inside = 0
    for i in 1:num_points
        if func(xs[i]) > ys[i]
            num_inside += 1
        end
        
        curve_area[i] = area_t * num_inside / i
    end

    return curve_area
end

end

# Write your package code here.

end
