/*
18/02/19 by Stratovarius

Dark Soul

Master, Heart and Soul 
Level/School: 7th/Enchantment (Compulsion) [Mind Affecting]
Range: Personal 
Target: You 
Duration: 1 round/level 
Saving Throw: Will negates; see text 
Spell Resistance: Yes; see text

You open the subject’s mind to the Plane of Shadow, altering its personality.

You turn the dark energies from the Plane of Shadow upon another creature, compelling it to act in ways that it normally would not. 
While this effect is active, you can use a standard action to focus the shadow energies on one living creature within 30 feet that you select. 
The creature must succeed on a Will saving throw (DC 17 + your Cha modifier) or immediately make a melee attack against one target within its reach.
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
        myst.fDur = 6.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        object oSkin = GetPCSkin(oShadow);        
        itemproperty ipFlick = ItemPropertyBonusFeat(IP_CONST_FEAT_DARK_SOUL);
        ActionDoCommand(AddItemProperty(DURATION_TYPE_TEMPORARY, ipFlick, oSkin, myst.fDur));        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ENTROPIC_SHIELD), oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}