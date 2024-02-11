/*
12/10/19 by Stratovarius

Umbral Fist

Apprentice, Night's Long Fingers 
Level/School: 3rd/Transmutation 
Range: Personal 
Target: You 
Duration: 1 minutes/level

Your hand turns jet black and seems to flicker as tiny wisps of shadow constantly leak from between your fingers and disappear.

For the duration of this mystery, you can, as a standard action, make a special attack against any foe within medium range (100 ft. + 10 ft./level). You must have line of sight to the target.
You can make any one of the following special attacks: bull rush, disarm, or trip. For purposes of adjudicating these attacks, make your touch attack as normal, if one is necessary. When actually 
resolving the opposed roll, however, substitute your caster level for your base attack bonus and either your Intelligence or Charisma modifier (your choice) for your Strength. Because the attack 
is made at a distance, it does not draw an attack of opportunity that such an attack would draw under normal circumstances, nor can your foe attempt to perform the same maneuver on you in turn, 
even if such is normally allowed.

You will be given a feat on your class radial to allow you to make these attacks.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        myst.fDur = 60.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT), oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);  
        object oSkin = GetPCSkin(oShadow);
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UMBRAL_FIST), myst.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
}