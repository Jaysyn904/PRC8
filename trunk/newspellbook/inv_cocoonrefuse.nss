//::///////////////////////////////////////////////
//:: Name      Cocoon of Refuse
//:: FileName  inv_cocoonrefuse.nss
//::///////////////////////////////////////////////
/*

Least Invocation
1st Level Spell

You cause various bits of trash and junk in an area
- rotting garbage, old clothes, even dead animals
- to fly about and latch onto a target. The target
is entangled for 1 round per invoker level, or
until he makes a DC 20 strength check to escape.
Because this uses urban remains, it cannot be used
in wilderness areas.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void DoRefuseEscapeCheck(object oTarget, int nDurationRemaining, object oCaster)
{
    int nStrChk = d20() + GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    if(nStrChk > 20)
    {
        PRCRemoveSpellEffects(INVOKE_COCOON_OF_REFUSE, oCaster, oTarget);
        FloatingTextStringOnCreature("*Strength check successful!*", oTarget, FALSE);
    }
    else if(nDurationRemaining > 0)
        DelayCommand(RoundsToSeconds(1), DoRefuseEscapeCheck(oTarget, nDurationRemaining - 1, oCaster));
}

void main()
{
    if(!PreInvocationCastCode()) return;

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oArea = GetArea(oCaster);
    int nCasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    int nDC = GetInvocationSaveDC(oTarget, oCaster);
    effect eVis = EffectVisualEffect(VFX_DUR_ENTANGLE);
    effect eEntangle = EffectEntangle();
    effect eLink = EffectLinkEffects(eEntangle, eVis);

    if(GetIsAreaNatural(oArea) != AREA_NATURAL
    && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND)
    {
        if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCasterLvl),TRUE,-1,nCasterLvl);
            DelayCommand(RoundsToSeconds(1), DoRefuseEscapeCheck(oTarget, nCasterLvl, oCaster));
        }
    }
}
