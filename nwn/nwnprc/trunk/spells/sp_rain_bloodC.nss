////////////////////////////////////////////////////
//  Rain of Blood AoE HB
//  sp_rain_bloodC.nss
///////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        location lLoc = GetLocation(OBJECT_SELF);
        int nType;
        float fDur = HoursToSeconds(24);
        
        //Define effects
        effect eBuff = EffectAttackIncrease(1);
        eBuff = EffectLinkEffects(eBuff, EffectDamageIncrease(1));
        eBuff = EffectLinkEffects(eBuff, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1));
        eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_SPELLTURNING_R));
        eBuff = SupernaturalEffect(eBuff);
        
        effect eDebuff = EffectAttackDecrease(1);
        eDebuff = EffectLinkEffects(eDebuff, EffectDamageDecrease(1, DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING));
        eDebuff = EffectLinkEffects(eDebuff, EffectSavingThrowDecrease(SAVING_THROW_ALL, 1));
        eDebuff = EffectLinkEffects(eDebuff, EffectVisualEffect(VFX_DUR_SPELLTURNING_R));
        eDebuff = SupernaturalEffect(eDebuff);
                
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 500.0f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))        
        {
                int nType = MyPRCGetRacialType(oTarget);
                
                if (nType == RACIAL_TYPE_UNDEAD)
                {
                        //Apply bonus
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDur);
                }
                
                else
                //Apply penalty if alive
                {
                        if(nType != RACIAL_TYPE_CONSTRUCT && nType != RACIAL_TYPE_ELEMENTAL)
                        {
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oTarget, fDur);                                       
                        }
                }
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, 500.0f, lLoc, FALSE, OBJECT_TYPE_CREATURE);                
        }
}