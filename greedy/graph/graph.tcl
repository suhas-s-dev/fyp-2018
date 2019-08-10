exec xgraph th.tr  -t "Throughput" -x "Time" -y "Kb/s" &
exec xgraph dl.tr  -t "Delay" -x "Time" -y "Delay in ms" &
#exec xgraph eg.tr  -t "Energy" -x "Time" -y "Energy in joules" &
exec xgraph pdr.tr  -t "PDR" -x "Time" -y "Ratio in %" &
exec xgraph over.tr  -t "Overhead" -x "Time" -y "Overhead" &
