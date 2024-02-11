//::///////////////////////////////////////////////
//:: Name      Abyssal Might
//:: FileName  sp_abyssal_mght.nss
//:://////////////////////////////////////////////
/**@file Abyssal Might
Conjuration (Summoning) [Evil]
Level: Blk 3, Clr 4, Demonologist 3, Sor/Wiz 4
Components: V, S, M, Demon
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 10 minutes/level

The caster summons evil energy from the Abyss and
imbues himself with its might. The caster gains a
+2 enhancement bonus to Strength, Constitution,
and Dexterity. The caster's existing spell
resistance improves by +2.

Material Component: The heart of a dwarf child.

Author:    Tenjac
Created:   1/27/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    //define vars
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nAlignEvil = GetAlignmentGoodEvil(oPC);
    int nAlignChaotic = GetAlignmentLawChaos(oPC);
    int nType = MyPRCGetRacialType(oTarget);
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_ABYSSAL_MIGHT, oPC);

    if(nType == RACIAL_TYPE_OUTSIDER && nAlignEvil == ALIGNMENT_EVIL && nAlignChaotic == ALIGNMENT_CHAOTIC)
    {
        int nBonus = 2;

        //Check for Empower
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
        {
            nBonus = 3;
        }

        //Str, Dex, Con increases
        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nBonus);
        effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nBonus);
        effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, nBonus);

        //SR increase by 2... yippee
        effect eResist = EffectSpellResistanceIncrease(nBonus);

        //Some sort of VFX
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR), oTarget, 1.5);

        //Link 'em up
        effect eLink = EffectLinkEffects(eStr, eDex);
        eLink = EffectLinkEffects(eLink, eCon);
        eLink = EffectLinkEffects(eLink, eResist);


        //Duration 10 min/level
        float fDuration = IntToFloat(nCasterLvl * 600);

        //Check for Extend
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        {
            fDuration = (fDuration * 2);
        }

        //Apply
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration, TRUE, PRCGetSpellId(), nCasterLvl);
    }

    //SPEvilShift(oPC);

    PRCSetSchool();
}

