using SimpleWeightedGraphs

function calculate_modularity(g::SimpleWeightedGraph, labels::Vector{Int})
    m = sum(g.weights) / 2
    Q = 0.0
    for i in 1:nv(g)
        for j in 1:nv(g)
            if labels[i] == labels[j]
                A_ij = g.weights[i, j]
                k_i = sum(g.weights[i, :])
                k_j = sum(g.weights[j, :])
                Q += (A_ij - k_i * k_j / (2m))
            end
        end
    end
    return Q / (2m)
end
