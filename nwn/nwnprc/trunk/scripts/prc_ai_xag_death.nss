#include "prc_alterations"  
#include "prc_inc_assoc"  
//;;  
//;; prc_ai_xag_death.nss  
//;;  
  
void main()  
{  
    object oFam = OBJECT_SELF;  
  
    ExecuteScript("prc_npc_death", oFam);  
    if(GetStringLeft(GetResRef(oFam), 9) == "prc_xagya")  
    {  
        //raisable  
        SetIsDestroyable(FALSE, TRUE, TRUE);  
        SetLocalInt(oFam, "XagYa_Died", 1);  
  
        //apply XP penalty  
        object oPC = GetMasterNPC(oFam);  
        int iSoldier = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT);  
        int nLostXP = 200 * iSoldier;  
        //fort save for half xp loss  
        if(FortitudeSave(oPC, 15))  
            nLostXP /= 2;  
        //check it wont loose a level  
        int nSpareXP = GetXP(oPC)-(GetHitDice(oPC)*(GetHitDice(oPC)-1)*500);  
        if(nSpareXP < nLostXP)  
            nLostXP = nSpareXP;  
        SetXP(oPC, GetXP(oPC) - nLostXP);  
  
        //:: Explosion (Su): body destroyed in a burst of positive energy,  
        //:: 1d8+9 damage, 20-ft radius, Fort DC 16 half  
        location lTarget = GetLocation(oFam);  
        effect eExplode = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);  
        effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);  
        effect eDam, eHeal;  
        int nDamage;  
        float fDelay;  
  
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);  
  
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget);  
        while(GetIsObjectValid(oTarget))  
        {  
            nDamage = d8(1) + 9;  
            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 16, SAVING_THROW_TYPE_POSITIVE))  
                nDamage /= 2;  
  
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;  
  
            if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD  
            || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)  
            || GetLocalInt(oTarget, "AcererakHealing"))  
            {  
                eHeal = EffectHeal(nDamage);  
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));  
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));  
            }  
            else  
            {  
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);  
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));  
            }  
  
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget);  
        }  
    }  
    else  
        ExecuteScript("nw_ch_ac7", oFam);  
}