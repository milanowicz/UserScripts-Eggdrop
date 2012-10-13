# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                                         # #
#          acl (autocontrolllist) - Script v1.2 by stylus740 & Milanowicz     # 
# #                                                                         # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                                         # #
#   Das Script ist dafür gedacht, das der ein registierter Bot, nicht         #
#   registierte Nicks in verschiedene Modes hochstufen soll. Es kann für      #
#   mehere Channel wie Modes verwendet werden.     						      #
#   Modes sind v für Voice, h für Halfop, o für Op einzuteilen                #
#   User künnen sich selber vom Bot hochstufen lassen, wenn sie nicht den     #
#   Mode haben, den sie sonst haben. Einfach !up eintippen 					  # 
# #                                                                         # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

###############################################################################
# History:                                                                    #
# 1.0		Erstes Release       autovoicelist by stylus740                   #
# 1.2		Zweites Release	     autocontrolllist by Milanowicz               #
###############################################################################

# Konfigurationsteil:
# Definition des Datenfiles für berechtigte User
set acl_ni(datafile) "scripts/acl.dat"

# Farbcodes für die Ausgaben
set coacl  "\00303"								;# ACL Name
set cocom  "\00307"								;# Befehls Farbe
set couser "\00315"								;# Nick Farbe
set comode "\00304"								;# Mode Farbe
set cochan "\00305"								;# Channel Farbe
set codes  "\00314"								;# Text und Beschreibungs Farbe
set cowarn "\00304"								;# Warn Text
set cohead "\00303"								;# überschrift der Ausgabe

# Befehle für manuelle hoch- und runtersetzen des Nick für die IRC Benutzer
set acl_ni(cmdch)  "!"							;# Aufruf Zeichen für den IRC
set acl_ni(up)     "up"							;# Befehlsaufruf zum hochsetzen
set acl_ni(down)   "down"						;# Befehlsaufruf zum runtersetzen
# Verwaltung der Nicks ohne Admin
set acl_ni(voice)  "voice"						;# Befehlsaufruf zum Voice setzen eines Nick
set acl_ni(dvoice) "dvoice"						;# Dem Nick Voice nehmen
set acl_ni(half)   "half"						;# Befehlsaufruf zum HalfOP setzen eines Nick
set acl_ni(dhalf)  "dhalf"						;# Dem Nick HalfOP nehmen
set acl_ni(op)     "op"							;# Befehlsaufruf zum HalfOP setzen eines Nick
set acl_ni(lnicks) "listacl"					;# Befehlsaufruf zum Anzeigen der Nicks des Channel
set acl_ni(help)   "aclhelp"					;# Befehlsaufruf zum Anzeigen der Hilfe

# Zugriffsfehlermeldung 
set acl_ni(text1)  "$codes Leider nich :-(, frag den Meister"
# Keine Daten vorhanden Fehlermeldung
set acl_ni(text2)  "$codes Keine Daten gespeichert!"
# überschriftanzeige bei der Auflistung
set acl_ni(text3)  "$cohead Eingetragene Nicks in ACL:"

###############################################################################
####################  Benutzung der AutoConrtollList  #########################
###############################################################################
# Mügliche Befehle im IRC :			            				              #
#													                          #
# !up                       Manuelles hochsetzen des Mode                     #
# !down						Manuelles runtersetzen des Mode                   #
# !voice <Nick>				Den Mode Voice für den Benutzer im Channel setzen #
# !dvoice <Nick>			Dem Nick Voice wieder entziehen                   #
# !half <Nick>				Den Mode HalfOP für den Benutzer im Channel setzen#
# !dhalf <Nick>				Dem Nick HalfOP wieder entziehen				  #
# !op <Nick>				Den Mode OP für den Benutzer im Channel setzen    #
# !listacl					Listet die User des akutellen Channel auf         #
# !aclhelp					Hilfe Anzeige der IRC Befehle					  #
###############################################################################
# Mügliche Message an den Bot :		            				              #
#													                          #
# /msg <Botname> aclhelp						Hilfen zur Bedienung          #
# /msg <Botname> addacl <nick> <mode> <channel>	User zur Liste hinzufügen     #
# /msg <Botname> delacl <nick> <mode> <channel>	User von Liste lüschen		  #
# /msg <Botname> listacl [channel]				Eintrüge anzeigen			  #
###############################################################################
# Mügliche Befehle in der Partyline :							              #
#													                          #
# .chanset #chan +acl		Aktivierung des scripts in Channel #chan		  #
# .chanset #chan -acl		Deaktivierung des scripts in Channel #chan		  #
#-----------------------------------------------------------------------------#
# .aclhelp							Hilfen zur Bedienung			          #
# .addacl <nick> <mode> <channel>	User zur Liste hinzufügen		          #
# .delacl <nick> <mode> <channel>	User von Liste lüschen			          #
# .listacl [channel]				Eintrüge anzeigen				          #
###############################################################################

#######################################################################################
####   Ab hier nur editieren, wenn man genau weiü, was man tut. Beginn des Codes   ####
#######################################################################################

setudef flag acl								;# Zur Aktivierung der userdefined flags
set acl_ni(version) v1.2						;# Variable für Version setzten

bind pub -|- $acl_ni(cmdch)$acl_ni(up) do_up		;# User künnen sich vom Bot hochsetzen lassen, wenn man auf der Liste steht
bind pub -|- $acl_ni(cmdch)$acl_ni(down) do_down	;# User künnen sich vom Bot runtersetzen lassen
bind pub -|- $acl_ni(cmdch)$acl_ni(voice) do_voice	;# User Voice geben
bind pub -|- $acl_ni(cmdch)$acl_ni(dvoice) do_dvoice ;# User Voice nehmen
bind pub -|- $acl_ni(cmdch)$acl_ni(half) do_half	;# User HalfOP geben
bind pub -|- $acl_ni(cmdch)$acl_ni(dhalf) do_dhalf	;# User HalfOP nehmen
bind pub -|- $acl_ni(cmdch)$acl_ni(op) do_op		;# User OP geben
bind pub -|- $acl_ni(cmdch)$acl_ni(lnicks) show_chan ;# Zeigt den Akutellen Channel mit den gespeicherten Nicks an
bind pub -|- $acl_ni(cmdch)$acl_ni(help) show_help  ;# Anzeigen der ACL Hilfe für die IRC Befehle

bind dcc n|n addacl add_users					;# User hinzufügen
bind dcc n|n delacl del_users					;# User hinzufügen
bind dcc n|n listacl list_users					;# User anzeigen
bind dcc n|n aclhelp help_users					;# Hilfe anzeigen

bind msg n|n addacl m_add_users					;# User hinzufügen
bind msg n|n delacl m_del_users					;# User hinzufügen
bind msg n|n listacl m_list_users				;# User anzeigen
bind msg n|n aclhelp m_help_users				;# Hilfe anzeigen

bind join - * join:acl_check					;# User bei Joinen prüfen
bind nick - * nick:acl_check					;# Falls der Bot mal einen anderen Nick hat


### Hilfe ausgaben Funktionen
### Partyline Funktion
proc help_users {handle idx args} {
	global coacl cocom couser comode cochan codes cowarn	;# Farb Variablen definieren
	
	putlog "$codes Die Steuerung von$coacl ACL$codes erfolgt über die Partyline mit den folgenden Befehlen:"
	putlog "$cowarn Mode ohne + oder - eingeben !"
	putlog "$cocom.addacl $couser<nick> $comode<mode> $cochan<chan>   $codes Nick mit Channel hinzufügen oder ündern"
	putlog "$cocom.delacl $couser<nick> $comode<mode> $cochan<chan>   $codes Den angegebenen Nick lüschen"
	putlog "$cocom.listacl                       $codes Sümtliche berechtigten User-Eintrüge anzeigen"
	putlog "$cocom.aclhelp                       $codes Diese Hilfemeldung anzeigen"
}												;# End Procedure

### PrivatChat Funktion
proc m_help_users {nick host hand args} {
	global coacl cocom couser comode cochan codes cowarn	;# Farb Variablen definieren
	
	puthelp "PRIVMSG $nick :$codes Die Steuerung von$coacl ACL$codes erfolgt über den Private Chat mit den folgenden Befehlen:"
	puthelp "PRIVMSG $nick :$cowarn Mode ohne + oder - eingeben !"
	puthelp "PRIVMSG $nick :$cocom/msg <Botname> addacl $couser<nick> $comode<mode> $cochan<chan>   $codes Nick mit Channel hinzufügen oder ündern"
	puthelp "PRIVMSG $nick :$cocom/msg <Botname> delacl $couser<nick> $comode<mode> $cochan<chan>   $codes Den angegebenen Nick lüschen"
	puthelp "PRIVMSG $nick :$cocom/msg <Botname> listacl                       $codes Sümtliche berechtigten User-Eintrüge anzeigen"
	puthelp "PRIVMSG $nick :$cocom/msg <Botname> aclhelp                       $codes Diese Hilfemeldung anzeigen"
}												;# End Procedure

### Ausgabe der ACL Hilfe in den IRC für den akutellen Channel, nur für Voice, HalfOp oder OP
### IRC Funktion
proc show_help {nick uhost handle chan args} {

 	if {![acl:active $chan]} { return 0 } 		;# falscher Channel: nix machen

	global coacl cocom couser comode cochan codes cowarn ;# Farb Variablen definieren
	global acl_ni								;# Datenstrukturen public definieren

	if { [isvoice $nick $chan] || [ishalfop $nick $chan] || [isop $nick $chan] } {
		putserv "NOTICE $nick :$codes Die Steuerung von$coacl ACL$codes über den IRC erfolgt mit den folgenden Befehlen:"
		putserv "NOTICE $nick :$cocom !up$codes                    Sich hochsetzen vom Mode"
		putserv "NOTICE $nick :$cocom !down$codes                  Sich runtersetzen vom Mode"
		putserv "NOTICE $nick :$cocom !voice$couser <Nick>$codes          Voice für den Nick im Channel setzen"
		putserv "NOTICE $nick :$cocom !dvoice$couser <Nick>$codes         Dem Nick Voice wegnehmen!"
		putserv "NOTICE $nick :$cocom !half$couser <Nick>$codes           HalfOP für den Nick im Channel setzen"
		putserv "NOTICE $nick :$cocom !dhalf$couser <Nick>$codes          Dem Nick HalfOP wieder wegnehmen!"
		putserv "NOTICE $nick :$cocom !op$couser <Nick>$codes             OP für den Nick im Channel setzen"
		putserv "NOTICE $nick :$cocom !listacl $codes              Zeigt Nicks des aktuellen Channel an"
		putserv "NOTICE $nick :$cocom !aclhelp $codes              Anzeige der Hilfe"
	} else {
		putserv "NOTICE $nick :$acl_ni(text1)"
	}											;# end if check ob Voice, HalfOP oder OP hat der Nick
}												;# End Procedure

### Nicks laden
proc init_users {} {
 global acl_nick acl_ni					   		;# Datenstrukturen public definieren
 global codes									;# Farb Variablen definieren
 
	if {[file exists $acl_ni(datafile)]} {		;# Falls File vorhanden
		putlog "$codes Userdaten aus der $acl_ni(datafile) Datei erfolgreich geladen"
		set in [open $acl_ni(datafile) r]		;# Datenfile im read modus üffnen

		while {![eof $in]} {					;# solange kein EOF
			set vline [gets $in]                ;# Zeile holen

			if {[eof $in]} {break}  			;# Falls EOF, Ende von while
			
			set inick [lindex $vline 0]			;# Nick extrahieren
			set imode [lindex $vline 1]			;# Mode extrahieren
			set ichan [lrange $vline 2 end]		;# Channel extrahieren
			set ientry "$inick&$imode&$ichan"	;# Kombination Nick&Chan bauen
			set acl_nick($ientry) $ientry       ;# Array Datenfeld belegen
		}								   		;# End while
		close $in							   	;# Datei schlieüen
	}								   			;# End If (dataexist)
}								   				;# End Procedure
init_users

### Liste User Funktionen
### Partyline Funktion
proc list_users {handle idx args} {
 global acl_nick acl_ni					   		;# Datenstrukturen public definieren
 global codes couser comode cochan cohead 		;# Farb Variablen definieren

	if {[string length $args] > 2} {			; # Prüft ob ein Argument eingeben wurde	
		set atmp [lindex $args 0]				;# Channel extrahieren
		set atmp [form $atmp]					;# Channel formatieren
		set select "0"							;# Nur ein bestimmer Channel soll angezeigt werden
	} else {									;# End if
		set select "1"							;# Alle Nicks sollen angezigt werden
	}

	if {[info exists acl_nick]} {				;# Falls Felder definiert sind
		putlog "$acl_ni(text3)" 				;# überschrift anzeigen in Grün

		foreach search [array names acl_nick] { ;# Für jeden Eintrag
			if {$search != 0} {					;# wenn kein leerer Eintrag

				set acmd [split $search "&"]	;# Eintrag bei "&" aufsplitten
				set inick [lindex $acmd 0]		;# erstes Argument ist Nick
				set inick [form $inick]			;# Nick formatieren
				set imode [lindex $acmd 1]		;# Mode extrahieren
				set imode [form $imode]			;# Mode formatieren
				set ichan [lrange $acmd 2 end]	;# Der gesamte Rest ist der Channel
				set ichan [form $ichan]			;# Chan formatieren
				
				if {$select != 1} {				;# Prüft ob alle oder ein Channel
					if {$atmp == $ichan} {		;# Gibt nur den eingeben Channel aus
						putlog "$codes Stats: $couser$inick $comode$imode $cochan$ichan"
					}							;# End if 
				} else {						;# Falls kein Argument eingegeben wurde, alle zeigen
					putlog "$codes Stats: $couser$inick $comode$imode $cochan$ichan"
				}								;# End if (select)
			}							   		;# End if (search)
		}								   		;# End foreach
	} else {						   			;# Falls keine Struktur vorhanden
    putlog "$acl_ni(text2)"   					;# Fehler anzeigen
	}							   				;# End if
}								   				;# End Procedure

### PrivatChat Funktion
proc m_list_users {nick host hand args} {
 global acl_nick acl_ni					   		;# Datenstrukturen public definieren
 global codes couser comode cochan cohead 		;# Farb Variablen definieren
 
	if {[string length $args] > 2} {			;# Prüft ob ein Argument eingeben wurde	
		set atmp [lindex $args 0]				;# Channel extrahieren
		set atmp [form $atmp]					;# Channel formatieren
		set select "0"							;# Nur ein bestimmer Channel soll angezeigt werden
	} else {									;# End if
		set select "1"							;# Alle Nicks sollen angezigt werden
	}
	
	if {[info exists acl_nick]} {				;# Falls Felder definiert sind
		puthelp "PRIVMSG $nick :$acl_ni(text3)" ;# überschrift anzeigen in Grün

		foreach search [array names acl_nick] { ;# Für jeden Eintrag
			if {$search != 0} {					;# wenn kein leerer Eintrag

				set acmd [split $search "&"]	;# Eintrag bei "&" aufsplitten
				set inick [lindex $acmd 0]		;# erstes Argument ist Nick
				set inick [form $inick]			;# Nick formatieren
				set imode [lindex $acmd 1]		;# Mode extrahieren
				set imode [form $imode]			;# Mode formatieren
				set ichan [lrange $acmd 2 end]	;# Der gesamte Rest ist der Channel
				set ichan [form $ichan]			;# Chan formatieren
				
				if {$select != 1} {				;# Prüft ob alle oder ein Channel
					if {$atmp == $ichan} {		;# Gibt nur den eingeben Channel aus
						puthelp "PRIVMSG $nick :$codes Stats: $couser$inick $comode$imode $cochan$ichan"
					}							;# End if 
				} else {						;# Falls kein Argument eingegeben wurde, alle zeigen
					puthelp "PRIVMSG $nick :$codes Stats: $couser$inick $comode$imode $cochan$ichan"
				}								;# End if (select)
			}							   		;# End if (search)
		}								   		;# End foreach
	} else {						   			;# Falls keine Struktur vorhanden
    puthelp "PRIVMSG $nick :$acl_ni(text2)"   	;# Fehler anzeigen
	}							   				;# End if
}								   				;# End Procedure

### Add User Funktionen
### Partyline Funktion
proc add_users {handle idx args} {
 global acl_nick acl_ni					   		;# Datenstrukturen public definieren
 global codes couser comode cochan				;# Farb Variablen definieren
 
 set acmd [lindex $args 0]				   		;# Befehlszeile extrahieren
 set inick [lindex $acmd 0]				   		;# erstes Argument ist Nick
 set inick [form $inick]				   		;# Nick formatieren
 set imode [lindex $acmd 1]						;# Mode extrahieren
 set imode [form $imode]						;# Mode formatieren
 set imode [string tolower $imode]	        	;# Mode in Kleinschreibung
 set ichan [lrange $acmd 2 end]			   		;# Der gesamte Rest ist der Channel
 set ichan [form $ichan]				   		;# Chan formatieren
 set ientry "$inick&$imode&$ichan"				;# Kombination Nick&Mode&Chan bauen
 set acl_nick($ientry) $ientry                  ;# Array Datenfeld (neu) belegen

 writefile							   			;# Datei schreiben
 putlog "$codes User $couser$inick$codes mitm Mode $comode$imode$codes in Channel $cochan$ichan$codes eingefügt in $acl_ni(datafile)"
 
	if {[onchan $inick $ichan]} {
		pushmode $ichan +$imode $inick 			;# User setzen
	}
}								   				;# End Procedure

### PrivatChat Funktion
proc m_add_users {nick host hand args} {
 global acl_nick acl_ni					   		;# Datenstrukturen public definieren
 global codes couser comode cochan				;# Farb Variablen definieren
 
 set acmd [lindex $args 0]				   		;# Befehlszeile extrahieren
 set inick [lindex $acmd 0]				   		;# erstes Argument ist Nick
 set inick [form $inick]				   		;# Nick formatieren
 set imode [lindex $acmd 1]						;# Mode extrahieren
 set imode [form $imode]						;# Mode formatieren
 set imode [string tolower $imode]	        	;# Mode in Kleinschreibung
 set ichan [lrange $acmd 2 end]			   		;# Der gesamte Rest ist der Channel
 set ichan [form $ichan]				   		;# Chan formatieren
 set ientry "$inick&$imode&$ichan"				;# Kombination Nick&Mode&Chan bauen
 set acl_nick($ientry) $ientry                  ;# Array Datenfeld (neu) belegen

 writefile							   			;# Datei schreiben
 puthelp "PRIVMSG $nick :$codes User $couser$inick$codes mitm Mode $comode$imode$codes in Channel $cochan$ichan$codes eingefügt in $acl_ni(datafile)"

	if {[onchan $inick $ichan]} {
		pushmode $ichan +$imode $inick 			;# User setzen
	}
}								   				;# End Procedure

### Delete User Funktionen
### Partyline Funktion
proc del_users {handle idx args} {
 global acl_nick acl_ni					   		;# Datenstrukturen public definieren
 global codes couser comode cochan				;# Farb Variablen definieren
 
 set acmd [lindex $args 0]				   		;# Befehlszeile extrahieren
 set inick [lindex $acmd 0]				  		;# erstes Argument ist Nick
 set inick [form $inick]				  		;# Nick formatieren
 set imode [lindex $acmd 1]						;# Mode 
 set imode [form $imode]						;# Mode formatieren
 set imode [string tolower $imode]	        	;# Mode in Kleinschreibung
 set ichan [lrange $acmd 2 end]			  		;# Der gesamte Rest ist der Channel
 set ichan [form $ichan]				   		;# Chan formatieren
 set ientry "$inick&$imode&$ichan"				;# Eintrag nick&mode&chan montieren

	if {([info exists acl_nick($ientry)])} {    ;# wenn der Eintrag existiert 
		unset acl_nick($ientry)				 	;# Array Datenfeld freigeben
		writefile
		putlog "$codes Lüsche--> User $couser$inick$codes mitm Mode $comode$imode$codes aus'm Channel $cochan$ichan$codes wurde aus der $acl_ni(datafile) Datei entfernt!"
	} else {							 		;# Falls Nick nicht vorhanden
		putlog "$codes! Eintrag $couser$inick $comode$imode $cochan$ichan$codes ist nicht gespeichert!"	
	}											;# End if (info)

	if {[onchan $inick $ichan]} {				;# Prüfen ob User auf dem Channel is
		pushmode $ichan -$imode $inick 			;# User setzen
	}											;# end if 
}												;# End Procedure

### PrivatChat Funktion
proc m_del_users {nick host hand args} {
 global acl_nick acl_ni					   		;# Datenstrukturen public definieren
 global codes couser comode cochan				;# Farb Variablen definieren
 
 set acmd [lindex $args 0]				   		;# Befehlszeile extrahieren
 set inick [lindex $acmd 0]				  		;# erstes Argument ist Nick
 set inick [form $inick]				  		;# Nick formatieren
 set imode [lindex $acmd 1]						;# Mode 
 set imode [form $imode]						;# Mode formatieren
 set imode [string tolower $imode]	        	;# Mode in Kleinschreibung
 set ichan [lrange $acmd 2 end]			  		;# Der gesamte Rest ist der Channel
 set ichan [form $ichan]				   		;# Chan formatieren
 set ientry "$inick&$imode&$ichan"				;# Eintrag nick&mode&chan montieren

	if {([info exists acl_nick($ientry)])} {    ;# wenn der Eintrag existiert 
		unset acl_nick($ientry)				 	;# Array Datenfeld freigeben
		writefile
		puthelp "PRIVMSG $nick :$codes Lüsche--> User $couser$inick$codes mitm Mode $comode$imode$codes aus'm Channel $cochan$ichan$codes wurde aus der $acl_ni(datafile) Datei entfernt!"
	} else {							 		;# Falls Nick nicht vorhanden
		puthelp "PRIVMSG $nick :$codes! Eintrag $couser$inick $comode$imode $cochan$ichan$codes ist nicht gespeichert!"	
	}											;# End if (info)

	if {[onchan $inick $ichan]} {				;# Prüfen ob User auf dem Channel is
		pushmode $ichan -$imode $inick 			;# User setzen
	}											;# end if 
}												;# End Procedure

### Zusatz Funktionen im IRC
### falls der Bot mal nich da is
### kann der User nachtrüglich seinen Mode hochsetzen lassen vom Bot
proc do_up {nick uhost handle chan args} {
 global botnick acl_nick acl_ni								;# Datenstrukturen public definieren
 global codes 												;# Farb Variablen definieren

	if {![acl:active $chan]} { return 0 } 					;# falscher Channel: nix machen

 set chan [string tolower $chan]							;# Channel in Kleinschreibung
 set nick [string tolower $nick]							;# Nick in Kleinschreibung
 set acl_see 1												;# Variable für Fehlerausgabe

	if ([isop $botnick $chan]) {							;# Wenn Bot im Channel Op hat
		foreach search [array names acl_nick] {		  		;# Liste aller Eintrüge durchlaufen
			if {$search != 0} {					 			;# wenn kein leerer Eintrag

				set ientry [string tolower $acl_nick($search)] ;# Eintrag (nick&#chan) extrahieren
				set parts [split $ientry "&"] 				;# Das & entfernen
				set inick [lindex $parts 0]		   	   		;# Nick extrahieren
				set inick [string tolower $inick]		    ;# Nick in Kleinschreibung
				set imode [lindex $parts 1]					;# Mode extrahieren
				set imode [string tolower $imode]	        ;# Mode in Kleinschreibung
				set ichan [lindex $parts 2]	   	   			;# Chan extrahieren
				set ichan [string tolower $ichan]	        ;# Chan in Kleinschreibung
		
				if {($nick == $inick) && ($chan == $ichan)} {
					pushmode $chan +$imode $nick			;# User auf den Voice Mode setzen
					set acl_see 0							;# User hat Berechtigung für die Modeünderung
				} 
			}												;# end if search
		} 													;# end for eache
		if {$acl_see != 0} {								;# Wenn man keine Berechigung hat, kommt die Meldung
			putserv "NOTICE $nick :$acl_ni(text1)"
		}													;# end if Fehlermeldung
	}		 												;# end if Bot OP
}															;# End Procedure

### kann der User nachtrüglich seinen Mode runtersetzen lassen vom Bot
proc do_down {nick uhost handle chan args} {
 global botnick acl_nick acl_ni								;# Datenstrukturen public definieren
 global codes 												;# Farb Variablen definieren

	if {![acl:active $chan]} { return 0 } 					;# falscher Channel: nix machen

 set chan [string tolower $chan]							;# Channel in Kleinschreibung
 set nick [string tolower $nick]							;# Nick in Kleinschreibung
 set acl_see 1												;# User hat Berechtigung für die Modeünderung
	
	if ([isop $botnick $chan]) {							;# Wenn Bot im Channel Op hat
		foreach search [array names acl_nick] {		  		;# Liste aller Eintrüge durchlaufen
			if {$search != 0} {					 			;# wenn kein leerer Eintrag

				set ientry [string tolower $acl_nick($search)] ;# Eintrag (nick&#chan) extrahieren
				set parts [split $ientry "&"] 				;# Das & entfernen
				set inick [lindex $parts 0]		   	   		;# Nick extrahieren
				set inick [string tolower $inick]		    ;# Nick in Kleinschreibung
				set imode [lindex $parts 1]					;# Mode extrahieren
				set imode [string tolower $imode]	        ;# Mode in Kleinschreibung
				set ichan [lindex $parts 2]	   	   			;# Chan extrahieren
				set ichan [string tolower $ichan]	        ;# Chan in Kleinschreibung
		
				if {($nick == $inick) && ($chan == $ichan)} {
					pushmode $chan -$imode $nick			;# User runtersetzen
					set acl_see 0							;# User hat Berechtigung
				} 
			}												;# end if search
		} 													;# end for eache
		if {$acl_see != 0} {								;# Wenn man keine Berechigung hat, kommt die Meldung
			putserv "NOTICE $nick :$acl_ni(text1)"
		}													;# end if Fehlermeldung
	}		 												;# end if Bot OP
}															;# End Procedure

### Nachtrüglich Setzen der Nicks im IRC, falls der Admin nicht da is
### Nur HalfOp oder Ops künnen Nick zu Voice hochstufen
proc do_voice {nick uhost handle chan args} {
 global botnick acl_nick acl_ni						;# Datenstrukturen public definieren
 global codes couser comode cochan					;# Farb Variablen definieren
 
 	if {![acl:active $chan]} { return 0 } 			;# falscher Channel: nix machen
 
	if { [ishalfop $nick $chan] || [isop $nick $chan] } {

		set inick [lindex $args 0]				   	;# erstes Argument ist Nick
		set inick [form $inick]				   		;# Nick formatieren
		set ichan [lindex $chan 0]				   	;# Der gesamte Rest ist der Channel
		set ichan [form $ichan]				   		;# Chan formatieren
		set ientry "$inick&v&$ichan"				;# Kombination Nick&v&Chan bauen
		set acl_nick($ientry) $ientry               ;# Array Datenfeld (neu) belegen

		writefile							   		;# Datei schreiben
		putserv "NOTICE $nick :$codes User $couser$inick$codes mitm Mode$comode v$codes in Channel $cochan$ichan$codes eingefügt in $acl_ni(datafile)"
 
		if {[onchan $inick $ichan]} {
			pushmode $ichan +v $inick	 			;# User setzen
		} 
	} else {
		putserv "NOTICE $nick :$acl_ni(text1)"
	}												;# end if check ob HalfOP oder OP
}													;# End Procedure

### Nur HalfOp oder Ops künnen Voice vom Nick nehmen
proc do_dvoice {nick uhost handle chan args} {
 global botnick acl_nick acl_ni						;# Datenstrukturen public definieren
 global codes couser comode cochan					;# Farb Variablen definieren
 
 	if {![acl:active $chan]} { return 0 } 			;# falscher Channel: nix machen
 
	if { [ishalfop $nick $chan] || [isop $nick $chan] } {

		set inick [lindex $args 0]				   	;# erstes Argument ist Nick
		set inick [form $inick]				   		;# Nick formatieren
		set ichan [lindex $chan 0]				   	;# Der gesamte Rest ist der Channel
		set ichan [form $ichan]				   		;# Chan formatieren
		set ientry "$inick&v&$ichan"				;# Kombination Nick&v&Chan bauen
		set acl_nick($ientry) $ientry               ;# Array Datenfeld (neu) belegen

		if {([info exists acl_nick($ientry)])} {    ;# wenn der Eintrag existiert 
			unset acl_nick($ientry)				 	;# Array Datenfeld freigeben
			writefile
			putserv "NOTICE $nick :$codes User --> $couser$inick$codes mit'm Mode$comode v$codes aus'm Channel $cochan$ichan$codes wurde entfernt!"
		} else {							 		;# Falls Nick nicht vorhanden
			putserv "NOTICE $nick :$codes! Eintrag $couser$inick $comode$imode $cochan$ichan$codes ist nicht gespeichert!"	
		}											;# End if (info)

		if {[onchan $inick $ichan]} {
			pushmode $ichan -v $inick	 			;# User setzen
		} 
	} else {										
		putserv "NOTICE $nick :$acl_ni(text1)"
	}												;# end if check ob HalfOP oder OP
}													;# End Procedure

### Nur Ops künnen Nick zu HalfOP hochstufen
proc do_half {nick uhost handle chan args} {
 global botnick acl_nick acl_ni						;# Datenstrukturen public definieren
 global codes couser comode cochan					;# Farb Variablen definieren
 
 	if {![acl:active $chan]} { return 0 } 			;# falscher Channel: nix machen
 
	if { [isop $nick $chan] } {
	
		set inick [lindex $args 0]				   	;# erstes Argument ist Nick
		set inick [form $inick]				   		;# Nick formatieren
		set ichan [lindex $chan 0]				   	;# Der gesamte Rest ist der Channel
		set ichan [form $ichan]				   		;# Chan formatieren
		set	ientry "$inick&h&$ichan"				;# Kombination Nick&h&Chan bauen
		set acl_nick($ientry) $ientry               ;# Array Datenfeld (neu) belegen

		writefile							   		;# Datei schreiben
		putserv "NOTICE $nick :$codes User $couser$inick$codes mitm Mode$comode h$codes in Channel $cochan$ichan$codes eingefügt in $acl_ni(datafile)"
 
		if {[onchan $inick $ichan]} {
			pushmode $ichan +h $inick	 			;# User setzen
		} 

	} else {										
		putserv "NOTICE $nick :$acl_ni(text1)"
	}												;# end if check ob OP
}													;# End Procedure

### Nur Ops künnen HalfOPs nehmen
proc do_dhalf {nick uhost handle chan args} {
 global botnick acl_nick acl_ni						;# Datenstrukturen public definieren
 global codes couser comode cochan					;# Farb Variablen definieren
 
 	if {![acl:active $chan]} { return 0 } 			;# falscher Channel: nix machen
 
	if {[isop $nick $chan]} {

		set inick [lindex $args 0]				   	;# erstes Argument ist Nick
		set inick [form $inick]				   		;# Nick formatieren
		set ichan [lindex $chan 0]				   	;# Der gesamte Rest ist der Channel
		set ichan [form $ichan]				   		;# Chan formatieren
		set ientry "$inick&v&$ichan"				;# Kombination Nick&h&Chan bauen
		set acl_nick($ientry) $ientry               ;# Array Datenfeld (neu) belegen

		if {([info exists acl_nick($ientry)])} {    ;# wenn der Eintrag existiert 
			unset acl_nick($ientry)				 	;# Array Datenfeld freigeben
			writefile
			putserv "NOTICE $nick :$codes User --> $couser$inick$codes mit'm Mode$comode h$codes aus'm Channel $cochan$ichan$codes wurde entfernt!"
		} else {							 		;# Falls Nick nicht vorhanden
			putserv "NOTICE $nick :$codes! Eintrag $couser$inick $comode$imode $cochan$ichan$codes ist nicht gespeichert!"	
		}											;# End if (info)

		if {[onchan $inick $ichan]} {
			pushmode $ichan -v $inick	 			;# User setzen
		} 
	} else {										
		putserv "NOTICE $nick :$acl_ni(text1)"
	}												;# end if check ob HalfOP oder OP
}													;# End Procedure

### Nur Ops künnen Nick zu OP hochstufen
proc do_op {nick uhost handle chan args} {
 global botnick acl_nick acl_ni						;# Datenstrukturen public definieren
 global codes couser comode cochan					;# Farb Variablen definieren
	
	if {![acl:active $chan]} { return 0 } 			;# falscher Channel: nix machen
	
	if { [isop $nick $chan] } {

		set inick [lindex $args 0]				   	;# erstes Argument ist Nick
		set inick [form $inick]				   		;# Nick formatieren
		set ichan [lindex $chan 0]				   	;# Der gesamte Rest ist der Channel
		set ichan [form $ichan]				   		;# Chan formatieren
		set ientry "$inick&o&$ichan"				;# Kombination Nick&o&Chan bauen
		set acl_nick($ientry) $ientry               ;# Array Datenfeld (neu) belegen

		writefile							   		;# Datei schreiben
		putserv "NOTICE $nick :$codes User $couser$inick$codes mitm Mode$comode o$codes in Channel $cochan$ichan$codes eingefügt in $acl_ni(datafile)"
 
		if {[onchan $inick $ichan]} {
			pushmode $ichan +o $inick	 			;# User setzen
		}
	} else {										
		putserv "NOTICE $nick :$acl_ni(text1)"
	}												;# end if check ob OP
}													;# End Procedure

### Ausgabe der ACL in den IRC für den akutellen Channel, nur für HalfOp oder OP
proc show_chan {nick uhost handle chan args} {
 global botnick acl_nick acl_ni								;# Datenstrukturen public definieren
 global codes couser comode cochan cohead					;# Farb Variablen definieren
 
	if {![acl:active $chan]} { return 0 } 					;# falscher Channel: nix machen
	
	if { [ishalfop $nick $chan] || [isop $nick $chan] } {
		if {[info exists acl_nick]} {						;# Falls Felder definiert sind
			putserv "NOTICE $nick :$acl_ni(text3)" 			;# überschrift anzeigen in Grün

			foreach search [array names acl_nick] { 		;# Für jeden Eintrag
				if {$search != 0} {							;# wenn kein leerer Eintrag

					set acmd [split $search "&"]			;# Eintrag bei "&" aufsplitten
					set inick [lindex $acmd 0]				;# erstes Argument ist Nick
					set inick [form $inick]					;# Nick formatieren
					set imode [lindex $acmd 1]				;# Mode extrahieren
					set imode [form $imode]					;# Mode formatieren
					set ichan [lrange $acmd 2 end]			;# Der gesamte Rest ist der Channel
					set ichan [form $ichan]					;# Chan formatieren
				
					if {$ichan == $chan} {
						putserv "NOTICE $nick :$codes Stats: $couser$inick $comode$imode $cochan$ichan"
					}
				}							   				;# End if (search)
			}								   				;# End foreach
		} else {						   					;# Falls keine Struktur vorhanden
			putserv "NOTICE $nick :$acl_ni(text2)" 			;# Fehler anzeigen
		}							   						;# End if 
	} else {												
		putserv "NOTICE $nick :$acl_ni(text1)"
	}														;# End if check ob HalfOP oder OP
}															;# End Procedure

### Zusatzfunktionen für ACL
### Bei einem Join wird der Mode vergeben, wenn der Nick im Datenfile steht
proc join:acl_check {nick uhost handle chan} {
 global botnick acl_nick imode
  
	if {![acl:active $chan]} { return 0 } 					;# falscher Channel: nix machen
  
 set chan [string tolower $chan]							;# Channel in Kleinschreibung
 set nick [string tolower $nick]							;# Nick in Kleinschreibung
  
	if ([isop $botnick $chan]) {							;# Wenn Bot im Channel Op hat
		foreach search [array names acl_nick] {		  		;# Liste aller Eintrüge durchlaufen
			if {$search != 0} {					 			;# wenn kein leerer Eintrag

				set ientry [string tolower $acl_nick($search)] ;# Eintrag (nick&#chan) extrahieren
				set parts [split $ientry "&"] 				;# Das & entfernen
				set inick [lindex $parts 0]		   	   		;# Nick extrahieren
				set inick [string tolower $inick]		    ;# Nick in Kleinschreibung
				set imode [lindex $parts 1]					;# Mode extrahieren
				set imode [string tolower $imode]	        ;# Mode in Kleinschreibung
				set ichan [lindex $parts 2]	   	   			;# Chan extrahieren
				set ichan [string tolower $ichan]	        ;# Chan in Kleinschreibung
		
				if {($nick == $inick) && ($chan == $ichan)} {
					pushmode $chan +$imode $nick			;# User auf den Mode setzen
				}  											;# End if User & Channel check
			}												;# End if search
		} 													;# End foreach
	} 														;# End if Bot OP
}															;# End procedure

### Falls der Bot nich seinen Name hat, geht er die Funktion durch
proc nick:acl_check {nick uhost handle chan newnick} {
 global botnick acl_nick
  
	if {![acl:active $chan]} { return 0 } 					;# Falscher Channel: nix machen
  
 set chan [string tolower $chan]							;# Channel in Kleinschreibung
 set nick [string tolower $nick]							;# Nick in Kleinschreibung
  
	if ([isop $botnick $chan]) {							;# Wenn Bot im Channel Op hat
		foreach search [array names acl_nick] {		   		;# Liste aller Eintrüge durchlaufen
			if {$search != 0} {					 			;# wenn kein leerer Eintrag

				set ientry [string tolower $acl_nick($search)] ;# Eintrag (nick&#chan) extrahieren
				set parts [split $ientry "&"]				;# Das & entfernen
				set inick [lindex $parts 0]		   	   		;# Nick extrahieren
				set inick [string tolower $inick]		    ;# Nick in Kleinschreibung
				set imode [lindex $parts 1]					;# Mode extrahieren
				set imode [string tolower $imode]	        ;# Nick in Kleinschreibung
				set ichan [lindex $parts 2]	   	   			;# Chan extrahieren
				set ichan [string tolower $ichan]	        ;# Nick in Kleinschreibung
		
				if {($nick == $inick) && ($chan == $ichan)} {
					pushmode $chan +$imode $newnick 		;# User setzen
				}    										;# End if User & Channel check
			}												;# End if search
		}													;# End foreach
	} 														;# End if Bot OP
}															;# End procedure


### Zusatz Funktion, zum Entfernen der Leerzeichen aus dem Sting
proc form {formtext} {							;# Formatierung String
	set t [string trimleft $formtext]			;# führende Leerzeichen entfernen
	set t [string trimright $t]					;# folgende Leerzeichen entfernen
	return $t									;# formatierten String zurückliefern
}


### Funktion zum Schreiben der ACL Datei
proc writefile {} {
 global acl_nick acl_ni
 set out [open $acl_ni(datafile) w]			   	;# Datenfile im w modus üffnen (überschreiben)
	foreach search [array names acl_nick] {		;# durchlaufen der Daten arrays
		if {$search != 0} {						;# wenn keine leere Zeile
			set parts [split $search "&"]		;# Eintrag bei "&" aufsplitten
			set inick [lindex $parts 0]			;# Nick extrahieren
			set imode [lindex $parts 1]			;# Mode extrahieren
			set ichan [lindex $parts 2]			;# Channel extrahieren
			set output "$inick $imode $ichan"	;# Output montieren
			puts $out $output					;# Zeile schreiben
		}							         	;# End if (search)
	}											;# End Foreach
	close $out									;# Datei schlieüen
}												;# End procedure


### Funktion zum Prüfen ob ACL lüuft auf dem Channel
proc acl:active {chan} {
	foreach setting [channel info $chan] {		;# "channel info" ist ein TCL Befehl!
		if {[regexp -- {^[\+-]} $setting]} {
			if {$setting == "+acl"} { return 1 }
		}
	}
	return 0
}
### Code End

putlog "$coacl ACL\00300 (AutoControllList) $acl_ni(version) von stylus740 & Aj geladen. (Stand 12.02.07)"
putlog "Eingabe von$cocom \.aclhelp \00300bzw.$cocom \/msg $botnick aclhelp \00300zeigt die Hilfe an"