## names.jl retrieve and set dimension names
## (c) 2013 David A. van Leeuwen

## This code is licensed under the GNU General Public License, version 2
## See the file LICENSE in this distribution## access to the names of the dimensions

import Base.names

sortnames(dict::Dict) = collect(keys(dict))[sortperm(collect(values(dict)))] 
allnames(a::NamedArray) = [sortnames(dict) for dict in a.dicts]
names(a::NamedArray, d::Int) = sortnames(a.dicts[d])
dimnames(a::NamedArray) = [dn for dn in a.dimnames]
dimnames(a::NamedArray, d::Int) = a.dimnames[d]

## string versions of the above
strnames(dict::Dict) = map(string, sortnames(dict))
strnames(a::NamedArray) = [strnames(d) for d in a.dicts]
strnames(a::NamedArray, d::Int) = strnames(a.dicts[d])
strdimnames(a::NamedArray) = [string(dn) for dn in a.dimnames]
strdimnames(a::NamedArray, d::Int) = string(a.dimnames[d])


## seting names, dimnames
function setnames!(a::NamedArray, v::Vector, d::Int)
    size(a.array,d) == length(v) || error("inconsistent vector length")
    eltype(a.dicts[d])[1] == eltype(v) || error("inconsistent name type")
    ## a.dicts is a tuple, so we need to replace it as a whole...
    vdicts = Dict[]
    for i = 1:length(a.dicts)
        if i==d
            push!(vdicts, Dict(zip(v, 1:length(v))))
        else
            push!(vdicts, a.dicts[i])
        end
    end
    a.dicts = tuple(vdicts...)
end

function setnames!(a::NamedArray, v, d::Int, i::Int)
    @assert 1 <= d <= ndims(a)
    @assert 1 <= i <= size(a, d)
    filter!((k,v) -> v!=i, a.dicts[d]) # remove old name
    a.dicts[d][v] = i
end

function setdimnames!{T,N}(a::NamedArray{T,N}, dn::NTuple{N})
    a.dimnames = dn
end
    
setdimnames!(a::NamedArray, dn::Vector) = setdimnames!(a, tuple(dn...))

function setdimnames!{T,N}(a::NamedArray{T,N}, v, d::Int)
    @assert 1 <= d <= N
    vdimnames = Array(Any, N)
    for i=1:N
        if i==d
            vdimnames[i] = v
        else
            vdimnames[i] = a.dimnames[i]
        end
    end
    a.dimnames = tuple(vdimnames...)
end
