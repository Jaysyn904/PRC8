//::///////////////////////////////////////////////
//:: FileName sc_has_loreskill
//:://////////////////////////////////////////////

int StartingConditional()
{

    // Perform skill checks
    if(!(GetSkillRank(SKILL_LORE, GetPCSpeaker()) >= 0))
        return FALSE;

    return TRUE;
}
