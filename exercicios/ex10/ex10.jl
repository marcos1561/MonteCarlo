using Plots

#
# Walker Stuff
#

@kwdef mutable struct Walker
    x::Float64
    y::Float64
    max_step::Float64
end

@kwdef struct SpaceCfg
    width::Float64
    height::Float64
end

function get_new_pos(walker::Walker)
    size = rand(Float64) * walker.max_step
    angle = rand(Float64) * 2 * π

    dx = size * cos(angle)
    dy = size * sin(angle)

    return (walker.x + dx, walker.y + dy)
end

function is_outside(pos, space_cfg::SpaceCfg)
    out_x = abs((pos[1] - space_cfg.width/2)) > space_cfg.width/2
    out_y = abs((pos[2] - space_cfg.height/2)) > space_cfg.height/2

    return out_x || out_y
end

function ignore_step(walker, space_cfg)
    new_pos = get_new_pos(walker)
    count_step = !is_outside(new_pos, space_cfg)
    return count_step, new_pos
end

function accept_step(walker, space_cfg)
    new_pos = get_new_pos(walker)

    if is_outside(new_pos, space_cfg)
        new_pos = (walker.x, walker.y)
    end
    return true, new_pos
end

#
# Shape Stuff
#

struct Circle 
    center::Tuple{Float64, Float64}
    radius::Float64
end

function is_inside_shape(pos, shape::Circle)
    dist_sqr = (pos[1] - shape.center[1])^2 + (pos[2] - shape.center[2])^2
    return dist_sqr < shape.radius^2
end


function random_walk!(walker::Walker, space_cfg::SpaceCfg, step_func, shape; num_steps)
    history = (
        x=Vector{Float64}(undef, num_steps),
        y=Vector{Float64}(undef, num_steps),
        num_points_inside=Vector{Int}(undef, num_steps),
    )

    new_pos = (0.0, 0.0)
    num_inside = 0
    for i in 1:num_steps
        accept_step = false
        while !accept_step
            accept_step, new_pos = step_func(walker, space_cfg)
        end
        
        if is_inside_shape(new_pos, shape)
            num_inside += 1
        end
        
        walker.x = new_pos[1]
        walker.y = new_pos[2]

        history.x[i] = walker.x
        history.y[i] = walker.y
        history.num_points_inside[i] = num_inside
    end

    return history
end

function main()
    num_steps = 100000
    
    walker = Walker(
        x=0.5, y=0.5,
        max_step=0.3,
    )

    space_cfg = SpaceCfg(
        width=1,
        height=1,
    )

    shape = Circle((0, 0), 1)

    history_ignore = random_walk!(walker, space_cfg, ignore_step, shape, num_steps=num_steps)
    history_accept = random_walk!(walker, space_cfg, accept_step, shape, num_steps=num_steps)

    function plot_data(p, history, init_cut, name)
        n_list = Vector(1:length(history.num_points_inside))
        pi_est = (history.num_points_inside ./ n_list) .* 4
        plot!(p, n_list[init_cut:end], pi_est[init_cut:end], label=name)
    end
    
    init_cut = 1000

    p = plot(xlabel="N", ylabel="n/N")
    plot_data(p, history_ignore, init_cut, "Ignorar")
    plot_data(p, history_accept, init_cut, "Aceitar")
    plot!(p, [init_cut, num_steps], [π, π], c=:black, label="π")

    # plot(xlim=(0, 1), ylim=(0, 1))
    # @gif for i in 1:length(history.x)
    #     scatter([history.x[i]], [history.y[i]], 
    #         xlim=(0, 1), ylim=(0, 1),
    #     )
    # end fps=3
end
main()