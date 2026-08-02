//::////////////////////////////////////////////////////////  
//:: tmp_hvamp_cnight.nss  
//::////////////////////////////////////////////////////////  
/*  
	  
	Children of the Night (Su): Some half-vampires can   
	command the lesser creatures of the world. Once per day,   
	a half-vampire that has this special attack can call   
	forth 1d4 rat swarms, 1d3 bat swarms, or a pack of 1d6   
	wolves as a standard action. (If the base creature is   
	not terrestrial, this ability might summon other   
	creatures of equivalent power.) These creatures arrive   
	in 2d6 rounds and serve the half-vampire for up to 1 hour.  
   
*/  
//::////////////////////////////////////////////////////////   
#include "prc_inc_function"  
  
int CheckUses(object oPC, int nUses)  
{  
    if(nUses == 0) //unlimited uses per day  
        return TRUE;  
  
    int nTest = GetLocalInt(oPC, "TemplateSLA_CHILDREN_OF_THE_NIGHT");  
  
    if(nTest < nUses)  
    {  
        nTest++;  
        SetLocalInt(oPC, "TemplateSLA_CHILDREN_OF_THE_NIGHT", nTest);  
        return TRUE;  
    }  
    else  
    {  
        FloatingTextStringOnCreature("You have already used this ability today.", oPC);  
        return FALSE;  
    }  
}  
  
// Attaches the standard PRC AI event scripts directly to a summoned creature  
void SetupSummonAI(object oSummon)  
{  
    if (!GetIsObjectValid(oSummon))  
        return;  
  
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, "prc_ai_sum_block");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "prc_ai_sum_damag");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_DEATH, "prc_ai_sum_death");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, "prc_ai_sum_conv");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_DISTURBED, "prc_ai_sum_distb");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, "prc_ai_sum_combt");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "prc_ai_sum_heart");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "prc_ai_sum_attck");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_NOTICE, "prc_ai_sum_percp");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_RESTED, "prc_ai_sum_rest");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, "prc_ai_sum_spawn");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, "mirror_image_sa");
	SetEventScript(oSummon, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, "prc_ai_sum_userd");  
   
}  
  
// Walks the caster's summoned associate list and applies AI to any not yet configured  
void BuffChildrenOfTheNight(object oCaster)  
{  
    int i = 1;  
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);  
    while(GetIsObjectValid(oSummon))  
    {  
        if (!GetLocalInt(oSummon, "HVamp_CNightAISet"))  
        {  
            SetupSummonAI(oSummon);  
            SetLocalInt(oSummon, "HVamp_CNightAISet", TRUE);  
        }  
        i++;  
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);  
    }  
}  
  
void main()  
{  
    object oPC = OBJECT_SELF;  
    int nSpellID = PRCGetSpellId();  
  
    if (!CheckUses(oPC, 1))  
        return;  
  
    int nCount;  
    string sResRef;  
    int nVFX;  
  
    switch(nSpellID)  
    {  
        case SPELL_HALF_VAMPIRE_CHILDREN_RAT:  
            nCount  = 1+d3();  
            sResRef = "prc_rat_swarm";  
            nVFX    = VFX_FNF_SUMMON_MONSTER_1;  
            break;  
        case SPELL_HALF_VAMPIRE_CHILDREN_BAT:  
            nCount  = 1+d3();  
            sResRef = "prc_bat_swarm";  
            nVFX    = VFX_FNF_SUMMON_MONSTER_2;  
            break;  
        case SPELL_HALF_VAMPIRE_CHILDREN_WOLF:  
            nCount  = d2() + d4();  
            sResRef = "prc_s_wolf001";  
            nVFX    = VFX_FNF_SUMMON_MONSTER_3;  
            break;  
        default:  
            nCount  = d6();  
            sResRef = "prc_s_wolf001";  
            nVFX    = VFX_FNF_SUMMON_MONSTER_3;  
            break;  
    }  
  
    // Duration: up to 1 hour  
    float fDuration = HoursToSeconds(1);  
  
    location lTarget = PRCGetSpellTargetLocation(oPC);  
  
    int i;  
    for(i = 0; i < nCount; i++)  
    {  
        effect eSummon = EffectSummonCreature(sResRef, nVFX);  
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);  
    }  
  
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_EVIL), oPC);  
  
    // Give the engine a moment to actually create the associates before we walk the list  
    DelayCommand(0.3, BuffChildrenOfTheNight(oPC));  
}