### To-do list

[x] When we check two clauses to see if there should be an edge connecting them, we should not consider any literals that have already been assigned a truth value.

[x] If community detection results in every clause being in its own community, we sort the remaining literals by frequency and assign a truth value greedily in that order

[ ] Another idea is to quit out of community detection once the modularity falls below a certain threshold

[x] MAX3SAT_solver.jl is still randomly assigning truth values; need a more robust strategy!

[x] Need a baseline to compare to, so perhaps just take the best of 1000 random assignments for now.

[ ] Hmm, maybe it's a bad idea to comb through for (m, f, f) and assign the m to true? Cuz then such a clause could still form part of a community.

[ ] For large instances, I think I need to make the communities larger and less frequent, although the modularity is above 0.9 for uuf50-01 and uuf50-02, so hmm..

### Best scores seen so far

            hill    me
uuf50-01    214     208
uuf50-02    211     210
uuf50-03    212     208
