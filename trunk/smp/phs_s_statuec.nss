/*:://////////////////////////////////////////////
//:: Spell Name Statue - On Heartbeat
//:: Spell FileName PHS_S_StatueC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    The creature will apply the first effects, too. It'll use the effects
    creator to determine which are the granite effects.

    On Heartbeat

    This will check for times cast (if none set, it has fired, well, impossibly
    early).

    Will remove its effects if it either has no duration left, the master
    with it has gone, or nTimesCast isn't correct now.

    Also applies first instance of the effects, if none are present.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/


#include "PHS_INC_SPELLS"

void main()
{
    // Declarations
    object oTarget = GetLocalObject(OBJECT_SELF, "PHS_SPELL_STATUE_MASTER");
    int nTimesCast = GetLocalInt(OBJECT_SELF, "PHS_SPELL_STATUE_CAST_TIMES");

    // If we have nothing set from the original spell script, do nothing
    if(nTimesCast == 0) return;

    // Check target affected with the spell
    if(!GetIsObjectValid(oTarget))
    {
        // Error, destroy self (logged out, ETC)
        PHS_CompletelyDestroyObject(OBJECT_SELF);
        return;
    }

    // Check if they have the spells effects still, and that nTimesCast matches!
    if(!GetHasSpellEffect(PHS_SPELL_STATUE, oTarget) ||
        nTimesCast != GetLocalInt(oTarget, "PHS_SPELL_STATUE_CAST_TIMES"))
    {
        // Remove the effects, destroy us.

        // Search through the valid effects on the target.
        effect eCheck = GetFirstEffect(oTarget);
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
                        RemoveEffect(oTarget, eCheck);
                        return;
                    }
                }
            }
            //Get next effect on the target
            eCheck = GetNextEffect(oTarget);
        }
        PHS_CompletelyDestroyObject(OBJECT_SELF);
        return;
    }
    else
    {
        if(GetLocalInt(OBJECT_SELF, "PHS_STATUE_DOONCE") == FALSE)
        {
            // Do this once
            SetLocalInt(OBJECT_SELF, "PHS_STATUE_DOONCE", TRUE);

            // Apply it (if not got it already)
            if(!PHS_GetHasEffectFromCaster(EFFECT_TYPE_PETRIFY, oTarget, OBJECT_SELF))
            {
                // Apply it
                SendMessageToPC(oTarget, "*You turn into a statue*");

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
                PHS_ApplyPermanent(oTarget, eLink);
            }
        }
    }
}
