using Graphs
using SimpleWeightedGraphs

function build_graph(clauses::Vector{Vector{Int}})
    debug = (length(clauses) < 10)
    num_clauses = length(clauses)
    g = SimpleWeightedGraph(num_clauses)
    for i in eachindex(clauses)
        for j in (i+1):lastindex(clauses)
            clause1 = clauses[i]
            clause2 = clauses[j]
            conflicts = 0
            for literal in clause1
                if -literal in clause2
                    conflicts += 1
                end
            end
            if conflicts > 1
                debug && println("Adding edge $i to $j for conflicts = $conflicts")
                add_edge!(g, i, j)
            end
        end
    end

    return g
end