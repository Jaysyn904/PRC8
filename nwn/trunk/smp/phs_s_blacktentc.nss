/*:://////////////////////////////////////////////
//:: Spell Name Black Tentacles: On Heartbeat
//:: Spell FileName PHS_S_BlackTentC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Grapple check uses the functions created for this, and other spells-which-grapple
    things.

    The tentacles will only attack (using a proper attack thing) On Enter.

    If they have the entanglement of tentacles, the HB will continue to grapple.

    Always applies 50% movement speed decrease. Removes all effects On Exit. Will
    not grapple someone with the spells effects already.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    int nCasterLevel = PHS_GetAOECasterLevel();
    int nMetaMagic = PHS_GetAOEMetaMagic();
    int nDamage;
    float fDelay;

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Need to have entanglement from this spell to contiune grappling
            if(PHS_GetHasEffectFromSpell(EFFECT_TYPE_ENTANGLE, oTarget, PHS_SPELL_EVARDS_BLACK_TENTACLES))
            {
                // Check grapple roll
                if(PHS_GrappleCheck(oTarget, nCasterLevel, 4, 4, GetAC(oTarget), oCaster))
                {
                    // Fire cast spell at event for the affected target
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_EVARDS_BLACK_TENTACLES);

                    // Get damage
                    nDamage = PHS_MaximizeOrEmpower(6, 1, nMetaMagic, 4);

                    // Get a small delay
                    fDelay = PHS_GetRandomDelay(0.1, 3.0);

                    // Apply damage and visuals
                    DelayCommand(fDelay, PHS_ApplyDamageToObject(oTarget, nDamage, DAMAGE_TYPE_BLUDGEONING));
                }
                else
                {
                    // Remove entanglement
                    PHS_RemoveSpecificEffectFromSpell(EFFECT_TYPE_ENTANGLE, PHS_SPELL_EVARDS_BLACK_TENTACLES, oTarget);
                }
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
