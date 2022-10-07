#include "prc_alterations"
void Rejuvenate(object oTarget)
{
    int nType;
    int nLevel = GetLevelByClass(CLASS_TYPE_MORNINGLORD);
    effect eHeal,eVis;
    effect eEffect = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eEffect))
    {
        nType = GetEffectType(eEffect);
        if (nType == EFFECT_TYPE_POISON ||
            nType == EFFECT_TYPE_ABILITY_DECREASE ||
            nType == EFFECT_TYPE_DISEASE ||
            nType == EFFECT_TYPE_NEGATIVELEVEL)
        {
            RemoveEffect(oTarget, eEffect);
        }
        eEffect = GetNextEffect(oTarget);
    }
    eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    eHeal = EffectHeal(nLevel+d6());
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
void RejuvenateParty()
{
    object oPC = OBJECT_SELF;
    FloatingTextStringOnCreature("**Lathander answers your prayer**",oPC,FALSE);
    object oTarget = GetFirstFactionMember(oPC,FALSE);
    while(GetIsObjectValid(oTarget))
    {
        Rejuvenate(oTarget);
        oTarget = GetNextFactionMember(oPC,FALSE);
    }
}
void CheckRejuventationSuccess()
{
    object oPC = OBJECT_SELF;
    location lStart = GetLocalLocation(oPC,"MLPrayerLocation");
    location lFinish =GetLocation(oPC);
    if(lStart!=lFinish)
    {
        FloatingTextStringOnCreature("**Rejuvenation Failed**",oPC,FALSE);
        SendMessageToPC(oPC,"Your concentration was broken.");
        return;
    }
    RejuvenateParty();
}
void main()
{
    object oPC = OBJECT_SELF;
    int nPreDawn = MOD_DAWN_START_HOUR-1;
    int nSecondsPerHour = FloatToInt(HoursToSeconds(1));
    string sTime = IntToString(nPreDawn);
    if(GetTimeHour() != nPreDawn)
    {
        FloatingTextStringOnCreature("**Rejuvenation Failed**",oPC,FALSE);
        SendMessageToPC(oPC,"This ability only works just before dawn, at "+IntToString(nPreDawn)+" AM.");
        IncrementRemainingFeatUses(oPC,FEAT_REJUVENATION_OF_MORN);
        return;
    }
    int nSecondsElapsed = GetTimeSecond()+GetTimeMinute()*60;
    int nSecondsBeforeDawn = nSecondsPerHour-nSecondsElapsed;
    if(nSecondsBeforeDawn<12)
    {
        FloatingTextStringOnCreature("**Rejuvenation Failed**",oPC,FALSE);
        SendMessageToPC(oPC,"It is too close to dawn to begin the prayer.  You will have to wait until tomorrow.");
        return;
    }
    int nSecondsToBegin = abs(60-nSecondsBeforeDawn);
    if(nSecondsBeforeDawn>60)
    {
        FloatingTextStringOnCreature("**Rejuvenation Failed**",oPC,FALSE);
        SendMessageToPC(oPC,"It is not quite time to begin the prayer. Try again in "+IntToString(nSecondsToBegin)+" seconds.");
        IncrementRemainingFeatUses(oPC,FEAT_REJUVENATION_OF_MORN);
        return;
    }
    FloatingTextStringOnCreature("**You pray to Lathander**",oPC,FALSE);
    float fPrayerTime = IntToFloat(nSecondsBeforeDawn);
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE,1.0,fPrayerTime));
    SetLocalLocation(oPC,"MLPrayerLocation",GetLocation(oPC));
    DelayCommand(fPrayerTime,CheckRejuventationSuccess());
}
