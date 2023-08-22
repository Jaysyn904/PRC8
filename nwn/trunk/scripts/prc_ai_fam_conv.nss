#include "prc_inc_assoc"

void main()
{
    object oComp = OBJECT_SELF;

    if(GetLastSpeaker() == GetMasterNPC(oComp)
    && GetStringLeft(GetResRef(oComp), 11) != "prc_pnpfam_")
    {
        if(GetListenPatternNumber() == ASSOCIATE_COMMAND_LEAVEPARTY)
        {
            DestroyAssociate(oComp);
            return;
        }
    }

    ExecuteScript("nw_ch_ac4", oComp);
    ExecuteScript("prc_npc_conv", oComp);
}