using JLD2
using StatsBase
using FileIO
using ArgParse
using Plots
backend(:plotly)

include("MainFunctions.jl")

function dataCollect(range::Int) #collects data from 0.1 - range/10 for PNC/D and 0.01 - range/100 for PR
    freqs = zeros(range, range, 3)
    for(i) in 1:range #PNC/PND 8
        for(j) in 1:range #PNR 
            vals = (i/(range), j/(20*range)) #easier access
            #coopFreq = runSimNetSave(vals[1], vals[2], 100, 500, 2.0, 0.5, 0.0, 0.001, false, 0.00, 0.05, 0.010, 0.000, 0, networkitCoauthor, networkitCoauthorEvolLink,0.1,exppay,1)
            coopFreq = runSimNetSave(pn=vals[1], pr=vals[2], generations=500, b=2.0, c=0.5, d=0.0, mu=0.001, delta=0.1,payfun=exppay)            
            for(i) in 1:49
                temp = runSimNetSave(pn=vals[1], pr=vals[2], generations=500, b=2.0, c=0.5, d=0.0, mu=0.001, delta=0.1,payfun=exppay)     
                coopFreq=coopFreq.+temp
            end
            coopFreq=coopFreq./50
                #runSimNetSave(;pn::Float64=0.5, pr::Float64=0.1, netsize::Int64=100, generations::Int64=100, b::Float64=1.0, c::Float64=0.5, d::Float64=0.0, mu::Float64=0.01, evollink::Bool=false, mulink::Float64=0.0, sigmapn::Float64=0.05, sigmapr::Float64=0.01,clink::Float64=0.0,retint::Int64=0, funnoevollink::Function=networkitCoauthor, funevollink::Function=networkitCoauthorEvolLink,delta::Float64=1.0,payfun::Function=linpay,netsaveint::Int64=1)
            println(coopFreq[1], " ", round(vals[1]; digits = 3), "-PN, ", round(vals[2]; digits = 3), "-PR")
            freqs[i, j, :] .= coopFreq
        end
    end
    return freqs
end

function hmap(data, range::Int, index::Int) #index 1 is coop frequency
    x_axis = String[]
    y_axis = String[]
    for(i) in 1:range #PNC/PND times 10
        push!(x_axis, (string(round(i/(20*range); digits = 3))))
        push!(y_axis, (string(round(i/(range); digits = 3))))
    end
    p = heatmap(x_axis, y_axis, data[:, :, index]; title = "Cooperation Frequencies",)
    gui(p)
end

#notebook for running below
data = dataCollect(10)
hmap(data, 10, 1)
