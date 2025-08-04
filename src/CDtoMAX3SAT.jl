module CDtoMAX3SAT

using Graphs
using SimpleWeightedGraphs
using Random

include("./parse_cnf_file.jl")
include("./build_graph.jl")
include("./community_detection.jl")
include("./calculate_modularity.jl")
include("./get_max3sat_score.jl")
include("./MAX3SAT_solver.jl")
include("./get_baseline.jl")
include("./external_solver.jl")

using Graphs

function main(instance_file = nothing)
    if instance_file === nothing && length(ARGS) > 0
        instance_file = "./instances/" * ARGS[1]
    elseif instance_file === nothing
        instance_file = "./instances/test-9v-5c.cnf"
    end

    num_vars, num_clauses, clauses = parse_cnf_file(instance_file)
    
    debug = (num_clauses < 10)
    
    println("Number of variables: $num_vars")
    println("Number of clauses: $num_clauses")
    println("Clauses (first 10): $(first(clauses, 10))")

    my_best_score = 0
    max_iters = 100
    best_assignments = Vector{Union{Bool,Missing}}(missing, num_vars)

    for _ in 1:max_iters

        # missing means not assigned yet
        assignments = Vector{Union{Bool,Missing}}(missing, num_vars)

        while any(ismissing, assignments) 

            g = build_graph(clauses, assignments, debug)
            if debug
                println("Number of vertices: ", nv(g))
                println("Number of edges: ", ne(g))
                println("Edges:")
                for e in edges(g)
                    println(e)
                end
            end

            labels = label_propagation(g)
            debug && @show labels

            modularity = calculate_modularity(g, labels)
            debug && @show modularity

            num_unique_communities = length(unique(labels))
            debug && @show num_unique_communities

            assign(labels, clauses, assignments, debug)
            debug && @show assignments

        end

        score = get_max3sat_score(clauses, assignments, debug)
        
        if score > my_best_score
            my_best_score = score
            best_assignments = copy(assignments)
        end

    end
    
    println("score = $my_best_score out of $num_clauses = $(round(my_best_score/num_clauses, digits = 2))")

    # Run local hill-climbing for comparison
    println("\nRunning local hill-climbing optimization for comparison...")
    
    # Hill-climbing implementation for comparison
    function count_satisfied_inline(clauses, assignments)
        count = 0
        for clause in clauses
            satisfied = false
            for literal in clause
                var_index = abs(literal)
                var_value = assignments[var_index]
                if (literal > 0 && var_value) || (literal < 0 && !var_value)
                    satisfied = true
                    break
                end
            end
            if satisfied
                count += 1
            end
        end
        return count
    end
    
    assignments = [rand(Bool) for _ in 1:num_vars]
    for iter in 1:1000
        best_improvement = 0
        best_flip = 0
        
        for var in 1:num_vars
            assignments[var] = !assignments[var]
            new_score = count_satisfied_inline(clauses, assignments)
            assignments[var] = !assignments[var]
            old_score = count_satisfied_inline(clauses, assignments)
            
            improvement = new_score - old_score
            if improvement > best_improvement
                best_improvement = improvement
                best_flip = var
            end
        end
        
        if best_flip > 0
            assignments[best_flip] = !assignments[best_flip]
        else
            break
        end
    end
    hill_climbing_score = count_satisfied_inline(clauses, assignments)
    println("Hill-climbing baseline: $hill_climbing_score satisfied clauses")
    
    if my_best_score > hill_climbing_score
        println("✅ Your algorithm beats hill-climbing by $(my_best_score - hill_climbing_score) clauses!")
    elseif my_best_score == hill_climbing_score
        println("🟡 Your algorithm matches hill-climbing performance")
    else
        println("🔴 Hill-climbing beats your algorithm by $(hill_climbing_score - my_best_score) clauses")
    end
end

export  parse_cnf_file, 
        build_graph, 
        label_propagation, 
        main, 
        calculate_modularity,
        assign,
        get_max3sat_score,
        get_baseline,
        local_hill_climbing,
        count_satisfied_clauses

end