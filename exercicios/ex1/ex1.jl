using Plots

using MonteCarlo.Ehrenfest

function part_b()
    num_steps = 500
    no = 100

    sample1 = simulate(no, num_steps)
    sample2 = simulate(no, num_steps)

    exact = analytical(1:length(sample1), no)
    
    plot(exact, label="Analítico", color="black")
    
    plot!([sample1 sample2],
        label="Numérico",
        title="N=100",
        xlabel="t",
        ylabel="N_a",
    )

end

function avg_sample(no, num_steps, num_sims)
    sample = zeros(Float64, num_steps+1)
    for i in 1:num_sims
        sample .+= simulate(no, num_steps)
    end
    sample ./= num_sims
    
    return sample
end

function part_c()
    num_sims = 10
    num_steps = 1000

    no_range = [100, 500, 1000]
    # no_range = 100:100:1000

    samples = []
    for no in no_range
        push!(samples, avg_sample(no, num_steps, num_sims) / no)
    end

    p = plot(
        xlabel="t",
        ylabel="<N_a>/N_0",
    )
    for i in eachindex(no_range)
        sample = samples[i]
        no = no_range[i]
        label_text = "N=$(no)"

        plot!(sample,
            label=label_text,
        ) 
    end
    display(p)
end

function part_d()
    n = 10000
    sample = simulate(n, n*4)
    exact = analytical(1:length(sample), n)

    plot([sample exact],
        label=["Simulação" "Analítico"],
        title="N=$(n)",
        xlabel="t",
        ylabel="N_a",
    ) 
end

part_b()
savefig("exercicios/ex1/part_b.png")

# part_c()
# savefig("exercicios/ex1/part_c.png")

# part_d()
# savefig("exercicios/ex1/part_d.png")