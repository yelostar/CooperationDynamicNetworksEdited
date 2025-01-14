using JLD2
using StatsBase
using FileIO
using ArgParse
using Plots
using DataFrames
using CSV
using Distributed
backend(:plotly)

addprocs(20) 
@everywhere include("MainFunctions.jl")

@everywhere function run_worker(inputs, results)
    include("MainFunctions.jl")
    while true
        pard = take!(inputs)
        println(pard["pn"], " ", pard["pr"], " in pard")
        #coopFreq = runSimsReturn(; B=2.0, C=0.5, D=0.0, CL=0.0, gen=500, pnc=pard["pn"], pnd=pard["pn"], pr=pard["pr"], muP=0.001, reps=100)
        coopFreq = runSimNetSave(pn=pard["pn"], pr=pard["pr"], generations=500, b=2.0, c=0.5, d=0.0, mu=0.001, evollink=true, delta=0.1,payfun=exppay)            
            for(i) in 1:99
                temp = runSimNetSave(pn=pard["pn"], pr=pard["pr"], generations=500, b=2.0, c=0.5, d=0.0, mu=0.001, evollink=true, delta=0.1,payfun=exppay)     
                coopFreq=coopFreq.+temp
            end
            coopFreq=coopFreq./100
        #(coopfreq, meandeg, meanpn, meanpr, meanpay)
        Keys = ["coopFreq","degree","pn_end","pr_end","payoffs"]
        temp = Dict(zip(Keys, coopFreq))
        temp = merge(pard, temp)
        println(temp["pn"], " ", temp["pr"], " CF: ", temp["coopFreq"])
        put!(results, temp)
    end
end

function fill_inputs(range,pars, nruns)
    for(i) in 1:range #PNC/PND 
        for(j) in 1:range #PNR 
            vals = (i/(range), j/(20*range))
            temp = copy(pars)
            temp["pn"] = vals[1]
            temp["pr"] = vals[2]
            println(temp["pn"], " ", temp["pr"], "into inputs")
            nruns+=1
            put!(inputs, temp)
            #vals_arr.push(vals)
        end
    end
    return nruns
end

#notebook for running below
range = 10        
inputs  = RemoteChannel(()->Channel{Dict}(range*range)) #2*nsets*maximum(pars["num_crossings"])
results = RemoteChannel(()->Channel{Dict}(range*range))
        
vals_arr = Array{Tuple}
pars = Dict([
        "pn" => 0.0,
        "pr" => 0.0,
        "pn_end" => 0.0,
        "pr_end" => 0.0,
        "degree" => 0.0,
        "payoffs" => 0.0,
        "coopFreq" => 0.0,
    ])
nruns = fill_inputs(range,pars, 0)

for w in workers() # start tasks on the workers to process requests in parallel
    remote_do(run_worker, w, inputs, results)
end

file = "datacollect_akcay_10.csv"
    cols = push!(sort(collect(keys(pars))),
                 ["pn", "pr"]...)
    dat = DataFrame(Dict([(c, Any[]) for c in cols]))

for sim in 1:nruns
    # get results from parallel jobs
    flush(stdout)
    resd = take!(results)
    # add to table (must convert dict keys to symbols) and save
    push!(dat, Dict([(Symbol(k), resd[k]) for k in keys(resd)]))
    CSV.write(file, dat)
end#hmap(results, 8, "Cooperation Frequencies")

#save("parker-hmap1.jld", "matr", data)
#currentDict = load("akcay-hmap1.jld")
#data2 = currentDict["matr"]
#diff = data[:, :, 8] - data2[:, :, 1]
#hmap(diff, 10, 1)

