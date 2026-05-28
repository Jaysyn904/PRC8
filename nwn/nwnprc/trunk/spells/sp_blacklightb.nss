#include "prc_inc_spells"

const int SPELL_UR_BLACKLIGHT = 2091;

void main()
{

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oTarget = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();

    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        int nID = GetEffectSpellId(eAOE);

        if( nID== SPELL_BLACKLIGHT)
        {
           if (GetEffectCreator(eAOE) == oCreator)
              RemoveEffect(oTarget, eAOE);

        }

        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
	
	effect eEffect = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eEffect))
    {
        if(GetEffectTag(eEffect) == "SHADOWSIGHT+BLUR")
		{
            RemoveEffect(oTarget, eEffect);		
			if(DEBUG) DoDebug("sp_blacklightb >> Removing SHADOWSIGHT+BLUR");
		}
        eEffect = GetNextEffect(oTarget);
    }	
    
    PRCSetSchool();

}
