#include "prc_inc_smite"
#include "prc_inc_template"

void main()
{
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_THETRIAD)) return;
    object oTarget = PRCGetSpellTargetObject(); 
    int nUses = 3;
    int nSLA = GetSpellId(); 
    
    // Check uses per day
    if (GetLegacyUses(oBinder, nSLA) >= nUses)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oBinder, FALSE);
        return;
    }             
    else
    {
		SetLegacyUses(oBinder, nSLA);
    	FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oBinder, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oBinder, FALSE);    		    		

    	if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) 
        	DoSmite(oBinder, oTarget, SMITE_TYPE_TRIAD);
    }     

}