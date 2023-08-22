//::///////////////////////////////////////////////
//:: Fireball
//:: NW_S0_Fireball
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

// Testing summoning spell


void main()
{
    // Create summon effect
    string sResRef = "phs_kobold";
    string sResRef2 = "phs_balor";
    effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_MONSTER_1);
    effect eSummon2 = EffectSummonCreature(sResRef2, VFX_FNF_SUMMON_MONSTER_2);
    effect eLink = EffectLinkEffects(eSummon, eSummon2);
    location lTarget = GetSpellTargetLocation();

    SpeakString("Summoning monster: Kobold");

    // Set the associates (summons) to destroyable: FALSE for a sec.
    int nCnt = 1;
    object oAssociate = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oAssociate))
    {
        SpeakString("Summon: " + GetName(oAssociate) + ". changing to destroyable");
        AssignCommand(oAssociate, SetIsDestroyable(FALSE));
        DelayCommand(0.1, AssignCommand(oAssociate, SetIsDestroyable(TRUE)));
        nCnt++;
        oAssociate = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, nCnt);
    }
    // Apply it for 10 minutes
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eLink, lTarget, TurnsToSeconds(10));

    // Apply it for 10 minutes
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, TurnsToSeconds(10));
    // 2 of them - Apply it for 10 minutes
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, lTarget, TurnsToSeconds(10));
}
