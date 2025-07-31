import StatsBase: mode

#=
g.weights: a matrix (usually of type Matrix{Float64}) where 
           weights[i, j] gives the weight of the edge from vertex i 
           to vertex j (0 if no edge).
g.fadjlist: a list of adjacency lists for fast neighbor lookup.
g.badjlist: (for directed graphs) a list of backward adjacency lists.
g.nv: the number of vertices.
g.is_directed: whether the graph is directed.

You can access the number of vertices with nv(g), the number of edges 
with ne(g), and the weight between two vertices with g.weights[i, j]. 
Edges are typically undirected unless specified otherwise.
=#

function assign(labels::Vector{Int}, 
                clauses::Vector{Vector{Int}},
                assignments::Vector{Union{Bool,Missing}},
                debug::Bool)

    # Find the largest community
    largest_community_label = mode(labels)
    debug && @show largest_community_label
    # Assign truth values to the variables found in this community
    indices = findall(x -> x == largest_community_label, labels)
    debug && @show indices
    all_literals = Int[]
    for i in indices
        debug && @show clauses[i]
        append!(all_literals, clauses[i])
    end
    unique_literals = unique(vcat(all_literals))
    debug && @show unique_literals
    for literal in unique_literals
        v = abs(literal) # in case literal is a negation
        if ismissing(assignments[v])
            # here is where I need a more robust strategy:
            assignments[v] = rand(Bool)
        end
    end

    # readline()

    # Check if any clauses have two falses:
    for clause in clauses
        debug && println(">>>> clause = $clause")
        assigned = [assignments[abs(l)] for l in clause]
        debug && println(">>>> assigned = $assigned")
        # readline()
        num_false = count(x -> x === false, assigned)
        num_missing = count(ismissing, assigned)
        if num_false == 2 && num_missing == 1
            debug && println(">>>> found an example!")
            missing_idx = findfirst(ismissing, assigned)
            v = abs(clause[missing_idx])
            assignments[v] = true
            # readline()
        end
    end
    
    debug && @show assignments
end