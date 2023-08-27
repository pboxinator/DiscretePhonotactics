###################################
## USER PROVIDE FILENAME OF INPUT:#
include("Build.jl")
inputDataFilename::String = "input_Turkish" #Change this string to your filename!
build(inputDataFilename) #Defines variable: inputWords
###################################
# PREPARES FUNCTIONS:##############
sounds = Sounds(Snd)
speaker = Speaker(sounds)
build_functions(sounds=sounds,speaker=speaker)
###################################
# TRAINS SPEAKER:##################
inputWords = shuffle(inputWords) # mix up the order of training words
T = 10000 # training time
for k in 1:T
    map(g3flow_uniform_2!,inputWords);
    map(g2flow_uniform_2!,inputWords);
    map(g1flow_uniform_2!,inputWords);
	#map(g3flow_uniform!,inputWords);
    #map(g2flow_uniform!,inputWords);
    #map(g1flow_uniform!,inputWords);
    end#for_k

# Output largest correlations as check that training was successful:
println(minimum(collect(Iterators.flatten(speaker._g1)))) # flattens _g tensor and gets minimum value
println(minimum(collect(Iterators.flatten(speaker._g2))))
println(minimum(collect(Iterators.flatten(speaker._g3))))
println("DONE!")
#END OF INITIALIZATION AND TRAINING!
###################################
###################################
# USER CODES BELOW (inside main):##
function main()

println(inputWords) # list input words
println(H.(inputWords)) # list input word energies

# CODE HERE ! 
# e.g:
myWord=discritize("g"); println(myWord," energy: ",H(myWord))
myWord=right(myWord); println(myWord," energy: ",H(myWord))
myWord=right(myWord); println(myWord," energy: ",H(myWord))
myWord=right(myWord); println(myWord," energy: ",H(myWord))
myWord=right(myWord); println(myWord," energy: ",H(myWord))
myWord=right(myWord); println(myWord," energy: ",H(myWord))
myWord=right(myWord); println(myWord," energy: ",H(myWord))
myWord=right(myWord); println(myWord," energy: ",H(myWord))

end#main
main();