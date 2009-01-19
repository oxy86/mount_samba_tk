#!/usr/bin/wish

#Στην Tcl, αναφερόμαστε στο βασικό παράθυρο με μια τελεία (.).  
#Με την wm title καθορίζουμε τον τίτλο του παραθύρου . σε "Connect to Share".
wm title . "Connect to Samba share"

#Δημιουργίου ενός 'κάδρου' μέσα στο βασικό παράθυρο με πλάτος περιθωρίου 2
frame .rc -borderwidth 2 
#Προβολή του κάδρου
pack .rc

global aList vList val

set aList "
{REMOTE IP} 
{RFOLDER  }
{LFOLDER  }
{USERNAME }
{PASSWORD }"

# Ορισμοί μεταβλητών - η vList είναι μια λίστα, αρχικά κενή.
set vList {}

# Στην Tcl δεν ορίζουμε τύπους στις μεταβλητές.
set maxl 0
set i 0


frame .rc.fff -height 40 
pack .rc.fff

entry .rc.ent -width 50
pack .rc.ent

foreach a $aList {
	#Δημιουργία πεδίου μιας γραμμής με όνομα .rc.fff.sub1 κοκ.
	set ff [frame .rc.fff.sub$i]
	pack $ff
	#Προσθήκη στο πεδίο μιας ετικέτας με μήκος 10 χαρακτήρων.
	#Το κείμενο της είναι το αντίστοιχο στοιχείο του aList.
	label $ff.lab -text $a  -width 10
	#Προσθήκη ενός πεδίου εισαγωγής δίπλα από την ετικέτα
	entry $ff.ent
	#Σύνδεση του πεδίου εισαγωγής με την υπορουτίνα argEnter
	#Η υπορουτίνα θα εκτελείται όταν ο χρήστης πατάει το πλήκτρο Return μέσα στο πεδίο εισαγωγής
	bind $ff.ent <Key-Return> [list argEnter .rc.ent $a ]
	#Επίσης θα εκτελείται όταν ο χρήστης πατάει το πλήκτρο Tab μέσα στο πεδίο εισαγωγής	
	bind $ff.ent <Tab> [list argEnter .rc.ent $a ]
	#Εισαγωγή του i στοιχείου της vList στο πεδίο εισαγωγής.
	$ff.ent insert 0 [lindex $vList $i]
	#Προβολή της ετικέτας και του πεδίου εισαγωγής
	pack $ff.lab $ff.ent -side left -in $ff
	#Αύξηση του i κατά μια μονάδα
	incr i
	}


proc argEnter { w a } {
	global aList vList 
	# Βρες τον δείκτη του a μέσα στην aList
	set idx [lsearch $aList $a]
	# Θέσε ότι περιέχει το πεδίο εισαγωγής της αντίστοιχης γραμμής στην μεταβλητή va
	set val [.rc.fff.sub$idx.ent get]
	if { $val == "" } {
			tk_messageBox -message "Warning. You did not enter something."
		} else {
			set idx2 [lsearch $vList $val]
			#tk_messageBox -message "You entered: $val  - idx2: $idx2  - vList: $vList . "
			if {  $idx2 >= 0  } { 	# ή != -1
				tk_messageBox -message "Value already in the list. Skipping."
			} else {
				lappend vList $val
                              # tk_messageBox -message "Appending to list..."
			}
			
		}
	}
button .rc.b -text "Προσάρτηση" -command  { .rc.ent insert 0 [set my [exec uname -r] ] }
				
pack .rc.b

button .rc.com -text "Εντολη" -command {
			
			set IP [lindex $vList 0 ]
			set RFOLDER [lindex $vList 1 ] 
			set LFOLDER  [lindex $vList 2 ]
			set USERNAME [lindex $vList 3 ]
			set PASSWORD [lindex $vList 4 ]
			set fullCommand ""
			append  fullCommand "smbmount //" $IP "/" $RFOLDER "  " $LFOLDER " -o username=" $USERNAME ",password=" $PASSWORD
			#tk_messageBox -message $IP
			#tk_messageBox -message $RFOLDER
			
			.rc.ent insert 0 $fullCommand
			#.rc.ent insert [string length $com] $IP 
			 #.rc.ent insert [set pre1 [expr [string length $IP]+1 + 6 ] ] $RFOLDER
			#.rc.ent insert [set pre2 [expr [string length $pre1] + 1 ] ] $LFOLDER
			#.rc.ent insert [set pre3 [expr [string length $pre2] + 1 ] ] $USERNAME
			#.rc.ent insert [set pre4 [expr [string length $pre3] + 1 ] ] $PASSWORD
		 }
pack .rc.com

button .rc.c -text "Eξοδος" -command {exit}
pack .rc.c



