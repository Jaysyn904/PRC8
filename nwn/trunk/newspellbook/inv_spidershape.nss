//::///////////////////////////////////////////////
//:: Polymorph Self
//:: NW_S0_PolySelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The PC is able to changed their form to one of
    several forms.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 21, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"
#include "pnp_shft_poly"

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    int nDuration = CasterLvl;

    effect ePoly = EffectPolymorph(POLYMORPH_TYPE_GIANT_SPIDER);
    effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, 4);
    effect eAC = EffectACDecrease(3);
    effect eDR = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
    effect eResFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, 5);
    effect eResCold = EffectDamageResistance(DAMAGE_TYPE_COLD, 5);
    effect eSR = EffectSpellResistanceIncrease(9);
    effect eLink = EffectLinkEffects(ePoly, eDR);
    eLink = EffectLinkEffects(eLink, eResFire);
    eLink = EffectLinkEffects(eLink, eSR);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eResCold);
    eLink = EffectLinkEffects(eLink, eStr);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_SPIDER_SHAPE, FALSE));

    // abort if mounted
    if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if (PRCHorseGetIsMounted(oTarget))
        { // abort
            if (GetIsPC(oTarget)) FloatingTextStrRefOnCreature(111982,oTarget,FALSE);
              return;
        } // abort
    } // check to see if abort due to being mounted
    //this command will make shore that polymorph plays nice with the shifter
    ShifterCheck(oTarget);

    AssignCommand(oTarget, ClearAllActions()); // prevents an exploit

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,CasterLvl);
    DelayCommand(1.5,ActionCastSpellOnSelf(SPELL_SHAPE_INCREASE_DAMAGE));
}

