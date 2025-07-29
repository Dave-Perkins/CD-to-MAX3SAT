using CDtoMAX3SAT
using Graphs

function main(debug = true, instance_file = "./instances/test-6v-5c.cnf")
    num_vars, num_clauses, clauses = parse_cnf_file(instance_file)
    if debug
        println("Number of variables: $num_vars")
        println("Number of clauses: $num_clauses")
        println("Clauses (first 5): $(first(clauses, 5))")
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

    labels = detect_communities(g)
    println(labels)
end

main()