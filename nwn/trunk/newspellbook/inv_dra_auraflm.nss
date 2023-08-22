//::///////////////////////////////////////////////
//:: Name      Aura of Flame
//:: FileName  inv_dra_auraflm.nss
//::///////////////////////////////////////////////
/*

Greater Invocation
6th Level Spell

You become wreathed in an aura of orange fire. Any
creature striking you in melee takes a number of
points of fire damage equal to your caster level.
Spell resistance can prevent this damage.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oSkin = GetPCSkin(oCaster);
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    effect eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
    effect eShield = EffectDamageShield(CasterLvl - 1, DAMAGE_BONUS_1, DAMAGE_TYPE_FIRE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eDur);
           eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oCaster, EventSpellCastAt(oCaster, INVOKE_AURA_OF_FLAME, FALSE));

    //  *GZ: No longer stack this spell
    if(GetHasSpellEffect(INVOKE_AURA_OF_FLAME, oCaster))
         PRCRemoveSpellEffects(INVOKE_AURA_OF_FLAME, oCaster, oCaster);

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HoursToSeconds(24), TRUE, -1, CasterLvl);
    IPSafeAddItemProperty(oSkin, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_ORANGE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
}

