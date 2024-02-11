//::///////////////////////////////////////////////
//:: Epic Spell: Superb Dispelling
//:: Author: Boneshank (Don Armstrong)

#include "inc_dispel"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_SUP_DIS))
    {
        effect   eVis         = EffectVisualEffect(VFX_IMP_BREACH);
        effect   eImpact      = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
        int      nCasterLevel = GetTotalCastingLevel(OBJECT_SELF);
        object   oTarget      = PRCGetSpellTargetObject();
        location lLocal       = PRCGetSpellTargetLocation();
        // If this option has been enabled, the caster will take the damage
        // as he/she should in accordance with the ELHB.
        if (GetPRCSwitch(PRC_EPIC_BACKLASH_DAMAGE) == TRUE)
        {
            effect eCast = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
            int nDam = d6(10);
            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_NEGATIVE);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCast, OBJECT_SELF);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, OBJECT_SELF);
            }

        // Superb Dispelling's bonus is capped at caster level 40
        if(nCasterLevel >40 )
            nCasterLevel = 40;

        // Targeted Dispelling
        if (GetIsObjectValid(oTarget))
            spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact);

        // Area of Effect - Only dispel best effect
        else
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
            while (GetIsObjectValid(oTarget))
            {
                if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
                    spellsDispelAoEMod(oTarget, OBJECT_SELF, nCasterLevel);
                else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                else
                    spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact, FALSE);
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
            }
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
