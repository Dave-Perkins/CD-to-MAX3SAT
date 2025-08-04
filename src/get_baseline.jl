function get_baseline(clauses::Vector{Vector{Int}},
                      num_vars,
                      num_trials = 1000)

    println("="^40)
    println("Getting baseline score..")
    println("="^40)

    best_score = 0

    for _ in 1:num_trials
        assignments = Union{Bool, Missing}[rand([true, false]) for _ in 1:num_vars]
        score = get_max3sat_score(clauses, assignments, false)
        best_score = max(best_score, score)
    end

    return best_score
end