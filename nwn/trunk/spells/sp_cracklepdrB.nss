////////////////////////////////////////
// Cracklepowder On Exit
// sp_cracklepdrB.nss
////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
        object oTarget = GetExitingObject();
        effect eAOE;
        if(GetHasSpellEffect(SPELL_CRACKLEPOWDER, oTarget))
        {
                //Search through the valid effects on the target.
                eAOE = GetFirstEffect(oTarget);
                while (GetIsEffectValid(eAOE))
                {
                        if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
                        {
                                if(GetEffectType(eAOE) == EFFECT_TYPE_SKILL_DECREASE)
                                {
                                        //If the effect was created by crackle powder then remove it
                                        if(GetEffectSpellId(eAOE) == SPELL_CRACKLEPOWDER)
                                        {
                                                RemoveEffect(oTarget, eAOE);
                                        }
                                }
                        }
                        //Get next effect on the target
                        eAOE = GetNextEffect(oTarget);
                }
        }
}        