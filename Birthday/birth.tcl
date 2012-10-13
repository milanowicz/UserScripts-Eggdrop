# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                                         # #
#        	  Birthday (Birthday Remember) - Script v1.0 by Milanowicz        # 
# #                                                                         # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                                         # #
#   Das Script soll prüfen, ob einer in vier Tagen Geburtstag hat, und wenn	  #
#   dann postet er alle 18 Stunden den Glückpilz. Falls einer neu in den      #
#   Channel dazu kommt, postet er ihn das auch, wenn er berechtigt ist, es zu #
#   empfangen. Und am Geburtstag wird nachmal ein spezial post gemacht ;-)    #
#   Das Script war bei der Entwicklung nur für einen Channel gedacht. Für     #
#   weitere Channel ist noch Experimental, also viel spaü bei Fummeln ;-)     #
#   Die Auflistung der Geburtstage ist über !birth aufzurufen.                #
# #                                                                         # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

###############################################################################
# History:                                                                    #
# 1.0		Erstes Release       Birthday Remember by Milanowicz              #
###############################################################################

# Konfigurationsteil:
# Channel setzen wo er aktiv sein soll (Nur ein Channel)
set channel "#NoName"
# Farbcode für Chanel
set bdspch "\002\00303No\00306Name"

# Definition der Datenfiles für berechtigte User
# Geburtstag Kalender
set bd_ni(dates) "scripts/birth.dat"
# Die User die es empfangen dürfen
set bd_ni(user) "scripts/birthacl.dat"

# Prüfungszeit in Stunden
set idletime 18

# Farbbodes für die Ausgaben
set cobd "\00303"								;# Birth Name
set bdcom "\00307"								;# Befehls Farbe
set bddes "\00314"								;# Text und Beschreibungs Farbe
set bdwarn "\00304"								;# Warn Text
set bdnick "\00309"								;# Namens Farbe des Datum
set bddate "\00311"								;# Gerburtstag Farbe
set bduser "\00303"								;# Nick Farbe
set bdchan "\00305"								;# Channel Farbe
# Farbcodes für den Geburtstag Post
set bdhappy1 ""

# Befehls für Berechtige User im IRC
set bd_ni(cmd_show) "!birth"					;# Ausgabe der Geburtstage

###################################################################################################
#############################  Benutzung des Birthday Remember  ###################################
###################################################################################################
# Mügliche Befehle im IRC:							                          					  #
#													                          				      #
# !birth						Anzeige der Eintrüge für Berechtige User      					  #
###################################################################################################
# Mügliche Message an den Bot :		            				                      			  #
#													                          					  #
# /msg <Botname> helpbirth						Hilfen zur Bedienung          					  #
# /msg <Botname> addbirth <Name> <Datum>		User zur Liste hinzufügen     					  #
# /msg <Botname> delbirth <Name> <Datum>		User von Liste lüschen		  					  #
# /msg <Botname> listbirth						Eintrüge anzeigen			  					  #
# /msg <Botname> addbirthuser <nick> <channel>	User zur Liste hinzufügen     					  #
# /msg <Botname> delbirthuser <nick> <channel>	User von Liste lüschen		  					  #
# /msg <Botname> listbirthuser					Eintrüge anzeigen			  					  #
###################################################################################################
# Mügliche Befehle in der Partyline:							              					  #
#													                          					  #
# .chanset #chan +bd							Aktivierung des scripts in Channel #chan		  #
# .chanset #chan -bd							Deaktivierung des scripts in Channel #chan		  #
# .chansave										Allgemeine Channel Einstellungen im Bot speichern #
#-------------------------------------------------------------------------------------------------#
# .birthhelp					        		Hilfen zur Bedienung	      					  #
# .addbirth <Name> <Datem> 						Eingabe des Datums            					  #
# .delbirth <Name> <Datem>      				Lüschen des Geburtstags       					  #
# .listbirth									Eintrüge auflisten 			  					  #
# .addbirthuser <Nick> <Channel> 				Eingabe des User und Channel  					  #
# .delbirthuser <Nick> <Channel> 				Lüschen des User und Channel  					  #
# .listbirthuser								Eintrüge auflisten			  					  #
###################################################################################################

###################################################################################################
#########   Ab hier nur editieren, wenn man genau weiü, was man tut. Beginn des Codes   ###########
###################################################################################################

setudef flag bd								;# Zur Aktivierung der userdefined flags

set bd_ni(version) v1.0						;# Version setzen

### Einbindung der IRC Befehle
bind pub -|- $bd_ni(cmd_show) show_birth	;# Anzeige der Geburtstage für Berechtige User Anzeigen

### Einbindung der Partyline Befehle
bind dcc n|n addbirth add_birth
bind dcc n|n delbirth del_birth
bind dcc n|n listbirth list_dates
bind dcc n|n addbirthuser add_bduser
bind dcc n|n delbirthuser del_bduser
bind dcc n|n listbirthuser list_bdusers
bind dcc n|n birthhelp help_birth

### Einbindung der Privatechat Befehle
#bind msg n|n addbirth m_add_birth
#bind msg n|n delbirth m_del_birth
bind msg n|n listbirth m_list_dates
bind msg n|n addbirthuser m_add_bduser
bind msg n|n delbirthuser m_del_bduser
bind msg n|n listbirthuser m_list_bdusers
bind msg n|n birthhelp m_help_birth

### Einbindung von Zusatzfunktionen
#bind join - * join:bd_check
#bind time - * time:bd_check

### Hilfe ausgaben Funktionen
proc help_birth {handle idx args} {
	global bddes bdcom bdnick bddate bduser bdchan bdwarn cobd  	;# Farb Variablen definieren
	
	putlog "$bddes Die Steuerung von$cobd Birthday Remember v1.0$bddes erfolgt über die Partyline:"
	putlog "$bddes Beispiel: 1.1.07 wird in Birth zueingegeben$bdwarn 2007-01-01"
	putlog " "
	putlog "$bddes Geburtstags Verwaltung:"
	putlog "$bdcom.addbirth $bdnick<Name> $bddate<Geburtstag>      $bddes Name und Geburtstag hinzufügen (Datummuster: 2007-01-01)"
	putlog "$bdcom.delbirth $bdnick<Name> $bddate<Geburtstag>      $bddes Name und Geburtstag lüschen (Datummuster: 2007-01-01)"
	putlog "$bdcom.listbirth                         $bddes Anzeigen der Geburtstage"
	putlog " "
	putlog "$bddes Nick Verwaltung:"
	putlog "$bdcom.addbirthuser $bduser<Nick> $bdchan<Channel>     $bddes Nick mit Channel hinzufügen oder ündern"
	putlog "$bdcom.delbirthuser $bduser<Nick> $bdchan<Channel>     $bddes Den angegebenen Nick lüschen"
	putlog "$bdcom.listbirthuser                     $bddes Anzeigen der berechtigen User"
	putlog " "
	putlog "$bdcom.birthhelp                         $bddes Diese Hilfemeldung anzeigen"
}												;# End Procedure

proc m_help_birth {nick host hand args} {
	global bddes bdcom bdnick bddate bduser bdchan bdwarn cobd  	;# Farb Variablen definieren
	
	puthelp "PRIVMSG $nick :$bddes Die Steuerung von$cobd Birthday Remember v1.0$bddes erfolgt über den Private Chat:"
	puthelp "PRIVMSG $nick :$bddes Beispiel: 1.1.07 wird in Birth zueingegeben$bdwarn 2007-01-01"
	puthelp "PRIVMSG $nick : "
	puthelp "PRIVMSG $nick :$bddes Geburtstags Verwaltung:"
	puthelp "PRIVMSG $nick :$bdcom/msg <Botname> addbirth $bdnick<Name> $bddate<Geburtstag>      $bddes Name und Geburtstag hinzufügen (Datum: 2007-01-01)"
	puthelp "PRIVMSG $nick :$bdcom/msg <Botname> delbirth $bdnick<Name> $bddate<Geburtstag>      $bddes Name und Geburtstag lüschen (Datum: 2007-01-01)"
	puthelp "PRIVMSG $nick :$bdcom/msg <Botname> listbirth                         $bddes Anzeigen der Geburtstage"
	puthelp "PRIVMSG $nick : "
	puthelp "PRIVMSG $nick :$bddes Nick Verwaltung:"
	puthelp "PRIVMSG $nick :$bdcom/msg <Botname> addbirthuser $bduser<Nick> $bdchan<Channel>     $bddes Nick mit Channel hinzufügen oder ündern"
	puthelp "PRIVMSG $nick :$bdcom/msg <Botname> delbirthuser $bduser<Nick> $bdchan<Channel>     $bddes Den angegebenen Nick lüschen"
	puthelp "PRIVMSG $nick :$bdcom/msg <Botname> listbirthuser                     $bddes Anzeigen der berechtigen User"
	puthelp "PRIVMSG $nick : "
	puthelp "PRIVMSG $nick :$bdcom/msg <Botname> birthhelp                         $bddes Diese Hilfemeldung anzeigen"
}												;# End Procedure

### Geburtstage laden
proc init_bd {} {
 global bd_dates bd_ni							;# Datenstrukturen public definieren
 global bddes									;# Farb Variablen definieren

 if {[file exists $bd_ni(dates)]} {		   	;# Falls File vorhanden
		putlog "$bddes Geburtstage aus der $bd_ni(dates) Datei erfolgreich geladen"
		set in [open $bd_ni(dates) r]		;# Datenfile im read modus üffnen

		while {![eof $in]} {					;# solange kein EOF
			set vline [gets $in]                ;# Zeile holen

			if {[eof $in]} {break}  			;# Falls EOF, Ende von while
				set bd_name [lindex $vline 0]	;# Nick extrahieren
				set bd_date [lindex $vline 1]	;# Channel extrahieren
				set ientry "$bd_name&$bd_date"	;# Kombination Nick&Chan bauen
				set bd_dates($ientry) $ientry   ;# Array Datenfeld belegen
		}								   		;# End while
		close $in							   	;# Datei schlieüen
	}								   			;# End If (dataexist)
}								   				;# End Procedure
init_bd

### Auflisten der Geburtstage
proc list_dates {handle idx args} {
 global bd_dates bd_ni						  	;# Datenstrukturen public definieren
 global bddes bdnick bddate cobd				;# Farb Variablen definieren

	if {[info exists bd_dates]} {				;# Falls Felder definiert sind
		putlog "$bddes Eingetragene Geburtstage in$cobd Birth$bddes:"

		foreach search [array names bd_dates] { ;# Für jeden Eintrag
			if {$search != 0} {					;# wenn kein leerer Eintrag
				set acmd [split $search "&"]	;# Eintrag bei "&" aufsplitten
				set bd_name [lindex $acmd 0]	;# erstes Argument ist Name
				set bd_name [form $bd_name]		;# Name formatieren
				set bd_date [lrange $acmd 1 end] ;# Der gesamte Rest ist das Datum
				set bd_date [form $bd_date]		;# Datum formatieren

				putlog "$bddes Stats: $bdnick$bd_name $bddate$bd_date"
			}							   		;# End if (search)
		}								   		;# End foreach
	} else {							   		;# Falls keine Struktur vorhanden
		putlog "$bddes Keine Daten gespeichert!"   	;# Fehler anzeigen
	}							   				;# End if
}								   				;# End Procedure

proc m_list_dates {nick host hand args} {
 global bd_dates bd_ni						  	;# Datenstrukturen public definieren
 global bddes bdnick bddate cobd				;# Farb Variablen definieren

	if {[info exists bd_dates]} {			   	;# Falls Felder definiert sind
		putlog "$bddes Eingetragene Geburtstage in$cobd Birth$bddes:"

		foreach search [array names bd_dates] { ;# Für jeden Eintrag
			if {$search != 0} {					;# wenn kein leerer Eintrag
			set acmd [split $search "&"]		;# Eintrag bei "&" aufsplitten
			set bd_name [lindex $acmd 0]		;# erstes Argument ist Name
			set bd_name [form $bd_name]			;# Name formatieren
			set bd_date [lrange $acmd 1 end]	;# Der gesamte Rest ist das Datum
			set bd_date [form $bd_date]			;# Datum formatieren

			puthelp "PRIVMSG $nick :$bddes Stats: $bdnick$bd_name $bddate$bd_date"
			}							   		;# End if (search)
		}								   		;# End foreach
	} else {							   		;# Falls keine Struktur vorhanden
    puthelp "PRIVMSG $nick :$bddes Keine Daten gespeichert!"   	;# Fehler anzeigen
	}								   			;# End if
}								   				;# End Procedure

### Hinzufügen eines Geburtstages
proc add_birth {handle idx args} {
 global bd_dates bd_ni						   	;# Datenstrukturen public definieren
 global bddes bdnick bddate						;# Farb Variablen definieren
 
 set btmp [lindex $args 0]				   		;# Befehlszeile extrahieren
 set bname [lindex $btmp 0]				   		;# erstes Argument ist Nick
 set bname [form $bname]				   		;# Name formatieren
 set bdate [lrange $btmp 1 end]			   		;# Der gesamte Rest ist der Channel
 set bdate [form $bdate]				   		;# Datum formatieren
 set bentry "$bname&$bdate"						;# Kombination Name&Datum bauen
 set bd_dates($bentry) $bentry 	                ;# Array Datenfeld (neu) belegen
 
 writefile_dates								;# User Datei schreiben
 putlog "$bddes Der Geburtstag von$bdnick $bname$bddes am$bddate $bdate$bddes wurde in die bd_ni(dates) Datei gespeichert" 
}												;# End Procedure

### Lüschen von Geburtstagen
proc del_birth {handle idx args} {
 global bd_dates bd_ni						   	;# Datenstrukturen public definieren
 global bddes bdnick bddate						;# Farb Variablen definieren
 
 set btmp [lindex $args 0]				   		;# Befehlszeile extrahieren
 set bname [lindex $btmp 0]				  		;# erstes Argument ist Nick
 set bname [form $bname]				  		;# Nick formatieren
 set bdate [lrange $btmp 1 end]					;# Datum 
 set bdate [form $bdate]						;# Datum formatieren
 set bentry "$bname&$bdate"						;# Eintrag name&datum montieren

	if {([info exists bd_dates($bentry)])} {    ;# wenn der Eintrag existiert 
		unset bd_dates($ientry)				 	;# Array Datenfeld freigeben
		writefile_dates
		putlog "$bddes Lüsche--> Geburtstag vom $bdnick$bname$bddes am $bddate$bdate$bddes wurde aus der $bd_ni(dates) Datei entfernt!"
	} else {							 		;# Falls Nick nicht vorhanden
		putlog "$bddes! Eintrag $bdnick$bname am $bddate$bdate $bddesist nicht gespeichert!"	
	}											;# End if (info)
}												;# End Procedure

### Laden der Benutzer für Birth
proc init_bdusers {} {
 global bd_user bd_ni				   			;# Datenstrukturen public definieren
 global bddes									;# Farb Variablen definieren

	if {[file exists $bd_ni(user)]} {			;# Falls File vorhanden
		putlog "$bddes Userdaten aus der $bd_ni(user) Datei erfolgreich geladen"
		set in [open $bd_ni(user) r]			;# Datenfile im read modus üffnen

		while {![eof $in]} {					;# solange kein EOF
			set vline [gets $in]                ;# Zeile holen

			if {[eof $in]} {break}  			;# Falls EOF, Ende von while
				set bd_nick [lindex $vline 0]	;# Nick extrahieren
				set bd_chan [lrange $vline 1 end] ;# Channel extrahieren
				set ientry "$bd_nick&$bd_chan"	;# Kombination Nick&Chan bauen
				set bd_user($ientry) $ientry    ;# Array Datenfeld belegen
		}								   		;# End while
		close $in							   	;# Datei schlieüen
	}								   			;# End If (dataexist)
}								   				;# End Procedure
init_bdusers

### Auslisten der Birth User
proc list_bdusers {handle idx args} {
 global bd_user bd_ni						   	;# Datenstrukturen public definieren
 global bddes bduser bdchan						;# Farb Variablen definieren

	if {[info exists bd_user]} {				;# Falls Felder definiert sind
		putlog "$bddes Eingetragene Nicks in der Datei:"

		foreach search [array names bd_user] { 	;# Für jeden Eintrag
			if {$search != 0} {					;# wenn kein leerer Eintrag
				set acmd [split $search "&"]	;# Eintrag bei "&" aufsplitten
				set bd_nick [lindex $acmd 0]	;# erstes Argument ist Nick
				set bd_nick [form $bd_nick]		;# Nick formatieren
				set bd_chan [lrange $acmd 1 end] ;# Der gesamte Rest ist der Channel
				set bd_chan [form $bd_chan]		;# Chan formatieren
     
				putlog "$bddes Stats: $bduser$bd_nick $bdchan$bd_chan"
			}							   		;# End if (search)
		}								   		;# End foreach
	} else {							   		;# Falls keine Struktur vorhanden
		putlog "$bddes Keine Daten gespeichert!" ;# Fehler anzeigen
	}								   			;# End if
}								   				;# End Procedure

proc m_list_bdusers {nick host hand args} {
 global bd_user bd_ni						   	;# Datenstrukturen public definieren
 global bddes bduser bdchan						;# Farb Variablen definieren
	
	if {[info exists bd_user]} {				;# Falls Felder definiert sind
		putlog "$bddes Eingetragene Nicks in der Datei:"
			
			foreach search [array names bd_user] { ;# Für jeden Eintrag
				if {$search != 0} {				;# wenn kein leerer Eintrag
	
				set acmd [split $search "&"]	;# Eintrag bei "&" aufsplitten
				set bd_nick [lindex $acmd 0]	;# erstes Argument ist Nick
				set bd_nick [form $bd_nick]		;# Nick formatieren
				set bd_chan [lrange $acmd 1 end] ;# Der gesamte Rest ist der Channel
				set bd_chan [form $bd_chan]		;# Chan formatieren

				puthelp "PRIVMSG $nick :$bddes Stats: $bduser$bd_nick $bdchan$bd_chan"
				}							   	;# End if (search)
			}								   	;# End foreach
		} else {							   	;# Falls keine Struktur vorhanden
			puthelp "PRIVMSG $nick :$bddes Keine Daten gespeichert!" 
	}								   			;# End if
}								   				;# End Procedure

### Hinzufügen eines Birth User
proc add_bduser {handle idx args} {
 global bd_user bd_ni						   	;# Datenstrukturen public definieren
 global bddes bduser bdchan						;# Farb Variablen definieren
 
 set btmp [lindex $args 0]				   		;# Befehlszeile extrahieren
 set bnick [lindex $btmp 0]				   		;# erstes Argument ist Nick
 set bnick [form $bnick]				   		;# Nick formatieren
 set bchan [lrange $btmp 1 end]			   		;# Der gesamte Rest ist der Channel
 set bchan [form $bchan]				   		;# Chan formatieren
 set bentry "$bnick&$bchan"						;# Kombination Nick&Mode&Chan bauen
 set bd_user($bentry) $bentry 	                ;# Array Datenfeld (neu) belegen
 
 writefile_user									;# User Datei schreiben
 putlog "$bddes Der Nick$bduser $bnick$bddes ausm Channel$bdchan $bchan$bddes wurde in die bd_ni(user) Datei gespeichert" 
}												;# End Procedure

proc m_add_birthuser {nick host hand args} {
 global bd_user bd_ni						   	;# Datenstrukturen public definieren
 global bddes bduser bdchan						;# Farb Variablen definieren
 
 set btmp [lindex $args 0]				   		;# Befehlszeile extrahieren
 set bnick [lindex $btmp 0]				   		;# erstes Argument ist Nick
 set bnick [form $bnick]				   		;# Nick formatieren
 set bchan [lrange $btmp 1 end]			   		;# Der gesamte Rest ist der Channel
 set bchan [form $bchan]				   		;# Chan formatieren
 set bentry "$bnick&$bchan"						;# Kombination Nick&Mode&Chan bauen
 set bd_user($bentry) $bentry 	                ;# Array Datenfeld (neu) belegen
 
 writefile_user									;# User Datei schreiben
 puthelp "PRIVMSG $nick :$bddesDer Nick$bduser $bnick$bddes ausm Channel$bdchan $bchan$bddes wurde in die bd_ni(user) Datei gespeichert" 
}												;# End Procedure

### Delete User Funktionen für die Benutzer Nicks
proc del_bduser {handle idx args} {
 global bd_user bd_ni						   	;# Datenstrukturen public definieren
 global bddes bduser bdchan						;# Farb Variablen definieren
 
 set btmp [lindex $args 0]				   		;# Befehlszeile extrahieren
 set bnick [lindex $btmp 0]				  		;# erstes Argument ist Nick
 set bnick [form $bnick]				  		;# Nick formatieren
 set bchan [lrange $btmp 1 end]			  		;# Der gesamte Rest ist der Channel
 set bchan [form $bchan]				   		;# Chan formatieren
 set bentry "$bnick&$bchan"						;# Eintrag nick&chan montieren
 
	if {([info exists bd_user($bentry)])} {    ;# wenn der Eintrag existiert 
		unset bd_user($bentry)				 	;# Array Datenfeld freigeben
		writefile_user
		putlog "$bddes Lüsche--> User $bduser$bnick$bddes aus'm Channel $bdchan$bchan$bddes wurde aus der $bd_ni(user) Datei entfernt!"
	} else {							 		;# Falls Nick nicht vorhanden
		putlog "$bddes! Eintrag$bduser $bnick$bdchan $bchan$bddes ist nicht gespeichert!"	
	}											;# End if (info)
}												;# End Procedure

proc m_del_bduser {nick host hand args} {
 global bd_user bd_ni						   	;# Datenstrukturen public definieren
 global bddes bduser bdchan						;# Farb Variablen definieren
 
 set btmp [lindex $args 0]				   		;# Befehlszeile extrahieren
 set bnick [lindex $btmp 0]				  		;# erstes Argument ist Nick
 set bnick [form $bnick]				  		;# Nick formatieren
 set bchan [lrange $btmp 1 end]			  		;# Der gesamte Rest ist der Channel
 set bchan [form $bchan]				   		;# Chan formatieren
 set bentry "$bnick&$bchan"						;# Eintrag nick&chan montieren
 
	if {([info exists bd_user($bentry)])} {    ;# wenn der Eintrag existiert 
		unset bd_user($bentry)				 	;# Array Datenfeld freigeben
		writefile
		puthelp "PRIVMSG $nick :$bddes Lüsche--> User $bduser$bnick$bddes aus'm Channel $bdchan$bchan$bddes wurde aus der $bd_ni(user) Datei entfernt!"
	} else {							 		;# Falls Nick nicht vorhanden
		puthelp "PRIVMSG $nick :$bddes! Eintrag$bduser $bnick$bdchan $bchan$bddes ist nicht gespeichert!"	
	}											;# End if (info)
}												;# End Procedure

### Alle Geburtstage Anzeigen für berechtige Benutzer
proc show_birth {nick uhost handle chan args} {
	global bd_dates bd_user 								;# Datenstrukturen public definieren
	global bddes bdnick bddate bdspch						;# Farb Variablen definieren
	
	set seeit 1												;# Keine Berechtigung zur Anzeige
	set chan [string tolower $chan]							;# Channel in Kleinschreibung
	set nick [string tolower $nick]							;# Nick in Kleinschreibung
	
	if {[info exists bd_user] && [info exists bd_dates]} {	;# Falls Felder definiert sind
		foreach search [array names bd_user] {	 			;# Liste aller User Eintrüge durchlaufen
			if {$search != 0} {								;# Prüft ob Daten vorhanden sind

				set en [string tolower $bd_user($search)]	;# Eintrag (nick&#chan) extrahieren
				set bd_part [split $en "&"]					;# Das & entfernen
				set bd_nick [lindex $bd_part 0]				;# Nick extrahieren
				set bd_nick [string tolower $bd_nick]       ;# Nick in Kleinschreibung
				set bd_chan [lindex $bd_part 1]				;# Chan extrahieren
				set bd_chan [string tolower $bd_chan]       ;# Channel in Kleinschreibung

				if {($nick == $bd_nick) && ($chan == $bd_chan)} {

					putserv "NOTICE $nick :$bddes Geburtstage von $bdspch$bddes -->"
				
					foreach tt [array names bd_dates] { 	;# Geht die Datums durch
						if {$tt != 0} {						;# wenn kein leerer Eintrag

							set en2 [split $tt "&"]			;# Eintrag bei "&" aufsplitten
							set bd_name [lindex $en2 0]		;# erstes Argument ist Name
							set bd_name [form $bd_name]	  	;# Name formatieren
							set bd_date [lrange $en2 1 end] ;# Der gesamte Rest ist das Datum
							set bd_date [form $bd_date]		;# Datum formatieren

							set bd_tmp [split $bd_date "-"] ;# Eintrag bei "-" aufsplitten
							set bd_d1 [lindex $bd_tmp 0]	;# Datum Benutzer freundlich
							set bd_d2 [lindex $bd_tmp 1]	;# formatieren
							set bd_d3 [lindex $bd_tmp 2]
							
							putserv "NOTICE $nick : $bddes Stats $bdnick$bd_name $bddate$bd_d3.$bd_d2.$bd_d1"							
						}									;# end if ob Geburtstage vorhanden sind
					}										;# end foreach Geburtstage durchlaufen
					set seeit 0								;# User hat es gesehen, Fehlermeldung bleibt aus
				}											;# end if ob User & Channel gleich sind 
			}												;# end if ob User vorhanden sind
		}													;# end foreach Benutzer durchsuchen
		if {$seeit != 0} {									;# Wenn man keine Berechigung hat, kommt die Meldung
			putserv "NOTICE $nick :$bddes Leider nich :-(, frag den Meister"
		}													;# end if Falls der User keine Berechtigung hat
	} else {							   					;# Falls keine Struktur vorhanden
		putserv "NOTICE $nick :$bddes Leider keine Geburtstage da"
	}														;# end if falls felder definiert sind
}															;# End Procedure

### 
proc join:bd_check {nick uhost hand channel arg} {
 global bd_user bd_dates bd_ni					;# Datenstrukturen public definieren
 global bddes bduser bdchan bdnick bddate 		;# Farb Variablen definieren
 
 
}												;# End Procedure

### 
proc time:bd_check {nick uhost hand channel arg} {
 global bd_user bd_dates bd_ni					;# Datenstrukturen public definieren
 global bddes bduser bdchan bdnick bddate 		;# Farb Variablen definieren
 
 
}												;# End Procedure

### Für den Spezial Geburtstag Post im Channel
proc bd_happy {nick uhost hand channel arg} [
 global bd_user bd_dates bd_ni					;# Datenstrukturen public definieren
 global bddes bduser bdnick bddate		 		;# Farb Variablen definieren
 global bdhappy1
 
	putserv "NOTICE $nick : FGHJKL"
}												;# End Procedure

### Funktion zum Schreiben der birth.dat
proc writefile_dates {} {
 global bd_ni bd_dates							;# Datenstrukturen public definieren
 set out [open $bd_ni(dates) w]			   	;# Datenfile im w modus üffnen (überschreiben)

	foreach search [array names bd_dates] {		;# durchlaufen der Daten arrays
		if {$search != 0} {						;# wenn keine leere Zeile

			set parts [split $search "&"]		;# Eintrag bei "&" aufsplitten
			set bd_name [lindex $parts 0]		;# Name extrahieren
			set bd_dates [lindex $parts 1]		;# Datum extrahieren
			set output "$bd_names $bd_dates"	;# Output montieren
			puts $out $output					;# Zeile schreiben
		}							         	;# End if (search)
	}											;# End Foreach
	close $out									;# Datei schlieüen
}												;# End procedure

### Funktion zum Schreiben der birthacl.dat
proc writefile_user {} {
 global bd_ni bd_user							;# Datenstrukturen public definieren
 set out [open $bd_ni(user) w]			   		;# Datenfile im w modus üffnen (überschreiben)

 foreach search [array names bd_user] {		;# durchlaufen der Daten arrays
		if {$search != 0} {						;# wenn keine leere Zeile

			set parts [split $search "&"]		;# Eintrag bei "&" aufsplitten
			set bd_nick [lindex $parts 0]		;# Nick extrahieren
			set bd_chan [lindex $parts 1]		;# Channel extrahieren
			set output "$bd_nick $bd_chan"		;# Output montieren
			puts $out $output					;# Zeile schreiben
		}							         	;# End if (search)
	}											;# End Foreach
 close $out										;# Datei schlieüen
}												;# End procedure

### Zusatz Funktion, zum Entfernen der Leerzeichen aus dem Sting
proc form {ftext} {								;# Formatierung String
  set tmp [string trimleft $ftext]				;# führende Leerzeichen entfernen
  set tmp [string trimright $tmp]				;# folgende Leerzeichen entfernen
  return $tmp									;# formatierten String zurückliefern
}												;# End Procedure

### Funktion zum Einrichten von BD
proc bd:active {chan} {
  foreach setting [channel info $chan] {		;# "channel info" ist ein TCL Befehl!
    if {[regexp -- {^[\+-]} $setting]} {
      if {$setting == "+bd"} { return 1 }
    }
  }
  return 0
}												;# End Procedure
### Code End
putlog "$cobd Birthday Remember $bd_ni(version)\00300 geladen für $bdspch"
putlog "Eingabe von$bdcom \.birthhelp \00300bzw.$bdcom \/msg $botnick birthhelp \00300zeigt die Hilfe an"