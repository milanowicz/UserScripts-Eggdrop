# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                                         # #
#                          IRC Bar  - Script v1.0 by Milanowicz               # 
# #                                                                         # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                                         # #
#   IRC Bar Kellner	überreicht den Usern oder einer selbst die Getränke,      #
#   aber nur für Nicks die mind. Voice, HalfOP oder OP haben  				  #
# #                                                                         # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Konfigurationsteil:												### Farbtabelle
# Farbcodes f�r den Kellner											;# white  	  00
set barapp 		"\00303"			;# Bar Name						;# black  	  01
set bardes 		"\00311"			;# Beschreibungsfarbe			;# blue       02
set barkdes 	"\00306"			;# Kellner Farbe				;# green 	  03
set barwarn 	"\00304"			;# Warntext Farbe				;# red 		  04
set barcmd  	"\00307"			;# Befehlsfarbe					;# brown 	  05
set barnick 	"\00303"			;# Der Ausgeber					;# purple 	  06
set barargs 	"\00310"			;# Die Empf�nger				;# orange 	  07
set bardrin 	"\00302"			;# Drink Farbe					;# yellow 	  08
set barchan 	"\00309"			;# Channel Name					;# lightgreen 09
																	;# turqois 	  10
# Kellner Name														;# lightblue  11
set bar_va(kellner) "Janni"											;# dblue 	  12
																	;# pink 	  13
# Anzahl Channels													;# grey 	  14
set bar_va(chanact)		 "1"		;# Anzahl der Channel auf der der Bot l�uft
# Channels
set bar_va(channel1)	 "#NoName"
set bar_va(channel2)	 "#foo"

# Aufruf Befehle f�r den IRC
set bar_va(cmdch)         "!"						;# Aufruf Zeichen f�r den IRC
set bar_va(barh)          "bar"						;# Hilfe Anzeige der Bar
set bar_va(thx)			  "thx"						;# Bedanken beim Bot
set bar_va(liste)		  "blist"					;# Anzeigen der Bestellten Sachen
set bar_va(reset)         "breset"					;# Alle Benutzer bestellten Nicks l�schen
# Getr�nke Liste der Bar
# Softdrink Liste
set bar_va(barcola)   	  "cola"
set bar_va(barwass)       "wasser"
set bar_va(barcoff)		  "kaffee"
set bar_va(barsoja)       "soja"
set bar_va(barfant)       "fanta"
set bar_va(barkak)        "kakao"
# Hardrink Liste
set bar_va(barbier)       "bier"
set bar_va(barwein)       "wein"
set bar_va(barouzo)       "ouzo"
set bar_va(barjag)        "j�germeister"
set bar_va(barteq)        "tequilla"
set bar_va(barama)        "amaretto"
set bar_va(barwhi)        "whisky"
set bar_va(barrum)        "rum"
set bar_va(barfeig)       "feigling"
set bar_va(barmali)       "malibu"
set bar_va(barrama)       "ramazotti"
# Andere Sachen
set bar_va(barzuck)		  "zucker"
set bar_va(barmil)		  "milch"

# Fehlermeldungen
# Kick Grund
set bar_va(kick)   	"Undankbares St�ck >:"
# Genug gehabt
set bar_va(text1)  	"$bardes Leider nich, hast schon genug ;)"
# Keine Bestellung
set bar_va(text2)  	"$bardes Du hast nich bestellt :("
# Zugriffsfehlermeldung 
set bar_va(text3)  	"$bardes Du bist noch nich zu weit :D"
# Keine Daten gespeichert
set bar_va(text4)  	"$barwarn !Leider nichts gespeichert!"
# Nicks aus dem Array gel�scht
set bar_va(text5)  	"$barwarn Alle Nicks wurden entfernt !"

###############################################################################
#############################  Benutzung der Bar ##############################
###############################################################################
# M�gliche Befehle im IRC :			            				              #
#													                          #
# !bar                       Bar Hilfe anzeigen lassen                        #	
# !thx                       Bedanken beim Bar Keeper                         #	
# !breset                    Alle Nicks l�schen die Bestellt hatten           #
###############################################################################

#######################################################################################
####   Ab hier nur editieren, wenn man genau wei�, was man tut. Beginn des Codes   ####
#######################################################################################

setudef flag bar								;# Zur Aktivierung der userdefined flags
set bar_va(version) "v1.0"						;# Release Version

# Steuerung
bind pub -|- $bar_va(cmdch)$bar_va(barh) show_bar
bind pub -|- $bar_va(cmdch)$bar_va(thx) b_thx
bind pub -|- $bar_va(cmdch)$bar_va(liste) b_list
bind pub -|- $bar_va(cmdch)$bar_va(reset) b_reset
# Getr�nke
bind pub -|- $bar_va(cmdch)$bar_va(barcola) b_cola
bind pub -|- $bar_va(cmdch)$bar_va(barfant) b_fanta
bind pub -|- $bar_va(cmdch)$bar_va(barwass) b_wasser
bind pub -|- $bar_va(cmdch)$bar_va(barcoff) b_coffee
bind pub -|- $bar_va(cmdch)$bar_va(barzuck) b_zucker
bind pub -|- $bar_va(cmdch)$bar_va(barmil) b_milch
bind pub -|- $bar_va(cmdch)$bar_va(barsoja) b_soja
bind pub -|- $bar_va(cmdch)$bar_va(barkak) b_kakao
bind pub -|- $bar_va(cmdch)$bar_va(barbier) b_bier
bind pub -|- $bar_va(cmdch)$bar_va(barwein) b_wein
bind pub -|- $bar_va(cmdch)$bar_va(barouzo) b_ouzo
bind pub -|- $bar_va(cmdch)$bar_va(barjag) b_jager
bind pub -|- $bar_va(cmdch)$bar_va(barteq) b_tequ
bind pub -|- $bar_va(cmdch)$bar_va(barama) b_ama
bind pub -|- $bar_va(cmdch)$bar_va(barwhi) b_whis
bind pub -|- $bar_va(cmdch)$bar_va(barrum) b_rum
bind pub -|- $bar_va(cmdch)$bar_va(barfeig) b_feig
bind pub -|- $bar_va(cmdch)$bar_va(barmali) b_mali
bind pub -|- $bar_va(cmdch)$bar_va(barrama) b_rama
# Timer
bind time - "*" b_timer
	;#bind pub -|- $bar_va(cmdch)$

proc show_bar {nick uhost handle chan args} {

   if {![bar:active $chan]} { return 0 } 			;# Falscher Channel: nix machen

 global barkdes bardes barcmd barapp 				;# Globale Farb Variblen definieren
 global bar_va										;# Globale Variblen definieren
 
 putserv "NOTICE $nick :$bardes Wilkommen bei$barkdes $bar_va(kellner)$barapp Bar$bardes, folgende getr�nke hab ich im Angebot:"
 putserv "NOTICE $nick :$barcmd !kakao, !wasser, !fanta, !cola, !kaffee, !bier, !wein, !ouzo, !j�germeister, !tequilla, !amaretto, !rum, !ramazotti"
 putserv "NOTICE $nick :$bardes Du kannst dich bei $barkdes$bar_va(kellner)$bardes damit bedanken $barcmd$bar_va(cmdch)$bar_va(thx)"
 if { [isop $nick $chan] } {						;# Ob Nick im Channel OP hat
	putserv "NOTICE $nick :$barcmd $bar_va(cmdch)$bar_va(liste)$bardes       Bestellte Getr�nke Anzeige"
	putserv "NOTICE $nick :$barcmd $bar_va(cmdch)$bar_va(reset)$bardes      Bestellte Getr�nke l�schen"
 }
}													;# End of proc

### Definition der Getr�nke Liste
### Ausgabe Funktionen f�r die weichen Sachen
### Cola
proc b_cola {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren
  
 set bar_va(drink) 		"Cola"						;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt eine $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes schenkt mal ins Glas rein, beim$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal eine $bardrin$bar_va(drink)$bardes :D"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes schenkt dem $barnick$nick$bardes mal einfach dat Zeug ins Glas rein"
 set bar_va(lmess) 		"2"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"2"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe
}													;# End of proc

### Fanta
proc b_fanta {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren
  
 set bar_va(drink) 		"Fanta"						;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt eine $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes schenkt das gelbe Zeug mal ins Glas rein, beim$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal eine feine $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes schenkt dem $barnick$nick$bardes mal einfach dat gelbe Zeug ins Glas rein"
 set bar_va(lmess) 		"2"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"2"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe
}													;# End of proc

### Wasser
proc b_wasser {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren
 
 set bar_va(drink) 		"Wasser"					;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt ein Glas $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes stellt das Glas auf die Theke f�rn$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal ein klares $bardrin$bar_va(drink)$bardes :D"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes stell das Glas aufm Bierkdeckel f�rn $barnick$nick"
 set bar_va(lmess) 		"2"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"2"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe
}													;# End of proc

### Kaffee
proc b_coffee {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin barwarn barcmd ;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren
 
 set bar_va(drink) 		"Kaffee"					;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt einen Pot $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes �berreicht den$barwarn heissen$bardes Pot an$barargs"
 set bar_va(lmessage3)  "$barkdes$bar_va(kellner)$bardes Falls er zu stark is, dann ich noch einbisschen $barcmd$bar_va(cmdch)$bar_va(barzuck)$bardes anbieten, wenn de m�chtest"
 set bar_va(lmessage4)  "$barkdes$bar_va(kellner)$bardes Wennn der $bardrin$bar_va(drink)$bardes zu schwarz is, kann ich $barcmd$bar_va(cmdch)$bar_va(barmil)$bardes anbieten, wenn es dir besser schmeckt"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal einen grossen Pot $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes �berreicht den$barwarn heissen$bardes Pot an $barnick$nick"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes Falls er zu stark is, dann ich noch einbisschen $barcmd$bar_va(cmdch)$bar_va(barzuck)$bardes anbieten"
 set bar_va(amessage4)  "$barkdes$bar_va(kellner)$bardes Wennn der $bardrin$bar_va(drink)$bardes zu schwarz is, kann ich $barcmd$bar_va(cmdch)$bar_va(barmil)$bardes anbieten"
 set bar_va(lmess) 		"4"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"4"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe
}													;# End of proc

### Zucker
proc b_zucker {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin barwarin	barcmd ;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren
 
 set bar_va(drink) 		"Zucker"					;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes schieb den Zucker zu $barargs"
 set bar_va(amessage1)  "$barkdes$bar_va(kellner)$bardes schmeisst den Zucker dem $barnick$nick$bardes r�ber"
 set bar_va(lmess) 		"2"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"1"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe
}													;# End of proc

### Milch
proc b_milch {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin barwarin	barcmd ;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren
 
 set bar_va(drink) 		"Milch"					;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes stellt den Milch Pot zu $barargs"
 set bar_va(amessage1)  "$barkdes$bar_va(kellner)$bardes schiebt den Milch Pot $barnick$nick$bardes r�ber"
 set bar_va(lmess) 		"2"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"1"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe
}													;# End of proc

### Soja
proc b_soja {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren
 
 set bar_va(drink) 		"Soja"						;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt ein Glas $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes stellt das Glas auf die Theke f�rn$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal ein Glas $bardrin$bar_va(drink)$bardes"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes stell das Glas einfach aufm Bierdeckel f�rn $barnick$nick"
 set bar_va(lmess) 		"2"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"2"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe
}													;# End of proc


### Kakao
proc b_kakao {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin barwarn ;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren
  
 set bar_va(drink) 		"Kakao"						;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt einen heissen $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes �berreicht mal die heisse Tasse$barargs"
 set bar_va(lmessage3)  "$barwarn Vorsichtig der $bardrin$bar_va(drink)$barwarn ist hei�$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal einen feinen sch�nen heissen $bardrin$bar_va(drink)$bardes :D"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes �berreicht die heisse Tasse $barnick$nick$bardes mal"
 set bar_va(amessage3)  "$barwarn Vorsichtig der $bardrin$bar_va(drink)$barwarn ist hei� !"
 set bar_va(lmess) 		"3"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"3"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe
}													;# End of proc

### Ausgabe Funktionen f�r die harten Sachen
### Bier
proc b_bier {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren
  
 set bar_va(drink) 		"Bier"						;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt ein $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes einen vollen Krug mit Bier f�rn$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal ein $bardrin$bar_va(drink)$bardes"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes �berrecht $barnick$nick$bardes einen vollen Krug entgegen"
 set bar_va(lmess) 		"2"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"2"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe
}													;# End of proc

### Wein
proc b_wein {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren
 
 set bar_va(drink) 		"Wein"						;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt einen $bardrin$bar_va(drink)$bardes aus, f�r den$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes macht das Glas voll f�r$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal einen klaren $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes stell die einfach auf die Bar f�rn $barnick$nick"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes macht noch eben das Glas voll f�r $barnick$nick"
 set bar_va(lmess) 		"2"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"3"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe
}													;# End of proc

### Ouzo
proc b_ouzo {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren

 set bar_va(drink) 		"Ouzo"						;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt einen kleinen $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes schiebt den kleinen R�ber zu$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal einen klaren $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes schiebt den kleinen zu$barnick$nick$bardes r�ber"
 set bar_va(lmess) 		"2"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"2"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe 
}													;# End of proc

### J�germeister
proc b_jager {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren

 set bar_va(drink) 		"J�germeister"				;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt einen kleinen $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes schiebt das kleine Kr�uterding r�ber zu$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal einen kleinen $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes schiebt das komische Kr�uterding zu $barnick$nick$bardes r�ber"
 set bar_va(lmess) 		"2"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"2"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe 
}													;# End of proc

### Tequilla
proc b_tequ {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren

 set bar_va(drink) 		"Tequilla"					;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt einen kleinen $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes schiebt das kleine Kr�uterding r�ber zu$barargs"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes: Klo ist hinten rechts durch, extra f�r dich vorbereitet$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal einen kleinen $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes schiebt das komische Kr�uterding zu $barnick$nick$bardes r�ber"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes: Klo ist hinten rechts durch ;)"
 set bar_va(lmess) 		"3"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"3"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe 
}													;# End of proc

### Amaretto
proc b_ama {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren

 set bar_va(drink) 		"Amaretto"					;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt einen kleinen feinen $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes stellt das jute ding aufm Deckel f�rn$barargs"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes: Dann las es dir schmecken$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal einen kleinen feinen $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes stellt das gute ding bei $barnick$nick$bardes hin"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes: Dann las es dir schmecken ;)"
 set bar_va(lmess) 		"3"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"3"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe 
}													;# End of proc

### Whiskey
proc b_whis {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren

 set bar_va(drink) 		"Whiskey"					;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt einen kleinen feinen $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes stellt das jute ding aufm Deckel f�rn$barargs"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes: Dann las es dir schmecken$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal einen kleinen feinen $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes stellt das gute ding bei $barnick$nick$bardes hin"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes: Dann las es dir schmecken ;)"
 set bar_va(lmess) 		"3"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"3"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe 
}													;# End of proc

### Rum
proc b_rum {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren

 set bar_va(drink) 		"Rum"						;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt einen kleinen $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes stellt das ding aufm Deckel f�rn$barargs"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes: Dann las es dir schmecken$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal einen kleinen $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes stellt das ding bei $barnick$nick$bardes hin"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes: Dann las es dir schmecken ;) Klo is hinten rechts durch"
 set bar_va(lmess) 		"3"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"3"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe 
}													;# End of proc

### Kleiner Feigling
proc b_feig {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren

 set bar_va(drink) 		"Feigling"					;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt einen kleinen $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes stellt das ding auf die Bar f�rn$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal einen kleinen $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes stellt das ding bei $barnick$nick$bardes hin"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes: Dann las es dir schmecken"
 set bar_va(lmess) 		"3"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"3"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe 
}													;# End of proc

### Malibu
proc b_mali {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren

 set bar_va(drink) 		"Malibu"					;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt ein Glas $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes stellt das jute Glas auf die Bar f�rn$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal zur Abwechselung einen $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes stellt das ding bei $barnick$nick$bardes hin"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes: macht 5,5, sofort :D"
 set bar_va(lmess) 		"3"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"3"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe 
}													;# End of proc

### Ramazotti
proc b_rama {nick uhost handle chan args} {
 global bardes barkdes barnick barargs bardrin		;# Globale Farb Variblen definieren
 global bar_va botnick								;# Globale Variblen definieren

 set bar_va(drink) 		"Ramazotti"					;# Getr�nk
 set bar_va(lmessage1)  "$barnick$nick$bardes gibt ein Glas $bardrin$bar_va(drink)$bardes aus, f�rn$barargs"
 set bar_va(lmessage2)  "$barkdes$bar_va(kellner)$bardes stellt das jute Glas auf die Bar f�rn$barargs"
 set bar_va(lmessage3)  "$barkdes$bar_va(kellner)$bardes: macht 7,5, sofort :D extra preis f�r dich$barargs"
 set bar_va(lmessage4)  "$barkdes$bar_va(kellner)$bardes: klo is hinten rechts durch f�r dich$barargs"
 set bar_va(amessage1)  "$barnick$nick$bardes k�nnt sich mal zur Abwechselung einen $bardrin$bar_va(drink)"
 set bar_va(amessage2)  "$barkdes$bar_va(kellner)$bardes stellt das ding bei $barnick$nick$bardes hin"
 set bar_va(amessage3)  "$barkdes$bar_va(kellner)$bardes: macht 7,5, sofort :D"
 set bar_va(amessage4)  "$barkdes$bar_va(kellner)$bardes: klo is hinten rechts durch !!"
 set bar_va(lmess) 		"4"							;# Anzahl der Nachrichten, wenn einer einen Ausgibt
 set bar_va(amess) 		"4"							;# Anzahl der Nachrichten, wenn sich einer was g�nnt
 
 b_output $nick $uhost $handle $chan $args			;# Aufruf der Ausgabe Funktion und �bergabe der Variblen von Nick,Channel,Argumente&Co. an die Ausgabe 
}													;# End of proc

### Definition der Ausgabe des Kellners
### Ausgabe Funktionen f�r die Sachen
proc b_thx {nick uhost handle chan args} {
 global barkdes bardes barchan barnick barargs bardrin	;# Globale Farb Variblen definieren
 global bar_va bar_nick									;# Globale Variblen definieren

	if {![bar:active $chan]} { return 0 } 				;# falscher Channel: nix machen
 
 set btmpnick $nick										;# Nick zwischen speichern
 set nick [string tolower $nick]						;# Nick in Kleinschreibung
 set bar_see 1 											;# Die Variable wird umgesetzt, falls man was Bestellt hat
	
 	foreach search [array names bar_nick] {		  		;# Liste aller Eintr�ge durchlaufen
		if {$search != 0} {					 			;# wenn kein leerer Eintrag

			set bparts [split $bar_nick($search) "&"] 	;# Das & entfernen
			set bnick [lindex $bparts 0]		   		;# Nick extrahieren
			set bnick [string tolower $bnick]		    ;# Nick in Kleinschreibung
			set bdrink [lindex $bparts 1]				;# Mode extrahieren
								
			if {$nick == $bnick} {						;# Pr�fen ob Nick gleich ist, mit der Varible aus bar_nick
				putserv "PRIVMSG $chan : $bardrin$bdrink$bardes immer doch $barnick$btmpnick$bardes, bitte sch�n :D"
				set bar_see 0							;# User hat Berechtigung f�r die Mode�nderung
				unset bar_nick($btmpnick&$bdrink)	 	;# Array Datenfeld freigeben
			} 
		}												;# end if search
	}	 												;# end foreach
	if {$bar_see != 0} {								;# Falls man nichts Bestellt hat, kommt die Meldung
		putserv "NOTICE $nick :$bar_va(text2)"
	}													;# end if Fehlermeldung
}														;# End of proc

### Ausgabe der Bestellten Getr�nke
proc b_output {nick uhost handle chan args} {
 
	if {![bar:active $chan]} { return 0 }			;# falscher Channel: nix machen
 
 global bar_va bar_nick  							;# Globale Variblen definieren

 	if {$args == "{{}}"} {							;# Pr�ft ob ein Argument eingeben wurde	
		set barsel "1"								;# Falsch kein Argument da ist
		set bentry "$nick&$bar_va(drink)"			;# Eintrag f�r Variable setzen
	} else {										;# Falsch kein Nick angegeben wurde
		set bnick [lindex $args 0]					;# Extrahieren des Nicks
		set bnick [form $bnick]						;# Leerzeichen entfernen vom Nick
		set barsel "0"								;# Es wurde ein Nick eingegeben
		set bentry "$bnick&$bar_va(drink)"			;# Eintrag f�r Variable setzen		
	}												;# End if

	if {([info exists bar_nick($bentry)])} {   		;# Wenn der Eintrag existiert, Fehlermeldung
		putserv "PRIVMSG $chan : $bar_va(text1)"
	} else {										;# Wenn der nicht da ist, dann weiter machen
		set i "1"									;# Start Wert f�r die for Schleifen			
		if {$barsel == 0} {							;# Wurde ein Nick angegeben, dann diese Ausgabe
			for {set i} {$i <= $bar_va(lmess)} {incr i +1} {
				putserv "PRIVMSG $chan : $bar_va(lmessage$i) $bnick"
			}
		} else {									;# Wurde kein Nick angegeben, dann diese Ausgabe
			for {set i} {$i <= $bar_va(amess)} {incr i +1} {
				putserv "PRIVMSG $chan : $bar_va(amessage$i)"
			}
		}											;# End if f�r eingegebenen Nick
	}												;# End if falls Eintrag existiert

	if {$bar_va(drink) != "Zucker" && $bar_va(drink) != "Milch"} {
		set bar_nick($bentry) $bentry				;# Eintrag setzen
	}
}													;# End of proc

### Alle Nicks aus dem Array l�schen, aber nur f�r OPs
proc b_reset {nick uhost handle chan args} {

	if {![bar:active $chan]} { return 0 } 					;# Falscher Channel: nix machen	

 global bar_va bar_nick 									;# Globale Variblen definieren
   
	if { [isop $nick $chan] } {								;# Ob Nick im Channel OP hat
		if {[info exists bar_nick]} {						;# Falls Felder definiert sind
			foreach search [array names bar_nick] {		  	;# Liste aller Eintr�ge durchlaufen
				if {$search != 0} {	

					set bparts [split $bar_nick($search) "&"] ;# Das & entfernen
					set bnick [lindex $bparts 0]		   	;# Nick extrahieren
					set bnick [form $bnick]					;# Nick formatieren
					set bdrink [lindex $bparts 1]			;# Drink extrahieren
					set bdrink [form $bdrink]				;# Drink formatieren
								
					unset bar_nick($bnick&$bdrink)	 		;# Array Datenfeld freigeben
					putserv "NOTICE $nick : $bar_va(text5)"
				}											;# end if search
			}												;# end foreach Schleife f�r bar_nick
		} else {											
			putserv "NOTICE $nick : $bar_va(text4)"
		}													;# end if check ob Nicks gespeichert sind	 		
	} else {										
		putserv "NOTICE $nick : $bar_va(text3)"
	}														;# end if check ob OP
}															;# End of proc

### Bestellte Getr�nke wie Benutzer anzeigen lassen
proc b_list {nick uhost handle chan args} {
 
   if {![bar:active $chan]} { return 0 } 					;# Falscher Channel: nix machen
 
 global bardes barkdes barnick barargs bardrin				;# Globale Farb Variblen definieren
 global bar_va bar_nick 									;# Globale Variblen definieren
   
 set select 1												;# Ob Nicks gespeichert sind (1 f�r nich, 0 f�r ja)
  
	if { [isop $nick $chan] } {								;# Ob Nick im Channel OP hat
		if {[info exists bar_nick]} {						;# Falls Felder definiert sind
			foreach search [array names bar_nick] {		  	;# Liste aller Eintr�ge durchlaufen
				if {$search != 0} {	

					set bparts [split $bar_nick($search) "&"] ;# Das & entfernen
					set bnick [lindex $bparts 0]		   	;# Nick extrahieren
					set bnick [form $bnick]					;# Nick formatieren
					set bdrink [lindex $bparts 1]			;# Drink extrahieren
					set bdrink [form $bdrink]				;# Drink formatieren
					
					putserv "NOTICE $nick :$bardes Bestellte Sachen -->$bardrin$bdrink$bardes von $barnick$bnick"
					set select 0
				}											;# end if search
			}												;# end foreach Schleife f�r bar_nick
		} 
		if {$select != 0} {
			putserv "NOTICE $nick : $bar_va(text4)"
		}													;# end if check ob Nicks gespeichert sind	 		
	} else {										
		putserv "NOTICE $nick : $bar_va(text3)"
	}														;# end if check ob OP
}															;# End of proc

### Mal schauen wer sich bedankt hat, ansonsten kick 
### und falls nich mehr da, dann werden die Getr�nke trotzdem gel�scht
proc b_timer {args} {

 global bar_va 											;# Globale Variblen definieren
 
	for {set i 1} {$i <= $bar_va(chanact)} {incr i +1} {
		if {[botonchan $bar_va(channel$i)] == 1} {		;# Ob Bot aufm Channel is
			if {![bar:active $bar_va(channel$i)]} {
				return 0								;# falscher Channel: nix machen
			}
		}												;# End of for Zum �berpr�fen der Channel
	}													;# End of if Ob Bot aufm Channel ist

 global barkdes barchan barnick barargs	bardes			;# Globale Farb Variblen definieren
 global bar_nick 										;# Globale Variblen definieren
 
  	if {[info exists bar_nick]} {						;# Falls Felder definiert sind
	
		set bar_tmp [split $args " "]
		set bar_min [lindex $bar_tmp 0]
		
		### Aller 10 minten schauen und dann kicken
		if {[string index $bar_min 1] == 0} {

			foreach search [array names bar_nick] {		;# Liste aller Eintr�ge durchlaufen
				if {$search != 0} {	

					set bparts [split $bar_nick($search) "&"] ;# Das & entfernen
					set bnick [lindex $bparts 0]		;# Nick extrahieren
					set bnick [form $bnick]				;# Nick formatieren
					set bdrink [lindex $bparts 1]		;# Drink extrahieren
					set bdrink [form $bdrink]			;# Drink formatieren
					
					for {set j 1} {$j <= $bar_va(chanact)} {incr j +1} {
						if {[onchan $bnick $bar_va(channel$j)] == 1} {
							putserv "PRIVMSG $bar_va(channel) :$barkdes$bar_va(kellner): Du wolltest ja nit h�ren, bis demn�chst $barnick$bnick"
							putkick $bar_va(channel$j) $bnick $bar_va(kick)
						}								;# End of if Pr�fen ob User aufm Channel ist
					}									;# End of for Durchgehen der Channel
					unset bar_nick($bnick&$bdrink)		;# Array Datenfeld freigeben
				}										;# end if search
			}											;# end foreach Schleife f�r bar_nick
		### Aller 5 minten erinnern
		} elseif {[string index $bar_min 1] == 5} {		;# end of if 10 min check
		
			foreach search [array names bar_nick] {		;# Liste aller Eintr�ge durchlaufen
				if {$search != 0} {	

				set bparts [split $bar_nick($search) "&"] ;# Das & entfernen
				set bnick [lindex $bparts 0]		   	;# Nick extrahieren
				set bnick [form $bnick]					;# Nick formatieren
				set bdrink [lindex $bparts 1]			;# Drink extrahieren
				set bdrink [form $bdrink]				;# Drink formatieren
				
					for {set j 1} {$j <= $bar_va(chanact)} {incr j +1} {
						if {[onchan $bnick $bar_va(channel$j)] == 1} {
							putserv "PRIVMSG $bar_va(channel$j) : $barkdes$bar_va(kellner):$bardes  Wie siehts aus $barnick$bnick$barkdes ??"
						}								;# End of if Pr�fen ob User aufm Channel ist
					}									;# End of for Durchgehen der Channel
				}										;# end if search
			}											;# end foreach Schleife f�r bar_nick
		### Nochmal erinnern bevor rausschmiess
		} elseif {[string index $bar_min 1] == 9} {
			foreach search [array names bar_nick] {		;# Liste aller Eintr�ge durchlaufen
				if {$search != 0} {	

				set bparts [split $bar_nick($search) "&"] ;# Das & entfernen
				set bnick [lindex $bparts 0]		   	;# Nick extrahieren
				set bnick [form $bnick]					;# Nick formatieren
				set bdrink [lindex $bparts 1]			;# Drink extrahieren
				set bdrink [form $bdrink]				;# Drink formatieren
					
					for {set j 1} {$j <= $bar_va(chanact)} {incr j +1} {
						if {[onchan $bnick $bar_va(channel$j)] == 1} {
							putserv "PRIVMSG $bar_va(channel$j) :$barkdes$bar_va(kellner):$bardes Also langsam finde ich das nit mehr lustig $barnick$bnick$barkdes >:"
						}								;# End of if Pr�fen ob User aufm Channel ist
					}									;# End of for Durchgehen der Channel
				}										;# end if search
			}											;# end foreach Schleife f�r bar_nick
		
		} else {
			return 0									;# Abbrechen
		}
	} else {
		return 0										;# Abbrechen
	}													;# end of if of bar_nick da is
}														;# End of proc

### Definition der Zusatz Funktionen zum Kellner
### Zum Entfernen der Leerzeichen aus dem Sting
proc form {formtext} {							;# Formatierung String
	set t [string trimleft $formtext]			;# f�hrende Leerzeichen entfernen
	set t [string trimright $t]					;# folgende Leerzeichen entfernen
	return $t									;# formatierten String zur�ckliefern
}												;# End of proc

### Pr�fen ob die Bar auf dem Channel l�uft
proc bar:active {chan} {
	foreach setting [channel info $chan] {		;# "channel info" ist ein TCL Befehl!
		if {[regexp -- {^[\+-]} $setting]} {
			if {$setting == "+bar"} { return 1 }
		}
	}
	return 0
}												;# End of proc

putlog "Bar Script $bar_va(version) by Aj "
