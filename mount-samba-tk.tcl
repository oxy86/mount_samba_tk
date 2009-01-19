#!/usr/bin/wish


#     Just a simple Tk GUI to facilitate Samba shares mounting.
#     Copyright (C) 2008 Dimitris V. Kalamaras

#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.

#Στην Tcl, αναφερόμαστε στο βασικό παράθυρο με μια τελεία (.).  
#Με την wm title καθορίζουμε τον τίτλο του παραθύρου . σε "Connect to Share".
wm title . "Connect to Samba share"

#Δημιουργίου ενός 'κάδρου' μέσα στο βασικό παράθυρο με πλάτος περιθωρίου 2
frame .rc -borderwidth 2 
#Προβολή του κάδρου
pack .rc

# Ορισμοί καθολικών μεταβλητών -  οι δύο πρώτες είναι λίστες.
global aList vList val

# Περιεχόμενα της aList: οι ετικέτες των πεδίων μας.
set aList "
{REMOTE IP} 
{RFOLDER  }
{LFOLDER  }
{USERNAME }
{PASSWORD }"

# η vList είναι μια λίστα, αρχικά κενή. Εδώ θα βάζουμε τις τιμές των πεδίων.
set vList {}

# Στην Tcl δεν ορίζουμε τύπους στις μεταβλητές.
set maxl 0
set i 0

# Στο .rc.fff θα δημιουργήσουμε 5 πεδία εισαγωγής.
frame .rc.fff -height 40 
pack .rc.fff

# Στο rc.ent θα έχουμε μια γραμμή κειμένου ως "εξοδο".
entry .rc.ent -width 50
pack .rc.ent

# Δημιουργία πεδίων εισαγωγής με ετικέτες. 
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


# Η ρουτίνα argEnter καλείται όταν ο χρήστης πατάει Enter/Return ή Tab στο πεδίο εισαγωγής 
proc argEnter { w a } {
	# Καθολικές μεταβλητές που θα χρειαστούμε
	global aList vList IP RFOLDER LFOLDER USERNAME PASSWORD fullCommand
	# Βρες τον δείκτη του a μέσα στην aList
	set idx [lsearch $aList $a]
	# Θέσε ότι περιέχει το πεδίο εισαγωγής της αντίστοιχης γραμμής στην μεταβλητή val
	set val [.rc.fff.sub$idx.ent get]
	if { $val == "" } {
			tk_messageBox -message "Δεν εισήχθη τίποτα."
		} else {
			set idx2 [lsearch $vList $val]
			#tk_messageBox -message "You entered: $val  - idx2: $idx2  - vList: $vList . "
			if {  $idx2 >= 0  } { 	# ή != -1
				tk_messageBox -message "Υπάρχει στη λίστα.."
			} else {
				 # βάλε το περιεχόμενο της val στην vList.
				lappend vList $val 
                              # tk_messageBox -message "Προσθήκη στη λίστα..."
			}
			
		}
	# Αρχικοποίηση όλων των μεταβλητών με τα δεδομένα που εισήχθησαν.
	set IP [lindex $vList 0 ]
	set RFOLDER [lindex $vList 1 ] 
	set LFOLDER  [lindex $vList 2 ]
	set USERNAME [lindex $vList 3 ]
	set PASSWORD [lindex $vList 4 ]
	set fullCommand  ""
	# Δημιουργία εντολής για το mounting
	# Προσοχη: απαιτείται η εγκατάσταση του smbmount (δες πακέτο smbfs στο Ubuntu/Debian)
	append  fullCommand "smbmount //" $IP "/" $RFOLDER "  " $LFOLDER " -o username=" $USERNAME ",password=" $PASSWORD

}



# Κουμπί για την επιβεβαιωτική προβολή της εντολής προσάρτησης.
button .rc.com -text "Προβολή Εντολής" -command {			
			.rc.ent insert 0 $fullCommand 
		 }
pack .rc.com

# Κουμπί εκτέλεσης της προσάρτησης
button .rc.b -text "Εκτέλεση Εντολής" -command  { 
			.rc.ent insert 0 $fullCommand [exec $fullCommand]	
		}
				
pack .rc.b

# Κουμπί εξόδου από το πρόγραμμα
button .rc.c -text "Eξοδος" -command {exit}
pack .rc.c



