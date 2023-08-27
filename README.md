## DiscretePhonotactics

# INITIALIZATION:
(1) Download and place files in a chosen directory.

(2) Run Julia. Inside Julia run "include("main.jl")". (Note: You must be in same directory as file.)

Note: File name "main.jl" is provided as a template, which uses "input_Turkish.jl" file by default. In order to change the input language set, change line: 

        inputDataFilename::String = "input_Turkish"

to: 

        inputDataFilename::String = "input_custom"

which requires creating a file "input_custom.jl". 

(Note: Use "input_Turkish.jl" as a template for creating custom input data.)

See examples files!

# Basic/useful Functions:

discritize() : Formats string "bla" into ["b","l","a"]. Use as: discritize("bla")

               For multiple inputs use: discritize.(["bla","hello","world"])

gW(x) : "Grow Word" function. Given conditional word x, finds lowest energy next-sound.

          Use as: gW("bl") --> "bla"

gW(x,y) : Same as above but penalizes list of words y. Useful for finding the next-lowest energy next-sound.

          Use as: gW("bl",["bla","ble"]) --> "blu" 

right(x) : Another name for function as gW(x).

left(x)  : Chops of the final sound in a word, e.g: left("bla") --> "bl"

upN(x,N) : Same as gW(x,y) but where y is taken to be the N-lowest energy next words. Note that upN(x,0)=right(x).

           Use as: UpN("bl",1) --> "ble"  or similarly UpN("bl",2) --> "blu"

# RESOURCE & INITIALIZATION FILES:

(1) Build.jl     : Builds Sounds and Speaker classes. (Note "e0" sets default energy value. Must be positive to use gflow_uniform_2!() functions.)

(2) Sounds.jl    : Defines vector basis for individual sound characters from "input_custom.jl".

(3) Speaker.jl   : Defines speaker object (see accompanying paper) and related functions. 

(4) Functions.jl : Defines additional functions non-specific to training.
