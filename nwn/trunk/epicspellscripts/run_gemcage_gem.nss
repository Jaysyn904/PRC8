//:://////////////////////////////////////////////
//:: FileName: "run_gemcage_gem"
/*   Purpose: This will uncage the creature associated with the particular gem.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "nw_i0_generic"

void main()
{
    object oItem = GetItemActivated();
    object oCre;
    string sName = GetLocalString(oItem, "sNameOfCreature");
    string sRef = GetLocalString(oItem, "sCagedCreature");
    if (PRCGetSpellTargetObject() == OBJECT_SELF)
    {
        FloatingTextStringOnCreature("Inside this gem, " + sName +
            " is safely caged.", OBJECT_SELF);
    }
    else
    {
        location lTarget = GetItemActivatedTargetLocation();
        effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
        oCre = CreateObject(OBJECT_TYPE_CREATURE, sRef, lTarget);
        FloatingTextStringOnCreature(sName + " has been set free!", OBJECT_SELF);
        DestroyObject(oItem);
        AssignCommand(oCre, DetermineCombatRound());
    }
}

