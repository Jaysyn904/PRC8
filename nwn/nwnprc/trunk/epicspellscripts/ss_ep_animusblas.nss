//:://////////////////////////////////////////////
//:: FileName: "ss_ep_animusblas"
/*   Purpose: Animus Blast
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"
#include "nw_i0_generic"

void DoAnimationBit(location lTarget, object oCaster, int nCasterLvl);

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ANBLAST))
    {
        int nCasterLvl = PRCGetCasterLevel();
        float fDelay;
        int nDam;
        effect eExplode = EffectVisualEffect(VFX_IMP_PULSE_COLD);
        effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
        effect eDam, eLink;
        location lTarget = PRCGetSpellTargetLocation();

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        DelayCommand(0.3,
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
        DelayCommand(0.6,
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
        DelayCommand(0.9,
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
        DelayCommand(1.2,
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
            RADIUS_SIZE_HUGE, lTarget);
        while (GetIsObjectValid(oTarget))
        {
            if (oTarget != OBJECT_SELF && !GetIsDM(oTarget) &&
                !GetFactionEqual(oTarget) && spellsIsTarget(oTarget,
                SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                    PRCGetSpellId()));
                fDelay = PRCGetRandomDelay();
                if(!PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF), fDelay))
                {
                    nDam = d6(10);
                    // Reflex save for half damage.
                    if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget),
                        SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
                        nDam /= 2;
                    eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);
                    eLink = EffectLinkEffects(eDam, eVis);
                    eLink = EffectLinkEffects(eExplode, eLink);
                    DelayCommand(fDelay, SPApplyEffectToObject
                        (DURATION_TYPE_INSTANT, eLink, oTarget));
                    // Do the animation bit if the target dies from blast.
                    if (!MatchNonliving(MyPRCGetRacialType(oTarget)))
                    {
                        SetLocalInt(oTarget, "nAnBlasCheckMe", TRUE);
                    }
                }
            }
           oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                RADIUS_SIZE_HUGE, lTarget);
        }
        DelayCommand(3.0, DoAnimationBit(lTarget, OBJECT_SELF, nCasterLvl));
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void DoSpawnBit(object oCaster, object oTarget, string sSkel, int nCasterLvl)
{
    if(GetPRCSwitch(PRC_MULTISUMMON))
    {
        //only create a new one if less than maximum count                    
        int nMaxHDControlled = nCasterLvl * 4;
        int nTotalControlled = GetControlledUndeadTotalHD(oCaster);
        if(nTotalControlled < nMaxHDControlled)
        {
            MultisummonPreSummon(oCaster);
            AssignCommand(oCaster, ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, 
                EffectSummonCreature(sSkel, VFX_FNF_SUMMON_UNDEAD), GetLocation(oTarget)));
        }       
    }
    else
    {
        SetMaxHenchmen(999);
        object oSkel = CreateObject(OBJECT_TYPE_CREATURE, sSkel,
            GetLocation(oTarget));
        AddHenchman(oCaster, oSkel);
        SetAssociateListenPatterns(oSkel);
        DetermineCombatRound(oSkel);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD), GetLocation(oTarget));
    }
}    

void DoAnimationBit(location lTarget, object oCaster, int nCasterLvl)
{
    int nX = 0;
    int nM = GetMaxHenchmen();
    int nH = nM;
    string sSkel = "NW_S_SKELWARR";
    object oSkel;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
        RADIUS_SIZE_HUGE, lTarget);
    while (GetIsObjectValid(oTarget))
    {
        if (nX < 12)
        {
            if (GetIsDead(oTarget) &&
                GetLocalInt(oTarget, "nAnBlasCheckMe") == TRUE)
            {
                float fDelay = IntToFloat(Random(60))/10.0;
                DelayCommand(fDelay, DoSpawnBit(oCaster, oTarget, sSkel, nCasterLvl));
                nX++;
            }
        }
        DeleteLocalInt(oTarget, "nAnBlasCheckMe");
        oTarget = GetNextObjectInShape(SHAPE_SPHERE,
            RADIUS_SIZE_HUGE, lTarget);
    }
    DelayCommand(10.0, SetMaxHenchmen(nM));
}
