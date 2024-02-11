/**
 * Rage
 *
 * Enchantment (Compulsion) [Mind-Affecting] 
 * Level: Bard 2, Sorcerer/Wizard 3
 * Components: V, S, 
 * Casting Time: 1 standard action
 * Range: Medium (100 ft. + 10 ft./level)
 * Target: One willing living creature per three levels, no two of which may be more than 30 ft. apart
 * Duration: Concentration + 1 round/level (D)
 * Saving Throw: None
 * Spell Resistance: Yes
 *
 * Each affected creature gains a +2 morale bonus to Strength and Constitution, a +1 morale bonus on Will saves, and a -2 penalty to AC.
 */

#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
    if (!X2PreSpellCastCode())
        return;

    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = CasterLvl;
    int nSpellID   = PRCGetSpellId();
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        nDuration *= 2;

     // how many creatures (we've done one already)
     int nCreatures = (CasterLvl/3);
     if (nCreatures >= 1)
     {
         object oNextTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oTarget), TRUE); // only creatures
         int nCount;
         while (GetIsObjectValid(oNextTarget) && nCount < nCreatures)
         {
             if (GetIsFriend(oNextTarget, OBJECT_SELF) && PRCGetIsAliveCreature(oNextTarget))
             {
                 //Fire cast spell at event for the specified target
                 SignalEvent(oNextTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
                 effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
                        eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, 2));
                        eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 2));
                        eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, 1));
                        eLink = EffectLinkEffects(eLink, EffectACDecrease(2, AC_DODGE_BONUS));
                 SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
                 nCount++;
             }
             oNextTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oTarget), TRUE); // only creatures
         }
     }

     PRCSetSchool();
}
