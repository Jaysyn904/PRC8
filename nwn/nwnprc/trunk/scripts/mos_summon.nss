/**
 * Master of Shrouds: Summon Undead (1-4)
 * 2004/02/15
 * Brian Greinke
 * edited to include epic wraith summons 2004/03/04; also removed unnecessary scripting.
 * Lockindal Linantal
 */

#include "prc_inc_spells"
//#include "inc_utility"
#include "prc_inc_turning"

void SummonUndeadPseudoHB(object oCaster, object oSummon, int nChaMod, int nSpellID)
{
    if(!GetIsObjectValid(oSummon))
        return;
    if(!GetIsInCombat(oCaster))
    {
        //casters level for turning
        int nLevel = GetTurningClassLevel(oCaster);
        int nTurningCheck = d20() + nChaMod;
        int nTurningMaxHD = GetTurningCheckResult(nLevel, nTurningCheck);
        int nTargetHD = GetHitDiceForTurning(oSummon, SPELL_TURN_UNDEAD, RACIAL_TYPE_UNDEAD);
        if(nTurningMaxHD < nTargetHD)
        {
            effect eTest= GetFirstEffect(oSummon);
            while(GetIsEffectValid(eTest))
            {
                if(GetEffectSpellId(eTest) == nSpellID)
                    RemoveEffect(oSummon, eTest);
                eTest = GetNextEffect(oSummon);
            }
            //make em hostile
            object oTest = GetFirstFactionMember(oCaster);
            while(GetIsObjectValid(oTest))
            {
                SetIsTemporaryEnemy(oTest, oSummon);
                oTest = GetNextFactionMember(oCaster);
            }
        }    
        else
        {
            AssignCommand(oSummon, ClearAllActions());
            AssignCommand(oSummon, ActionForceFollowObject(oCaster, IntToFloat(Random(8)+3)));
        }
    }
    DelayCommand(6.0, SummonUndeadPseudoHB(oCaster, oSummon, nChaMod, nSpellID));
}

void main()
{
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nClass = GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oCaster);
    int nChaMod = GetTurningCharismaMod(SPELL_TURN_UNDEAD);
    float fDuration = RoundsToSeconds(nClass);

    int nSpellID = GetSpellId();
    int nCount;
    switch(nSpellID)
    {
        case 3009: nCount = 1; break;
        case 3010: nCount = 2; break;
        case 3011: nCount = 4; break;
        case 3012: nCount = 8; break;
    }

    string sSummon;
    if (nClass > 28)        sSummon = "prc_mos_39";
    else if (nClass > 25)   sSummon = "prc_mos_36";
    else if (nClass > 22)   sSummon = "prc_mos_33";
    else if (nClass > 19)   sSummon = "prc_mos_30";
    else if (nClass > 16)   sSummon = "prc_mos_27";
    else if (nClass > 13)   sSummon = "prc_mos_24";
    else if (nClass > 10)   sSummon = "prc_mos_21";
    else if (nClass > 8)    sSummon = "prc_mos_spectre2";
    else if (nClass > 6)    sSummon = "prc_mos_spectre1";
    else if (nClass > 4)    sSummon = "prc_mos_wraith";
    else                     sSummon = "prc_mos_allip";

    //MultisummonPreSummon(oCaster);
    effect eCommand = EffectCutsceneDominated();//SupernaturalEffect(effectdominated doesnt work on mind-immune
    effect eSummonB = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);//EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
    int i;
    for(i = 0; i < nCount; i++)
    {
        object oSummon = CreateObject(OBJECT_TYPE_CREATURE, sSummon, lTarget);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummonB, GetLocation(oSummon));
        ChangeToStandardFaction(oSummon, STANDARD_FACTION_HOSTILE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCommand, oSummon);
		DelayCommand(0.5, AugmentSummonedCreature(sSummon));
        DelayCommand(6.0, SummonUndeadPseudoHB(oCaster, oSummon, nChaMod, nSpellID));
        DestroyObject(oSummon, fDuration);
    }
}
