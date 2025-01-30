//::///////////////////////////////////////////////
//:: Name      Draconic Might
//:: FileName  sp_drac_might.nss
//:://////////////////////////////////////////////
/**@file Draconic Might
Transmutation
Level: Paladin 4, sorcerer/wizard 5
Components: V, S
Casting Time: 1 standard action
Range: Touch
Target: Living creature touched
Duration: 1 minute/level (D)
Saving Throw: Fortitude negates
(harmless)
Spell Resistance: Yes (harmless)

The subject of the spell gains a +4
enhancement bonus to Strength, Constitution,
and Charisma. It also gains
a +4 enhancement bonus to natural
armor. Finally, it has immunity to
magic sleep and paralysis effects.
Special: Sorcerers cast this spell at +1
caster level.

Author:    Tenjac
Created:   6/28/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        
        if(!PRCGetIsAliveCreature(oTarget))
           {
                   SendMessageToPC(oPC, "This spell must be cast on a living target");
                   PRCSetSchool();
                   return;
           }
        
        int nCasterLvl = PRCGetCasterLevel(oPC);
        
        //Determine if we need to adjust nCasterLvl
        
        if(GetLevelByClass(CLASS_TYPE_SORCERER, oPC))
        {
                //not sure whether we can have 40+ caster levels now...
                nCasterLvl = PRCMin(nCasterLvl + 1, 40);
        }
        
        float fDur = (60.0 * nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        
        if(nMetaMagic & METAMAGIC_EXTEND)
        {
                fDur += fDur;
        }
                
        //Create effect
        effect eLink = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
               eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
               eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CHARISMA, 4));
               eLink = EffectLinkEffects(eLink, EffectACIncrease(4, AC_NATURAL_BONUS));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLEEP));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
        
        //VFX
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oTarget);
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, SPELL_DRACONIC_MIGHT, nCasterLvl);
        
        PRCSetSchool();
}      