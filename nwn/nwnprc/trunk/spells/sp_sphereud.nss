#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    if (!X2PreSpellCastCode()) return;

    // Calculate spell duration.
    int nCasterLvl = PRCGetCasterLevel();
    float fDuration = RoundsToSeconds(nCasterLvl);
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
            fDuration = RoundsToSeconds(nCasterLvl*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));
    fDuration = PRCGetMetaMagicDuration(fDuration);

    // Apply summon and vfx at target location. 
    location lTarget = PRCGetSpellTargetLocation();
        MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, 
        EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, 
        EffectSummonCreature("sp_sphereofud"), lTarget, fDuration);
    
    // Save the spell DC and SR for the spell so the sphere can use it.
    int nSaveDC = PRCGetSaveDC(OBJECT_SELF,OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "SP_SPHEREOFUD_DC", nSaveDC);
    SetLocalInt(OBJECT_SELF, "SP_SPHEREOFUD_SR", nCasterLvl);
}
