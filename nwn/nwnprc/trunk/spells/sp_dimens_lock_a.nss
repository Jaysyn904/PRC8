//::///////////////////////////////////////////////
//:: Spell: Dimensional Lock - AoE OnEnter
//:: sp_dimens_lock_a
//::///////////////////////////////////////////////
/** @ file
    The OnEnter script of the area of effect
    created by the spell Dimensional Lock.
    Sets the teleportation forbiddance marker on
    creatures in it.


    @author Ornedan
    @date   Created  - 2005.10.22
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_teleport"

void main()
{
    object oAoE = OBJECT_SELF;
    if(!GetLocalInt(oAoE, "INIT_DONE"))
    {
        object oCreator = GetAreaOfEffectCreator();

        SetLocalObject(oAoE, "PRC_Spell_DimLock_Caster", GetLocalObject(oCreator, "PRC_Spell_DimLock_Caster"));
        SetLocalInt(oAoE, "PRC_Spell_DimLock_SpellPenetr", GetLocalInt(oCreator, "PRC_Spell_DimLock_SpellPenetr"));

        DestroyObject(oCreator);

        SetLocalInt(oAoE, "INIT_DONE", TRUE);
    }

    /* Apply the spell's effect */
    object oCaster   = GetLocalObject(oAoE, "PRC_Spell_DimLock_Caster");
    object oTarget   = GetEnteringObject();
    int nPenetr      = GetLocalInt(oAoE, "PRC_Spell_DimLock_SpellPenetr");

    // Let the AI know
    PRCSignalSpellEvent(oTarget, TRUE, SPELL_DIMENSIONAL_LOCK, oCaster);

    // Spell Resistance
    if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
    {
        SendMessageToPCByStrRef(oTarget, 16825687); // "You feel steady"
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_10), oTarget);
        SetLocalInt(oTarget, "PRC_Spell_DimLock_Affected", TRUE);
        DisallowTeleport(oTarget);
    }
}