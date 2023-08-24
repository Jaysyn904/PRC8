/*
18/02/19 by Stratovarius

Shadow Time

Master, Dark Metamorphosis 
Level/School: 9th/Transmutation 
Duration: 1d4+4 rounds (apparent time); see text for time stop

This mystery functions like the spell time stop, except as noted above.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "inc_timestop"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        myst.fDur = d4() * 6.0 + 24.0;
        if(myst.bExtend) myst.fDur *= 2;
        
        myst.eLink = EffectTimeStop();
        
        if(GetPRCSwitch(PRC_TIMESTOP_LOCAL))
        {
            myst.eLink = EffectAreaOfEffect(VFX_PER_NEW_TIMESTOP);
            myst.eLink = EffectLinkEffects(myst.eLink, EffectEthereal());
            if(GetPRCSwitch(PRC_TIMESTOP_NO_HOSTILE))
            {
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oShadow),myst.fDur);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oShadow),myst.fDur);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BULLETS, oShadow),myst.fDur);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_ARROWS, oShadow),myst.fDur);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BOLTS, oShadow),myst.fDur);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oShadow),myst.fDur);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oShadow),myst.fDur);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oShadow),myst.fDur);            
                DelayCommand(myst.fDur, RemoveTimestopEquip());

            }
        }
        DelayCommand(0.75, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel)); 
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_TIME_STOP_DN_PURPLE), PRCGetSpellTargetLocation());        
    }
}