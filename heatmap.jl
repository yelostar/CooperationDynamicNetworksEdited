using JLD2
using StatsBase
using FileIO
using ArgParse
using Plots
backend(:plotly)

include("MainFunctions.jl")
#sunsetcolors = cgrad([RGB{Float64}(0., 0., 0.), RGB{Float64}( 0.02236758, 0.008148, 0.030390180000000006), RGB{Float64}( 0.04473516, 0.016296, 0.06078036000000001), RGB{Float64}( 0.06710274, 0.024444, 0.09117054000000001), RGB{Float64}( 0.08947032, 0.032592, 0.12156072000000002), RGB{Float64}( 0.1118379, 0.040740000000000005, 0.15195090000000003), RGB{Float64}( 0.13420548, 0.048888, 0.18234108000000002), RGB{Float64}( 0.15657306000000001, 0.05703600000000001,   0.21273126000000006), RGB{Float64}( 0.17894064, 0.065184, 0.24312144000000005), RGB{Float64}( 0.20130821999999998, 0.07333200000000001, 0.27351162), RGB{Float64}( 0.2236758, 0.08148000000000001, 0.30390180000000006), RGB{Float64}( 0.24604338, 0.08962800000000001, 0.33429198000000004), RGB{Float64}( 0.26841096, 0.097776, 0.36468216000000003), RGB{Float64}( 0.29077854000000003, 0.10592400000000002,   0.3950723400000001), RGB{Float64}( 0.31314612000000003, 0.11407200000000002,   0.4254625200000001), RGB{Float64}( 0.33551369999999997, 0.12222000000000001,   0.45585270000000006), RGB{Float64}( 0.35788128, 0.130368, 0.4862428800000001), RGB{Float64}( 0.38110288000000003, 0.13828032, 0.5017885), RGB{Float64}( 0.40603252, 0.14572128, 0.48764500000000005), RGB{Float64}( 0.43096216000000004, 0.15316224, 0.4735015), RGB{Float64}( 0.45589180000000007, 0.16060320000000003, 0.459358), RGB{Float64}( 0.48082144, 0.16804416, 0.4452145), RGB{Float64}( 0.50575108, 0.17548512, 0.431071), RGB{Float64}( 0.5306807200000001, 0.18292608000000002, 0.4169275), RGB{Float64}( 0.55561036, 0.19036704, 0.40278400000000003), RGB{Float64}( 0.5805400000000001, 0.197808, 0.3886405), RGB{Float64}( 0.60546964, 0.20524896000000004, 0.37449699999999997), RGB{Float64}( 0.63039928, 0.21268992000000003, 0.3603535), RGB{Float64}( 0.6553289200000001, 0.22013088000000003,   0.34620999999999996), RGB{Float64}( 0.68025856, 0.22757184, 0.33206650000000004), RGB{Float64}( 0.7051882, 0.2350128, 0.317923), RGB{Float64}( 0.73011784, 0.24245376000000002, 0.3037795), RGB{Float64}( 0.75504748, 0.24989472000000001, 0.289636), RGB{Float64}( 0.7799771200000001, 0.25733568, 0.2754925), RGB{Float64}( 0.7959306, 0.26748204000000003, 0.26199219599999996), RGB{Float64}( 0.807396, 0.27898110000000004, 0.24881348999999994), RGB{Float64}( 0.8188614, 0.29048016, 0.235634784), RGB{Float64}( 0.8303268, 0.30197922, 0.222456078), RGB{Float64}( 0.8417922, 0.31347828, 0.209277372), RGB{Float64}( 0.8532576000000001, 0.32497734, 0.19609866599999998), RGB{Float64}( 0.864723, 0.3364764, 0.18291995999999996), RGB{Float64}( 0.8761884000000001, 0.34797546, 0.16974125399999995), RGB{Float64}( 0.8876538, 0.35947451999999996, 0.15656254800000002), RGB{Float64}( 0.8991192, 0.37097358, 0.143383842), RGB{Float64}( 0.9105846, 0.38247264000000003, 0.130205136), RGB{Float64}( 0.92205, 0.39397170000000004, 0.11702642999999999), RGB{Float64}( 0.9335154000000001, 0.40547076000000004,   0.10384772399999997), RGB{Float64}( 0.9449808000000001, 0.41696982000000005,   0.09066901799999996), RGB{Float64}( 0.9564462, 0.42846887999999994, 0.077490312), RGB{Float64}( 0.9679116, 0.43996793999999995, 0.064311606), RGB{Float64}( 0.979377, 0.451467, 0.0511329), RGB{Float64}( 0.98061438, 0.46534026, 0.055851186000000004), RGB{Float64}( 0.9818517600000001, 0.47921352000000006,   0.06056947200000001), RGB{Float64}( 0.98308914, 0.49308678000000006, 0.06528775800000002), RGB{Float64}( 0.9843265200000001, 0.5069600400000001,   0.07000604400000002), RGB{Float64}( 0.9855639, 0.5208333, 0.07472433000000003), RGB{Float64}( 0.98680128, 0.53470656, 0.07944261600000002), RGB{Float64}( 0.9880386600000001, 0.54857982, 0.08416090200000004), RGB{Float64}( 0.98927604, 0.5624530799999999, 0.08887918799999998), RGB{Float64}( 0.99051342, 0.5763263399999999, 0.09359747399999999), RGB{Float64}( 0.9917508, 0.5901996, 0.09831576), RGB{Float64}( 0.99298818, 0.60407286, 0.10303404599999999), RGB{Float64}( 0.9942255600000001, 0.61794612, 0.107752332), RGB{Float64}( 0.99546294, 0.63181938, 0.11247061800000001), RGB{Float64}( 0.99670032, 0.64569264, 0.11718890400000001), RGB{Float64}( 0.9979377, 0.6595659, 0.12190719000000003), RGB{Float64}( 0.99917508, 0.67343916, 0.12662547600000001), RGB{Float64}( 1., 0.6866789600000001, 0.13699746000000015), RGB{Float64}( 1., 0.69865184, 0.15867684000000015), RGB{Float64}( 1., 0.7106247200000001, 0.18035622000000018), RGB{Float64}( 1., 0.7225976000000001, 0.20203560000000018), RGB{Float64}( 1., 0.7345704799999999, 0.22371497999999995), RGB{Float64}( 1., 0.74654336, 0.24539435999999995), RGB{Float64}( 1., 0.75851624, 0.26707373999999995), RGB{Float64}( 1., 0.77048912, 0.28875312), RGB{Float64}( 1., 0.782462, 0.3104325), RGB{Float64}( 1., 0.7944348800000001, 0.33211187999999997), RGB{Float64}( 1., 0.80640776, 0.35379125999999994), RGB{Float64}( 1., 0.81838064, 0.37547063999999997), RGB{Float64}( 1., 0.8303535200000001, 0.39715002), RGB{Float64}( 1., 0.8423264, 0.4188294), RGB{Float64}( 1., 0.85429928, 0.44050878000000004), RGB{Float64}( 1., 0.8662721600000001, 0.46218815999999996), RGB{Float64}( 1., 0.8782450400000001, 0.48386754), RGB{Float64}( 1., 0.8869465599999999, 0.5114502399999997), RGB{Float64}( 1., 0.8940123999999999, 0.5419845999999998), RGB{Float64}( 1., 0.90107824, 0.5725189599999998), RGB{Float64}( 1., 0.90814408, 0.6030533199999999), RGB{Float64}( 1., 0.91520992, 0.63358768), RGB{Float64}( 1., 0.92227576, 0.66412204), RGB{Float64}( 1., 0.9293416, 0.6946564000000001), RGB{Float64}( 1., 0.93640744, 0.72519076), RGB{Float64}( 1., 0.94347328, 0.7557251200000001), RGB{Float64}( 1., 0.9505391200000001, 0.7862594800000001), RGB{Float64}( 1., 0.9576049600000001, 0.8167938400000001), RGB{Float64}( 1., 0.9646708, 0.8473282000000002), RGB{Float64}( 1., 0.9717366399999999, 0.8778625599999998), RGB{Float64}( 1., 0.9788024799999999, 0.9083969199999999), RGB{Float64}( 1., 0.98586832, 0.93893128), RGB{Float64}( 1., 0.99293416, 0.9694656400000001), RGB{Float64}(1., 1., 1.)])


function dataCollect(range::Int) #collects data from 0.1 - range/10 for PNC/D and 0.01 - range/100 for PR
    freqs = zeros(range, range, 3)
    for(i) in 1:range #PNC/PND 8
        for(j) in 1:range #PNR 
            vals = (i/(range), j/(20*range)) #easier access
            coopFreq = runSimNetSave(vals[1], vals[2], 100, 500, 2.0, 0.5, 0.0, 0.001, false, 0.00, 0.05, 0.010, 0.000, 0, networkitCoauthor, networkitCoauthorEvolLink,0.1,exppay,1)
            for(i) in 1:49
                temp = runSimNetSave(vals[1], vals[2], 100, 500, 2.0, 0.5, 0.0, 0.001, false, 0.00, 0.05, 0.010, 0.000, 0, networkitCoauthor, networkitCoauthorEvolLink,0.1,exppay,1)
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
