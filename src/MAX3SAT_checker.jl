function get_max3sat_score(clauses::Vector{Vector{Int}}, 
                           assignments::Vector{Union{Bool,Missing}},
                           debug::Bool)

    num_satisfied_clauses = 0

    if debug
        println("Checking the number of satisfied clauses for: ")
        @show clauses 
        @show assignments
    end
    
    for clause in clauses
        debug && println("Scoring for clause = $clause")
        for literal in clause
            debug && println("Checking literal = $literal")
            if (literal > 0 && assignments[literal] == true) || (literal < 0 && assignments[abs(literal)] == false)
                num_satisfied_clauses += 1
                debug && println("scored!")
                break
            end
        end
    end

    return num_satisfied_clauses
end