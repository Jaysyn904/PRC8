//::///////////////////////////////////////////////
//:: Silence
//:: NW_S0_Silence.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ILLUSION);

    //Declare major variables including Area of Effect Object
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nAoE = AOE_MOB_SILENCE;

    //Make sure duration does no equal 0
    if(nCasterLvl < 1)
        nCasterLvl = 1;

    float fDuration = RoundsToSeconds(nCasterLvl);
    //Check Extend metamagic feat.
    if(nMetaMagic & METAMAGIC_EXTEND)
       fDuration *= 2;    //Duration is +100%

    if(!GetIsFriend(oTarget))
    {
        if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget, oCaster))))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE));

                //Create an instance of the AOE Object using the Apply Effect function
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(nAoE), oTarget, fDuration);
            }
        }
    }
    else
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE, FALSE));
        //Create an instance of the AOE Object using the Apply Effect function
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(nAoE), oTarget, fDuration);
    }

    //Setup Area Of Effect object
    object oAoE = GetAreaOfEffectObject(GetLocation(oTarget), "VFX_MOB_SILENCE");
    SetAllAoEInts(SPELL_SILENCE, oAoE, PRCGetSpellSaveDC(SPELL_SILENCE, SPELL_SCHOOL_ILLUSION), 0, nCasterLvl);

    PRCSetSchool();
}