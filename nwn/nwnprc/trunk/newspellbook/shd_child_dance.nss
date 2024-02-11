/*
   ----------------
   Child of Night Dancing Shadows

   shd_child_dance.nss
   ----------------

   Cast the Dancing Shadows mystery
   
   27.02.19 by Stratovarius
*/
#include "shd_inc_shdfunc"

void main()
{
    object oShadow = OBJECT_SELF;
    SetLocalInt(oShadow, "MysteryFreeUse", TRUE);
    UseMystery(MYST_DANCING_SHADOWS, CLASS_TYPE_SHADOWCASTER);
    DelayCommand(2.0, DeleteLocalInt(oShadow, "MysteryFreeUse"));
}