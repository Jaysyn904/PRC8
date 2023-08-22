/*:://////////////////////////////////////////////
//:: Spell Name Storm of Vengance On Exit
//:: Spell FileName PHS_S_StormVenB
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    On exit, we must remove the miss chances and consealment applied from this
    spell.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oExiter = GetExitingObject();

    // Remove all miss chance and consealments from this spell.
    effect eCheck = GetFirstEffect(oExiter);
    while(GetIsEffectValid(eCheck))
    {
        // Check spell Id
        if(GetEffectSpellId(eCheck) == PHS_SPELL_STORM_OF_VENGEANCE)
        {
            // Check effect type and remove the right ones
            switch(GetEffectType(eCheck))
            {
                case EFFECT_TYPE_CONCEALMENT:
                case EFFECT_TYPE_MISS_CHANCE:
                {
                    RemoveEffect(oExiter, eCheck);
                }
                break;
            }
        }
        eCheck = GetNextEffect(oExiter);
    }
}
