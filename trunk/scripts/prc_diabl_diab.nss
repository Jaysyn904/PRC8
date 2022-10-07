#include "prc_feat_const"

void main()
{
    object oCaster = OBJECT_SELF;
    
    if (GetLocalInt(oCaster, "Diabolism") == FALSE)
    {
       	SetLocalInt(oCaster, "Diabolism", TRUE);
    	FloatingTextStringOnCreature("Diabolism On", oCaster, FALSE);
    }
    else
    {
       	SetLocalInt(oCaster, "Diabolism", FALSE);
    	FloatingTextStringOnCreature("Diabolism Off", oCaster, FALSE);
        IncrementRemainingFeatUses(oCaster, FEAT_DIABOL_DIABOLISM_1);
        IncrementRemainingFeatUses(oCaster, FEAT_DIABOL_DIABOLISM_2);
        IncrementRemainingFeatUses(oCaster, FEAT_DIABOL_DIABOLISM_3);
    }   
}