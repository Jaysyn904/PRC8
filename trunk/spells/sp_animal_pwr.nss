//::///////////////////////////////////////////////
//:: Name      Animalistic Power
//:: FileName  sp_animal_pwr.nss
//:://////////////////////////////////////////////
/**@file Animalistic Power
Transmutation
Level: Cleric 2, druid 2, duskblade 2, ranger 2,
       sorcerer/wizard 2
Components: V,S,M
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: 1 minute/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You imbue the subject with an aspect of the natural
world. The subject gains a +2 enhancement bonus
to Strength, Dexterity, and Constitution.

Material Component: A bit of animal fur, feathers,
                    or skin.
**/

////////////////////////////////////////////////////
// Author:  Tenjac
// Date:    14.9.2006
////////////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_sp_func"
#include "prc_add_spell_dc"

int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = (60.0f * nCasterLevel);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur += fDur;

    PRCSignalSpellEvent(oTarget,FALSE, SPELL_ANIMALISTIC_POWER, oCaster);

    //Build effect
    effect eBuff = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 2), EffectAbilityIncrease(ABILITY_DEXTERITY, 2));
           eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_CONSTITUTION, 2));
           eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_SANCTUARY));

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDur, TRUE, SPELL_ANIMALISTIC_POWER, nCasterLevel);

    return TRUE;
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {
            //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
            DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}

