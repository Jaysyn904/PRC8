/*:://////////////////////////////////////////////
//:: Spell Name Cloudkill - On Heartbeat
//:: Spell FileName SMP_s_cloudkillc
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Heartbeat, so SR.

    HD         Effect
    3 or less  Death, no save
    4-6        Save, death on fail. Pass means constitution damage (no save, 1d4).
    7 or more  Constitution damage (1d4), fort for half.

    Posion save and immunity applies to saves.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// Applies the constitution damage (note, with metamagic and saves)
void ApplyCloudkillConDamage(object oTarget, object oCaster, float fDelay, effect eVis, int nMetaMagic, int nSaveDC = 0);

void main()
{
    // Get creator
    if(!SMP_CheckAOECreator()) return;

    // Our creator is an ambiguous "Cloudkill" object.
    object oCaster = GetAreaOfEffectCreator();
    int nSpellSaveDC = SMP_GetAOESpellSaveDC();
    int nMetaMagic = SMP_GetAOEMetaMagic();
    object oTarget;
    float fDelay;
    int nHD;

    // Declare effects
    effect eDeathVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eDeath = EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            // Fire cast spell at event for the affected target
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CLOUDKILL);

            // Get a small delay
            fDelay = SMP_GetRandomDelay(0.1, 0.3);

            nHD = GetHitDice(oTarget);
            // We kill on a cirtain amount of HD
            if(nHD <= 3)
            {
                // Instant death
                DelayCommand(fDelay, SMP_ApplyInstantAndVFX(oTarget, eDeathVis, eDeath));
            }
            else if(nHD <= 6)
            {
                // Immunity to death means we do con damage
                if(SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_DEATH, fDelay, oCaster))
                {
                    // Con damage
                    ApplyCloudkillConDamage(oTarget, oCaster, fDelay, eVis, nMetaMagic);
                }
                // Save on a fort save vs death
                if(!SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_DEATH, oCaster, fDelay))
                {
                    // Instant death
                    DelayCommand(fDelay, SMP_ApplyInstantAndVFX(oTarget, eDeathVis, eDeath));
                }
                else
                {
                    // Save is Con damage
                    ApplyCloudkillConDamage(oTarget, oCaster, fDelay, eVis, nMetaMagic);
                }
            }
            else
            {
                // Con damage
                ApplyCloudkillConDamage(oTarget, oCaster, fDelay, eVis, nMetaMagic, nSpellSaveDC);
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}

// Applies the constitution damage (note, with metamagic and saves)
void ApplyCloudkillConDamage(object oTarget, object oCaster, float fDelay, effect eVis, int nMetaMagic, int nSaveDC = 0)
{
    // Delcare effects
    effect eNeg;

    // Check poison immunity
    if(!SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_POISON, fDelay, oCaster) &&
       !SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE, fDelay, oCaster))
    {
        // Damage is 1d4
        int nDam = SMP_MaximizeOrEmpower(4, 1, nMetaMagic);

        if(nSaveDC != 0)
        {
            // Adjust for fortitude - half damage
            if(SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_POISON, oCaster, fDelay))
            {
                nDam /= 2;
            }
            if(nDam > 0)
            {
                // Apply effects
                eNeg = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
                // Apply
                DelayCommand(fDelay, SMP_ApplyPermanentAndVFX(oTarget, eVis, eNeg));
            }
        }
    }
}
