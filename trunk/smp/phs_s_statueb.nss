/*:://////////////////////////////////////////////
//:: Spell Name Statue - On Listen
//:: Spell FileName PHS_S_StatueB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    The creature will apply the first effects, too. It'll use the effects
    creator to determine which are the granite effects.

    On Conversation

    Listens for "move" and "statue".
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declarations
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();

    // Disallow non-masters
    if(GetLocalObject(OBJECT_SELF, "PHS_SPELL_STATUE_MASTER") != oShouter)
    {
        return;
    }
    else
    {
        // Apply statue?
        if(nMatch == 60)
        {
            // Apply it (if not got it already)
            if(!PHS_GetHasEffectFromCaster(EFFECT_TYPE_PETRIFY, oShouter, OBJECT_SELF))
            {
                // Apply it
                SendMessageToPC(oShouter, "*You turn into a statue*");

                // Declare effects

                // Hardness 8
                effect eHardness1 = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 8);
                effect eHardness2 = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 8);
                effect eHardness3 = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 8);
                // Visual and stopping effect
                // * Also adds all the things a statue would be immune to (criticals ETC)
                effect eStatue = PHS_CreateProperPetrifyEffectLink();

                // Link these effects
                effect eLink = EffectLinkEffects(eStatue, eHardness1);
                eLink = EffectLinkEffects(eLink, eHardness2);
                eLink = EffectLinkEffects(eLink, eHardness3);

                // Make it supernatural
                eLink = SupernaturalEffect(eLink);

                // Apply it
                PHS_ApplyPermanent(oShouter, eLink);
            }
            else
            {
                SendMessageToPC(oShouter, "*You already are a statue*");
            }
        }
        else if(nMatch == 50)
        {
            // Remove it (if they have it).
            // Apply it (if not got it already)
            if(PHS_GetHasEffectFromCaster(EFFECT_TYPE_PETRIFY, oShouter, OBJECT_SELF))
            {
                // Apply it
                SendMessageToPC(oShouter, "*You turn to flesh again*");

                // Search through the valid effects on the target.
                effect eCheck = GetFirstEffect(oShouter);
                while(GetIsEffectValid(eCheck))
                {
                    // Check effect type
                    // * Only remove petrify, its all linked.
                    if(GetEffectType(eCheck) == EFFECT_TYPE_PETRIFY)
                    {
                        // Its supernatural
                        if(GetEffectSubType(eCheck) == SUBTYPE_SUPERNATURAL)
                        {
                            // Created by us
                            if(GetEffectCreator(eCheck) == OBJECT_SELF)
                            {
                                // Remove it
                                RemoveEffect(oShouter, eCheck);
                                return;
                            }
                        }
                    }
                    //Get next effect on the target
                    eCheck = GetNextEffect(oShouter);
                }
            }
            else
            {
                SendMessageToPC(oShouter, "*You already are not a statue*");
            }
        }
    }
}
