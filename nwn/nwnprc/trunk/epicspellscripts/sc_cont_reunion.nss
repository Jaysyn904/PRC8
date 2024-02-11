//:://////////////////////////////////////////////
//:: FileName: "sc_cont_reunion"
/*   Purpose: This is the conditional script that allows the appearance of
        any of the "target" options of the Contingent Reunion conversation
        when the target of the spell is a creature. This is so the caster can
        choose who will trigger the teleportation, the caster ot the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    if (!GetLocalInt(GetPCSpeaker(), "nMyTargetIsACreature") == TRUE)
        return FALSE;
    return TRUE;
}
