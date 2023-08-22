/**
 * @file
 * Spellscript for Karsus Vestige
 *
 */

#include "bnd_inc_bndfunc"
#include "prc_inc_template"
#include "prc_inc_sp_tch"
#include "inc_dispel"

void main()
{
    object oBinder = OBJECT_SELF;
    int nCasterLevel = GetBinderLevel(oBinder, VESTIGE_KARSUS);
    int nDC = GetBinderDC(oBinder, VESTIGE_KARSUS);
    int nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    int nInstant = FALSE;
    
    if (nSLA == VESTIGE_KARSUS_DISPEL)
    {
    	if(!BindAbilCooldown(oBinder, VESTIGE_KARSUS_DISPEL, VESTIGE_KARSUS)) return;
    }	
    
    switch(nSLA){
        case VESTIGE_KARSUS_SENSES:
        {
            DoRacialSLA(SPELL_DETECT_MAGIC, nCasterLevel, nDC, nInstant);
            break;
        } 
        case VESTIGE_KARSUS_DISPEL:
        {
            object oTarget = PRCGetSpellTargetObject();
            nUses = nCasterLevel; 
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
    			if(PRCDoMeleeTouchAttack(oTarget))
    			{
			    	effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
    				effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);        		
        			spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact);
        		}	
    		}
            
            break;
        } 
    }
}
        