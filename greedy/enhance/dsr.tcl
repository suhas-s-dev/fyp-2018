package provide math::fuzzy 0.2

#------------------------------------------- Tool Command Language (TCL)---------------------------------------

#-------------------------------Environmental Settings-----------------------------
		
 set nn                49               ;# number of mobilenodes
 set val(x)            3070		;#X co-ordinate value
 set val(y)            1200		;#Y co-ordinate value
 set rp                DSR
#---------------------------------- Simulator Object Creation----------------------

set ns_ [new Simulator]

#--------------------------- Trace File to record all the Events-------------------

set f [open Trace.tr w]
$ns_ trace-all $f
#$ns_ use-newtrace

#----------------------------------- NAM Window creation--------------------------

set namtrace [open Nam.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)


# -------------------------------Topology Creation------------------------------

set topo [new Topography]
set rp DSR
$topo load_flatgrid $val(x) $val(y)

#--------------------------- General Operational Director-----------------------

create-god $nn
set god_ [create-god $nn]
# -----------------------------Node Configuration-------------------------------


Phy/WirelessPhy set freq_ 2.4e+9
Mac/802_11 set dataRate_ 54.0e6   

$ns_ node-config  -adhocRouting $rp \
 		 -llType LL \
                 -macType Mac/802_11 \
                 -ifqType Queue/DropTail/PriQueue \
                 -ifqLen 500 \
                 -antType Antenna/OmniAntenna \
                 -propType Propagation/TwoRayGround \
                 -phyType Phy/WirelessPhy \
                 -channelType Channel/WirelessChannel \
                 -topoInstance $topo \
		 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace ON \
                 -movementTrace ON \
                 -idlePower 1.2 \
		 -rxPower 1.0 \
		 -txPower 1.5 \
		 -sleepPower 0.000015 \
           	 -initialEnergy 200 \
                 -energyModel EnergyModel 
		 

#--------------------------------- Node Creation  -------------------------------      
source tmp
Phy/WirelessPhy set Pt_ 0.788
for {set i 0} {$i < $nn } {incr i} {
					set node_($i) [$ns_ node]
					if { [expr $i % 4] != 0 } { $node_($i) set X_ 030.0 ; $node_($i) set Y_ 030.0 } 
					if { [expr $i % 4] == 0 } { $node_($i) set X_ 930.0 ; $node_($i) set Y_ 930.0 }
					$node_($i) set Z_ 0.0
					$god_ new_node $node_($i)
					$ns_ initial_node_pos $node_($i) 60
					$node_($i) color black
				   } 
set node_(49) [$ns_ node]
$node_(49) set X_ 1930.0
$node_(49) set Y_ 505.0
$node_(49) set Z_ 0.0
$ns_ initial_node_pos $node_(49) 40

set node_(50) [$ns_ node]
$node_(50) set X_ 2207.0
$node_(50) set Y_ 1003.0
$node_(50) set Z_ 0.0
$ns_ initial_node_pos $node_(50) 60

set node_(51) [$ns_ node]
$node_(51) set X_ 1386.0
$node_(51) set Y_ 1188.0
$node_(51) set Z_ 0.0
$ns_ initial_node_pos $node_(51) 10

#--------------------------------- Sink Creation  ------------------------------- 

for {set i 0} {$i<$nn} {incr i} {
				  $ns_ at 0.0 "$node_($i) label-color black"
				  set sink($i) [new Agent/TCPSink]
				  $ns_ attach-agent $node_($i) $sink($i)
				}

#source certificate.tcl

#----------------------- CBR Creation  ---------------------------------------- 

proc attach-CBR-traffic { node sink pk ivt } {
					   #Get an instance of the simulator
					   set ns_ [Simulator instance]
					   set reno [new Agent/TCP/Reno]
					   $ns_ attach-agent $node $reno
					   #Create a CBR  agent and attach it to the node
					   set cbr [new Application/Traffic/CBR]
					   $cbr attach-agent $reno
					   $cbr set packetSize_ $pk	;#sub packet size
					   $cbr set interval_ $ivt
					   #Attach CBR source to sink;
					   $ns_ connect $reno $sink
					   return $cbr
 				     }



#for {set i 0} {$i < $nn } {incr i} {  $ns_ at 0.001 "$node_($i)  setdest 480.632 480.686 1500" }
#--------------------------------- Node Deploy  -------------------------------- 

proc Deploy { tm tt nkt } {  
                   global ns_ node_ a nn

		   if { $nkt==0 } {
		   #------------- Random Value Generate -------------
		   if { $tt==1} {
						
		   #------ Execute number of time --------
  	           for { set i 0 } { $i<$nn } { incr i } {
		     set nt 1
		     #----- Repeat execuation-----
	             while { $nt } { 
				    set chk 1
				    set val [expr int(rand()*$nn)] ; #--- Random value Generate ----
				    if {  $val <$nn } { 
 							#----- Check Duplicate Value --------
						 	for { set j 0 } { $j<$i } { incr j} { if { $val==$a($j) } { set chk 0 } }
							#----- Store In Array ---------------
							if { $chk==1 } {  set a($i) $val  ;  set nt 0  } 
						      }
				}
						        }  
				  }  
			

			 set rr [open "Route_Req" w]
                         puts $rr "----------------------------------------------"
			 puts $rr "Node\tQueue_Lemgth\tM"
                         puts $rr "----------------------------------------------"
			 for { set i 0} { $i<49 } { incr i } { 
			 set nt 1
	                 while { $nt } { 
				  	  set chk 1
				    	  set val [expr int(rand()*500)] ; 
				    	  #set val1 [expr int(rand()*20)] ; 
				           if { $val >50 && $val <500 } { puts $rr "$i\t  $val\t\t $a($i)" ; set nt 0 } 
				       }
				                              } 
			 close $rr



 #---------------------- Random Node Deploy  ---------------
                        

			$ns_ at $tm "$node_($a(0))  setdest 1194.63 864.686 2000"
			$ns_ at $tm "$node_($a(1))  setdest 05.889  897.421 2000"
			$ns_ at $tm "$node_($a(2))  setdest 192.526 867.723 2000"
			$ns_ at $tm "$node_($a(3))  setdest 403.681 878.145 2000"
			$ns_ at $tm "$node_($a(4))  setdest 566.131 861.195 2000"
			$ns_ at $tm "$node_($a(5))  setdest 786.770 891.176 2000"
			$ns_ at $tm "$node_($a(6))  setdest 1018.25 877.490 2000"
			$ns_ at $tm "$node_($a(7))  setdest 07.112  743.439 2000"
			$ns_ at $tm "$node_($a(8))  setdest 183.387 723.714 2000"
			$ns_ at $tm "$node_($a(9))  setdest 396.864 726.312 2000"
			$ns_ at $tm "$node_($a(10)) setdest 600.249 722.778 2000"
			$ns_ at $tm "$node_($a(11)) setdest 780.595 744.345 2000"
			$ns_ at $tm "$node_($a(12)) setdest 978.030 742.895 2000"
			$ns_ at $tm "$node_($a(13)) setdest 028.024 594.853 2000"
			$ns_ at $tm "$node_($a(14)) setdest 210.162 595.741 2000"
			$ns_ at $tm "$node_($a(15)) setdest 397.493 591.160 2000"
			$ns_ at $tm "$node_($a(16)) setdest 604.486 578.724 2000"
			$ns_ at $tm "$node_($a(17)) setdest 833.068 602.543 2000"
			$ns_ at $tm "$node_($a(18)) setdest 1014.50 600.092 2000"
			$ns_ at $tm "$node_($a(19)) setdest 01.137  448.425 2000"
			$ns_ at $tm "$node_($a(20)) setdest 166.025 446.032 2000"
			$ns_ at $tm "$node_($a(21)) setdest 420.372 443.229 2000"
			$ns_ at $tm "$node_($a(22)) setdest 613.236 437.806 2000"
			$ns_ at $tm "$node_($a(23)) setdest 813.173 464.223 2000"
			$ns_ at $tm "$node_($a(24)) setdest 1008.39 460.157 2000"
			$ns_ at $tm "$node_($a(25)) setdest 018.729 312.913 2000"
			$ns_ at $tm "$node_($a(26)) setdest 200.299 313.954 2000"
			$ns_ at $tm "$node_($a(27)) setdest 389.457 314.250 2000"
			$ns_ at $tm "$node_($a(28)) setdest 594.978 305.736 2000"
			$ns_ at $tm "$node_($a(29)) setdest 770.954 328.334 2000"
			$ns_ at $tm "$node_($a(30)) setdest 982.254 323.374 2000"
			$ns_ at $tm "$node_($a(31)) setdest 06.106  167.062 2000"
			$ns_ at $tm "$node_($a(32)) setdest 193.068 172.333 2000"
			$ns_ at $tm "$node_($a(33)) setdest 418.951 185.829 2000"
			$ns_ at $tm "$node_($a(34)) setdest 618.363 167.535 2000"
			$ns_ at $tm "$node_($a(35)) setdest 833.363 190.643 2000"
			$ns_ at $tm "$node_($a(36)) setdest 1015.50 177.758 2000"
			$ns_ at $tm "$node_($a(37)) setdest 030.749 040.714 2000"
			$ns_ at $tm "$node_($a(38)) setdest 208.270 027.805 2000"
			$ns_ at $tm "$node_($a(39)) setdest 409.215 037.426 2000"
			$ns_ at $tm "$node_($a(40)) setdest 603.061 019.428 2000"
			$ns_ at $tm "$node_($a(41)) setdest 813.290 042.416 2000"
			$ns_ at $tm "$node_($a(42)) setdest 988.135 025.104 2000"
			$ns_ at $tm "$node_($a(43)) setdest 1160.26 719.847 2000"
			$ns_ at $tm "$node_($a(44)) setdest 1173.23 582.316 2000"
			$ns_ at $tm "$node_($a(45)) setdest 1168.41 444.810 2000"
			$ns_ at $tm "$node_($a(46)) setdest 1147.31 305.640 2000"
			$ns_ at $tm "$node_($a(47)) setdest 1185.58 162.339 2000"
			$ns_ at $tm "$node_($a(48)) setdest 1180.69 020.018 2000"
			}
		
		  #------------------------ Random Mobility ---------------------
		 if { $nkt==1 } {
			$ns_ at $tm "$node_($a(0))  setdest [expr (rand()*50)+1194.63] [expr (rand()*50)+ 864.686 ] $a(48)"
			$ns_ at $tm "$node_($a(1))  setdest [expr (rand()*50)+05.889 ] [expr (rand()*50)+ 897.421 ] $a(47)"
			$ns_ at $tm "$node_($a(2))  setdest [expr (rand()*50)+192.526] [expr (rand()*50)+ 867.723 ] $a(46)"
			$ns_ at $tm "$node_($a(3))  setdest [expr (rand()*50)+403.681] [expr (rand()*50)+ 878.145 ] $a(45)"
			$ns_ at $tm "$node_($a(4))  setdest [expr (rand()*50)+566.131] [expr (rand()*50)+ 861.195 ] $a(44)"
			$ns_ at $tm "$node_($a(5))  setdest [expr (rand()*50)+786.770] [expr (rand()*50)+ 891.176 ] $a(43)"
			$ns_ at $tm "$node_($a(6))  setdest [expr (rand()*50)+1018.25] [expr (rand()*50)+ 877.490 ] $a(42)"
			$ns_ at $tm "$node_($a(7))  setdest [expr (rand()*50)+07.112 ] [expr (rand()*50)+ 743.439 ] $a(41)"
			$ns_ at $tm "$node_($a(8))  setdest [expr (rand()*50)+183.387] [expr (rand()*50)+ 723.714 ] $a(40)"
			$ns_ at $tm "$node_($a(9))  setdest [expr (rand()*50)+396.864] [expr (rand()*50)+ 726.312 ] $a(39)"
			$ns_ at $tm "$node_($a(10)) setdest [expr (rand()*50)+600.249] [expr (rand()*50)+ 722.778 ] $a(38)"
			$ns_ at $tm "$node_($a(11)) setdest [expr (rand()*50)+780.595] [expr (rand()*50)+ 744.345 ] $a(37)"
			$ns_ at $tm "$node_($a(12)) setdest [expr (rand()*50)+978.030] [expr (rand()*50)+ 742.895 ] $a(36)"
			$ns_ at $tm "$node_($a(13)) setdest [expr (rand()*50)+028.024] [expr (rand()*50)+ 594.853 ] $a(35)"
			$ns_ at $tm "$node_($a(14)) setdest [expr (rand()*50)+210.162] [expr (rand()*50)+ 595.741 ] $a(34)"
			$ns_ at $tm "$node_($a(15)) setdest [expr (rand()*50)+397.493] [expr (rand()*50)+ 591.160 ] $a(33)"
			$ns_ at $tm "$node_($a(16)) setdest [expr (rand()*50)+604.486] [expr (rand()*50)+ 578.724 ] $a(32)"
			$ns_ at $tm "$node_($a(17)) setdest [expr (rand()*50)+833.068] [expr (rand()*50)+ 602.543 ] $a(31)"
			$ns_ at $tm "$node_($a(18)) setdest [expr (rand()*50)+1014.50] [expr (rand()*50)+ 600.092 ] $a(30)"
			$ns_ at $tm "$node_($a(19)) setdest [expr (rand()*50)+01.137 ] [expr (rand()*50)+ 448.425 ] $a(29)"
			$ns_ at $tm "$node_($a(20)) setdest [expr (rand()*50)+166.025] [expr (rand()*50)+ 446.032 ] $a(28)"
			$ns_ at $tm "$node_($a(21)) setdest [expr (rand()*50)+420.372] [expr (rand()*50)+ 443.229 ] $a(27)"
			$ns_ at $tm "$node_($a(22)) setdest [expr (rand()*50)+613.236] [expr (rand()*50)+ 437.806 ] $a(26)"
			$ns_ at $tm "$node_($a(23)) setdest [expr (rand()*50)+813.173] [expr (rand()*50)+ 464.223 ] $a(25)"
			$ns_ at $tm "$node_($a(24)) setdest [expr (rand()*50)+1008.39] [expr (rand()*50)+ 460.157 ] $a(24)"
			$ns_ at $tm "$node_($a(25)) setdest [expr (rand()*50)+018.729] [expr (rand()*50)+ 312.913 ] $a(23)"
			$ns_ at $tm "$node_($a(26)) setdest [expr (rand()*50)+200.299] [expr (rand()*50)+ 313.954 ] $a(22)"
			$ns_ at $tm "$node_($a(27)) setdest [expr (rand()*50)+389.457] [expr (rand()*50)+ 314.250 ] $a(21)"
			$ns_ at $tm "$node_($a(28)) setdest [expr (rand()*50)+594.978] [expr (rand()*50)+ 305.736 ] $a(20)"
			$ns_ at $tm "$node_($a(29)) setdest [expr (rand()*50)+770.954] [expr (rand()*50)+ 328.334 ] $a(19)"
			$ns_ at $tm "$node_($a(30)) setdest [expr (rand()*50)+982.254] [expr (rand()*50)+ 323.374 ] $a(18)"
			$ns_ at $tm "$node_($a(31)) setdest [expr (rand()*50)+06.106 ] [expr (rand()*50)+ 167.062 ] $a(17)"
			$ns_ at $tm "$node_($a(32)) setdest [expr (rand()*50)+193.068] [expr (rand()*50)+ 172.333 ] $a(16)"
			$ns_ at $tm "$node_($a(33)) setdest [expr (rand()*50)+418.951] [expr (rand()*50)+ 185.829 ] $a(15)"
			$ns_ at $tm "$node_($a(34)) setdest [expr (rand()*50)+618.363] [expr (rand()*50)+ 167.535 ] $a(14)"
			$ns_ at $tm "$node_($a(35)) setdest [expr (rand()*50)+833.363] [expr (rand()*50)+ 190.643 ] $a(13)"
			$ns_ at $tm "$node_($a(36)) setdest [expr (rand()*50)+1015.50] [expr (rand()*50)+ 177.758 ] $a(12)"
			$ns_ at $tm "$node_($a(37)) setdest [expr (rand()*50)+030.749] [expr (rand()*50)+ 040.714 ] $a(11)"
			$ns_ at $tm "$node_($a(38)) setdest [expr (rand()*50)+208.270] [expr (rand()*50)+ 027.805 ] $a(10)"
			$ns_ at $tm "$node_($a(39)) setdest [expr (rand()*50)+409.215] [expr (rand()*50)+ 037.426 ] $a(9)"
			$ns_ at $tm "$node_($a(40)) setdest [expr (rand()*50)+603.061] [expr (rand()*50)+ 019.428 ] $a(8)"
			$ns_ at $tm "$node_($a(41)) setdest [expr (rand()*50)+813.290] [expr (rand()*50)+ 042.416 ] $a(7)"
			$ns_ at $tm "$node_($a(42)) setdest [expr (rand()*50)+988.135] [expr (rand()*50)+ 025.104 ] $a(6)"
			$ns_ at $tm "$node_($a(43)) setdest [expr (rand()*50)+1160.26] [expr (rand()*50)+ 719.847 ] $a(5)"
			$ns_ at $tm "$node_($a(44)) setdest [expr (rand()*50)+1173.23] [expr (rand()*50)+ 582.316 ] $a(4)"
			$ns_ at $tm "$node_($a(45)) setdest [expr (rand()*50)+1168.41] [expr (rand()*50)+ 444.810 ] $a(3)"
			$ns_ at $tm "$node_($a(46)) setdest [expr (rand()*50)+1147.31] [expr (rand()*50)+ 305.640 ] $a(2)"
			$ns_ at $tm "$node_($a(47)) setdest [expr (rand()*50)+1185.58] [expr (rand()*50)+ 162.339 ] $a(1)"
			$ns_ at $tm "$node_($a(48)) setdest [expr (rand()*50)+1180.69] [expr (rand()*50)+ 020.018 ] $a(0)"
			}
		     }


			







$ns_ at 22.0  "$node_(3) label ."



$ns_ at 0.01 "$node_(0) setdest 846.0 528.0 2000.0"

			$ns_ at 0.01 "$node_(1)  setdest 2088.889  10.421 2000"
			$ns_ at 0.01 "$node_(2)  setdest 1733.526 162.723 2000"
			$ns_ at 0.01 "$node_(3)  setdest 2333.681 663.145 2000"
			$ns_ at 0.01 "$node_(4)  setdest 2569.131 663.195 2000"
			$ns_ at 0.01 "$node_(5)  setdest 615.770 883.176 2000"
			$ns_ at 0.01 "$node_(6)  setdest 1030.25 893.490 2000"
			$ns_ at 0.01 "$node_(7)  setdest 615.112  1035.439 2000"
			$ns_ at 0.01 "$node_(8)  setdest 2333.387 335.714 2000"
			$ns_ at 0.01 "$node_(9)  setdest 2088.864 335.312 2000"
			$ns_ at 0.01 "$node_(10) setdest 2569.249 335.778 2000"
			$ns_ at 0.01 "$node_(11) setdest 2789.595 335.345 2000"
                        $ns_ at 0.01 "$node_(12) setdest 2791.030 663.895 2000"
			$ns_ at 0.01 "$node_(13) setdest 2088.024 663.853 2000"
			$ns_ at 0.01 "$node_(14) setdest 208.162 663.741 2000"
			$ns_ at 0.01 "$node_(15) setdest 387.493 663.160 2000"
			$ns_ at 0.01 "$node_(16) setdest 615.486 663.724 2000"
			$ns_ at 0.01 "$node_(17) setdest 3060.068 330.543 2000"
			$ns_ at 0.01 "$node_(18) setdest 25.50 663.092 2000"
			$ns_ at 0.01 "$node_(19) setdest 616.137  170.425 2000"
			$ns_ at 0.01 "$node_(20) setdest 616.025 12.032 2000"
			$ns_ at 0.01 "$node_(21) setdest 1211.372 335.229 2000"
			$ns_ at 0.01 "$node_(22) setdest 1733.236 10.806 2000"
			$ns_ at 0.01 "$node_(23) setdest 1827.173 663.223 2000"
			$ns_ at 0.01 "$node_(24) setdest 1030.39 1037.157 2000"
			$ns_ at 0.01 "$node_(25) setdest 25.729 663.913 2000"
			$ns_ at 0.01 "$node_(26) setdest 208.299 335.954 2000"
			$ns_ at 0.01 "$node_(27) setdest 387.457 335.250 2000"
			$ns_ at 0.01 "$node_(28) setdest 615.978 335.736 2000"
			$ns_ at 0.01 "$node_(29) setdest 3018.954 677.334 2000"
			$ns_ at 0.01 "$node_(30) setdest 1030.254 663.374 2000"
			$ns_ at 0.01 "$node_(31) setdest 1030.106  1195.062 2000"
			$ns_ at 0.01 "$node_(32) setdest 1733.068 335.333 2000"
			$ns_ at 0.01 "$node_(44) setdest 903.951 29.829 2000"
			$ns_ at 0.01 "$node_(34) setdest 1374.363 335.535 2000"
			$ns_ at 0.01 "$node_(35) setdest 1030.363 171.643 2000"
			$ns_ at 0.01 "$node_(36) setdest 1030.50 335.758 2000"
			$ns_ at 0.01 "$node_(37) setdest 2088.749 162.714 2000"
			$ns_ at 0.01 "$node_(38) setdest 615.270 1188.805 2000"
			$ns_ at 0.01 "$node_(39) setdest 1030.215 12.426 2000"
			$ns_ at 0.01 "$node_(40) setdest 1519.061 335.428 2000"
			$ns_ at 0.01 "$node_(41) setdest 1211.290 663.416 2000"
			$ns_ at 0.01 "$node_(42) setdest 1374.135 663.104 2000"
			$ns_ at 0.01 "$node_(43) setdest 1519.26 663.847 2000"
			$ns_ at 0.01 "$node_(33) setdest 1646.23 663.316 2000"
			$ns_ at 0.01 "$node_(45) setdest 2708.41 506.810 2000"
			$ns_ at 0.01 "$node_(46) setdest 1930.31 1.640 2000"
			$ns_ at 0.01 "$node_(47) setdest 859.58 1103.339 2000"
			$ns_ at 0.01 "$node_(48) setdest 1.69 457.018 2000"

for { set i 1 } { $i < 44} { incr i } {
       $ns_ at 2.01 "$node_($i) label RSU"
$ns_ at 2.01 "$node_($i) add-mark c3 red square"
}

for { set i 44 } { $i < 49} { incr i } {
       $ns_ at 2.01 "$node_($i) label VEHICLE-OBU"
$ns_ at 2.01 "$node_($i) add-mark c3 black hexagon"
}

$ns_ at 2.01 "$node_(0) label TA"
$ns_ at 2.01 "$node_(0) add-mark c3 brown square"
$ns_ at 2.01 "$node_(49) label TA"
$ns_ at 2.01 "$node_(49) add-mark c3 brown square"

$node_(50) color grey
$ns_ at 5.02 "$node_(50) color grey"
$node_(51) color grey
$ns_ at 0.0 "$node_(51) color grey"
$ns_ at 7.01 "$node_(51) label virus"

$node_(30) color grey
$ns_ at 7.7 "$node_(30) color grey"
$ns_ at 7.71 "$node_(51) label ."
$ns_ at 7.7 "$node_(30) label MALICIOUS-NODE"

$ns_ at 5.01 "$node_(50) setdest 1939.69 738.018 1000"

$ns_ at 3.01 "$node_(48) setdest 3029.69 434.018 1000"
$ns_ at 4.01 "$node_(45) setdest 1820.69 578.018 1000"
$ns_ at 5.01 "$node_(46) setdest 1962.69 335.018 1000"
$ns_ at 3.01 "$node_(47) setdest 745.69 665.018 1000"
$ns_ at 3.81 "$node_(47) setdest 734.69 40.018 1000"

$ns_ at 4.01 "$node_(44) setdest 943.69 566.018 1000"
$ns_ at 5.01 "$node_(44) setdest 2988.69 568.018 1000"


$ns_ at 5.11 "$node_(45) setdest 1823.69 19.018 1000"
$ns_ at 5.4 "$node_(46) setdest 29.69 445.018 1000"
$ns_ at 6.5 "$node_(47) setdest 717.69 1169.1167 1000"
$ns_ at 6.01 "$node_(50) label MALICIOUS-NODE"

$ns_ at 7.01 "$node_(51) setdest 1007.69 648.018 1000"

set udp3 [$ns_ create-connection UDP $node_(30) LossMonitor $node_(0) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 7.7 "$cbr2 start"
$ns_ at 7.9 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(30) LossMonitor $node_(0) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .0001
$ns_ at 7.95 "$cbr2 start"
$ns_ at 8.1 "$cbr2 stop"


set udp3 [$ns_ create-connection UDP $node_(38) LossMonitor $node_(0) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.05 "$cbr2 start"
$ns_ at 7.4 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(39) LossMonitor $node_(0) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 4.05 "$cbr2 start"
$ns_ at 7.4 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(14) LossMonitor $node_(0) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.05 "$cbr2 start"
$ns_ at 7.4 "$cbr2 stop"
$ns_ at 0.0 "$ns_ trace-annotate \" Process started.....\""
$ns_ at 2.0 "$ns_ trace-annotate \" ROAD SIDE UNIT TRANSFERS THE INFORMATION TO ON BOARD UNIT OF VEHICLE THROUGH TRUSTED AUTHORITY.....\""
$ns_ at 4.0 "$ns_ trace-annotate \" TRUSTED AUTHORITY VERIFIES RSU AUTHENTICATION THROUGH ECC CRYPTOGRAPHIC FUNCTION.....\""
$ns_ at 5.5 "$ns_ trace-annotate \" EXTERNAL ATTACK - unauthorized RSU NODE sends the false information to TRUSTED-AUTHORITY, TA IDENTIFIES THE NODE AS MALICIOUS AND DROPS ALL PACKETS FROM MALICIOUS NODE.....\""
$ns_ at 8.0 "$ns_ trace-annotate \" INTERNAL ATTACK - VIRUS AFFECTS THE RSU-NODE-30 AS RESULT RSU-30 SENDS false information to TRUSTED-AUTHORITY, TA IDENTIFIES THE NODE AS MALICIOUS AND DROPS ALL PACKETS FROM MALICIOUS NODE.....\""



set udp3 [$ns_ create-connection UDP $node_(30) LossMonitor $node_(29) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.05 "$cbr2 start"
$ns_ at 7.05 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(36) LossMonitor $node_(32) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.5 "$cbr2 start"
$ns_ at 7.05 "$cbr2 stop"


set udp3 [$ns_ create-connection UDP $node_(9) LossMonitor $node_(17) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 4.05 "$cbr2 start"
$ns_ at 7.05 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(20) LossMonitor $node_(28) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 7.05 "$cbr2 start"
$ns_ at 9.05 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(28) LossMonitor $node_(20) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 7.15 "$cbr2 start"
$ns_ at 9.05 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(0) LossMonitor $node_(38) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 7.25 "$cbr2 start"
$ns_ at 9.05 "$cbr2 stop"


set udp3 [$ns_ create-connection UDP $node_(50) LossMonitor $node_(49) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 5.3 "$cbr2 start"
$ns_ at 5.7 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(50) LossMonitor $node_(49) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .0001
$ns_ at 5.7 "$cbr2 start"
$ns_ at 6.0 "$cbr2 stop"

# Generation of CRL list
set ac [open KEY-MANAGER.txt w]
puts $ac "\n  --------------------------------------------------------------------------------------"
puts $ac "    Public-key(gpk)\tNode-Id\t\tID-basedKey-H(ID)\tPrivateSigningKey(gsk)"
puts $ac "  ----------------------------------------------------------------------------------------\n"
close $ac

set f 1
while {$f} {
set mk [expr int(rand()*50)]
if {$mk>20} {
set f 0
}
}

set a(0) 10
set a(1) 11
set a(2) 100
set a(3) 101
set a(4) 110
set a(5) 111

set n [expr int(rand()*6)]

for {set i 0} {$i<30} {incr i} {
set sk($i) [expr $mk*$a($n)$i]
set ac [open KEY-MANAGER.txt a]
puts $ac "\t$mk\t\t$i\t\t\t$a($n)$i[expr int(rand()*10)]\t\t$sk($i)"
close $ac
}
for {set i 31} {$i<49} {incr i} {
set sk($i) [expr $mk*$a($n)$i]
set ac [open KEY-MANAGER.txt a]
puts $ac "\t$mk\t\t$i\t\t\t$a($n)$i[expr int(rand()*10)]\t\t$sk($i)"
close $ac
}
proc finish {} {
		global ns_ namtrace  node_ a
		$ns_ flush-trace
		close $namtrace 
		
		exec nam Nam.nam &
		
		exit 0
	       }
for { set i 0 } { $i < $nn} { incr i } {
        
}


$ns_ at 10.0 "finish"

puts "Start of simulation.."
$ns_ run
         



