using Graphs
using SimpleWeightedGraphs

function build_graph(clauses::Vector{Vector{Int}},
                     assignments::Vector{Union{Bool,Missing}},
                     debug::Bool)

    num_clauses = length(clauses)
    g = SimpleWeightedGraph(num_clauses)
    for i in eachindex(clauses)
        for j in (i+1):lastindex(clauses) 
            clause1 = clauses[i]
            clause2 = clauses[j]
            # If a clause is already satisfied, then skip it
            if any(ismissing, [assignments[abs(i)] for i in clause1]) && any(ismissing, [assignments[abs(j)] for j in clause2])
                conflicts = 0
                for literal in clause1
                    if ismissing(assignments[abs(literal)]) && -literal in clause2
                        conflicts += 1
                    end
                end
                if conflicts > 0
                    debug && println("Adding edge $i to $j for conflicts = $conflicts")
                    add_edge!(g, i, j)
                end
            end
        end
    end

    return g
end