import StatsBase: mode, countmap

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

    # If the largest community has size one, complete assignment manually
    # if length(unique(labels)) == length(labels)
    #     debug && println("all communities have size 1, so manually assigning!")
    #     manually_assign(assignments)
    #     return 
    # end

    debug && @show largest_community_label

    #=
    labels = [5, 8, 7, 5, 5, 8, 7, 8]
    modularity = 0.7800000000000001
    num_unique_communities = 3
    largest_community_label = 5
    indices = [1, 4, 5]
    all_literals = [-1, 2, 3, 1, -2, -3, -2, 5, 6]
    unique_literals = [-1, 2, 3, 1, -2, -3, 5, 6]

    sort the literal pairs by the ones that appear the most often
    find which of v and -v appears most often 
    assign that one to true 

    =#

    # Assign truth values to the variables found in this community
    indices = findall(x -> x == largest_community_label, labels)
    debug && @show indices
    all_literals = vcat(clauses[indices]...)
    debug && @show all_literals

    # sort the literals in descending order by the freq of abs(literal)
    counts = countmap(abs.(all_literals))
    debug && @show counts
    sorted_literals = sort(collect(keys(counts)); by = k -> -counts[k])
    debug && @show sorted_literals
    for lit in sorted_literals
        count_x  = count(x -> x == lit, all_literals)
        count_nx = count(x -> x == -lit, all_literals)
        if count_x > count_nx
            assignments[lit] = true
        else
            assignments[lit] = false
        end
    end

    # Check if any clauses have two falses:
    for clause in clauses
        assigned = [assignments[abs(l)] for l in clause]
        num_false = count(x -> x === false, assigned)
        num_missing = count(ismissing, assigned)
        if num_false == 2 && num_missing == 1
            missing_idx = findfirst(ismissing, assigned)
            v = abs(clause[missing_idx])
            assignments[v] = true
        end
    end
    
    debug && @show assignments
end

function manually_assign(assignments::Vector{Union{Bool,Missing}})

    println("="^40)
    println("Manually assigning the remaining truth values")
    println("="^40)

    # Assign truth values to the remaining variables
    missing_literals = findall(ismissing, assignments)
    
    # Sort the literals in descending order by the freq of abs(literal)
    counts = countmap(abs.(missing_literals))
    sorted_literals = sort(collect(keys(counts)); by = k -> -counts[k])
    for lit in sorted_literals
        count_x  = count(x -> x == lit, missing_literals)
        count_nx = count(x -> x == -lit, missing_literals)
        assignments[lit] = count_x > count_nx ? true : false
    end

end