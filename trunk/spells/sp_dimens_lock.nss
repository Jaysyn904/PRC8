//::///////////////////////////////////////////////
//:: Spell: Dimensional Lock
//:: sp_dimens_lock
//::///////////////////////////////////////////////
/** @ file
    Dimensional Lock

    Abjuration
    Level: Clr 8, Sor/Wiz 8
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./level)
    Area: 20-ft.-radius emanation centered on a point in space
    Duration: One day/level
    Saving Throw: None
    Spell Resistance: Yes

    You create a shimmering emerald barrier that completely blocks
    extradimensional travel. Forms of movement barred include astral projection,
    blink, dimension door, ethereal jaunt, etherealness, gate, maze,
    plane shift, shadow walk, teleport, and similar spell-like or psionic
    abilities. Once dimensional lock is in place, extradimensional travel into
    or out of the area is not possible.

    A dimensional lock does not interfere with the movement of creatures already
    in ethereal or astral form when the spell is cast, nor does it block
    extradimensional perception or attack forms. Also, the spell does not
    prevent summoned creatures from disappearing at the end of a summoning
    spell.


    @author Ornedan
    @date   Created  - 2005.10.22
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_teleport"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);
    // Spellhook
    if(!X2PreSpellCastCode()) return;

    /* Main spellscript */
    object oCaster   = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLvl   = PRCGetCasterLevel();
    int nSpellID     = PRCGetSpellId();
    effect eVis      = EffectLinkEffects(EffectVisualEffect(VFX_IMP_BLINDDEAD_DN_GREEN), EffectVisualEffect(VFX_IMP_BLINDDEAD_DN_SOUNDFX));
    float fDur       = PRCGetMetaMagicDuration(HoursToSeconds(24 * nCasterLvl));


    // Do VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);

    // Spawn invisible caster object
    object oApplyObject = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lTarget);

    // Store data on it
    SetLocalObject(oApplyObject, "PRC_Spell_DimLock_Caster", oCaster);
    SetLocalLocation(oApplyObject, "PRC_Spell_DimLock_Target", lTarget);
    SetLocalInt(oApplyObject, "PRC_Spell_DimLock_SpellPenetr", nCasterLvl + SPGetPenetr());
    SetLocalFloat(oApplyObject, "PRC_Spell_DimLock_Duration", fDur);

    // Assign commands
    AssignCommand(oApplyObject, ExecuteScript("sp_dimens_lock_x", oApplyObject));
    AssignCommand(oApplyObject, DelayCommand(fDur, DestroyObject(oApplyObject))); // The AoE is likely to destroy it before this, but paranoia

    // Cleanup
    PRCSetSchool();
}