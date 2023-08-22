//::///////////////////////////////////////////////
//:: Name      Augment Familiar
//:: FileName  sp_aug_famil.nss
//:://////////////////////////////////////////////
/**@file Augment Familiar
Transmutation
Level:            Sor/Wiz 2, Hexblade 1
Components:       V,S
Casting Time:     1 standard action
Range:            Close (25 ft. +5 ft./2 levels)
Target:           Your familiar
Duration:         Concentration + 1 round/level
Saving Throw:     Fortitude negates (harmless)
Spell Resistance: Yes (harmless)

This spell grants your familiar a +4 enhancement bonus
to Strength, Dexterity and Constitution, damage
reduction 5/magic, and a +2 resistance bonus on
saving throws.

**/

/////////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date:   8.9.2006
/////////////////////////////////////////////////////

#include "inc_npc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    if(GetAssociateTypeNPC(oTarget) == ASSOCIATE_TYPE_FAMILIAR && GetMasterNPC(oTarget) == oPC)
    {
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        float fDur = RoundsToSeconds(nCasterLvl);
        if(nMetaMagic & METAMAGIC_EXTEND)
            fDur *= 2;

        PRCSignalSpellEvent(oTarget, FALSE, SPELL_AUGMENT_FAMILIAR, oPC);

        effect eBuff = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
               eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_DEXTERITY, 4));
               eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
               eBuff = EffectLinkEffects(eBuff, EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE, 0));
               eBuff = EffectLinkEffects(eBuff, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDur, TRUE, SPELL_AUGMENT_FAMILIAR, nCasterLvl);
    }
    else
    {
        FloatingTextStrRefOnCreature(16789952, oPC, FALSE);
    }
    PRCSetSchool();
}
