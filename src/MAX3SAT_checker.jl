function get_max3sat_score(clauses::Vector{Vector{Int}}, 
                           assignments::Vector{Union{Bool,Missing}})

    num_satisfied_clauses = 0

    println("Checking the number of satisfied clauses for: ")
    @show clauses 
    @show assignments

    for clause in clauses
        println("Scoring for clause = $clause")
        for literal in clause
            println("Checking literal = $literal")
            if (literal > 0 && assignments[literal] == true) || (literal < 0 && assignments[abs(literal)] == false)
                num_satisfied_clauses += 1
                println("scored!")
                break
            end
        end
    end

    return num_satisfied_clauses
end