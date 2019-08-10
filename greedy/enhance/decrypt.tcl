puts "To continue with decryption Enter 'D' to decrypt"
set choice [gets stdin]
set choice [string toupper $choice]
if {$choice eq "D"} {
# Tcl program to decrpyt a file using RSA 
# initialize the parameters 
set e 3
set d 11787
set n 17947

set fname [gets stdin]
puts "DECRYPTION IN PROGRESS ......"
set new [split $fname {.}]
set newfile [lindex $new 0] 

# open the file in read mode
set fileid1 [open en r]
set fileid2 [open de w]
#puts $fileid2
# read the input file
set cont [read $fileid1]
puts $cont
close $fileid1

#split the file contents into constituent characters
set mylist [split $cont {}]

# process character-wise
foreach {char} $mylist {
	if {$char eq ""} {break}
	set asc [scan $char %c]
	set res 1
	for {set i 1} {$i <= $d} {incr i} {
		set res [expr "($res * $asc) % $n"]
	}
	set newchar [format "%c" $res]
	puts -nonewline $fileid2 $newchar
}
close $fileid2
puts "DECRYPTION COMPLETE ......"
}

