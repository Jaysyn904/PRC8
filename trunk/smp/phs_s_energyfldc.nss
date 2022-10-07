/*:://////////////////////////////////////////////
//:: Spell Name Energy Field: Heartbeat
//:: Spell FileName PHS_S_EnergyFldC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Jasperre:

    On Heartbeat:
    We do 2d6 damage a round to those in the fog, and do it only to living
    creatures. We heal undead. Negative damage.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    int nMetaMagic = PHS_GetAOEMetaMagic();
    int nDamage, nHeal;
    effect eHeal;
    effect eHealVis = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
    float fDelay;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // If undead, we heal
        if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            // Get what to do
            nHeal = PHS_MaximizeOrEmpower(6, 2, nMetaMagic);

            // Do heal
            eHeal = EffectHeal(nHeal);

            // Fire cast spell at event for the affected target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ENERGY_FIELD);

            // Heal
            PHS_ApplyInstantAndVFX(oTarget, eVis, eHeal);
        }
        // PvP check
        else if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Must be living
            if(PHS_GetIsAliveCreature(oTarget))
            {
                // Fire cast spell at event for the affected target
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ENERGY_FIELD);

                // Get damage
                nDamage = PHS_MaximizeOrEmpower(6, 2, nMetaMagic);

                // Get a small delay
                fDelay = PHS_GetRandomDelay(0.1, 3.0);

                // Apply damage and visuals
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_NEGATIVE));
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
