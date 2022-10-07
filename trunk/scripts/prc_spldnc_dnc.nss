//::///////////////////////////////////////////////
//:: Perform Spelldance
//:: prc_spldnc_dnc.nss
//::///////////////////////////////////////////////
/*
    Does the dancing and storing of metamagics
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 27.2.2006
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void SpelldanceEnd(object oPC, int nMax, int nExt, int nEmp, int nRounds)
{
    SetCommandable(TRUE, oPC);
    int nMeta;
    if (nMax)
        nMeta |= METAMAGIC_MAXIMIZE;
    if (nExt)
        nMeta |= METAMAGIC_EXTEND;
    if (nEmp)
        nMeta |= METAMAGIC_EMPOWER;
    
    SetLocalInt(oPC, "Spelldance", nMeta);    
    
    FloatingTextStringOnCreature("You have one round to cast a spelldanced spell", oPC, FALSE);
    DelayCommand(9.0, DeleteLocalInt(oPC, "Spelldance"));
    
    nRounds += GetLocalInt(oPC, "SpelldanceRounds");  
    int nDance = GetLevelByClass(CLASS_TYPE_SPELLDANCER, oPC) + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
    
    FloatingTextStringOnCreature("You have spelldanced for "+IntToString(nRounds)+" rounds today", oPC, FALSE);
    if (nDance >= nRounds) FloatingTextStringOnCreature("You have "+IntToString(nDance - nRounds)+" rounds remaining before you must save or be fatigued", oPC, FALSE);
    else //Danced more rounds than you can
    {
        if (!PRCMySavingThrow(SAVING_THROW_FORT, oPC, 10+nRounds, SAVING_THROW_TYPE_NONE))
        {
            if (GetLocalInt(oPC, "SpelldanceFatigue"))
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectExhausted()), oPC, HoursToSeconds(24)); //Until you rest
                ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, 2, DURATION_TYPE_TEMPORARY, TRUE, HoursToSeconds(24));
                FloatingTextStringOnCreature("You are exhausted and cannot spelldance", oPC, FALSE);
                SetLocalInt(oPC, "SpelldanceExhaust", TRUE);
            }
            else
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectFatigue()), oPC, HoursToSeconds(24)); //Until you rest
                FloatingTextStringOnCreature("You are fatigued", oPC, FALSE);
                ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, 2, DURATION_TYPE_TEMPORARY, TRUE, HoursToSeconds(24));
                SetLocalInt(oPC, "SpelldanceFatigue", TRUE);
            }            
        }            
    }
    SetLocalInt(oPC, "SpelldanceRounds", nRounds);  
}


void main()
{
    object oPC = OBJECT_SELF;
    if (GetLocalInt(oPC, "SpelldanceExhaust"))
    {
        FloatingTextStringOnCreature("You are exhausted and cannot spelldance", oPC, FALSE);
        return;
    }    

    string sMsg;
    int nMax = GetLocalInt(oPC, "SpelldanceMaximize");
    int nExt = GetLocalInt(oPC, "SpelldanceExtend");
    int nEmp = GetLocalInt(oPC, "SpelldanceEmpower");
    int nRounds;

    if (nMax)
        nRounds += 3;    
    if (nExt)
        nRounds += 1;
    if (nEmp)
        nRounds += 2;        
       
    FloatingTextStringOnCreature("Spelldancing for "+IntToString(nRounds)+" rounds", oPC, FALSE);
    float fDur = RoundsToSeconds(nRounds);
    SetCommandable(FALSE, oPC);
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, fDur));
    DelayCommand(fDur, SpelldanceEnd(oPC, nMax, nExt, nEmp, nRounds));
}