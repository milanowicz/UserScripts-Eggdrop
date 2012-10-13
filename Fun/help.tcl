# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                                         # #
#                       help  - Script v1.0 by Milanowicz                     # 
# #                                                                         # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                                         # #
#   Hilfebeschreibung der IRC Scripte f�r den Bot f�r andere User im IRC      #
# #                                                                         # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

###############################################################################
# History:                                                                    #
# 1.0		Erstes Release       help by Milanowicz                           #
###############################################################################
# Konfigurationsteil:
# Farbcodes f�r den vorderen und den hinteren Teil der Ausgabe
set cohelp "\00303"								;# Help Name
set teil1  "\00307"								;# Befehlsfarbe
set teil2  "\00305"								;# Beschreibundsfarbe

# Befehle f�r die IRC Benutzer
set help_cmd(cmdch)  "!"						;# Aufruf Zeichen f�r den IRC
set help_cmd(main) 	 "help"
set help_cmd(tv)     "tv"
set help_cmd(rss)    "rss"
set help_cmd(google) "google"

#######################################################################################
####   Ab hier nur editieren, wenn man genau wei�, was man tut. Beginn des Codes   ####
#######################################################################################

bind pub -|- $help_cmd(cmdch)$help_cmd(main) help
bind pub -|- $help_cmd(cmdch)$help_cmd(main)$help_cmd(tv) helptv
bind pub -|- $help_cmd(cmdch)$help_cmd(main)$help_cmd(rss) helprss
bind pub -|- $help_cmd(cmdch)$help_cmd(main)$help_cmd(google) helpgoogle

setudef flag help								;# Zur Aktivierung der userdefined flags
set help_ni(version) v1.0

proc help {nick uhost handle chan args} {

		if {![help:active $chan]} { return 0 } 					;# falscher Channel: nix machen
	
	global teil1 teil2

	putserv "NOTICE $nick :$teil2 Allgemeine Hilfe"
	putserv "NOTICE $nick : $teil1!tv <ard> $teil2              (more !helptv)" 
	putserv "NOTICE $nick : $teil1!xvid $teil2                  XviD Rechner"
	putserv "NOTICE $nick : $teil1!txhelp $teil2                Texas Holdin' Hilfe"
	putserv "NOTICE $nick : $teil1!gamble $teil2                Einarmiger Bandit"
	putserv "NOTICE $nick : $teil1!bar $teil2                   Janni zum Bestellen rufen"
	putserv "NOTICE $nick : $teil1!charts help $teil2           (Zeigt die Eingabe an)"
	putserv "NOTICE $nick : $teil1!google <Suchbegriff> $teil2  (more !helpgoogle)"
	putserv "NOTICE $nick : $teil1!rss <RSS> $teil2             Nachrichten anzeigen lassen (more !helprss)"
	putserv "NOTICE $nick : $teil1!gsore <web-seite> $teil2     Google Score f�r Webseiten"
	putserv "NOTICE $nick : $teil1!up $teil2                    Manuelles hochsetzen des Mode"
	putserv "NOTICE $nick : $teil1!down $teil2                  Manuelles runtersetzen des Mode"
	putserv "NOTICE $nick : $teil1!aclhelp $teil2               Access Control List Hilfe"
}

proc helptv {nick uhost handle chan args} {

		if {![help:active $chan]} { return 0 } 					;# falscher Channel: nix machen

	global teil1 teil2

	putserv "NOTICE $nick :$teil2 TV Programm Suche"
	putserv "NOTICE $nick : $teil1!tv ard 20 $teil2     (Programm um 20 Uhr)" 
	putserv "NOTICE $nick : $teil1!tv ard 17 3 $teil2   (Programm um 17 Uhr und 3 Zeilen)" 
	putserv "NOTICE $nick : $teil1!tv ard 20 5 1 $teil2 (Programm in 5 Zeilen und f�r morgen!)"
	putserv "NOTICE $nick :$teil2 Bekannte Programme und mit !funkzen nich:"
	putserv "NOTICE $nick :$teil2 haupt, ARD, ZDF, RTL, SAT1, !PRO7, !KABEL1, !RTL 2, !S-RTL,\
	ARTE, TM3, VOX, 3SAT, regio, NORD, WEST3, BAYERN3, MDR, HESSEN, SW3, TVBERLIN,\
	MUENCHEN, HH1, B1/SFB, ORB, MTV, MTV2, VH1, VIVA, VIVA2, PREMIERE, DSF,\
	EUROSPORT, NTV, EURONEWS, KIKA, PHOENIX, CNN, NBC, TNT, CARTOON, FRANCE2, FR3, \
	TV5, TF1, ORF1, ORF2, TSR, DK1, DK2, DRS, NL1, NL2, NL3, TRT, SF1"
}

proc helprss {nick uhost handle chan args} {

		if {![help:active $chan]} { return 0 } 					;# falscher Channel: nix machen

	global teil1 teil2

	putserv "NOTICE $nick :$teil2 Nachrichten �ber RSS"
	putserv "NOTICE $nick : $teil1!rss ct $teil2     (www.Heise.de)"
	putserv "NOTICE $nick : $teil1!rss secure $teil2 (Security von www.Heise.de)"
	putserv "NOTICE $nick : $teil1!rss gulli $teil2  (www.Gulli.com)"
	putserv "NOTICE $nick : $teil1!rss kicker $teil2 (www.Kicker.de)"
}

proc helpgoogle {nick uhost handle chan args} {

		if {![help:active $chan]} { return 0 } 					;# falscher Channel: nix machen

	global teil1 teil2

	putserv "NOTICE $nick :$teil2 Google Zusatz Suchanfragen:"
	putserv "NOTICE $nick : $teil1!google <Suchbegriff>"
	putserv "NOTICE $nick : $teil1!gi <Suchbegriff>"
	putserv "NOTICE $nick : $teil1!gg <Suchbegriff>"
	putserv "NOTICE $nick : $teil1!gl <Was?> near <Wo?>"
	putserv "NOTICE $nick : $teil1!gp <Suchbegriff>"
	putserv "NOTICE $nick : $teil1!gv <Suchbegriff>"
	putserv "NOTICE $nick : $teil1!gf <W�rt(er) Nummer eins> vs <W�rt(er) Nummer zwei>"
}

### Funktion zum Pr�fen ob Help l�uft auf dem Channel
proc help:active {chan} {
	foreach setting [channel info $chan] {		;# "channel info" ist ein TCL Befehl!
		if {[regexp -- {^[\+-]} $setting]} {
			if {$setting == "+help"} { return 1 }
		}
	}
	return 0
}

putlog "$cohelp Help $help_ni(version)\00300 geladen! Aufruf �ber $teil1$help_cmd(main)\00300 weitere Enthalten"