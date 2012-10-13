# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                                         # #
#                     XviD Calulator  - Script v1.0 by Milanowicz             # 
# #                                                                         # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                                         # #
#   Dies ist ein XviD Taschenrechner zum ermitteln der Dateigr�sse bei einer  #
#   gewissen Videorate und Audioraten, wie die umkehrfunktion zum ermitteln   #
#   der Videorate bei einer Dateigrösse                                       #
# #                                                                         # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Konfigurationsteil:
# Farbcodes f�r XviD Calulator
set xdapp   "\00303"								;# Programmname Farbe
set xddes   "\00314"								;# Beschreibungsfarbe
set xdcmd   "\00307"								;# Befehlsfarbe
set xdvbt   "\00306"								;# Farbe f�r die Videorate
set xdabt	"\00310"								;# Farbe f�r die Audiorate
set xdsiz	"\00309"								;# Dateigr��e Farbe
set xdlen	"\00312"								;# Spiell�nge Farbe

# Standard Kilo Bit Raten pro Sekunde
set xd_va(vbit)			"1080"						;# Video Bitrate in Kbits
set xd_va(abit1)		"112"						;# Erste Audio Bitrate in Kbits
set xd_va(abit2)		"112"						;# Zweite Audio Bitrate in Kbits
set xd_va(prozent)		"5"							;# Abweich Prozent zur Bestimmung

# Aufruf Befehle f�r den IRC
set xd_va(cmdch)		"!"							;# Aufruf Zeichen f�r den IRC
set xd_va(help)			"xvid"						;# Hilfe Anzeige des XviD Rechners
set xd_va(enc)			"encode"					;# Datei gr��e errechnen lassen
set xd_va(size)			"xsize"						;# Videorate & Audiorate ermitteln

# Meldungen
# enc Funktion Fehlerasugaben
set xd_va(text1)		"$xddes Bitte so eingeben-->$xdcmd $xd_va(cmdch)$xd_va(enc)$xdlen 1:20:0"
set xd_va(text2)		"$xddes Bitte so eingeben-->$xdcmd $xd_va(cmdch)$xd_va(enc)$xdlen 1:24:05$xdvbt 1080$xdabt 112"
# xsize Funktion Fehlerasugaben
set xd_va(text3)		"$xddes Bitte so eingeben-->$xdcmd $xd_va(cmdch)$xd_va(size)$xdsiz 800$xdlen 1:40:23"
set xd_va(text4)		"$xddes Bitte so eingeben-->$xdcmd $xd_va(cmdch)$xd_va(size)$xdsiz 800$xdlen 1:40:0$xdabt 112"
# Minuten Eingabe Ausgabe
set xd_va(text5)		"$xddes Bei einer Tonspur:"
set xd_va(text6)		"$xddes Bei zwei Tonspuren:"



#######################################################################################
####   Ab hier nur editieren, wenn man genau wei�, was man tut. Beginn des Codes   ####
#######################################################################################

setudef flag xvid									;# Zur Aktivierung der userdefined flags
set xd_va(version) "v1.0"							;# Release Version

bind pub -|- $xd_va(cmdch)$xd_va(help) xd_help
bind pub -|- $xd_va(cmdch)$xd_va(enc) xd_encode
bind pub -|- $xd_va(cmdch)$xd_va(size) xd_file

### Hilfe Anzeige
proc xd_help {nick uhost handle chan args} {

	if {![xvid:active $chan]} { return 0 } 			;# falscher Channel: nix machen

 global xdapp xddes xdcmd xdlen xdvbt xdabt xdsiz 	;# Globale Farb Variblen definieren
 global xd_va										;# Globale Variblen definieren
 
 putserv "NOTICE $nick : $xddes Wilkommen beim$xdapp XviD Calulator$xddes, folgende Sachen k�nnen berechnet werden:"
 putserv "NOTICE $nick : $xdcmd $xd_va(cmdch)$xd_va(enc)$xdlen <Spiell�nge>$xdvbt \[Videorate]$xdabt \[Audiorate1] \[Audiorate2]"
 putserv "NOTICE $nick : $xdcmd $xd_va(cmdch)$xd_va(size)$xdsiz <Mega Byte>$xdlen <Spiell�nge>$xdabt \[Audiorate1] \[Aduiorate2]"
 
}													;# End of proc

### Datei Gr�sse zu Video- und Audiobitrate ermitteln
proc xd_encode {nick uhost handle chan args} {
 global xdapp xddes xdlen xdvbt xdabt xdsiz xdcmd	;# Globale Farb Variblen definieren
 global xd_va										;# Globale Variblen definieren
 
	if {![xvid:active $chan]} { return 0 } 			;# falscher Channel: nix machen
 
 set xdtmp   [split $args " "]						;# Trennen der Leezeichen
 set xdlenth [lindex $xdtmp 0]						;# Spiel L�nge
 set xdvbit  [lindex $xdtmp 1]						;# Videobitrate
 set xdabit1 [lindex $xdtmp 2]						;# Erste Audiobitrate
 set xdabit2 [lindex $xdtmp 3]						;# Zweite Audiobitrate
 set select "1"										;# Funktion Check
	
	# Falls L�nge, Video- und zwei Audiobitraten eingegeben wurde
 	if {[string length $xdlenth] >= 3 && [string length $xdvbit] >= 3 && [string length $xdabit1] >= 2 && [string length $xdabit2] >= 3} { 
		if {[regexp -- {([0-9]+):+([0-9]+) +([0-9]+) +([0-9]+) +([0-9])} $args]} {		
		
			set xdlenth [split $xdlenth "{"] 		;# f�hrende Zeichen entfernen
			set xdlenth [lindex $xdlenth 1]			;# String ausw�hlen
			set xdabit2 [split $xdabit2 "}"] 		;# folgende Zeichen entfernen
			set xdabit2 [lindex $xdabit2 0]			;# String ausw�hlen
		
			set select "0"							;# Daten wurden schon berechnet
			xd_output $nick $uhost $handle $chan $xdlenth $xdvbit $xdabit1 $xdabit2 0
		
		} else {									;# Fehlerausgabe wenn Eingabe falsch war
			putserv "NOTICE $nick :$xd_va(text1)"
			putserv "NOTICE $nick :$xd_va(text2)"
			return 0
		}
	# Falls L�nge, Video- und eine Audiobitrate eingegeben wurde
	} elseif {[string length $xdlenth] >= 3 && [string length $xdvbit] >= 3 && [string length $xdabit1] >= 3 && [string length $xdabit2] == 0} { 
		if {[regexp -- {([0-9]+):+([0-9]+) +([0-9]+) +([0-9])} $args]} {
		
			set xdlenth [split $xdlenth "{"] 		;# f�hrende Zeichen entfernen
			set xdlenth [lindex $xdlenth 1]			;# String ausw�hlen
			set xdabit1 [split $xdabit1 "}"] 		;# folgende Zeichen entfernen
			set xdabit1 [lindex $xdabit1 0]			;# String ausw�hlen

			set select "0"							;# Daten wurden schon berechnet
			xd_output $nick $uhost $handle $chan $xdlenth $xdvbit $xdabit1 $xdabit2 0

		} else {									;# Fehlerausgabe wenn Eingabe falsch war
			putserv "NOTICE $nick :$xd_va(text1)"
			putserv "NOTICE $nick :$xd_va(text2)"
			return 0
		}
	# Falls nur die L�nge eingegeben wurde
	} elseif {[string length $xdlenth] >= 3 && $select == "1" && [string length $xdvbit] == 0 && [string length $xdabit1] == 0 && [string length $xdabit2] == 0} {
		if {[regexp -- {([0-9]+):+([0-9])} $args]} {
		
			putserv "PRIVMSG $chan :$xd_va(text5)"
			xd_output $nick $uhost $handle $chan $xdlenth $xd_va(vbit) $xd_va(abit1) 0 0
			putserv "PRIVMSG $chan :$xd_va(text6)"
			xd_output $nick $uhost $handle $chan $xdlenth $xd_va(vbit) $xd_va(abit1) $xd_va(abit2) 0
		
		} else {									;# Fehlerausgabe wenn Eingabe falsch war
			putserv "NOTICE $nick :$xd_va(text1)"
			putserv "NOTICE $nick :$xd_va(text2)"
			return 0
		}
	# Fehlermeldung bei falsch eingabe
	} else {
		putserv "NOTICE $nick :$xd_va(text1)"
		putserv "NOTICE $nick :$xd_va(text2)"
	}												;# End of if
}													;# End of proc

### Video- und Audiobitraten zu der Datei Gr�sse ermitteln
proc xd_file {nick uhost handle chan args} {
 global xdapp xddes xdlen xdvbt xdabt xdsiz xdcmd	;# Globale Farb Variblen definieren
 global xd_va										;# Globale Variblen definieren
 
	if {![xvid:active $chan]} { return 0 } 			;# falscher Channel: nix machen
 
 set xdtmp   [split $args " "]						;# Trennen der Leezeichen
 set xdfile  [lindex $xdtmp 0]						;# Datei Gr�sse
 set xdlenth [lindex $xdtmp 1]						;# Video L�nge
 set xdabit1 [lindex $xdtmp 2]						;# Erste Audiobitrate
 set xdabit2 [lindex $xdtmp 3]						;# Zweite Audiobitrate
 set select "1"										;# Funktion Check
	
	# Falls Dateigr�sse, L�nge und zwei Audiobitraten eingegeben wurde
 	if {[string length $xdfile] >= 3 && [string length $xdlenth] >= 3 && [string length $xdabit1] >= 2 && [string length $xdabit2] >= 3} { 
		if {[regexp -- {([0-9]+) +([0-9]+):+([0-9]+) +([0-9]+) +([0-9])} $args]} {	
		
			set xdfile [split $xdfile "{"]	 		;# f�hrende Zeichen entfernen
			set xdfile [lindex $xdfile 1]			;# String ausw�hlen
			set xdabit2 [split $xdabit2 "}"] 		;# folgende Zeichen entfernen
			set xdabit2 [lindex $xdabit2 0]			;# String ausw�hlen
		
			set select "0"							;# Daten wurden schon berechnet
			xd_output $nick $uhost $handle $chan $xdlenth 0 $xdabit1 $xdabit2 $xdfile

		} else {									;# Fehlerausgabe wenn Eingabe falsch war
			putserv "NOTICE $nick :$xd_va(text3)"
			putserv "NOTICE $nick :$xd_va(text4)"
			return 0
		}
	# Falls Dateigr�sse, L�nge und eine Audiobitrate eingegeben wurde
	} elseif {[string length $xdfile] >= 3 && [string length $xdlenth] >= 3 && [string length $xdabit1] >= 3 && [string length $xdabit2] == 0} { 
		if {[regexp -- {([0-9]+) +([0-9]+):+([0-9]+) +([0-9])} $args]} {	
		
			set xdfile [split $xdfile "{"]	 		;# f�hrende Zeichen entfernen
			set xdfile [lindex $xdfile 1]			;# String ausw�hlen
			set xdabit1 [split $xdabit1 "}"] 		;# folgende Zeichen entfernen
			set xdabit1 [lindex $xdabit1 0]			;# String ausw�hlen

			set select "0"							;# Daten wurden schon berechnet
			xd_output $nick $uhost $handle $chan $xdlenth 0 $xdabit1 $xdabit2 $xdfile
		
		} else {									;# Fehlerausgabe wenn Eingabe falsch war
			putserv "NOTICE $nick :$xd_va(text3)"
			putserv "NOTICE $nick :$xd_va(text4)"
			return 0
		}
	# Falls nur die Dateigr�sse und L�nge eingegeben wurde
	} elseif {[string length $xdfile] > 2 && [string length $xdlenth] > 2 && $select == "1" && [string length $xdabit1] == 0 && [string length $xdabit2] == 0} {
		if {[regexp -- {([0-9]+) +([0-9]+):+([0-9])} $args]} {	
		
			set xdfile [split $xdfile "{"]	 			;# f�hrende Zeichen entfernen
			set xdfile [lindex $xdfile 1]				;# String ausw�hlen
			set xdlenth [split $xdlenth "}"] 			;# folgende Zeichen entfernen
			set xdlenth [lindex $xdlenth 0]				;# String ausw�hlen

			putserv "PRIVMSG $chan :$xd_va(text5)"
			xd_output $nick $uhost $handle $chan $xdlenth 0 $xd_va(abit1) 0 $xdfile
			putserv "PRIVMSG $chan :$xd_va(text6)"
			xd_output $nick $uhost $handle $chan $xdlenth 0 $xd_va(abit1) $xd_va(abit2) $xdfile
			return 0
			
		} else {									;# Fehlerausgabe wenn Eingabe falsch war
			putserv "NOTICE $nick :$xd_va(text3)"
			putserv "NOTICE $nick :$xd_va(text4)"
			return 0
		}
	# Fehlermeldung bei falsch eingabe
	} else {
		putserv "NOTICE $nick :$xd_va(text3)"
		putserv "NOTICE $nick :$xd_va(text4)"
	}												;# End of if
}													;# End of proc

### Ausgabe Funktion
proc xd_output {nick uhost handle chan xd_len xd_vbt xd_abt1 xd_abt2 xd_file} {
 global xdapp xddes xdlen xdvbt xdabt xdsiz xdcmd	;# Globale Farb Variblen definieren
 global xd_va bar_va								;# Globale Variblen definieren
 
 set sol1  	0										;# Ergebnis f�r Video
 set sol2	0										;# Ergebnis f�r die 1.Audio Spur
 set sol3	0										;# Ergebnis f�r die zweite Audio Spur
 set sol4	0										;# Gesamtergebnis
 set dsol	0										;# Differenz Ergebnis
 set sec	0										;# Zeit in Sekunden
 
 set xdtmp [split $xd_len ":"] 						;# f�hrende Zeichen entfernen
 set len1  [lindex $xdtmp 0]						;# Zahl extrahieren
 set len2  [lindex $xdtmp 1]						;# Zahl extrahieren
 set len3  [lindex $xdtmp 2]						;# Zahl extrahieren

	### Ermitteln der Dateigr�sse bei hh:mm:ss
	if {[string length $xd_vbt] > 1 && [string length $len3] > 0} {
		
		set sec [expr $sec + (($len1 * 3600) + ($len2 * 60) + $len3)]  	;# Sekunden setzen
		set sol1 [expr $sol1 + ((($xd_vbt / 8) * $sec) / 1024)]			;# Video Berechnung
		set sol2 [expr $sol2 + ((($xd_abt1 / 8) * $sec) / 1024)]		;# 1.Audiospur Berechnung
		
		if {[string length $xd_abt2] > 1} {								;# Check ob da
			set sol3 [expr $sol3 + ((($xd_abt1 / 8) * $sec) / 1024)]    ;# 2.Audiospur Berechnung
		}

		set sol4 [expr $sol1 + $sol2 + $sol3]							;# Gesamt Ergebnis setzen
		set dsol [expr $sol4 - (($sol4 / 100) * $xd_va(prozent))]		;# Differenz Ergebnis

	### Ermitteln der Dateigr�sse bei mm:ss
	} elseif {[string length $xd_vbt] > 1 && [string length $len3] == 0} {
			
		set sec [expr $sec + (($len1 * 60) + $len2)]					;# Sekunden setzen
		set sol1 [expr $sol1 + ((($xd_vbt / 8) * $sec) / 1024)]			;# Video Berechnung
		set sol2 [expr $sol2 + ((($xd_abt1 / 8) * $sec) / 1024)]		;# 1.Audiospur Berechnung
			
		if {[string length $xd_abt2] > 1} {								;# Check ob da
			set sol3 [expr $sol3 + ((($xd_abt2 / 8) * $sec) / 1024)] 	;# 2.Audiospur Berechnung
		}

		set sol4 [expr $sol1 + $sol2 + $sol3]							;# Gesamt Ergebnis setzen
		set dsol [expr $sol4 - (($sol4 / 100) * $xd_va(prozent))]		;# Differenz Ergebnis
	
	### Ermitteln der Videobitrate bei MB, hh:mm:ss
	} elseif {[string length $xd_file] > 1  && [string length $len3] > 0} {

		set sec [expr $sec + (($len1 * 3600) + ($len2 * 60) + $len3)] 	;# Sekunden setzen

		if {[string length $xd_abt2] > 1} {								;# Check ob xd_abt2 da
			set sol3 [expr $sol3 + ((($xd_abt2 / 8) * $sec) / 1024)] 	;# 2.Audiospur Berechnung
		}
		
		set sol2 [expr $sol2 + ((($xd_abt1 / 8) * $sec) / 1024)]		;# 1.Audiospur Berechnung
		set sol1 [expr $xd_file - $sol2 - $sol3]						;# Tonspuren abziehen
		set dsol [expr ($sol1 * 1024 * 8) / $sec]						;# Differnz rate
		set sol1 [expr ($sol1 * 8 * 1024) / $sec]						;# Videorate Berechnung
		set dsol [expr $dsol - ((($dsol / 100) * $xd_va(prozent)) / 2)] ;# 1.Videorate
		set sol1 [expr $sol1 + ((($sol1 / 100) * $xd_va(prozent)) / 2)]	;# 2.Videorate

	### Ermitteln der Videobitrate bei MB, mm:ss	
	} else {												;# Falls keine Stunden eingeben wurden

		set sec [expr $sec + (($len1 * 60) + $len2)]					;# Sekunden setzen

		if {[string length $xd_abt2] > 1} {								;# Check ob xd_abt2 da
			set sol3 [expr $sol3 + ((($xd_abt2 / 8) * $sec) / 1024)]
		}

		set sol2 [expr $sol2 + ((($xd_abt1 / 8) * $sec) / 1024)] 		;# 1.Audiospur Berechnung
		set sol1 [expr $xd_file - $sol2 - $sol3]						;# Tonspuren abziehen

		set dsol [expr ($sol1 * 1024 * 8) / $sec]						;# Differnz rate
		set sol1 [expr ($sol1 * 1024 * 8) / $sec]						;# Videorate Berechnung
		set dsol [expr $dsol - ((($dsol / 100) * $xd_va(prozent)) / 2)]	;# 1.Videorate
		set sol1 [expr $sol1 + ((($sol1 / 100) * $xd_va(prozent)) / 2)]	;# 2.Videorate
		
	}																	;# End of if XviD berechen

	### Ausgabe Funktion f�r beide Funktion
	### Ausgabe f�r encode Funktion
	if {[string length $xd_vbt] > 1 && [string length $xd_abt2] > 1} {
			putserv "PRIVMSG $chan :$xddes XviD Stats --> $xdvbt$xd_vbt Kbit/s $xdabt$xd_abt1 Kbit/s $xd_abt2 Kbit/s $xdsiz$xd_len"
			putserv "PRIVMSG $chan :$xddes File Stats --> $xdvbt$sol1 MB $xdabt$sol2 MB $sol3 MB  $xddes-->  von $xdsiz$dsol$xddes bis $xdsiz$sol4 MB"
	} elseif {[string length $xd_vbt] > 1 && [string length $xd_abt2] <= 1} {
			putserv "PRIVMSG $chan :$xddes XviD Stats --> $xdvbt$xd_vbt Kbit/s $xdabt$xd_abt1 Kbit/s $xdsiz$xd_len"
			putserv "PRIVMSG $chan :$xddes File Stats --> $xdvbt$sol1 MB $xdabt$sol2 MB  $xddes-->  von $xdsiz$dsol$xddes bis $xdsiz$sol4 MB"
	### Ausgabe f�r file Funktion
	} elseif {[string length $xd_file] > 1 && [string length $xd_abt2] > 1} {
			putserv "PRIVMSG $chan :$xddes XviD Stats --> $xdsiz$xdabt $xdsiz$xd_len $xd_abt1 Kbit/s $xd_abt2 Kbit/s"
			putserv "PRIVMSG $chan :$xddes Encode at  --> $xddes von $xdvbt$dsol Kbit/s$xddes bis $xdvbt$sol1 Kbit/s$xddes f�r $xdsiz$xd_file MB"
	} else {
			putserv "PRIVMSG $chan :$xddes XviD Stats --> $xdsiz$xdabt $xdsiz$xd_len $xd_abt1 Kbit/s"
			putserv "PRIVMSG $chan :$xddes Encode at  --> $xddes von $xdvbt$dsol Kbit/s$xddes bis $xdvbt$sol1 Kbit/s$xddes f�r $xdsiz$xd_file MB"
	}
}													;# End of proc 

### Pr�fen ob die XviD Calulator auf dem Channel l�uft
proc xvid:active {chan} {
	foreach setting [channel info $chan] {		;# "channel info" ist ein TCL Befehl!
		if {[regexp -- {^[\+-]} $setting]} {
			if {$setting == "+xvid"} { return 1 }
		}
	}
	return 0
}												;# End of proc

putlog "XviD Calulator $xd_va(version) by Aj "