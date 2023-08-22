/*:://////////////////////////////////////////////
//:: Spell Name Prismatic Sphere: (Blindness) On Heartbeat
//:: Spell FileName PHS_S_PrisSpherC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changes include the fact it won't do all 7 effects, it is affected by dispel
    magic normally, it has a duration (might extend it higher, its a level 7
    spell).

    It still is immobile, and does blindness normally too (a second AOE)

    How does the spell stopping work?

    Well, it will add a new check into the spell hook. If we cast a spell
    into the AOE's location (can use GetNearestObjectByTag() and distance check)
    but we are not ourselves in it, it will fail.

    Ranged weapons have 100% miss chance from both inside and outside (100%
    concealment + 100% miss chance applied on enter, whatever).

    The blindness AOE is done normally, using a LOS sphere check, which should
    work.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    location lTarget = GetLocation(OBJECT_SELF);
    object oTarget;
    int nMetaMagic = PHS_GetAOEMetaMagic();
    float fDelay, fDuration;

    // Declare blindness
    effect eBlind = EffectBlindness();

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Check HD
            if(GetHitDice(oTarget) <= 8)
            {
                // Fire cast spell at event for the affected target
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PRISMATIC_SPHERE);

                // Check if they can see
                if(PHS_GetCanSee(oTarget))
                {
                    // Check spell resistance
                    if(PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                    {
                        // Get duration
                        fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 2, nMetaMagic);

                        // Get a small delay
                        fDelay = GetDistanceToObject(oTarget)/20;

                        // Apply blindness
                        DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eBlind, fDuration));
                    }
                }
            }
        }
        //Get next target.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
