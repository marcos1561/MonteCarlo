using MonteCarlo.AreaEstimator

function main()
    x_lims = [0, 1]
    y_lims = [0, 1]
    num_points = 3000
    func(x) = sin(1/x)^2
    
    areas = estimate_area_hist(x_lims, y_lims, func, num_points)

    plot(1:num_points, areas, label="Numérico")
    plot!([1, num_points], [0.67345, 0.67345], label="Wolfram")
    xlabel!("N")

    savefig("exercicios/ex9/area.png")
end
main()