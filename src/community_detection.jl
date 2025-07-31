using SimpleWeightedGraphs
using Random
using Graphs

function label_propagation(g::SimpleWeightedGraph)
    # Currently using simple label propagation
    n = nv(g)
    labels = collect(1:n)
    label_changed = true
    while label_changed
        label_changed = false
        for v in randperm(n)
            label_counts = Dict{Int, Int}()
            for nbr in neighbors(g, v)
                label_counts[labels[nbr]] = get(label_counts, labels[nbr], 0) + g.weights[v, nbr]
            end
            if !isempty(label_counts)
                max_count = maximum(values(label_counts))
                most_frequent_labels = [label for (label, count) in label_counts if count == max_count]
                new_label = rand(most_frequent_labels)
                if new_label != labels[v]
                    labels[v] = new_label
                    label_changed = true
                end
            end
        end
    end
    return labels
end