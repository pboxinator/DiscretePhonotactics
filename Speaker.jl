using LinearAlgebra, Random

function g0(D;e0::Int=e0)
#= Returns a DxD matrix with all entries 1*e0.
Changing e0 means changing the default global starting interaction energy for pre-trained _g's.=#
    #e0 = 1000 # initial energy scale (default)
    return ones(D,D)*e0
    end
function ranD(D)
# Returns random int between 1 and D
    return rand([k for k::Int32 in 1:D])
    end
function pnm(n,m,D)
    I = one(ones(D,D))
    I[n,:]*transpose(I[m,:])
    end
function δg(D=sounds.D)
# Returns random δg:
    return pnm(ranD(D),ranD(D),D)
    end

mutable struct Speaker
    _g1::Array{Float64,2}
    _g2::Array{Float64,2}
    _g3::Array{Float64,2}
    function Speaker(x::Sounds)
        D = x.D; return new(g0(D),g0(D),g0(D))
        end#function
    end#struct

function prepWordString(iWord,range=3)
# Needed to guarantee that the input to H(n::Array{String,1}) has a length equal to the farthest interaction range (e.g range=3 for _g3).
# Default N value is set by length of interaction range or length(iWord) -- whichever is largest.
    N = max(length(iWord),range+1)
    Word = Array{String,1}(undef,N); # Declare N-size Word and fill initial boundary sounds followed by "O"s
    [Word[k]=iWord[k] for k in 1:length(iWord)];
    [Word[k]="O" for k in length(iWord)+1:N];
    return Word
    end#function

function H(n;speaker::Speaker=speaker) # Input word "n" is a list of unit vectors. (Note that "n" means the same as "word" used elsewhere in code.)
# n = set of {nj for j=1,...} "List of local state vectors"--> total configuration of the input word
# Warning: Breaks if "n" is smaller than the interaction range (e.g if length(n)-3<1) => H(n::Array{String,1}) fixes this!
    _g1,_g2,_g3 = speaker._g1,speaker._g2,speaker._g3
    #E_onsite = sum([dot(n[j],_u[j]) for j in 1:length(n)])
    E_g1 = sum([dot(n[j],_g1,n[j+1]') for j in 1:length(n)-1])
    E_g2 = sum([dot(n[j],_g2,n[j+2]') for j in 1:length(n)-2])
    E_g3 = sum([dot(n[j],_g3,n[j+3]') for j in 1:length(n)-3])
    return E_g1 + E_g2 + E_g3 #+ E_onsite
    end

function H(n::Array{String,1};sounds::Sounds=sounds,speaker::Speaker=speaker) # Input word "n" is a list of strings.
# Reformats string list into unit vectors and passes to H(n::Array{Array}) -- see above.
    return H([SndV(sounds,s) for s in prepWordString(n)];speaker=speaker)
    end

function g1flow_uniform!(word::Array{String};x::Speaker=speaker)
    x = speaker
    Ei = H(word)
    Δg = δg()
    g_matrix_temp = deepcopy(x._g1)
    x._g1 = x._g1 - Δg
    Ef = H(word) # Energy post-modification
    if Ef-Ei>=0
        x._g1 = g_matrix_temp # Undo modification if doesn't lower the energy
        end#if
    end#function

function g2flow_uniform!(word::Array{String};x::Speaker=speaker)
    x = speaker
    Ei = H(word)
    Δg = δg()
    g_matrix_temp = deepcopy(x._g2)
    x._g2 = x._g2 - Δg
    Ef = H(word) # Energy post-modification
    if Ef-Ei>=0
        x._g2 = g_matrix_temp # Undo modification if doesn't lower the energy
        end#if
    end#function

function g3flow_uniform!(word::Array{String};x::Speaker=speaker)
    x = speaker
    Ei = H(word)
    Δg = δg()
    g_matrix_temp = deepcopy(x._g3)
    x._g3 = x._g3 - Δg
    Ef = H(word) # Energy post-modification
    if Ef-Ei>=0
        x._g3 = g_matrix_temp # Undo modification if doesn't lower the energy
        end#if
    end#function

function g1flow_uniform_2!(word::Array{String};x::Speaker=speaker,e0::Int=e0)
    x = speaker
    Ei = H(word)
    Δg = δg()
    g_matrix_temp = deepcopy(x._g1)
    gvalue = maximum(Iterators.flatten(x._g1.*Δg))-1
    x._g1 = x._g1 - (gvalue^2/e0)*Δg
    Ef = H(word) # Energy post-modification
    if Ef-Ei>=0
        x._g1 = g_matrix_temp # Undo modification if doesn't lower the energy
        end#if
    end#function

function g2flow_uniform_2!(word::Array{String};x::Speaker=speaker,e0::Int=e0)
    x = speaker
    Ei = H(word)
    Δg = δg()
    g_matrix_temp = deepcopy(x._g2)
    gvalue = maximum(Iterators.flatten(x._g2.*Δg))-1
    x._g2 = x._g2 - (gvalue^2/e0)*Δg
    Ef = H(word) # Energy post-modification
    if Ef-Ei>=0
        x._g2 = g_matrix_temp # Undo modification if doesn't lower the energy
        end#if
    end#function

function g3flow_uniform_2!(word::Array{String};x::Speaker=speaker,e0::Int=e0)
    x = speaker
    Ei = H(word)
    Δg = δg()
    g_matrix_temp = deepcopy(x._g3)
    gvalue = maximum(Iterators.flatten(x._g3.*Δg))-1
    x._g3 = x._g3 - (gvalue^2/e0)*Δg
    Ef = H(word) # Energy post-modification
    if Ef-Ei>=0
        x._g3 = g_matrix_temp # Undo modification if doesn't lower the energy
        end#if
    end#function



