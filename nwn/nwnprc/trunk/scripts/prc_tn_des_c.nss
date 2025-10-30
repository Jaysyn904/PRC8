//::///////////////////////////////////////////////
//:: Desecrate
//:: prc_tn_des_c
//:://////////////////////////////////////////////
/*
    You create an aura that boosts the undead
    around you.
*/
#include "prc_alterations"
#include "prc_spell_const"

void main()
{
    object oTarget = GetExitingObject();
	
	effect eAOE = GetFirstEffect(oTarget);
	
	if(GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
	{
		string sTag = GetEffectTag(eAOE);
		if(sTag == "EFFECT_DESECRATE_AURA" || sTag == "EFFECT_DESECRATE_HP")
			RemoveEffect(oTarget, eAOE);
	}	

/*     if(GetHasSpellEffect(SPELL_DES_20, oTarget) || GetHasSpellEffect(SPELL_DES_100, oTarget) || GetHasSpellEffect(SPELL_DESECRATE, oTarget))
    {
        //Search through the valid effects on the target.
        effect eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            if(GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectSpellId(eAOE) == SPELL_DES_20 || GetEffectSpellId(eAOE) == SPELL_DESECRATE || GetEffectSpellId(eAOE) == SPELL_DES_100)
                    RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    } */
}