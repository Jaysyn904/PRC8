#include "prc_inc_unarmed"  
  
void main()  
{  
    object oPC = OBJECT_SELF;  
      
    if(GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0)  
    {  
        SetLocalInt(oPC, CALL_UNARMED_FEATS, TRUE);  
        SetLocalInt(oPC, CALL_UNARMED_FISTS, TRUE);  
    }  
}