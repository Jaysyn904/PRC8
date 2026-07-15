#include "prc_alterations"
#include "prc_inc_assoc"

void main()
{
    ExecuteScript("nw_ch_aca", OBJECT_SELF);
    ExecuteScript("prc_npc_rested", OBJECT_SELF);

	if(GetPRCSwitch(PRC_PNP_FAMILIARS))
    {
        object oPC = GetMasterNPC();
		if(!GetHasFeat(FEAT_SUMMON_FAMILIAR, oPC)) return;
        DelayCommand(6.0f, AssignCommand(oPC, ActionCastSpell(318)));
    }
}