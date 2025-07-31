module CDtoMAX3SAT

using Graphs
using SimpleWeightedGraphs
using Random

include("./cnf_parser.jl")
include("./graph_builder.jl")
include("./community_detection.jl")
include("./modularity.jl")
include("./MAX3SAT_solver.jl")
include("./MAX3SAT_checker.jl")

using Graphs

function main(instance_file = nothing)
    if instance_file === nothing && length(ARGS) > 0
        instance_file = "./instances/" * ARGS[1]
    elseif instance_file === nothing
        instance_file = "./instances/test-9v-5c.cnf"
    end
    num_vars, num_clauses, clauses = parse_cnf_file(instance_file)
    debug = (num_clauses < 10)
    if debug
        println("Number of variables: $num_vars")
        println("Number of clauses: $num_clauses")
        println("Clauses (first 10): $(first(clauses, 10))")
    end

    # missing means not assigned yet
    assignments = Vector{Union{Bool,Missing}}(missing, num_vars)

    while any(ismissing, assignments)

        g = build_graph(clauses, assignments)
        if debug
            println("Number of vertices: ", nv(g))
            println("Number of edges: ", ne(g))
            println("Edges:")
            for e in edges(g)
                println(e)
            end
        end

        labels = label_propagation(g)
        @show labels

        modularity = calculate_modularity(g, labels)
        @show modularity

        num_unique_communities = length(unique(labels))
        @show num_unique_communities

        assign(labels, clauses, assignments)
        @show assignments

        # readline()
    end

    score = get_max3sat_score(clauses, assignments)
    println("score = $score out of $num_clauses = $(round(score/num_clauses, digits = 2))")

end

export  parse_cnf_file, 
        build_graph, 
        label_propagation, 
        main, 
        calculate_modularity,
        assign,
        get_max3sat_score

end