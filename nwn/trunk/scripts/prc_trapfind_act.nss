//::///////////////////////////////////////////////
//:: Trapfinder - active search mode
//:: prc_trapfind_act.nss
//::///////////////////////////////////////////////
/*
    One of the hard-coded NWN 'features' is that
    only rouges can detect traps with detect
    DC > 35. This may be OK for standard NWN, but
    we have some cool classes that would benefit
    from trapfinder feat. That's why I wrote this
    small script.

    This system is quite simple - it complements
    standard detect mode (so it will only detect
    traps with detect DC > 35).
    Basically there are two invisible area of
    effect objects that check for presence of traps
    in the area. Then if trap can be detected and
    has DC > 35 this script will make a search
    skill roll to check if oPC can detect the trap.
    If check was succesful the trap is marked as
    detected.

    The AoE objects are applied by PC's skin in
    prc_feats.nss - one for each detect mode.
    In passive detect mode search checks are made
    every round in 15 ft radius.
    In active detect mode search checks are made
    twice per round in 25 ft radius.

    X
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void DoDetectCheck(object oPC, object oTrap);

void main()
{
    object oPC = GetItemPossessor(GetAreaOfEffectCreator());

    if(GetDetectMode(oPC) != DETECT_MODE_ACTIVE)
        return;

    object oTest = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTest))
    {
        if(GetTrapDetectable(oTest) && !GetTrapDetectedBy(oTest, oPC))
        {
            DoDetectCheck(oPC, oTest);
            DelayCommand(3.0f, DoDetectCheck(oPC, oTest));
        }
        oTest = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void DoDetectCheck(object oPC, object oTrap)
{
    int nDC = GetTrapDetectDC(oTrap);
    if(nDC > 35)
    {
        if((d20() + GetSkillRank(SKILL_SEARCH, oPC)) >= nDC)
            SetTrapDetectedBy(oTrap, oPC);
    }
}