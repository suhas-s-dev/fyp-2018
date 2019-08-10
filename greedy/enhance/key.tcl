#!/usr/bin/tclsh

set e 3
set d 11787
set n 17947
puts "Vehicle Authentication process started"
puts "Enter the message to be transmitted"
set txt [gets stdin]
set filename "original.txt"
set fileId [open $filename "w"]
puts -nonewline $fileId $txt
close $fileId 

puts "Do you want to encrypt the massage ? Enter 'E' to encrpyt"
set choice [gets stdin]
set choice [string toupper $choice]
if {$choice eq "E"} {

set fname [gets stdin]
puts "ENCRYPTION IN PROGRESS ......"
set new [split $fname {.}]
set newfile [lindex $new 0]

# open the file in read mode
set fileid1 [open original.txt r]
set fileid2 [open en w]

# read the input file
set cont [read $fileid1]
close $fileid1

#split the file contents into constituent characters
set mylist [split $cont {}]

# process character-wise and encrypt
foreach {char} $mylist {
	set asc [scan $char %c] ; # scan command here is used to convert char to ascii
	set res 1
	for {set i 1} {$i <= $e} {incr i} {
		set res [expr "($res * $asc) % $n"]
	}
	set newchar [format "%c" $res]
	puts -nonewline $fileid2 $newchar
}
close $fileid2
puts "ENCRYPTION COMPLETE ......"
}

puts "Paring of keys started"

puts "Enter the key"
set msg1 [gets stdin]
set filename "key.txt"
set fileId [open $filename "w"]
puts -nonewline $fileId $msg1
close $fileId 

puts "Enter the private key"
set msg2 [gets stdin]
set filename "pkey.txt"
set fileId [open $filename "w"]
puts -nonewline $fileId $msg2
close $fileId 

set msg1 [split $msg1 {}]
puts $msg1 
set msg2 [split $msg2 {}] 
puts $msg2
set str1 0 

for {set i 0} {$i < [llength $msg1]} {incr i} { 
    set temp [lappend temp [expr [lindex $msg1 $i]^[lindex $msg2 $i]]] 
} 
puts $temp 

for {set i 0} {$i < [llength $temp]} {incr i} { 
    set str1 [concat $str1[lindex $temp $i]] 
} 

set filename "paring.txt"
set fileId [open $filename "w"]
puts -nonewline $fileId $str1
close $fileId 

set fname [gets stdin]
puts "ENCRYPTION OF PARING KEYS IN PROGRESS ......"
set new [split $fname {.}]
set newfile [lindex $new 0]

# open the file in read mode
set fileid1 [open paring.txt r]
set fileid2 [open en2 w]

# read the input file
set cont [read $fileid1]
close $fileid1

#split the file contents into constituent characters
set mylist [split $cont {}]

# process character-wise and encrypt
foreach {char} $mylist {
	set asc [scan $char %c] ; # scan command here is used to convert char to ascii
	set res 1
	for {set i 1} {$i <= $e} {incr i} {
		set res [expr "($res * $asc) % $n"]
	}
	set newchar [format "%c" $res]
	puts -nonewline $fileid2 $newchar
}
close $fileid2
puts "ENCRYPTION COMPLETE ......"
puts "Secrete key generated"


puts "Do you want to decrypt the massage ? Enter 'y' to decrypt the Key"
set choice [gets stdin]
set choice [string toupper $choice]
if {$choice eq "Y"} {
puts "Enter the secrete key to decrypt message"
set str2 [gets stdin]
set filename "sec.txt"
set fileId [open $filename "w"]
puts -nonewline $fileId $str2
close $fileId
puts [string compare $str1 $str2]}
if {[string compare $str1 $str2] == 0} {
puts "key correct"
source "decrypt.tcl"
}

if {[string compare $str1 $str2] == 1} {
puts "Key incorrect"
}
if {[string compare $str1 $str2] == -1} {
puts "Key incorrect"
}


