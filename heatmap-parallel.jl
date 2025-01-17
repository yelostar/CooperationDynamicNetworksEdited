using JLD2
using StatsBase
using FileIO
using ArgParse
using Plots
backend(:plotly)
using DataFrames
using CSV
using Distributed


function dataRead(data, range, index::Int)
    df = CSV.read(data, DataFrame, delim=",")
    df = df[!, [4, 6, 1, 2, 5, 7, 3]]
    sort!(df, [:pn, :pr])
    print(df)
    dfData = Matrix{Float64}(df)
    dataArr = zeros(range, range, 1) #transforms [range^2 * 10] arr to [range, range, 1] arr
    for(i) in 1:range
        for(j) in 1:range
            dataArr[i, j, 1] = dfData[range*(i-1)+j, index]
        end
    end
    dataArr
end

function hmap(data, range::Int, index::Int, titles) 
    #indexes: pn       pr       coopFreq   degree    pnc_end    pnd_end    pr_end     distance  inclusion  assortment 
    dataArr = dataRead(data, range, index)
    x_axis = String[]
    y_axis = String[]
    for(i) in 1:range #PNC/PND times 10
        push!(x_axis, (string(round((0.05*i/range); digits = 4))))
        push!(y_axis, (string(round((1*i/range); digits = 3))))
    end
    p = heatmap(x_axis, y_axis, dataArr[:, :, 1]; title = titles,)
    gui(p)
end

hmap("datacollect_akcay_10.csv", 10, 3, "Cooperation Frequencie0s")
df = CSV.read("datacollect_akcay_10.csv", DataFrame, delim=",")
