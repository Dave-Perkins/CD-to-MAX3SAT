module CDtoMAX3SAT

using Graphs
using SimpleWeightedGraphs
using Random

include("./cnf_parser.jl")
include("./graph_builder.jl")
include("./community_detection.jl")
include("./modularity.jl")

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

    g = build_graph(clauses)
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

end

export parse_cnf_file, build_graph, label_propagation, main, calculate_modularity

end