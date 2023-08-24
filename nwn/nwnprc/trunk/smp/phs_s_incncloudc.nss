/*:://////////////////////////////////////////////
//:: Spell Name Incendiary Cloud: On Heartbeat
//:: Spell FileName PHS_S_IncnCloudC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says. No moving fog though!

    Damage is done On Heartbeat, consealment effects (Which do not stack anyway)
    are On Enter, On Exit.

    On Heartbeat:
    Deals 4d6 fire damage (Reflex save negates, no SR) to things in the cloud.
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
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();
    int nDamage;
    float fDelay;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Fire cast spell at event for the affected target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_INCENDIARY_CLOUD);

            // Get a small delay
            fDelay = PHS_GetRandomDelay(0.1, 3.0);

            // Get damage. 4d6
            nDamage = PHS_MaximizeOrEmpower(6, 4, nMetaMagic);

            // Adjust damage due to reflex saves.
            nDamage = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDamage, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE, oCaster, fDelay);

            // Apply damage and visuals
            DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_FIRE));
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
    }
}
