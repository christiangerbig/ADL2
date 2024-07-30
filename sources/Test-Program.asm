  move.w  #$4000,$dff09a
  move.l  #$200,$dff080
  move.l  #$300,$dff084
wm
  btst    #6,$bfe001
  bne.s   wm
  move.w  #$c000,$dff09a
  rts

  END
