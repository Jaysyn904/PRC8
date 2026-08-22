//::///////////////////////////////////////////////  
//:: Soldier of Light - Energon Companion  
//:: sol_energon.nss  
//:://////////////////////////////////////////////  
/*  
    Energon Companion: At 4th level, a soldier of light can  
    summon a xag-ya companion (prc_xagya001). At 8th level, he  
    may summon a second xag-ya, and both gain +2 HD (with all  
    attendant benefits, including BAB and save increases).  
*/  
//:://////////////////////////////////////////////
#include "prc_inc_json"
#include "inc_ecl"  

  
void SpawnEnergon(object oPC, json jXagYa, location lTarget, float fDuration)  
{  
    MultisummonPreSummon(oPC, TRUE);  
  
    object oEnergon = JsonToObject(jXagYa, lTarget);  
    if (!GetIsObjectValid(oEnergon))  
    {  
        SendMessageToPC(oPC, "sol_energon | SpawnEnergon() >> JsonToObject failed.");  
        return;  
    }  
  
    effect eSummon = EffectSummonCreature("", VFX_FNF_SUMMON_MONSTER_2, 0.0, 0, VFX_IMP_UNSUMMON, oEnergon);  
  
    ChangeFaction(oEnergon, oPC);  
    SetLocalObject(oEnergon, "SUMMONER", oPC);  
  
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);  
  
    SetLocalNPC(oPC, oEnergon, ASSOCIATE_TYPE_SUMMONED);  
    SetAssociateState(NW_ASC_HAVE_MASTER, TRUE, oEnergon);  
    SetAssociateState(NW_ASC_DISTANCE_2_METERS); 

	SetName(oEnergon, "Xag-Ya Companion");
}  
  
void main()  
{  
    object oPC = OBJECT_SELF;  
    int nSolLevel = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT, oPC);  
  
    if (nSolLevel < 4)  
    {  
        SendMessageToPC(oPC, "You must be at least 4th level Soldier of Light to summon an Energon Companion.");  
        return;  
    }  
  
    location lTarget = GetLocation(oPC);  
    float fDuration = HoursToSeconds(24); // "companion" - long duration, not per-turn combat summon  
  
    //:: Despawn any existing energon companions belonging to this PC  
    object oArea = GetArea(oPC);  
    object oObj  = GetFirstObjectInArea(oArea);  
    while (GetIsObjectValid(oObj))  
    {  
        if (GetTag(oObj) == "PRC_XAGYA001")  
        {  
            if (GetLocalObject(oObj, "SUMMONER") == oPC)  
                DestroyObject(oObj);  
        }  
        oObj = GetNextObjectInArea(oArea);  
    }  
  
    //:: Load & optionally boost the template  
    json jXagYa = TemplateToJson("prc_xagya001", RESTYPE_UTC);  
    if (jXagYa == JSON_NULL)  
    {  
        SendMessageToPC(oPC, "sol_energon >> TemplateToJson failed - bad resref or resource missing.");  
        return;  
    }  
  
    if (nSolLevel >= 8)  
    {  
        //:: Improved Energon Companion - +2 HD  
        jXagYa = json_AddHitDice(jXagYa, 2);  
        if (jXagYa == JSON_NULL)  
        {  
            SendMessageToPC(oPC, "sol_energon >> json_AddHitDice failed - JSON became invalid.");  
            return;  
        }  
        jXagYa = json_RecalcMaxHP(jXagYa, 8);  
        if (jXagYa == JSON_NULL)  
        {  
            SendMessageToPC(oPC, "sol_energon >> json_RecalcMaxHP failed - JSON became invalid.");  
            return;  
        }  
    }  
  
    if (GetPRCSwitch(PRC_MULTISUMMON) || nSolLevel >= 8)  
    {  
        //:: 4th level: one companion. 8th level: a second  
        SpawnEnergon(oPC, jXagYa, lTarget, fDuration);  
        if (nSolLevel >= 8)  
            SpawnEnergon(oPC, jXagYa, lTarget, fDuration);  
    }  
    else  
    {  
        SpawnEnergon(oPC, jXagYa, lTarget, fDuration);  
    }  
}