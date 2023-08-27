using LinearAlgebra, Random

mutable struct Sounds
    Snd::Array{String} # list of sound characters in ipa
    SndK::Dict{String,Int64} # Key from string-to-index, e.g "y"=>5 where Snd[5]=="y"
    D::Int # Local dimension (i.e the total number of ipa sounds)
    
    function Sounds(Snd)
    #=Constructor inputs string list (w/o null "O") and initializes Sounds object w/ a key.=#
        # Sound key:
        SndK=Dict(Snd[1]=>1)
        for k in 2:length(Snd)
            merge!(SndK,Dict(Snd[k]=>k))
            end#for        
        return new(Snd,SndK,length(Snd))
        end#function
    
    ## Error constructors imply only Sounds(Array{String}) is accepted:
    function Sounds(Snd,SndK) error("Sounds accepts only one parameter Sounds(Array{String}) holding sounds characters in ipa.") end
    function Sounds(Snd,SndK,D) error("Sounds accepts only one parameter Sounds(Array{String}) holding sounds characters in ipa.") end
    end#struct

### Methods:

function SndV(sounds::Sounds,k::Integer)
#= Returns a unit vector representation of the sound Snd[k] given k::Int.=#
    D = sounds.D; I = one(ones(D,D)) # DxD identity
    return I[k,:]'
    end
function SndV(sounds::Sounds,s::String)
#= Returns a unit vector representation of the sound Snd[k] given its string literal, which is reverse-searched via the SndK.
    Note that inuputing the null sound character "O" produces a null vector.=#
    D = sounds.D; I = one(ones(D,D)) # DxD identity
    SndK = sounds.SndK
    if s=="O" return 0*I[1,:]' end # null vector
    return I[SndK[s],:]'
    end
### Additional methods:
function SndV(k::Integer;sounds::Sounds=sounds)
#= Returns a unit vector representation of the sound Snd[k] given k::Int.=#
    D = sounds.D; I = one(ones(D,D)) # DxD identity
    return I[k,:]'
    end
function SndV(s::String;sounds::Sounds=sounds)
#= Returns a unit vector representation of the sound Snd[k] given its string literal, which is reverse-searched via the SndK.
    Note that inuputing the null sound character "O" produces a null vector.=#
    D = sounds.D; I = one(ones(D,D)) # DxD identity
    SndK = sounds.SndK
    if s=="O" return 0*I[1,:]' end # null vector
    return I[SndK[s],:]'
    end




