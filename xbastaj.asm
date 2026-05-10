.include "atari.inc"

posXP0=200                   ;pameti pozice hracu
posXP1=201
posXP2=202
posXP3=203
posYP0=204
posYP1=205
posYP2=206
posYP3=207

posXM0=208                   ;pameti pozice strel
posXM1=209
posXM2=210
posXM3=211
posYM0=212
posYM1=213
posYM2=214
posYM3=215
;-----------------------------------------------------------------------------
XMIN=48
XMAX=200
YMIN=16
YMAX=104
;-----------------------------------------------------------------------------
X0P0=80                      ;pocatecni pozice hracu
Y0P0=30
X0P1=100
Y0P1=50
X0P2=120
Y0P2=70
X0P3=140
Y0P3=90

;-----------------------------------------------------------------------------
X0M0=160                    ;pocatecni pozice strel
Y0M0=40
X0M1=170
Y0M1=40
X0M2=180
Y0M2=40
X0M3=190
Y0M3=40
;-----------------------------------------------------------------------------
barva0=5*16+8               ;barvy hracu
barva1=12*16+8
barva2=3*16+8
barva3=15*16+8

PM_page=152                 ;stranka pro hrace

off_hrac0=512               ;offesety pro hrace
off_hrac1=off_hrac0+128
off_hrac2=off_hrac1+128
off_hrac3=off_hrac2+128
off_strela=384

adr_hrac0= PM_page*256+off_hrac0
adr_hrac1= PM_page*256+off_hrac1
adr_hrac2= PM_page*256+off_hrac2
adr_hrac3= PM_page*256+off_hrac3
adr_strela= PM_page*256+off_strela

.CODE
;==============================================================================
 .proc main

        jsr sprite_init         ; inicializace spritu

        lda #3                  ; bitové pole: povolení hráčů i střel
        sta GRACTL              ; rídicí registr GRACTL na čipu GTIA

        lda #1                  ; priorita hráčů a pozadí
        sta GPRIOR              ; řídicí registr GPRIOR na čipu GTIA

        lda #PM_page            ; paměťová stránka pro hrace
        sta PMBASE

        lda #46                 ; povolení PMG DMA
        sta SDMCTL
;-----------------------------------------------------------------------------
cyklus:
        jsr vsync

;-----------------------------------------------------------------------------
        lda STICK0              ; čtení joysticku 0
c00:
        cmp #11                 ; L0
        bne c01
        jsr movLP0
c01:
        cmp #7                  ; R0
        bne c02
        jsr movRP0
c02:
        cmp #14                  ; U0
        bne c03
        jsr movUP0
c03:
        cmp #13                  ; D0
        bne c04
        jsr movDP0
c04:
        cmp #6                  ; RU0
        bne c05
        jsr movRP0
        jsr movUP0
c05:
        cmp #5                  ; RDU0
        bne c06
        jsr movRP0
        jsr movDP0
c06:
        cmp #10                 ; LU0
        bne c07
        jsr movLP0
        jsr movUP0
c07:
        cmp #9                  ; LD0
        bne c08
        jsr movLP0
        jsr movDP0
c08:
;-----------------------------------------------------------------------------
        lda STICK1              ; čtení joysticku 1
c10:
        cmp #11                 ; L1
        bne c11
        jsr movLP1
c11:
        cmp #7                  ; R1
        bne c12
        jsr movRP1
c12:
        cmp #14                  ; U1
        bne c13
        jsr movUP1
c13:
        cmp #13                  ; D1
        bne c14
        jsr movDP1
c14:
        cmp #6                  ; RU1
        bne c15
        jsr movRP1
        jsr movUP1
c15:
        cmp #5                  ; RDU1
        bne c16
        jsr movRP1
        jsr movDP1
c16:
        cmp #10                 ; LU1
        bne c17
        jsr movLP1
        jsr movUP1
c17:
        cmp #9                  ; LD1
        bne c18
        jsr movLP1
        jsr movDP1
c18:
;-----------------------------------------------------------------------------
c40:    lda STRIG0              ; cteni tlacitka 0
        bne c41
        lda #barva0+6           ; barva hráče
        sta PCOLR0
        jmp c43

c41:    lda P0PL              ;test kolize
        beq c42
        lda #barva0+4           ; barva hráče
        sta PCOLR0
        jmp c43
c42:    lda #barva0             ; barva hráče
        sta PCOLR0
c43:
;-----------------------------------------------------------------------------
c50:    lda STRIG1              ; cteni tlacitka 0
        bne c51
        lda #barva1+6           ; barva hráče
        sta PCOLR1
        jmp c53

c51:    lda P1PL              ;test kolize
        beq c52
        lda #barva1+4           ; barva hráče
        sta PCOLR1
        jmp c53
c52:    lda #barva1             ; barva hráče
        sta PCOLR1
c53:
;-----------------------------------------------------------------------------
c60:    lda STRIG0              ; cteni tlacitka 0
        bne c61
        lda #barva2+6           ; barva hráče
        sta PCOLR2
        jmp c63

c61:    lda P2PL              ;test kolize
        beq c62
        lda #barva2+4           ; barva hráče
        sta PCOLR2
        jmp c63
c62:    lda #barva2             ; barva hráče
        sta PCOLR2
c63:
;-----------------------------------------------------------------------------
c70:    lda STRIG1              ; cteni tlacitka 0
        bne c71
        lda #barva3+6           ; barva hráče
        sta PCOLR3
        jmp c73

c71:    lda P3PL              ;test kolize
        beq c72
        lda #barva3+4           ; barva hráče
        sta PCOLR3
        jmp c73
c72:    lda #barva3             ; barva hráče
        sta PCOLR3
c73:
;-----------------------------------------------------------------------------
c99:    sta HITCLR              ; vymazat informace o kolizích
        jmp cyklus
.endproc

;==============================================================================
.proc movLP0
        ldx posXP0              ;nacteno aktualni pozice
        cpx #XMIN               ;test okraje
        beq mKLP0
        dex                     ;posun
        stx posXP0              ;ulozeni pozice
        stx HPOSP0              ;nastaveni pozice
mKLP0:  rts
.endproc
;-----------------------------------------------------------------------------
.proc movRP0
        ldx posXP0              ;nacteno aktualni pozice
        cpx #XMAX               ;test okraje
        beq mKRP0
        inx                     ;posun
        stx posXP0              ;ulozeni pozice
        stx HPOSP0              ;nastaveni pozice
mKRP0:  rts
.endproc
;-----------------------------------------------------------------------------
.proc movUP0
        pha
        ldy posYP0              ;nacteno aktualni pozice
        cpy #YMIN               ;test okraje
        beq mKUP0
        dey                     ;posun
        sty posYP0              ;ulozeni pozice
        ldx #9                  ;pocitadlo

mUP0:   lda adr_hrac0+1, y      ;nacteni byte
        sta adr_hrac0, y        ;uložit byte
        iny
        dex                     ;snizeni pocitadla
        bne mUP0
mKUP0:  pla
        rts
.endproc
;-----------------------------------------------------------------------------
.proc movDP0
        pha
        ldy posYP0              ;nacteno aktualni pozice
        cpy #YMAX               ;test okraje
        beq mKDP0
        iny                     ;posun
        sty posYP0              ;ulozeni pozice
        tya
        clc
        adc #7
        tay
        ldx #9                  ;pocitadlo

mDP0:   lda adr_hrac0-1, y        ;nacteni byte
        sta adr_hrac0, y        ;uložit byte
        dey
        dex                     ;snizeni pocitadla
        bne mDP0
mKDP0:  pla
        rts
.endproc
;-----------------------------------------------------------------------------
.proc movLP1
        ldx posXP1              ;nacteno aktualni pozice
        cpx #XMIN               ;test okraje
        beq mKLP1
        dex                     ;posun
        stx posXP1              ;ulozeni pozice
        stx HPOSP1              ;nastaveni pozice
mKLP1:  rts
.endproc
;-----------------------------------------------------------------------------
.proc movRP1
        ldx posXP1              ;nacteno aktualni pozice
        cpx #XMAX               ;test okraje
        beq mKRP1
        inx                     ;posun
        stx posXP1              ;ulozeni pozice
        stx HPOSP1              ;nastaveni pozice
mKRP1:  rts
.endproc
;-----------------------------------------------------------------------------
.proc movUP1
        pha
        ldy posYP1              ;nacteno aktualni pozice
        cpy #YMIN               ;test okraje
        beq mKUP1
        dey                     ;posun
        sty posYP1              ;ulozeni pozice
        ldx #9                  ;pocitadlo

mUP1:   lda adr_hrac1+1, y      ;nacteni byte
        sta adr_hrac1, y        ;uložit byte
        iny
        dex                     ;snizeni pocitadla
        bne mUP1
mKUP1:  pla
        rts
.endproc
;-----------------------------------------------------------------------------
.proc movDP1
        pha
        ldy posYP1              ;nacteno aktualni pozice
        cpy #YMAX               ;test okraje
        beq mKDP1
        iny                     ;posun
        sty posYP1              ;ulozeni pozice
        tya
        clc
        adc #7
        tay
        ldx #9                  ;pocitadlo

mDP1:   lda adr_hrac1-1, y       ;nacteni byte
        sta adr_hrac1, y        ;uložit byte
        dey
        dex                     ;snizeni pocitadla
        bne mDP1
mKDP1:  pla
        rts
.endproc
;==============================================================================
.proc sprite_init

        ldx #X0P0               ; horizontální pozice hráče
        stx posXP0
        stx HPOSP0              ;
        lda #barva0             ; barva hráče
        sta PCOLR0              ;

        ldx #X0P1               ; horizontální pozice hráče
        stx posXP1
        stx HPOSP1              ;
        lda #barva1             ; barva hráče
        sta PCOLR1              ;

        ldx #X0P2               ; horizontální pozice hráče
        stx posXP2
        stx HPOSP2              ;
        lda #barva2             ; barva hráče
        sta PCOLR2              ;

        ldx #X0P3               ; horizontální pozice hráče
        stx posXP3
        stx HPOSP3              ;
        lda #barva3             ; barva hráče
        sta PCOLR3              ;

        ldx #X0M0               ; horizontální pozice strely
        stx posXM0
        stx HPOSM0

        ldx #X0M1               ; horizontální pozice strely
        stx posXM1
        stx HPOSM1

        ldx #X0M2               ; horizontální pozice strely
        stx posXM2
        stx HPOSM2

        ldx #X0M3               ; horizontální pozice strely
        stx posXM3
        stx HPOSM3

;-----------------------------------------------------------------------------
        ldy #Y0P0
        sty posYP0
        ldy #Y0P0+7
        ldx #8                  ; pocet o 1 vyšší

si0:    lda sprite0-1, x         ; načíst
        sta adr_hrac0, y        ; uložit byte
        dey
        dex                     ; snížit offset + nastavit příznaky
        bne si0                 ; další byte spritu
;-----------------------------------------------------------------------------
        ldy #Y0P1
        sty posYP1
        ldy #Y0P1+7
        ldx #8                  ; pocet o 1 vyšší

si1:    lda sprite1-1, x         ; načíst
        sta adr_hrac1, y        ; uložit byte
        dey
        dex                     ; snížit offset + nastavit příznaky
        bne si1                 ; další byte spritu
;-----------------------------------------------------------------------------
        ldy #Y0P2
        sty posYP2
        ldy #Y0P2+7
        ldx #8                  ; pocet o 1 vyšší

si2:    lda sprite2-1, x         ; načíst
        sta adr_hrac2, y        ; uložit byte
        dey
        dex                     ; snížit offset + nastavit příznaky
        bne si2                 ; další byte spritu
;-----------------------------------------------------------------------------
        ldy #Y0P3
        sty posYP3
        ldy #Y0P3+7
        ldx #8                  ; pocet o 1 vyšší

si3:    lda sprite3-1, x         ; načíst
        sta adr_hrac3, y        ; uložit byte
        dey
        dex                     ; snížit offset + nastavit příznaky
        bne si3                 ; další byte spritu
;-----------------------------------------------------------------------------
        ldy #Y0M0
        sty posYM0
        ldx #0                  ; pocet o 1 vyšší

        lda #$ff
        sta adr_strela, y        ; uložit byte

        iny
        sta adr_strela, y        ; uložit byte
        iny
        sta adr_strela, y        ; uložit byte
        iny
        sta adr_strela, y        ; uložit byte

        rts
.endproc

;------------------------------------------------------------------------------
.proc get_key

pg1:    lda 53279
        cmp #$07
        bne pg1
pg2:    lda 53279
        cmp #$07
        beq pg2
        rts

.endproc
;------------------------------------------------------------------------------
.proc   vsync
        ldx     RTCLOK+2        ; čekání na konec snímku
vs:     cpx     RTCLOK+2
        beq     vs
        rts
.endproc
;==============================================================================
sprite0:   .byte $81, $99, $bd, $ff, $ff, $bd, $99, $81
sprite1:   .byte $81, $99, $a5, $e7, $e7, $a5, $99, $81
sprite2:   .byte 24, 60, 126, 219, 255, 36, 90, 165
sprite3:   .byte $7e, 60, 126, 219, 255, 36, 90, 255

end:

;-----------------------------------------------------------------------------
; systemove segnmmenty pro XEX

.segment "EXEHDR"
.word   $ffff                   ; uvodni sekvence bajtu v souboru XEX
.word   main                    ; zacatek kodoveho segmentu
.word   end - 1                 ; konec kodoveho segmentu

.segment "AUTOSTRT"             ; segment s pocatecni adresou
.word   RUNAD                   ; naplni se pouze adresy RUNAD a RUNAD+1
.word   RUNAD+1
.word   main                    ; adresa vstupniho bodu do programu

;-----------------------------------------------------------------------------
