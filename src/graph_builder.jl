using Graphs
using SimpleWeightedGraphs

function build_graph(clauses::Vector{Vector{Int}})
    num_clauses = length(clauses)
    g = SimpleWeightedGraph(num_clauses)
    for i in eachindex(clauses)
        for j in (i+1):lastindex(clauses)
            clause1 = clauses[i]
            clause2 = clauses[j]
            for literal in clause1
                if -literal in clause2
                    add_edge!(g, i, j)
                end
            end
        end
    end

    return g
end