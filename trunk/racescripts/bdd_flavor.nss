// Says the lines necessary for a given part of the area

#include "inc_vfx_const"
#include "prc_misc_const"

void SchoonerAttack(object oPC, object oSpawn);
void ForgeSpawn(object oPC, object oTrigger);
void XenoSpawn(object oPC);
void TaintSpawn(object oPC);

void ETReturnHome(object oPC)
{
	CreateObject(OBJECT_TYPE_PLACEABLE, "prc_ea_return", GetLocation(oPC));
}

void SchoonerAttack(object oPC, object oSpawn)
{
    if (!GetIsDead(oPC))
    {
        AssignCommand(oSpawn, ActionAttack(oPC));
        
        DelayCommand(3.0, SchoonerAttack(oPC, oSpawn));
    }
}

void Schooner(object oPC)
{
    if (!GetLocalInt(GetModule(), "SchoonerSpawn"))
    {
        AssignCommand(oPC, SpeakString("Three desiccated, misshapen, humanoid forms crawl from beneath the battered vessel."));
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_ashen_husk", GetLocation(GetWaypointByTag("bdd_schooner_ash")));
        object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_ashen_husk", GetLocation(GetWaypointByTag("bdd_schooner_ash")));
        object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_ashen_husk", GetLocation(GetWaypointByTag("bdd_schooner_ash")));
        if (GetIsSkillSuccessful(oPC, SKILL_LORE, 12) && !GetLocalInt(GetModule(), "AshenHusk"))
        {
        	DelayCommand(3.0, AssignCommand(oPC, SpeakString("Ashen husks lost their lives to unquenchable thirst. The evidence of their dry death is obvious as a supernatural deliquescent aura that harms those who cannot resist heatstoke.")));
        	SetLocalInt(GetModule(), "AshenHusk", TRUE);
        }
        else if (!GetLocalInt(GetModule(), "AshenHusk"))
        {
        	DelayCommand(0.60, SetName(oSpawn1, " "));
        	DelayCommand(0.60, SetName(oSpawn2, " "));
        	DelayCommand(0.60, SetName(oSpawn3, " "));
        } 	
        SetLocalInt(GetModule(), "SchoonerSpawn", TRUE);
        SchoonerAttack(oPC, oSpawn1);
        SchoonerAttack(oPC, oSpawn2);
        SchoonerAttack(oPC, oSpawn3);
    }    
}

void FoyerSpawn(object oPC)
{
    if (!GetLocalInt(GetModule(), "FoyerSpawn"))
    {
        AssignCommand(oPC, SpeakString("Below the sand that buried the foyer are the remains of shattered desks, broken shelves, chairs, and disintegrated paperwork — and three desiccated, misshapen, humanoid husks."));
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_ashen_husk", GetLocation(GetWaypointByTag("bdd_foyer_ash")));
        object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_ashen_husk", GetLocation(GetWaypointByTag("bdd_foyer_ash")));
        object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_ashen_husk", GetLocation(GetWaypointByTag("bdd_foyer_ash")));
        if (GetIsSkillSuccessful(oPC, SKILL_LORE, 12) && !GetLocalInt(GetModule(), "AshenHusk"))
        {
        	DelayCommand(3.0, AssignCommand(oPC, SpeakString("Ashen husks lost their lives to unquenchable thirst. The evidence of their dry death is obvious as a supernatural deliquescent aura that harms those who cannot resist heatstoke.")));
        	SetLocalInt(GetModule(), "AshenHusk", TRUE);
        }
        else if (!GetLocalInt(GetModule(), "AshenHusk"))
        {
        	DelayCommand(0.60, SetName(oSpawn1, " "));
        	DelayCommand(0.60, SetName(oSpawn2, " "));
        	DelayCommand(0.60, SetName(oSpawn3, " "));
        }        
        SetLocalInt(GetModule(), "FoyerSpawn", TRUE);
        SchoonerAttack(oPC, oSpawn1);
        SchoonerAttack(oPC, oSpawn2);
        SchoonerAttack(oPC, oSpawn3);
    }    
}

void OfficeSpawn(object oPC)
{
    if (!GetLocalInt(GetModule(), "OfficeSpawn"))
    {
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "nw_shadow", GetLocation(GetWaypointByTag("bdd_office_shd")));
        object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "nw_shadow", GetLocation(GetWaypointByTag("bdd_office_shd")));
        if (GetIsSkillSuccessful(oPC, SKILL_LORE, 13))
        {
        	DelayCommand(3.0, AssignCommand(oPC, SpeakString("Shadows lurk in dark places, waiting for living prey to happen by. Unfortunately, today that's you.")));
        }
        else
        {
        	DelayCommand(0.60, SetName(oSpawn1, " "));
        	DelayCommand(0.60, SetName(oSpawn2, " "));
        }         
        SchoonerAttack(oPC, oSpawn1);
        SchoonerAttack(oPC, oSpawn2);        
        SetLocalInt(GetModule(), "OfficeSpawn", TRUE);
    }    
}

void VaultSpawn(object oPC)
{
    if (!GetLocalInt(GetModule(), "VaultSpawn"))
    {
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "nw_shfiend", GetLocation(GetWaypointByTag("bdd_vault_shd")));
        if (GetIsSkillSuccessful(oPC, SKILL_LORE, 19))
        {
        	DelayCommand(3.0, AssignCommand(oPC, SpeakString("Shadows fiends are the strongest of shadows, and their touch is deadly.")));
        }
        else
        {
        	DelayCommand(0.60, SetName(oSpawn1, " "));
        }          
        SchoonerAttack(oPC, oSpawn1);        
        SetLocalInt(GetModule(), "VaultSpawn", TRUE);
    }    
}

void ForgeSpawn(object oPC, object oTrigger)
{
    object oTarget = GetFirstInPersistentObject(oTrigger, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) && !GetLocalInt(GetModule(), "ForgeSpawn"))
    {    
        if (GetIsPC(oTarget))
        {
            object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
            object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
            object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
            object oSpawn4 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
            object oSpawn5 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
            object oSpawn6 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
            object oSpawn7 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
            object oSpawn8 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
            object oSpawn9 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
            object oSpawn10 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
            object oSpawn11 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
        	if (GetIsSkillSuccessful(oPC, SKILL_LORE, 11) && !GetLocalInt(GetModule(), "BDDAsherati"))
        	{
        		DelayCommand(3.0, AssignCommand(oPC, SpeakString("Asheratis are a people who live below the silky sands and dusts of suitable wastelands, rising to the surface to hunt for food, socialize and trade with other races, and make war upon their enemies. The skin of these asheratis appears blackened and rough.")));
        		SetLocalInt(GetModule(), "BDDAsherati", TRUE);
        		DelayCommand(0.60, SetName(oSpawn1, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn2, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn3, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn4, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn5, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn6, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn7, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn8, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn9, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn10, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn11, "Tainted Asherati"));        		
        	}
        	else if (GetLocalInt(GetModule(), "BDDAsherati"))
        	{
        		DelayCommand(0.60, SetName(oSpawn1, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn2, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn3, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn4, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn5, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn6, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn7, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn8, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn9, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn10, "Tainted Asherati"));
        		DelayCommand(0.60, SetName(oSpawn11, "Tainted Asherati"));
        	}             
            CreateObject(OBJECT_TYPE_PLACEABLE, "bdd_tunnel", GetLocation(GetWaypointByTag("bdd_forge_tnt")));
            SetLocalInt(GetModule(), "ForgeSpawn", TRUE);
            SchoonerAttack(oPC, oSpawn1);
            SchoonerAttack(oPC, oSpawn2);
            SchoonerAttack(oPC, oSpawn3);            
            SchoonerAttack(oPC, oSpawn4);
            SchoonerAttack(oPC, oSpawn5);
            SchoonerAttack(oPC, oSpawn6);            
            SchoonerAttack(oPC, oSpawn7);
            SchoonerAttack(oPC, oSpawn8);
            SchoonerAttack(oPC, oSpawn9);            
            SchoonerAttack(oPC, oSpawn10);
            SchoonerAttack(oPC, oSpawn11);
            break;
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(oTrigger, OBJECT_TYPE_CREATURE);
    }
}

void XenoSpawn(object oPC)
{
    if (!GetLocalInt(GetModule(), "XenoSpawn"))
    {
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_xeno_tnt")));
        object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_xeno_tnt")));
        object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_xeno_tnt")));
        object oSpawn4 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_xeno_tnt")));
        object oSpawn5 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_xeno_tnt")));
        SchoonerAttack(oPC, oSpawn1);
        SchoonerAttack(oPC, oSpawn2);
        SchoonerAttack(oPC, oSpawn3);            
        SchoonerAttack(oPC, oSpawn4);
        SchoonerAttack(oPC, oSpawn5);
       	if (GetIsSkillSuccessful(oPC, SKILL_LORE, 11) && !GetLocalInt(GetModule(), "BDDAsherati"))
       	{
       		DelayCommand(3.0, AssignCommand(oPC, SpeakString("Asheratis are a people who live below the silky sands and dusts of suitable wastelands, rising to the surface to hunt for food, socialize and trade with other races, and make war upon their enemies. The skin of these asheratis appears blackened and rough.")));
       		SetLocalInt(GetModule(), "BDDAsherati", TRUE);
       		DelayCommand(0.60, SetName(oSpawn1, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn2, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn3, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn4, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn5, "Tainted Asherati"));       		
       	}
       	else if (GetLocalInt(GetModule(), "BDDAsherati"))
       	{
       		DelayCommand(0.60, SetName(oSpawn1, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn2, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn3, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn4, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn5, "Tainted Asherati"));
       	}        
        SetLocalInt(GetModule(), "XenoSpawn", TRUE);
        
        DelayCommand(12.0, TaintSpawn(oPC));
    }
}

void TaintSpawn(object oPC)
{
    if (!GetLocalInt(GetModule(), "TaintSpawn"))
    {
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_taint_tnt")));
        object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_taint_tnt")));
        object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_taint_tnt")));
        object oSpawn4 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_taint_tnt")));
        object oSpawn5 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_taint_tnt")));
        object oSpawn6 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_taint_tnt")));
        object oSpawn7 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(GetWaypointByTag("bdd_taint_tnt")));
        SchoonerAttack(oPC, oSpawn1);
        SchoonerAttack(oPC, oSpawn2);
        SchoonerAttack(oPC, oSpawn3);            
        SchoonerAttack(oPC, oSpawn4);
        SchoonerAttack(oPC, oSpawn5);
        SchoonerAttack(oPC, oSpawn6);            
        SchoonerAttack(oPC, oSpawn7); 
       	if (GetIsSkillSuccessful(oPC, SKILL_LORE, 11) && !GetLocalInt(GetModule(), "BDDAsherati"))
       	{
       		DelayCommand(3.0, AssignCommand(oPC, SpeakString("Asheratis are a people who live below the silky sands and dusts of suitable wastelands, rising to the surface to hunt for food, socialize and trade with other races, and make war upon their enemies. The skin of these asheratis appears blackened and rough.")));
       		SetLocalInt(GetModule(), "BDDAsherati", TRUE);
       		DelayCommand(0.60, SetName(oSpawn1, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn2, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn3, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn4, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn5, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn6, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn7, "Tainted Asherati"));       		
       	}
       	else if (GetLocalInt(GetModule(), "BDDAsherati"))
       	{
       		DelayCommand(0.60, SetName(oSpawn1, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn2, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn3, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn4, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn5, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn6, "Tainted Asherati"));
       		DelayCommand(0.60, SetName(oSpawn7, "Tainted Asherati"));
       	}        
        SetLocalInt(GetModule(), "TaintSpawn", TRUE);
        
        DelayCommand(12.0, XenoSpawn(oPC));
    }
}

void ChangedSpawn(object oPC)
{
    if (!GetLocalInt(GetModule(), "ChangedSpawn"))
    {
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_chn", GetLocation(GetWaypointByTag("bdd_change_chn")));
        object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_chn", GetLocation(GetWaypointByTag("bdd_change_chn")));
        object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_chn", GetLocation(GetWaypointByTag("bdd_change_chn")));
        object oSpawn4 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_chn", GetLocation(GetWaypointByTag("bdd_change_chn")));
        object oSpawn5 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_chn", GetLocation(GetWaypointByTag("bdd_change_chn")));
        SchoonerAttack(oPC, oSpawn1);
        SchoonerAttack(oPC, oSpawn2);
        SchoonerAttack(oPC, oSpawn3);            
        SchoonerAttack(oPC, oSpawn4);
        SchoonerAttack(oPC, oSpawn5);
       	if (GetIsSkillSuccessful(oPC, SKILL_LORE, 11) && !GetLocalInt(GetModule(), "BDDAsherati"))
       	{
       		DelayCommand(3.0, AssignCommand(oPC, SpeakString("Asheratis are a people who live below the silky sands and dusts of suitable wastelands, rising to the surface to hunt for food, socialize and trade with other races, and make war upon their enemies. The skin of these asheratis appears blackened and rough.")));
       		SetLocalInt(GetModule(), "BDDAsherati", TRUE);
       		DelayCommand(0.60, SetName(oSpawn1, "Changed Asherati"));
       		DelayCommand(0.60, SetName(oSpawn2, "Changed Asherati"));
       		DelayCommand(0.60, SetName(oSpawn3, "Changed Asherati"));
       		DelayCommand(0.60, SetName(oSpawn4, "Changed Asherati"));
       		DelayCommand(0.60, SetName(oSpawn5, "Changed Asherati"));       		
       	}
       	else if (GetLocalInt(GetModule(), "BDDAsherati"))
       	{
       		DelayCommand(0.60, SetName(oSpawn1, "Changed Asherati"));
       		DelayCommand(0.60, SetName(oSpawn2, "Changed Asherati"));
       		DelayCommand(0.60, SetName(oSpawn3, "Changed Asherati"));
       		DelayCommand(0.60, SetName(oSpawn4, "Changed Asherati"));
       		DelayCommand(0.60, SetName(oSpawn5, "Changed Asherati"));
       	}        
        SetLocalInt(GetModule(), "ChangedSpawn", TRUE);
    }
}

void BlightSpawn(object oPC)
{
    if (!GetLocalInt(GetModule(), "BlightSpawn"))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BLOOD_FOUNTAIN), GetNearestObjectByTag("bdd_polyp", oPC), 6.0);
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_dustblight", GetLocation(GetNearestObjectByTag("bdd_polyp", oPC)));
        DestroyObject(GetNearestObjectByTag("bdd_polyp", oPC));
        DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BLOOD_FOUNTAIN), GetNearestObjectByTag("bdd_polyp", oPC), 6.0));
        object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_dustblight", GetLocation(GetNearestObjectByTag("bdd_polyp", oPC)));
        DelayCommand(0.25, DestroyObject(GetNearestObjectByTag("bdd_polyp", oPC)));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BLOOD_FOUNTAIN), GetNearestObjectByTag("bdd_polyp", oPC), 6.0));
        object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_dustblight", GetLocation(GetNearestObjectByTag("bdd_polyp", oPC)));
        DelayCommand(0.5, DestroyObject(GetNearestObjectByTag("bdd_polyp", oPC)));    
       	if (GetIsSkillSuccessful(oPC, SKILL_LORE, 15) && !GetLocalInt(GetModule(), "DustBlight"))
       	{
       		DelayCommand(3.0, AssignCommand(oPC, SpeakString("Although not especially intelligent, dustblights are wily wasteland hunters. They can move equally well through sand and above it, and they often lie in wait beneath a thin coating of sand for those unlucky enough to be deemed prey. These ones appear to be birthed from strange cocoons of tained coloration.")));
       		SetLocalInt(GetModule(), "DustBlight", TRUE);
       	}
       	else if (!GetLocalInt(GetModule(), "DustBlight"))
       	{
       		DelayCommand(0.60, SetName(oSpawn1, " "));
       		DelayCommand(0.60, SetName(oSpawn2, " "));
       		DelayCommand(0.60, SetName(oSpawn3, " "));
       	}        
        SchoonerAttack(oPC, oSpawn1);
        SchoonerAttack(oPC, oSpawn2);
        SchoonerAttack(oPC, oSpawn3);            
        SetLocalInt(GetModule(), "BlightSpawn", TRUE);
    }
}

void BlightSpawn2(object oPC)
{
    if (!GetLocalInt(GetModule(), "BlightSpawn2"))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BLOOD_FOUNTAIN), GetNearestObjectByTag("bdd_polyp", oPC), 6.0);
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_dustblight", GetLocation(GetNearestObjectByTag("bdd_polyp", oPC)));
        DestroyObject(GetNearestObjectByTag("bdd_polyp", oPC));
        DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BLOOD_FOUNTAIN), GetNearestObjectByTag("bdd_polyp", oPC), 6.0));
        object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_dustblight", GetLocation(GetNearestObjectByTag("bdd_polyp", oPC)));
        DelayCommand(0.25, DestroyObject(GetNearestObjectByTag("bdd_polyp", oPC)));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BLOOD_FOUNTAIN), GetNearestObjectByTag("bdd_polyp", oPC), 6.0));
        object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_dustblight", GetLocation(GetNearestObjectByTag("bdd_polyp", oPC)));
        DelayCommand(0.5, DestroyObject(GetNearestObjectByTag("bdd_polyp", oPC)));        
       	if (GetIsSkillSuccessful(oPC, SKILL_LORE, 15) && !GetLocalInt(GetModule(), "DustBlight"))
       	{
       		DelayCommand(3.0, AssignCommand(oPC, SpeakString("Although not especially intelligent, dustblights are wily wasteland hunters. They can move equally well through sand and above it, and they often lie in wait beneath a thin coating of sand for those unlucky enough to be deemed prey. These ones appear to be birthed from strange cocoons of tained coloration.")));
       		SetLocalInt(GetModule(), "DustBlight", TRUE);
       	}
       	else if (!GetLocalInt(GetModule(), "DustBlight"))
       	{
       		DelayCommand(0.60, SetName(oSpawn1, " "));
       		DelayCommand(0.60, SetName(oSpawn2, " "));
       		DelayCommand(0.60, SetName(oSpawn3, " "));
       	}        
        SchoonerAttack(oPC, oSpawn1);
        SchoonerAttack(oPC, oSpawn2);
        SchoonerAttack(oPC, oSpawn3);            
        SetLocalInt(GetModule(), "BlightSpawn2", TRUE);
    }
}

void BDDGrantXP(object oPC)
{
    object oTarget = GetFirstFactionMember(oPC);
    while(GetIsObjectValid(oTarget))
    {  	
    	GiveXPToCreature(oTarget, 4000);
    	oTarget = GetNextFactionMember(oPC);
    }
}    

void main()
{
    object oPC = GetEnteringObject();
    if (!GetIsObjectValid(oPC)) oPC = GetLastUsedBy();
    object oTrigger = OBJECT_SELF;
    string sTag = GetTag(oTrigger);

    if (GetIsPC(oPC))
    {
        if (sTag == "bdd_schooner" && !GetLocalInt(GetModule(), "bdd_schooner"))
        {
            AssignCommand(oPC, SpeakString("What appears to be a schooner lies half buried in sand that has blown in through the wide-open end of this building."));
            DelayCommand(4.0, Schooner(oPC));
            SetLocalInt(GetModule(), "bdd_schooner", TRUE);
        }    
        if (sTag == "bdd_well" && !GetLocalInt(GetModule(), "bdd_well"))
        {
            AssignCommand(oPC, SpeakString("The sound of trickling water echoes up from the bowels of this abandoned, chipped, and sandblasted stone well."));  
            SetLocalInt(GetModule(), "bdd_well", TRUE);
        }    
        if (sTag == "bdd_shell")
            AssignCommand(oPC, SpeakString("This adobe building is empty and doorless, its interior filled with drifting sand."));          
        if (sTag == "bdd_courtyard" && !GetLocalInt(GetModule(), "bdd_courtyard"))
        {
            AssignCommand(oPC, SpeakString("Adobe buildings squat around a sand-covered courtyard of adobe bricks. A stained and eroded well sits at the center of the courtyard. The buildings are in disrepair, many of them missing sections of roofing, others without doors, some tumbled down entirely. The entire complex is situated at the edge of a half-mile-wide crater with plunging stone walls that cradle a wide basin of gray-blue dust."));
            SetLocalInt(GetModule(), "bdd_courtyard", TRUE);
        }    
        if (sTag == "bdd_foyer" && !GetLocalInt(GetModule(), "bdd_foyer"))
        {
            AssignCommand(oPC, SpeakString("The missing door to this long foyer has allowed in the desert, which covers the floor in drifts and shallows, and piles up against three doors in this chamber. Bulges and drifts of sand reveal that many items lie below this blanket of dust."));
            DelayCommand(4.0, FoyerSpawn(oPC));
            SetLocalInt(GetModule(), "bdd_foyer", TRUE);
        } 
        if (sTag == "bdd_ruins" && !GetLocalInt(GetModule(), "bdd_ruins"))
        {
            AssignCommand(oPC, SpeakString("The warehouse that once stood here is broken and empty, anything of value long since picked over or buried beneath the desert."));
            SetLocalInt(GetModule(), "bdd_ruins", TRUE);
        }    
        if (sTag == "bdd_enter" && !GetLocalInt(GetModule(), "bdd_enter"))
        {
            AssignCommand(oPC, SpeakString("The strange happenings and tales of the crater have piqued your interest, and here you find yourself, finally arriving at the outpost of the ill-fated wizard Ammavaru. May you have better luck than she."));          
            AddJournalQuestEntry("bdd_wastes", 1, oPC);
            AddJournalQuestEntry("bdd_intro", 1, oPC);
            SetLocalInt(GetModule(), "bdd_enter", TRUE);
        }    
        if (sTag == "bdd_oil" && !GetLocalInt(GetModule(), "bdd_oil"))
        {
            AssignCommand(oPC, SpeakString("This chamber is stacked with rusting iron kegs under a thick layer of dust. By the strong odor of naphtha in the air and the oily slicks that saturate the floor, this chamber apparently holds lamp oil in great quantities."));
            SetLocalInt(GetModule(), "bdd_oil", TRUE);
        }    
        if (sTag == "bdd_filtrator" && !GetLocalInt(GetModule(), "bdd_filtrator"))
        {
            AssignCommand(oPC, SpeakString("A strange apparatus consisting of a netlike mesh of very fine lines stretches across a 5-foot-square metallic frame between two tall, wide wooden wheels. The device has a yoke, as if it might be possible to attach it behind a beast of burden. Hoppers, empty but for a residue of desert dust, are attached to each side of the frame. Various tools lie scattered on a nearby workbench."));            
            SetLocalInt(GetModule(), "bdd_filtrator", TRUE);
        }    
        if (sTag == "bdd_office" && !GetLocalInt(GetModule(), "bdd_office"))
        {
            AssignCommand(oPC, SpeakString("The doors to this chamber are slightly ajar, and drifts of sand have layered the floor. The elements, even with their limited access, have not been kind to what might have once been an office. An overturned, rotting desk, a shattered cabinet, splintered chairs, and shredded wall hangings decorate this room. The debris gives rise to disquieting shadows that flit about the chamber."));
            OfficeSpawn(oPC);
            SetLocalInt(GetModule(), "bdd_office", TRUE);
        } 
        if (sTag == "bdd_records")
            AssignCommand(oPC, SpeakString("This is a series of entries in the record books of Ammavaru's mining expedition. It reads as follows:" + "\n\n" + "So far, the operation has been a great success. The basin did truly contain valuable metals, most prominently a scarlet metal that pierces the stony hides and rocky flanks of earth-aligned creatures." + "\n\n" + "50 pounds! 50! It's amazing how much of value came out of the sky. Most of it is in the vault now."));                  
        if (sTag == "bdd_journal")
            AssignCommand(oPC, SpeakString("A ripped and sand-scoured journal. It's fragmentary, but reads as follows:" + "\n\n" + "...three more disappeared yesterday. Went missing from their..." + "\n\n" + "...the barracks! Gone, in one night. We can't..." + "\n\n" + "...the sand. Look to the..." + "\n\n" + "The journal ends on that last, worrying, note."));
        if (sTag == "bdd_forge")
        {
            if (!GetLocalInt(GetModule(), "ForgeSpawn")) AssignCommand(oPC, SpeakString("Machinery sprawls about this chamber, iron-sided and rust red. A layer of soft sand covers the floor, apparently drifting in from the smashed entrance. One piece of equipment, a large smelting furnace by the look of it, is topped and partially buried in the sand. A single other exit in the chamber remains sealed by a black iron door."));            
            DelayCommand(18.0, ForgeSpawn(oPC, oTrigger));
        }    
        if (sTag == "bdd_forge_tun")
            AssignCommand(oPC, JumpToLocation(GetLocation(GetWaypointByTag("bdd_cave_ent2"))));  
        if (sTag == "bdd_torn_page")
            AssignCommand(oPC, SpeakString("A few pages torn from the ledger record and dropped from the corpse’s hand. On those pages is written the following record:" + "\n\n" + "“The creatures in the earth are asheratis—but they are changed! Some contamination in the stardust is toxic to them, driving them insane, and changing their flesh to abomination. I gave them the remaining kheferu ingots, then even my blade, Rive, hoping that would be barter enough for my life. But here I remain until death takes me. Curse this basin!”"));                  
        if (sTag == "bdd_vault" && !GetLocalInt(GetModule(), "bdd_vault"))
        {
            AssignCommand(oPC, SpeakString("This small chamber contains a few pieces of refuse, as well as a makeshift bed, on which is huddled the brittle corpse of a human figure wearing heavy wraps. And the haunted spirit of what she once was."));
            VaultSpawn(oPC);
            SetLocalInt(GetModule(), "bdd_vault", TRUE);
        } 
        if (sTag == "bdd_barracks" && !GetLocalInt(GetModule(), "bdd_barracks"))
        {
            AssignCommand(oPC, SpeakString("The broken shells of what were once barracks are now empty of all but drifting sand. Even a cursory glance shows them to be nothing more than ruined emptiness."));                          
            SetLocalInt(GetModule(), "bdd_barracks", TRUE);
        }    
        if (sTag == "bdd_xeno" && !GetLocalInt(GetModule(), "bdd_xeno"))
        {
            AssignCommand(oPC, SpeakString("This chamber, while covered in sand like the ruins above, has a more homely aspect, in large part due to piles of food being scattered about. It is also the home to several creatures, lounging in the sands."));
            XenoSpawn(oPC);
            SetLocalInt(GetModule(), "bdd_xeno", TRUE);
        }  
        if (sTag == "bdd_taint" && !GetLocalInt(GetModule(), "bdd_taint"))
        {
            AssignCommand(oPC, SpeakString("By the look of the scattered tables, chests, cups, and other bits of domestic furniture, this chamber houses several humanoids. The refuse and garbage is striking in its quantity. As is the foulness emanating from the humanoids who swarm out of the sands."));
            TaintSpawn(oPC);
            SetLocalInt(GetModule(), "bdd_taint", TRUE);
        }  
        if (sTag == "bdd_change" && !GetLocalInt(GetModule(), "bdd_change"))
        {
            AssignCommand(oPC, SpeakString("A faint, sickly sweet stench lingers in this chamber, which is bare of the sand prevalent in earlier chambers. Several humanoids are clustered in this chamber, huddled close together in a ring in the center of the area. A scabrous black layer covers their entire bodies, though it is cracked here and there, allowing a yellowish fluid to ooze and drip, spattering into vile pools on the rocky floor."));
            ChangedSpawn(oPC);
            SetLocalInt(GetModule(), "bdd_change", TRUE);
        } 
        if (sTag == "bdd_blight" && !GetLocalInt(GetModule(), "bdd_blight"))
        {
            AssignCommand(oPC, SpeakString("A horribly cloying stench rolls away from the center of this chamber where a cluster of black, egglike polyps shudder and writhe. Some leak a yellowish fluid, while others leak blood. In the center of the chamber, roughly surrounded by the writhing, oozing polyps, is a scarlet-hued sword, rammed point-first into the stone floor. A few wooden crates are scattered near the quivering blade."));
            DelayCommand(6.0, BlightSpawn(oPC));
            DelayCommand(12.0, BlightSpawn2(oPC));
            SetLocalInt(GetModule(), "bdd_blight", TRUE);
        } 
        if (sTag == "bdd_cave_exp" && !GetLocalInt(GetModule(), "bdd_cave_exp"))
        {
            AssignCommand(oPC, SpeakString("The sand here is disturbed by the passage of many feet, and tracks lead both out into the basin, and further into the tunnel."));
            SetLocalInt(GetModule(), "bdd_cave_exp", TRUE);
        }    
        if (sTag == "bdd_books" && !GetLocalInt(GetModule(), "bdd_books"))
        {
            AssignCommand(oPC, SpeakString("A pile of books, magical apparatus, and other detritus, clearly gathered from Ammavaru's expedition up above. Despite being carried down into these caves, the thick layer of dust shows that they have not been used since they were brought beneath."));         
            SetLocalInt(GetModule(), "bdd_books", TRUE);
        }    
        if (sTag == "bdd_climb")
        {
            if (GetIsSkillSuccessful(oPC, SKILL_CLIMB, 10))
            {
                JumpToLocation(GetLocation(GetWaypointByTag("bdd_climb_up")));
            }       
            else
            {
                AssignCommand(oPC, SpeakString("Your attempt to clamber up from the cave has gone poorly. Sliding, losing traction, and eventually tumbling, you splash into the thick dust of basin. Moments later, hands drag you deep into the dust."));
                DelayCommand(6.0, PopUpDeathGUIPanel(oPC, TRUE, FALSE, 0, "Your attempt to clamber up from the cave has gone poorly. Sliding, losing traction, and eventually tumbling, you splash into the thick dust of basin. Moments later, hands drag you deep into the dust."));
            }
        }         
        if (sTag == "bdd_sword" && !GetLocalInt(GetModule(), "bdd_sword") && !GetIsInCombat(oPC))
        {
            // Strength check
            if ( (GetAbilityModifier(ABILITY_STRENGTH, oPC) + d20()) >= 15)
            {
                CreateItemOnObject("bdd_sword", oPC);
                AssignCommand(oPC, SpeakString("A heave has ripped the sword free of the earth that trapped it. A cursory examination reveals that the sword is magical, and called 'Rive'. A deeper examination of the sword and the surroundings brings further knowledge.")); 
                AddJournalQuestEntry("bdd_finish", 1, oPC);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCINTILLATING_PATTERN), oPC);
                SetLocalInt(GetModule(), "bdd_sword", TRUE);
                SetCutsceneMode(oPC, TRUE);
                
				DelayCommand(8.0, AssignCommand(oPC, SpeakString("While it is true that various starmetals were seeded when the falling star struck the surface, it was not true that Ammavaru was the only one who sent an expedition to attempt to profit thereby. In fact, a nearby community of asheratis was also drawn to the event. Being suited to life below the sand, they were able to begin filtering particles of strange starmetals from the earth as soon as conditions in the crater settled down. They found some of the particles very interesting indeed. Unfortunately, the particles were also strangely toxic (and eventually mind- and body-altering) to the asherati community, though these particular effects were not immediately evident.")));
				DelayCommand(20.0, AssignCommand(oPC, SpeakString("When Ammavaru turned up, she interrupted the effort of the asheratis to gather all the residual starmetal. However, Ammavaru and her team didn't immediately realize that they weren't alone (since asheratis operate mostly below the surface). Oblivious, Ammavaru constructed her base at the edge of the crater. The asheratis who still remained at the site were by now seriously infected by the toxic variety of starmetal dust they had foundered into and had become murderously deranged.")));
				DelayCommand(30.0, AssignCommand(oPC, SpeakString("In the end, the asheratis rose one midnight from the surrounding dust, and then silently and efficiently murdered the miners in their sleep. The tainted asheratis (or their descendants) remain to this day, living around and under the Basin of Deadly Dust, killing any creature that seeks to explore or claim any portion of starmetal found at the location, and it was they who you fought through in order to get to this point.")));
				DelayCommand(40.0, AssignCommand(oPC, SpeakString("From here on out, there is nothing more to do but leave this sad venture behind, and find a new challenge out there in the wastes.")));
                DelayCommand(45.0, SetCutsceneMode(oPC, FALSE));
                DelayCommand(45.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCINTILLATING_PATTERN), oPC));
                DelayCommand(48.0, BDDGrantXP(oPC));
                
                if (GetLocalInt(oPC, "BDD_Enter")) DelayCommand(48.0, ETReturnHome(oPC));
            }
            else
                AssignCommand(oPC, SpeakString("You struggle, but the sword is in too firmly. Perhaps another go...")); 
        }         
    }        
}