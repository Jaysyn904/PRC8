//::///////////////////////////////////////////////
//:: OnSpawn NPC eventscript
//:: prc_npc_spawn
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"
#include "inc_npc"

void AshenHuskHB();

void ChecksOnMaster()
{
    if (DEBUG) DoDebug("ChecksOnMaster: Entered");
    if(MyPRCGetRacialType(OBJECT_SELF)==RACIAL_TYPE_UNDEAD)
    {
        if (DEBUG) DoDebug("ChecksOnMaster: Undead");
        object oMaster = GetMaster();
        if(GetIsObjectValid(oMaster) /*&& GetAssociateType(OBJECT_SELF) != ASSOCIATE_TYPE_SUMMONED*/)
        {
            if (DEBUG) DoDebug("ChecksOnMaster: Valid Master, Not a Summon");
            CorpseCrafter(oMaster, OBJECT_SELF);
        }
    }
}

void FeignLife()
{
    if (GetResRef(OBJECT_SELF) == "prc_shd_animhuge" || GetResRef(OBJECT_SELF) == "prc_shd_animgarg")
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectLinkEffects(EffectConcealment(20), EffectVisualEffect(PSI_DUR_SHADOW_BODY))), OBJECT_SELF);  
        if(DEBUG) DoDebug("prc_npc_spawn: FeignLife");
    }    
}

void ShadowElem()
{
    if (GetResRef(OBJECT_SELF) == "shd_shdelem_huge" || GetResRef(OBJECT_SELF) == "shd_shdelem_eldr" || GetResRef(OBJECT_SELF) == "shd_shdelem_med" ||
        GetResRef(OBJECT_SELF) == "shd_shdelem_med2" || GetResRef(OBJECT_SELF) == "shd_shdelem_med3" || GetResRef(OBJECT_SELF) == "shd_shdelem_med4")
    {
        effect eLink = EffectLinkEffects(EffectTrueSeeing(), EffectVisualEffect(PSI_DUR_SHADOW_BODY)); 
               /*eLink = EffectLinkEffects(eLink, EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_COLD));
               eLink = EffectLinkEffects(eLink, EffectAttackIncrease(1));*/
        SetIncorporeal(OBJECT_SELF, 1.0, 2, TRUE);
        if(DEBUG) DoDebug("prc_npc_spawn: ShadowElem");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), OBJECT_SELF);
    }    
}

void AshenHuskHB()
{
    effect eImpact = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (PRCGetIsAliveCreature(oTarget) && !GetLocalInt(oTarget, "AshenHuskImmune") && !GetHasFeat(FEAT_HEAT_ENDURANCE, oTarget))
        {
             if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 13, SAVING_THROW_TYPE_NONE))
             {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d4()), oTarget);
                 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFatigue(), oTarget, HoursToSeconds(12));
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
             }
             else
             {
                SetLocalInt(oTarget, "AshenHuskImmune", TRUE);
             }    
        }         
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
    }
    
    DelayCommand(6.0, AshenHuskHB());
}

void AshenHusk()
{
    if (GetResRef(OBJECT_SELF) == "bdd_ashen_husk")
    {
        AshenHuskHB();
        if(DEBUG) DoDebug("prc_npc_spawn: AshenHusk");
    }    
}

void Asherati()
{
    if (GetResRef(OBJECT_SELF) == "bdd_asherati_chn" || GetResRef(OBJECT_SELF) == "bdd_asherati_tnt")
    {
        if(DEBUG) DoDebug("prc_npc_spawn: Asherati");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_5)), OBJECT_SELF);
    }    
}

void ShadowformFamiliar()
{
    object oPC = GetMaster();
    if(GetIsObjectValid(oPC) && GetHasFeat(FEAT_SHADOWFORM_FAMILIAR, oPC))
    {    
        int i;
        for(i = 1; i <= 5; i++)
        {
            object oAsso = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR, oPC, i);
            if(GetIsObjectValid(oAsso))
                SetIncorporeal(oAsso, -1.0, 2, TRUE);
        }
    }    
}

void main()
{
    //this has to be delayed since
    //master is not valid onSpawn for summons
    DelayCommand(0.1, ChecksOnMaster());
    DelayCommand(0.1, FeignLife());
    DelayCommand(0.1, ShadowElem());
    DelayCommand(0.1, AshenHusk());
    DelayCommand(0.1, Asherati());
    DelayCommand(0.1, ShadowformFamiliar());
    if(DEBUG) DoDebug("prc_npc_spawn for "+GetResRef(OBJECT_SELF));
    //check for local variable for XP and convert to real XP
    if(GetLocalInt(OBJECT_SELF, PRC_NPC_XP))
        SetXP(OBJECT_SELF, GetLocalInt(OBJECT_SELF, PRC_NPC_XP));
}