# Required function definition:
function discritize(x)
	tword = []
	for z in x push!(tword,z); end#for
	return string.(tword); end#fn
##################################################
##################################################
# Builds the code, including additional functions: 
global e0 = 1000 # Arbitrary shift in energy (needed for g_flow_uniform2!() to function properly)

include("Sounds.jl")
include("Speaker.jl")
function build(inputDataFilename::String)
	include(inputDataFilename*".jl")
end

function build_functions(;sounds::Sounds,speaker::Speaker)
	include("Functions.jl")
end