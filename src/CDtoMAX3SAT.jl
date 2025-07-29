module CDtoMAX3SAT

using Graphs
using SimpleWeightedGraphs
using Random

include("./cnf_parser.jl")
include("./graph_builder.jl")
include("./community_detection.jl")

export parse_cnf_file, build_graph, detect_communities

end