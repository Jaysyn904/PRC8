/*:://////////////////////////////////////////////
//:: Spell Name Acid Fog: Heartbeat
//:: Spell FileName SMP_S_AcidFogC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Jasperre:

    On Heartbeat:
    We do 2d6 damage a round to those in the fog (spell immunity only!).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Check AOE
    if(!SMP_CheckAOECreator()) return;

    // Declare major variables
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    int nMetaMagic = SMP_GetAOEMetaMagic();
    int nDamage;
    float fDelay;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            // Fire cast spell at event for the affected target
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_ACID_FOG);

            // Get damage
            nDamage = SMP_MaximizeOrEmpower(6, 2, nMetaMagic);

            // Get a small delay
            fDelay = SMP_GetRandomDelay(0.1, 3.0);

            // Apply damage and visuals
            DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_ACID));
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
    }
}
