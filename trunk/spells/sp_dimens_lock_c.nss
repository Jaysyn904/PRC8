//::///////////////////////////////////////////////
//:: Spell: Dimensional Lock - AoE OnExit
//:: sp_dimens_lock_c
//::///////////////////////////////////////////////
/** @ file
    The OnExit script of the area of effect
    created by the spell Dimensional Lock.
    Unsets the teleportation forbiddance marker on
    the exiting creature


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

    object oTarget = GetExitingObject();

    if(GetLocalInt(oTarget, "PRC_Spell_DimLock_Affected"))
    {
        SendMessageToPCByStrRef(oTarget, 16825688); // "You feel jumpy"
        AllowTeleport(oTarget);
    }
}