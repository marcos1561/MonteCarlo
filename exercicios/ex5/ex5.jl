using Plots, Statistics

struct FileData
    x::Vector{Float64}
    y::Vector{Float64}
    name::String
end

function load_data(filename)
    x_list = []
    y_list = []
    for line in readlines("exercicios/ex5/datasaurusdozen/$(filename).dat")
        x, y = [parse(Float64, i) for i in split(line, " ")]
        push!(x_list, x)
        push!(y_list, y)
    end
    
    return FileData(x_list, y_list, filename)
end

function main()
    filenames = ["datasaurusdozen01", "datasaurusdozen05", "datasaurusdozen06"]

    datas = [load_data(name) for name in filenames]

    for data in datas
        x_mean = trunc(Int, round(mean(data.x)))
        y_mean = trunc(Int, round(mean(data.y)))
        
        x_std = trunc(Int, round(std(data.x)))
        y_std = trunc(Int, round(std(data.y)))

        println("Data: $(data.name)")
        println("x = $(x_mean) ± $(x_std)")
        println("y = $(y_mean) ± $(y_std)")
        println()
    end
end
main()