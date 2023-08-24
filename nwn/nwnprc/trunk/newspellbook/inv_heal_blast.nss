//::///////////////////////////////////////////////
//:: Name      Eldritch Blast - Normal
//:: FileName  inv_eldtch_blast.nss
//:://////////////////////////////////////////////
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    object oPC = OBJECT_SELF;
    SetLocalInt(oPC, PRC_INVOKING_CLASS, CLASS_TYPE_WARLOCK + 1);

    if(!PreInvocationCastCode()) return;

    if(!CheckTurnUndeadUses(oPC, 1))
    {
        SpeakStringByStrRef(40550);//"This ability is tied to your turn undead ability, which has no more uses for today."
        return;
    }

    location lTargetArea = GetLocation(oPC);
    int bSculptor = GetHasFeat(FEAT_ELDRITCH_SCULPTOR, oPC);

    float fRange, fDelay;
    int nImpVFX, nDamage, nRace;
    effect eHealVFX = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eHarmVFX = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

    if(bSculptor)
    {
        fRange = FeetToMeters(40.0);
        nImpVFX = VFX_FNF_LOS_HOLY_30;
    }
    else
    {
        fRange = FeetToMeters(20.0);
        nImpVFX = VFX_FNF_LOS_HOLY_20;
    }

    //calculate DC for essence effects
    int nInvLevel = GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK);
    int nDmgDice = GetBlastDamageDices(oPC, nInvLevel);
    int nPenetr = nInvLevel + SPGetPenetr();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nImpVFX), lTargetArea);

    //Get first target in spell area
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lTargetArea, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetDistanceBetween(oPC, oTarget)/20;
        nDamage = d6(nDmgDice);

        nRace = MyPRCGetRacialType(oTarget);
        if(nRace == RACIAL_TYPE_UNDEAD)
        {
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oPC, INVOKE_HEALING_BLAST));

                if(!PRCDoResistSpell(oPC, oTarget, nPenetr, fDelay))
                {
                    //Apply damage effect and VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE), oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHarmVFX, oTarget));
                }
            }
        }
        else if((nRace == RACIAL_TYPE_CONSTRUCT && !GetIsWarforged(oTarget))
        || GetHasFeat(FEAT_IMPROVED_FORTIFICATION, oTarget))
        {
            //nothing
        }
        else if(!GetIsReactionTypeHostile(oTarget) || GetFactionEqual(oTarget)
        && (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, INVOKE_HEALING_BLAST, FALSE));

            if(GetIsWarforged(oTarget))
                nDamage /= 2;

            //Apply heal effect and VFX impact
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDamage), oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVFX, oTarget));
        }

        //Get next target in spell area
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lTargetArea, TRUE, OBJECT_TYPE_CREATURE);
    }

    /*if(bSculptor)
    {
        if(!GetLocalInt(oPC, "UsingSecondBlast"))
        {
            SetLocalInt(oPC, "UsingSecondBlast", TRUE);
            UseInvocation(INVOKE_HEALING_BLAST, CLASS_TYPE_WARLOCK, 0, TRUE);
        }
        else
            DeleteLocalInt(oPC, "UsingSecondBlast");
    }*/
}
