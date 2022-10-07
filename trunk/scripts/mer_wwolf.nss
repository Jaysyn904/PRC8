void AbilityUsesPerDay(object oCompanion, int nLevel)
{
    int iMax, i;
    int coneAbi = nLevel / 5;
    switch(coneAbi)
    {
        case 1 : iMax = 7; break;
        case 2 : iMax = 6; break;
        case 3 : iMax = 5; break;
        case 4 : iMax = 4; break;
        case 5 : iMax = 3; break;
        case 6 : iMax = 2; break;
        case 7 : iMax = 1; break;
    }

    if(iMax > 0)
    {
        for(i = 1; i <= iMax; i++)
            DecrementRemainingSpellUses(oCompanion, 230);
    }
}

void main()
{
    object oCompanion = OBJECT_SELF;
    int nLevel = GetHitDice(oCompanion);

    ExecuteScript("prc_ai_fam_rest", oCompanion);

    DelayCommand(6.0f, AbilityUsesPerDay(oCompanion, nLevel));
}