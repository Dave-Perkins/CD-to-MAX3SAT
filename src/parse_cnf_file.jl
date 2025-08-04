function parse_cnf_file(filename::String)
    clauses = Vector{Vector{Int}}()
    num_vars = 0
    num_clauses = 0
    
    open(filename, "r") do file
        for line in eachline(file)
            line = strip(line)
            if startswith(line, "c") || startswith(line, "%")  
                continue
            elseif startswith(line, "p cnf")  
                parts = split(line)
                num_vars = parse(Int, parts[3])
                num_clauses = parse(Int, parts[4])
            elseif !isempty(line) 
                clause_parts = split(line)
                clause = [parse(Int, x) for x in clause_parts if x != "0"]  
                if !isempty(clause)
                    push!(clauses, clause)
                end
            end
        end
    end
    
    return num_vars, num_clauses, clauses
end