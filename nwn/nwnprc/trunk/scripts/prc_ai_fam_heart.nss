#include "prc_alterations"
#include "prc_inc_assoc"

void main()
{
    object oFam = OBJECT_SELF;
    object oMaster = GetMasterNPC(oFam);

    //check if master is valid, if not unsummon
    if(!GetIsObjectValid(oMaster))
        DestroyAssociate(oFam);


    if(GetStringLeft(GetResRef(oFam), 11) == "prc_pnpfam_")
    {
        if(!GetIsDead(oFam) && GetLocalInt(oFam, "Familiar_Died"))
        {
            SetIsDestroyable(TRUE, TRUE, TRUE);
            DeleteLocalInt(oFam, "Familiar_Died");
        }
    }
    else if(!GetIsObjectValid(GetMaster(oFam)))
    {
        RemoveHenchman(oMaster, oFam);
        AddAssociate(oMaster, oFam);
    }

    ExecuteScript("nw_ch_ac1", oFam);

    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(oFam, EVENT_NPC_ONHEARTBEAT);
}