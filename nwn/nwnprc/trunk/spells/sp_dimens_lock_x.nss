//::///////////////////////////////////////////////
//:: Spell: Dimensional Lock - Aux
//:: sp_dimens_lock_x
//::///////////////////////////////////////////////
/** @ file
    This script is run by a placeable. It applies
    the effect of the Dimensional Lock spell.
    This is done in order to implement the
    1 day / level duration of the spell, which
    does not work if the caster applies the effect
    since the effect would disappear when the caster
    rests.


    @author Ornedan
    @date   Created  - 2005.10.22
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_teleport"

void main()
{
    //object oCaster   = GetLocalObject  (OBJECT_SELF, "PRC_Spell_DimLock_Caster");
    location lTarget = GetLocalLocation(OBJECT_SELF, "PRC_Spell_DimLock_Target");
    //int nPenetr      = GetLocalInt     (OBJECT_SELF, "PRC_Spell_DimLock_SpellPenetr");
    float fDur       = GetLocalFloat   (OBJECT_SELF, "PRC_Spell_DimLock_Duration");

    // Create the AoE
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(VFX_PER_20_FT_INVIS, "sp_dimens_lock_a", "sp_dimens_lock_b", "sp_dimens_lock_c"), lTarget, fDur);
}