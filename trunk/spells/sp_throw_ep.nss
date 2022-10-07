//////////////////////////////////////////////////
// Throw energized potion
// sp_throw_ep.nss
//////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oGrenade = PRCGetSpellCastItem();
        int nDamType = GetLocalInt(oGrenade, "PRC_GrenadeDamageType");
        int nStrength = GetLocalInt(oGrenade, "PRC_GrenadeLevel");
        int nSaveType = GetLocalInt(oGrenade, "PRC_EnergizedPotionSave");
        int nDC = GetLocalInt(oGrenade, "PRC_EnPotSaveDC");
        int nDam;
        location lLoc = PRCGetSpellTargetLocation();
        // do some vfx to apply to hit targets
        int nVFX;
        switch (nDamType)
        {
            case DAMAGE_TYPE_ACID:
                nVFX = VFX_IMP_ACID_L;
                break;
            case DAMAGE_TYPE_COLD:
                nVFX = VFX_IMP_FROST_S;
                break;
            case DAMAGE_TYPE_ELECTRICAL:
                nVFX = VFX_IMP_LIGHTNING_S;
                break;
            case DAMAGE_TYPE_FIRE:
                nVFX = VFX_IMP_FLAME_M;
                break;
            case DAMAGE_TYPE_SONIC:
                nVFX = VFX_IMP_SONIC;
                break;
        }
        effect eVis = EffectVisualEffect(nVFX);
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        
        while(GetIsObjectValid(oTarget))
        {
            if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF))
            {
                //Fire cast spell at event for the specified target
                PRCSignalSpellEvent(oTarget);
                nDam = d6(nStrength);
                nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, nDC, nSaveType);
                if(nDam > 0)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, nDamType), oTarget);
                    // vfx on object
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
}