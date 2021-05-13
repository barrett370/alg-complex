using Combinatorics

function (\)(A::Array, S::Array)
    filter(each -> each ∉ S, A)
end

function almost_tsp(C::Array{String}, dist::Function)
    n = C |> length
    OPT = Dict{Tuple{Array{String},String},Real}()
    for i = 2:n
        OPT[([C[i]], C[i])] = dist(C[1], C[i])
    end
    subsets = C[2:n] |> powerset |> collect
    for k = 2:n-3
        for S ∈ filter(i -> i |> length == k, subsets)
            for ci in S
                OPT[(S, ci)] =
                    minimum(map(cj -> OPT[(S \ [ci], cj)] + dist(cj, ci), S \ [ci]))
            end
        end
    end

    n2 = filter(i -> i |> length == n-3, subsets)
    res = map(r -> OPT[(r, r[1])] + dist(r[1], C[1]),n2)
    return minimum(res)
end

function almost_tsp_2(C::Array{String},dist)
    n = C |> length
    subsets = C[2:n] |> powerset |> collect
    filter!(x -> x|> length == n -3,subsets)
    res = []
    for s in subsets 
        append!(res, tsp(C\s,dist))
    end
    minimum(res)

end


function tsp(C::Array{String}, dist::Function)
    n = C |> length
    OPT = Dict{Tuple{Array{String},String},Real}()
    for i = 2:n
        OPT[([C[i]], C[i])] = dist(C[1], C[i])
    end
    subsets = C[2:n] |> powerset |> collect
    for k = 2:n
        for S ∈ filter(i -> i |> length == k, subsets)
            for ci in S
                OPT[(S, ci)] =
                    minimum(map(cj -> OPT[(S \ [ci], cj)] + dist(cj, ci), S \ [ci]))
            end
        end
    end
    res = map(i -> OPT[(C[2:n],C[i])] + dist(C[i],C[1]),2:n)
    return minimum(res)
end

known_dist = Dict(
    ("c1", "c2") => 20,
    ("c2", "c3") => 5,
    ("c1", "c4") => 17,
    ("c1", "c3") => 60,
    ("c2", "c4") => 15,
    ("c3", "c4") => 8,
)

new_dist = Dict(
                ("c1","c2") => 5,
                ("c1","c5") => 8,
                ("c1","c3") => 30,
                ("c1","c4") => 20,
                ("c2","c5") => 25,
                ("c2","c3") => 10,
                ("c3","c4") => 20,
                ("c4","c5") => 15,
                ("c2","c4") => 25,
                ("c3","c5") => 45
               )
dist = known_dist
d(c1, c2) = begin
    if c1 == c2
        0
    else
        try
            dist[(c1, c2)]
        catch
            dist[(c2, c1)]
        end
    end
end

@show almost_tsp(["c1", "c2", "c3","c4"], d)
@show tsp(["c1", "c2", "c3","c4"], d)

dist = new_dist
@show almost_tsp(["c1", "c2", "c3","c4","c5"], d)
@show almost_tsp_2(["c1", "c2", "c3","c4","c5"], d)

