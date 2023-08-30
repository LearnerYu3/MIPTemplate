
function SortCost(cost)
    clients = size(cost, 1)
    facilities = size(cost, 2)
    V = Array{Int}(undef, clients, facilities)
    for i in 1:clients
        V[i, :] = sortperm(cost[i, :])
    end
    return V
end

function FindMaxK(V, clients, facilities, y_vals)
    maxk = ones(Int, clients)
    for i in 1:clients
        sumy = 0
        for t in 1:facilities
            sumy += y_vals[V[i, t]]
            if sumy - 1 > -EPS
                maxk[i] = t
                break
            end
        end
    end
    return maxk
end
