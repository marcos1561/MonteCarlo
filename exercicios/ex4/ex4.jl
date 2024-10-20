using Statistics
using Plots

struct Dice 
    faces::Vector{Int}
    num_faces::Int
    name::String
end 
function Dice(faces, name)
    Dice(faces, length(faces), name)
end

function roll(dice)
    return dice.faces[rand(1:dice.num_faces)]
end

function fight(dice1, dice2, num_rounds)
    d1_wins = 0
    for i in 1:num_rounds
        d1, d2 = roll(dice1), roll(dice2)

        if d1 > d2
            d1_wins += 1
        end
    end

    return d1_wins
end

function fight_double(dice1, dice2, num_rounds)
    d1_wins = 0
    for i in 1:num_rounds
        d1 = roll(dice1) + roll(dice1)
        d2 = roll(dice2) + roll(dice2)

        if d1 > d2
            d1_wins += 1
        end
    end

    return d1_wins
end

function find_probabilitys(dices::Vector{Dice}, fight_func, num_rounds, num_sims)
    probs = Dict{String, Any}()
    
    for i in 1:length(dices)
        d1 = dices[i]
        dice_probs = Dict{String, NamedTuple}()
        for j in 1:length(dices)
            if j == i
                continue
            end

            d2 = dices[j]

            num_wins = Vector{Int}(undef, num_sims)
            for sim_i in 1:num_sims
                num_wins[sim_i] = fight_func(d1, d2, num_rounds)
            end

            prob_win = num_wins ./ num_rounds

            prob_mean = mean(prob_win)
            prob_std = std(prob_win)

            dice_probs[d2.name] = (mean=prob_mean, std=prob_std)
        end
        probs[d1.name] = dice_probs
    end

    return probs
end

function part_a()
    num_rounds = 10000
    num_sims = 100

    green_wins = Vector{Int}(undef, num_sims)
    for sim_i in 1:num_sims
        green_wins[sim_i] = fight(green, red, num_rounds)
    end

    percentage_win = green_wins ./ num_rounds

    win_mean = round(mean(percentage_win), digits=3)
    win_std = round(std(percentage_win), digits=3)

    println("Simulação: $(win_mean) ± $(win_std)")
    println("Analítico: $(round(7/12, digits=4))")
end

function plot_dice_probs(x_pos, dice_probs)
    names = keys(dice_probs)

    color = collect(names)
    height = [dice_probs[name].mean for name in names]
    yerr = [dice_probs[name].std for name in names]

    bar!(x_pos, height, yerr=yerr, color=color, label=:none)
end

function plot_all_dice_probs(fight_func, num_rounds, num_sims, title)
    probs = find_probabilitys([green, red, blue], fight_func, num_rounds, num_sims)

    bar(xticks=((1.5, 4.5, 7.5, 10.5), ("Green", "Red", "Blue", "Gray")))

    title!(title)
    ylabel!("Prob. de Ganhar")
    
    plot_dice_probs([1, 2], probs["green"])
    plot_dice_probs([4, 5], probs["red"])
    plot_dice_probs([7, 8], probs["blue"])
    plot!([0, 9], [0.5, 0.5], color="black", linestyle=:dash, label="y=0.5")
end

blue = Dice([3, 6, 3, 3, 3, 3], "blue")
green = Dice([2, 2, 2, 5, 5, 5], "green")
red = Dice([4, 1, 4, 4, 4, 4], "red")

part_a()

plot_all_dice_probs(fight, 10000, 100, "Um lance")
# savefig("exercicios/ex4/lance_unico.png")

plot_all_dice_probs(fight_double, 10000, 100, "Dois lances")
# savefig("exercicios/ex4/lance_duplo.png")