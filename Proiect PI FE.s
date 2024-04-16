.org 1800h


PI_ON_DELAY_SEL				;etichetă PI_ON_DELAY_SEL , definită global pentru alte programe
	.db 000h	
PI_TEMP						;etichetă PI_TEMP , definită pentru stocare temporară a registrului A
	.db 000h		
PI_AFISAJ_SELECTIE				;etichetă PI_AFISAJ_SELECTIE
	.db 000h ; 
	.db 000h ; 
	.db 000h ; 
	.db 085h ;L
	.db 08fh ;E
	.db 0aeh ;S
	
FE_ON_EXPRESS_SEL				;etichetă FE_ON_EXPRESS_SEL , definită global pentru alte programe
	.db 000h
FE_TEMP						;etichetă PI_TEMP , definită pentru stocare temporară a registrului A
	.db 000h	
FE_AFISAJ_SELECTIE				;etichetă PI_AFISAJ_SELECTIE
	.db 000h ; 
	.db 000h ; 
	.db 000h ; 
	.db 085h ;L
	.db 08fh ;E
	.db 0aeh ;S


.org 3000h


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Funcția Pornire Întârziată

PI_ENTRY_POINT					;etichetă, adresa de intrare a programului Pornire Întârziată
	LD hl, PI_ON_DELAY_SEL		;LD - load - încarcă adresa etichetei PI_ON_DELAY_SEL în registrul HL (adresa în sine)
	LD (hl),000h				;LD - load - încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL 

PI_AFISAJ						;etichetă, marchează începutul pentru afișaj
	LD hl, PI_TEMP				;LD - load - încarcă adresa etichetei PI_TEMP în registrul HL (adresa în sine), definită pentru stocare temporară a registrului A la validare
	LD (hl),000h				;LD - load - încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL 	
	LD ix, PI_BLOCK_AFISARE		;încarcă adresa indicată de eticheta PI_BLOCK_AFISARE în registrul index IX
	CALL PI_SCAN				;realizează un apel la o subrutină etichetată PI_SCAN, funcția SCAN definită mai jos

	CP 0h						;compară conținutul registrului A (folosit de funcția SCAN) cu valoarea 0 (scade 0 din A)
	JP z, PI_DELAY_ALES			;face un salt (jump) la eticheta PI_DELAY_ALES dacă rezultatul comparației este zero (A este egal cu 0)
	
	CP 1h						;compară conținutul registrului A (folosit de funcția SCAN) cu valoarea 1 (scade 1 din A)
	LD hl, PI_TEMP				;încarcă adresa de memorie a variabilei PI_TEMP în registrul HL
	LD (hl), a					;LD - load - încarcă valoarea registrului A în locația de memorie indicată de registrul HL 
	JP z, PI_VALIDARE_1			;face un salt (jump) la eticheta PI_VALIDARE_1 dacă rezultatul comparației este zero (A este egal cu 1)
	
	CP 2h						;compară conținutul registrului A (folosit de funcția SCAN) cu valoarea 2 (scade 2 din A)
	LD hl, PI_TEMP				;încarcă adresa de memorie a variabilei PI_TEMP în registrul HL
	LD (hl), a					;LD - load - încarcă valoarea registrului A în locația de memorie indicată de registrul HL 
	JP z, PI_VALIDARE_2			;face un salt (jump) la eticheta PI_VALIDARE_2 dacă rezultatul comparației este zero (A este egal cu 1)
	
	CP 3h						;compară conținutul registrului A (folosit de funcția SCAN) cu valoarea 3 (scade 3 din A)
	LD hl, PI_TEMP				;încarcă adresa de memorie a variabilei PI_TEMP în registrul HL
	LD (hl), a					;LD - load - încarcă valoarea registrului A în locația de memorie indicată de registrul HL 
	JP z, PI_VALIDARE_3			;face un salt (jump) la eticheta PI_VALIDARE_3 dacă rezultatul comparației este zero (A este egal cu 1)
	
	JP PI_AFISAJ				;dacă A nu este 0, 1, 2 sau 3, face un salt înapoi la PI_AFISAJ, ceea ce creează o buclă infinită.

PI_VALIDARE_1
	LD a, (CS_PI_P30)			;încarcă valoarea stocată la adresa lui CS_PI_P30 în registrul A				 
	CP 1h						;compară conținutul registrului A (folosit de funcția COMPARE) cu valoarea 1 (scade 1 din A)
	JP z, PI_DELAY_ALES			;face un salt (jump) la eticheta PI_DELAY_ALES dacă rezultatul comparației este zero (A este egal cu 1)
	JP PI_AFISAJ				;dacă rezultatul nu este 0, atunci sare la eticheta PI_AFISAJ (face buclă infinită - loop) 

PI_VALIDARE_2
	LD a, (CS_PI_P60)			;încarcă valoarea stocată la adresa lui CS_PI_P60 în registrul A				 
	CP 1h						;compară conținutul registrului A (folosit de funcția COMPARE) cu valoarea 1 (scade 1 din A)
	JP z, PI_DELAY_ALES			;face un salt (jump) la eticheta PI_DELAY_ALES dacă rezultatul comparației este zero (A este egal cu 1)
	JP PI_AFISAJ				;dacă rezultatul nu este 0, atunci sare la eticheta PI_AFISAJ (face buclă infinită - loop) 

PI_VALIDARE_3
	LD a, (CS_PI_P90)			;încarcă valoarea stocată la adresa lui CS_PI_P90 în registrul A				 
	CP 1h						;compară conținutul registrului A (folosit de funcția COMPARE) cu valoarea 1 (scade 1 din A)
	JP z, PI_DELAY_ALES			;face un salt (jump) la eticheta PI_DELAY_ALES dacă rezultatul comparației este zero (A este egal cu 1)
	JP PI_AFISAJ				;dacă rezultatul nu este 0, atunci sare la eticheta PI_AFISAJ (face buclă infinită - loop) 
	
PI_DELAY_ALES					;etichetă, marchează începutul pentru rezultatul întârzierii alese
	LD hl, PI_TEMP				;LD - load - încarcă adresa etichetei PI_ON_DELAY_SEL în registrul HL (adresa în sine)
	LD a, (hl)					;încarcă adresa de memorie a variabilei PI_TEMP în registrul HL	
	LD hl, PI_ON_DELAY_SEL		;LD - load - încarcă adresa etichetei PI_ON_DELAY_SEL în registrul HL (adresa în sine)
	LD (hl), a					;încarcă valoarea din registrul A la adresa specificată de registrul HL - (0 - 0 min, 1 - 30 min, 2 - 60 min, 3 - 90 min)
	JP PI_DISPLAY_DELAY			;face un salt (jump) la eticheta PI_DISPLAY_DELAY

PI_BLOCK_AFISARE				;etichetă PI_BLOCK_AFISARE
	.db 000h ; 
	.db 0b6h ;y
	.db 03fh ;A
	.db 085h ;L
	.db 08fh ;E
	.db 0b3h ;d

PI_SCAN .equ 05FEH				;definește o constantă numită PI_SCAN cu valoarea hexazecimală 05FEH (subrutina SCAN)
		
;; DISPLAY SELECTIE INTARZIERE

PI_DISPLAY_DELAY				;etichetă pentru PI_DISPLAY_DELAY, afișează opțiunea aleasă la PI_ON_DELAY_SEL 
	ld hl, PI_AFISAJ_SELECTIE	;se încarcă adresa de început a zonei de afișaj PI_AFISAJ_SELECTIE în registrul HL
	ld (hl),000h ; 			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	inc hl						;inc - incrementează conținutul registrului HL, astfel încât să pointeze la următoarea locație de memorie
	ld (hl),000h ; 			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	inc hl						;inc - incrementează conținutul registrului HL, astfel încât să pointeze la următoarea locație de memorie
	ld (hl),000h ; 			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	inc hl						;inc - incrementează conținutul registrului HL, astfel încât să pointeze la următoarea locație de memorie
	ld (hl),085h ;L			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	inc hl						;inc - incrementează conținutul registrului HL, astfel încât să pointeze la următoarea locație de memorie
	ld (hl),08fh ;E			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	inc hl						;inc - incrementează conținutul registrului HL, astfel încât să pointeze la următoarea locație de memorie
	ld (hl),0aeh ;S			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	
	ld hl, PI_ON_DELAY_SEL		;încarcă adresa de memorie a variabilei PI_ON_DELAY_SEL în registrul HL
	ld a, (hl)					;încarcă valoarea stocată la adresa la care pointează HL în registrul A
	
	call PI_HEX7				;apelează o subrutină numită PI_HEX7. Acesta este un salt către variabila PI_HEX7 declarată mai jos
	
	ld hl, PI_AFISAJ_SELECTIE	;încarcă adresa de început a zonei de afișaj PI_AFISAJ_SELECTIE în registrul HL
	inc hl						;incrementează conținutul registrului HL, HL acum pointează la următoarea poziție din zona de afișaj
	ld (hl), a					;încarcă valoarea din registrul A la adresa indicată de registrul HL, practic se scrie valoarea convertită în hexazecimal în zona de afișaj
	
	ld ix, PI_AFISAJ_SELECTIE	;încarcă adresa de început a zonei de afișaj PI_AFISAJ_SELECTIE în registrul IX folosit de subrutina SCAN
	call PI_SCAN_2				;apelează subrutina PI_SCAN_2 (SCAN), care afișează conținutul zonei de afișaj pe ecran până când se vor apăsa una din următoarele taste de mai jos

	CP PI_SCAN_A_CODE   		;CP compara - tasta apăsată cu variabila SCAN_A_CODE declarată mai jos
	JP z, FE_ENTRY_POINT		;JP - jump - sare la începutul etichetei FE_ENTRY_POINT dacă se apasă tasta A (ACCEPT)

	CP PI_SCAN_B_CODE			;CP compara - tasta apăsată cu variabila SCAN_B_CODE declarată mai jos
	JP z, PI_ENTRY_POINT		;JP - jump - sare la începutul etichetei PI_ENTRY_POINT dacă se apasă tasta B (BACK)

	JP PI_DISPLAY_DELAY			;JP - jump - sare la începutul etichetei PI_DISPLAY_DELAY (loop) dacă nu se apasă tasta A sau B
		
PI_SCAN_2 .equ 05feh			;definește o constantă numită PI_SCAN_2 cu valoarea hexazecimală 05FEH (subrutina SCAN)
PI_HEX7 .equ 0689h				;convertește o cifră în baza 16 în formatul de afișare cu 7segmente, rezultatul este memorat în registrul A
PI_SCAN_A_CODE .equ 000ah		;codul din funcția SACN pentru tasta A
PI_SCAN_B_CODE .equ 000bh		;codul din funcția SACN pentru tasta B
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Funcția EXPRESS	
	
	
FE_ENTRY_POINT					;etichetă, adresa de intrare a programului Pornire Întârziată
	LD hl, FE_ON_EXPRESS_SEL	;LD - load - încarcă adresa etichetei FE_ON_EXPRESS_SEL în registrul HL (adresa în sine)
	LD (hl),000h				;LD - load - încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL 

FE_AFISAJ						;etichetă, marchează începutul pentru afișaj
	LD hl, FE_TEMP				;LD - load - încarcă adresa etichetei FE_TEMP în registrul HL (adresa în sine), definită pentru stocare temporară a registrului A la validare
	LD (hl),000h				;LD - load - încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL 	
	LD ix, FE_BLOCK_AFISARE		;încarcă adresa indicată de eticheta FE_BLOCK_AFISARE în registrul index IX
	CALL FE_SCAN				;realizează un apel la o subrutină etichetată FE_SCAN, funcția SCAN definită mai jos

	CP 0h						;compară conținutul registrului A (folosit de funcția SCAN) cu valoarea 0 (scade 0 din A)
	JP z, FE_ALES				;face un salt (jump) la eticheta FE_ALES dacă rezultatul comparației este zero (A este egal cu 0)
	
	CP 1h						;compară conținutul registrului A (folosit de funcția SCAN) cu valoarea 1 (scade 1 din A)
	LD hl, FE_TEMP				;încarcă adresa de memorie a variabilei FE_TEMP în registrul HL
	LD (hl), a					;LD - load - încarcă valoarea registrului A în locația de memorie indicată de registrul HL 
	JP z, FE_VALIDARE			;face un salt (jump) la eticheta FE_VALIDARE dacă rezultatul comparației este zero (A este egal cu 1)
	
	JP FE_AFISAJ				;dacă A nu este 0 sau 1 face un salt înapoi la FE_AFISAJ, ceea ce creează o buclă infinită.

FE_VALIDARE					;etichetă
	LD a, (CS_FE_FCT_EXPRESS)	;încarcă valoarea stocată la adresa lui CS_FE_FCT_EXPRESS în registrul A				 
	CP 1h						;compară conținutul registrului A (folosit de funcția COMPARE) cu valoarea 1 (scade 1 din A)
	JP z, FE_ALES				;face un salt (jump) la eticheta FE_ALES dacă rezultatul comparației este zero (A este egal cu 1)
	JP FE_AFISAJ				;dacă rezultatul nu este 0, atunci sare la eticheta FE_AFISAJ (face buclă infinită - loop) 

	
FE_ALES						;etichetă, marchează începutul pentru rezultatul întârzierii alese
	LD hl, FE_TEMP				;LD - load - încarcă adresa etichetei FE_ON_DELAY_SEL în registrul HL (adresa în sine)
	LD a, (hl)					;încarcă adresa de memorie a variabilei FE_TEMP în registrul HL	
	LD hl, FE_ON_EXPRESS_SEL	;LD - load - încarcă adresa etichetei FE_ON_EXPRESS_SEL în registrul HL (adresa în sine)
	LD (hl), a					;încarcă valoarea din registrul A la adresa specificată de registrul HL - (0 - inactiv, 1 - activ)
	JP FE_DISPLAY_SELECTIE		;face un salt (jump) la eticheta FE_DISPLAY_SELECTIE

FE_BLOCK_AFISARE				;etichetă FE_BLOCK_AFISARE
	.db 0aeh ;S
	.db 08fh ;E
	.db 003h ;r
	.db 01fh ;P
	.db 037h ;H
	.db 08fh ;E

FE_SCAN .equ 05FEH				;definește o constantă numită FE_SCAN cu valoarea hexazecimală 05FEH (subrutina SCAN)

;; DISPLAY SELECTIE EXPRESS
	
FE_DISPLAY_SELECTIE			;etichetă pentru FE_DISPLAY_SELECTIE, afișează opțiunea aleasă la FE_ON_EXPRESS_SEL 
	ld hl, FE_AFISAJ_SELECTIE	;se încarcă adresa de început a zonei de afișaj FE_AFISAJ_SELECTIE în registrul HL
	ld (hl),000h ; 			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	inc hl						;inc - incrementează conținutul registrului HL, astfel încât să pointeze la următoarea locație de memorie
	ld (hl),000h ; 			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	inc hl						;inc - incrementează conținutul registrului HL, astfel încât să pointeze la următoarea locație de memorie
	ld (hl),000h ; 			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	inc hl						;inc - incrementează conținutul registrului HL, astfel încât să pointeze la următoarea locație de memorie
	ld (hl),085h ;L			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	inc hl						;inc - incrementează conținutul registrului HL, astfel încât să pointeze la următoarea locație de memorie
	ld (hl),08fh ;E			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	inc hl						;inc - incrementează conținutul registrului HL, astfel încât să pointeze la următoarea locație de memorie
	ld (hl),0aeh ;S			;încarcă valoarea 000h (0 în hexazecimal) în locația de memorie indicată de registrul HL
	
	ld hl, FE_ON_EXPRESS_SEL	;încarcă adresa de memorie a variabilei FE_ON_EXPRESS_SEL în registrul HL
	ld a, (hl)					;încarcă valoarea stocată la adresa la care pointează HL în registrul A
	
	call PI_HEX7				;apelează o subrutină numită FE_HEX7. Acesta este un salt către variabila FE_HEX7 declarată mai jos
	
	ld hl, FE_AFISAJ_SELECTIE	;încarcă adresa de început a zonei de afișaj FE_AFISAJ_SELECTIE în registrul HL
	inc hl						;incrementează conținutul registrului HL, HL acum pointează la următoarea poziție din zona de afișaj
	ld (hl), a					;încarcă valoarea din registrul A la adresa indicată de registrul HL, practic se scrie valoarea convertită în hexazecimal în zona de afișaj
	
	ld ix, FE_AFISAJ_SELECTIE	;încarcă adresa de început a zonei de afișaj FE_AFISAJ_SELECTIE în registrul IX folosit de subrutina SCAN
	call FE_SCAN_2				;apelează subrutina FE_SCAN_2 (SCAN), care afișează conținutul zonei de afișaj pe ecran până când se vor apăsa una din următoarele taste de mai jos

	CP FE_SCAN_A_CODE   		;CP compara - tasta apăsată cu variabila SCAN_A_CODE declarată mai jos
	JP z, FH_ENTRY_POINT		;JP - jump - sare la începutul etichetei FH_ENTRY_POINT dacă se apasă tasta A (ACCEPT)

	CP FE_SCAN_B_CODE			;CP compara - tasta apăsată cu variabila SCAN_B_CODE declarată mai jos
	JP z, FE_ENTRY_POINT		;JP - jump - sare la începutul etichetei FE_ENTRY_POINT dacă se apasă tasta B (BACK)

	JP FE_DISPLAY_SELECTIE		;JP - jump - sare la începutul etichetei FE_DISPLAY_DELAY (loop) dacă nu se apasă tasta A sau B
		
FE_SCAN_2 .equ 05feh			;definește o constantă numită FE_SCAN_2 cu valoarea hexazecimală 05FEH (subrutina SCAN)
FE_HEX7 .equ 0689h				;convertește o cifră în baza 16 în formatul de afișare cu 7segmente, rezultatul este memorat în registrul A
FE_SCAN_A_CODE .equ 000ah		;codul din funcția SACN pentru tasta A
FE_SCAN_B_CODE .equ 000bh		;codul din funcția SACN pentru tasta B




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;STUB;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CS_PI_P30						;etichetă
	.db 001h					;(0- inactiv  1-disponibil )

CS_PI_P60						;etichetă
	.db 001h					;(0- inactiv  1-disponibil )

CS_PI_P90						;etichetă
	.db 001h					;(0- inactiv  1-disponibil )

CS_FE_FCT_EXPRESS				;etichetă
	.db 001h					;(0- inactiv  1-disponibil )	
FH_ENTRY_POINT
	HALT
;;;;;;;;;;;;;;;;;;;;;;;;;;;END STUB;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.end
	rst 38h
