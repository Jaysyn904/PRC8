//::///////////////////////////////////////////////  
//:: Name           Effigy template npc script  
//:: FileName       make_effigy.nss  
//:://////////////////////////////////////////////  
/*  
	"Effigy" is an acquired template that can be added to any corporeal  
	aberration, animal, dragon, giant, humanoid, magical beast, monstrous  
	humanoid, or vermin (referred to hereafter as the base creature).  
	  
	Size and Type: Type changes to construct. Loses all subtypes, no augmented subtype.  
	Hit Dice: Non-class HD become d10; class HD dropped (min 1 HD). Bonus HP by size.  
	Armor Class: Natural armor +2.  
	Base Attack Bonus: 3/4 HD (as cleric).  
	Saving Throws: Fort/Ref/Will all +1 per 3 HD.  
	Abilities: Str +4, Dex -2, no Con, no Int, Wis 11, Cha 1.  
	Special Qualities: DR/adamantine scaling with HD; loses other SQs.  
	Skills/Feats: Loses all skill points and feats except attack-enhancing feats.  
	Challenge Rating: base creature + 1.  
	Alignment: Always neutral.  
*/  
//:://////////////////////////////////////////////  
#include "nw_inc_gff"  
#include "inc_debug"  
#include "prc_inc_json" 
  
//:: Helper: removes ITEM_PROPERTY_POISON from a single weapon, if valid.  
void StripPoisonFromWeapon(object oWeapon)  
{  
    if (!GetIsObjectValid(oWeapon)) return;  
  
    itemproperty ip = GetFirstItemProperty(oWeapon);  
    while (GetIsItemPropertyValid(ip))  
    {  
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_POISON)  
        {  
            RemoveItemProperty(oWeapon, ip);  
        }  
        ip = GetNextItemProperty(oWeapon);  
    }  
}

//:: Removes ITEM_PROPERTY_POISON from a creature's natural/creature weapons  
//:: (Effigy loses poison special attacks since it has no Con score).  
void StripEffigyPoisonFromCreatureWeapons(object oCreature)  
{  
    StripPoisonFromWeapon(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature));  
    StripPoisonFromWeapon(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature));  
    StripPoisonFromWeapon(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCreature));  
}  

json json_StripEffigySpecialAttacks(json jCreature)  
{  
    json jSpecAbilityList = GffGetList(jCreature, "SpecAbilityList");  
    if (jSpecAbilityList == JsonNull())  
        return jCreature;  
  
    json jFilteredList = JsonArray();  
    int nCount = JsonGetLength(jSpecAbilityList);  
    int i;  
  
    for (i = 0; i < nCount; i++)  
    {  
        json jSpecAbility = JsonArrayGet(jSpecAbilityList, i);  
        int nSpellID = JsonGetInt(GffGetWord(jSpecAbility, "Spell"));  
  
        // Petrification breath / touch  
        if (nSpellID == 495 /* Breath, Petrify */ ||  
            nSpellID == 496 /* Touch, Petrify  */)  
        {  
            continue;  
        }  
  
        // Generic elemental breath weapons (dragon-type breaths, etc.)  
        if (nSpellID == BREATH_FIRE_CONE   || nSpellID == BREATH_FIRE_LINE  ||  
            nSpellID == BREATH_FROST_CONE  || nSpellID == BREATH_ACID_CONE  ||  
            nSpellID == BREATH_SICKENING_CONE || nSpellID == BREATH_SLOW_CONE ||  
            nSpellID == BREATH_WEAKENING_CONE || nSpellID == BREATH_SLEEP_CONE ||  
            nSpellID == BREATH_THUNDER_CONE   || nSpellID == BREATH_PARALYZE_CONE ||  
            nSpellID == BREATH_BAHAMUT_LINE)  
        {  
            continue;  
        } 

		if (nSpellID == 236 /* Dragon_Breath_Acid */  ||  
			nSpellID == 237 /* Dragon_Breath_Cold  */  ||  
			nSpellID == 238 /* Dragon_Breath_Fear  */  ||  
			nSpellID == 239 /* Dragon_Breath_Fire  */  ||  
			nSpellID == 240 /* Dragon_Breath_Gas   */  ||  
			nSpellID == 241 /* Dragon_Breath_Lightning */ ||  
			nSpellID == 242 /* Dragon_Breath_Paralyze */  ||  
			nSpellID == 243 /* Dragon_Breath_Sleep */     ||  
			nSpellID == 244 /* Dragon_Breath_Slow */      ||  
			nSpellID == 771 /* Dragon_Breath_Prismatic */	|| 
			nSpellID == 698 /* Dragon_Breath_Negative */	|| 
			nSpellID == 245 /* Dragon_Breath_Weaken */)  
		{  
			continue;  
		}

		
  
        jFilteredList = JsonArrayInsert(jFilteredList, jSpecAbility);  
    }  
  
    jCreature = GffAddList(jCreature, "SpecAbilityList", jFilteredList);  
    return jCreature;  
}
  
//:: Update Challenge Rating 
json json_UpdateEffigyCR(json jCreature, int nBaseCR)  
{  
    int nNewCR = nBaseCR + 1;  
    jCreature = GffReplaceFloat(jCreature, "ChallengeRating", IntToFloat(nNewCR));  
    return jCreature;  
}  
  
//:: Returns bonus HP for a given construct size  
int GetEffigyBonusHP(int nSize)  
{  
    if (nSize == CREATURE_SIZE_SMALL)      return 10;  
    if (nSize == CREATURE_SIZE_MEDIUM)     return 20;  
    if (nSize == CREATURE_SIZE_LARGE)      return 30;  
    if (nSize == CREATURE_SIZE_HUGE)       return 40;  
    if (nSize == CREATURE_SIZE_GARGANTUAN) return 60;  
    if (nSize == CREATURE_SIZE_COLOSSAL)   return 80;  
    return 0; // Fine to Tiny  
}  
  
//:: Returns DR amount based on HD (DR is always /adamantine)  
int GetEffigyDRAmount(int nHD)  
{  
    if (nHD >= 21) return 15;  
    if (nHD >= 16) return 10;  
    if (nHD >= 11) return 7;  
    if (nHD >= 7)  return 5;  
    if (nHD >= 4)  return 3;  
    return 1;  
}  

  
//:: Apply Effigy template to a creature JSON template  
json json_MakeEffigy(json jCreature, int nBaseCR)  
{  
    if (jCreature == JsonNull())  
        return JsonNull();  
  
    int nHD = json_GetCreatureHD(jCreature);  
    if (nHD <= 0)  
    {  
        DoDebug("make_effigy >> json_MakeEffigy: Invalid HD");  
        return JsonNull();  
    }  
    //:: Size and Type: change to construct, drop subtypes  
    jCreature = json_ModifyRacialType(jCreature, RACIAL_TYPE_CONSTRUCT);
    if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> json_MakeEffigy: json_ModifyRacialType failed");  
        return JsonNull();  
    }  

	//:: Special Attacks/Qualities: Effigy loses all supernatural/spell-like abilities  
	//:: tied to a Constitution-based save   
	//jCreature = GffAddList(jCreature, "SpecAbilityList", JsonArray());
	jCreature = json_StripEffigySpecialAttacks(jCreature);
    if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> json_StripEffigySpecialAttacks: failed");  
        return JsonNull();  
    }
	//:: Abilities: Str +8, Dex +4, Wis -> 11, Cha -> 1, Con/Int none  
	jCreature = json_UpdateTemplateStats(jCreature, 4, -2, 0, 0, 0, 0);
	if (jCreature == JsonNull())
    {  
        DoDebug("make_effigy >> json_UpdateTemplateStats: STR & DEX update failed");  
        return JsonNull();  
    } 	
	jCreature = GffReplaceByte(jCreature, "Wis", 11);
	if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> GffReplaceByte: WIS update failed");  
        return JsonNull();  
    } 			
	jCreature = GffReplaceByte(jCreature, "Cha", 3);
	if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> GffReplaceByte: CHA update failed");  
        return JsonNull();  
    } 	
	jCreature = GffReplaceByte(jCreature, "Con", 10);
		if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> GffReplaceByte: CON update failed");  
        return JsonNull();  
    } 
	jCreature = GffReplaceByte(jCreature, "Int", 10);
	if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> GffReplaceByte: INT update failed");  
        return JsonNull();  
    } 	
	
//;: Remove all non-racial hit dice.
	jCreature = json_TrimAllClassHD(jCreature);
	if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> json_TrimAllClassHD: removing all PC classes failed");  
        return JsonNull();  
    }  		

//:: Change remaining class to construct
	jCreature = json_SetClassType(jCreature, CLASS_TYPE_CONSTRUCT, 1);
	if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> json_SetClassType: class update failed");  
        return JsonNull();  
    }  		
	
//:: Construct base creature uses d10 Hit Dice  
	jCreature = json_RecalcMaxHP(jCreature, 10);
	if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> json_RecalcMaxHP: failed");  
        return JsonNull();  
    }  		

//:: Remove all skill ranks	
	jCreature =  json_ZeroAllSkillRanks(jCreature);
	if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> json_ZeroAllSkillRanks: Skill removal failed");  
        return JsonNull();  
    }  	
	
//:: Remove all magical feats
	jCreature =  json_RemoveFeatsByToolsCategory(jCreature);
	if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> json_RemoveFeatsByToolsCategory: Feat removal failed");  
        return JsonNull();  
    }  	
	
    //:: Armor Class: Natural AC +2  
    json jNaturalAC = GffGetByte(jCreature, "NaturalAC");  
    if (jNaturalAC != JsonNull())  
        jCreature = GffReplaceByte(jCreature, "NaturalAC", JsonGetInt(jNaturalAC) + 2);
    if (jCreature == JsonNull())  
    {  
        DoDebug("make_effigy >> json_MakeEffigy: Natural AC update failed");  
        return JsonNull();  
    }  	
  
    //:: Challenge Rating: base creature + 1  
    jCreature = json_UpdateEffigyCR(jCreature, nBaseCR);  
    if (jCreature == JsonNull())  
    {  
        DoDebug("prc_inc_json >> json_MakeEffigy: json_UpdateEffigyCR failed");  
        return JsonNull();  
    }  
  
    return jCreature;  
}  
 
 
//:: Apply Effigy non-json effects  
void ApplyEffigyEffects(object oCreature, int nBaseHD, int nMaxHP)
{
    effect eEffigy;
 
    SetCurrentHitPoints(oCreature, nMaxHP);
 
    if(DEBUG) DoDebug("Effigy nMaxHP is: " + IntToString(nMaxHP) + ",");
 
    int nDRAmount = GetEffigyDRAmount(nBaseHD);
    eEffigy = EffectLinkEffects(eEffigy, EffectDamageReduction(nDRAmount, DAMAGE_POWER_PLUS_THREE, 0));
 
    eEffigy = EffectLinkEffects(eEffigy, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
    eEffigy = EffectLinkEffects(eEffigy, EffectImmunity(IMMUNITY_TYPE_POISON));
    eEffigy = EffectLinkEffects(eEffigy, EffectImmunity(IMMUNITY_TYPE_DISEASE));
    eEffigy = EffectLinkEffects(eEffigy, EffectImmunity(IMMUNITY_TYPE_SLEEP));
    eEffigy = EffectLinkEffects(eEffigy, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
    eEffigy = EffectLinkEffects(eEffigy, EffectImmunity(IMMUNITY_TYPE_STUN));
 
    eEffigy = UnyieldingEffect(eEffigy);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffigy, oCreature);
}


void main()  
{  
//:: Declare major variables  
    object oBaseCreature = OBJECT_SELF;  
    object oNewCreature;  
  
    string sBaseName = GetName(oBaseCreature);  
  
    int nRacial = MyPRCGetRacialType(oBaseCreature);  
  
    //:: No Template Stacking  
    if(GetLocalInt(oBaseCreature, "TEMPLATE_EFFIGY") > 0)  
    {  
        DoDebug("No Template Stacking");  
        return;  
    }  
  
    //:: Creatures & NPCs only  
    if ((GetObjectType(oBaseCreature) != OBJECT_TYPE_CREATURE) || (GetIsPC(oBaseCreature) == TRUE))  
    {  
        DoDebug("Not a creature");  
        return;  
    }  
  
/*  
    "Effigy" is an acquired template that can be added to any corporeal  
    aberration, animal, dragon, giant, humanoid, magical beast, monstrous  
    humanoid, or vermin.  
*/  
    //:: Corporeal creatures only  
    if(GetIsIncorporeal(oBaseCreature))  
    {  
        DoDebug("make_effigy: Incorporeal creatures cannot receive the Effigy template.");  
        return;  
    }  
  
    if(nRacial != RACIAL_TYPE_ABERRATION && nRacial != RACIAL_TYPE_ANIMAL &&  
       nRacial != RACIAL_TYPE_DRAGON     && nRacial != RACIAL_TYPE_GIANT &&  
       nRacial != RACIAL_TYPE_HUMAN      && nRacial != RACIAL_TYPE_MAGICAL_BEAST &&  
       nRacial != RACIAL_TYPE_HUMANOID_MONSTROUS && nRacial != RACIAL_TYPE_VERMIN &&  
       nRacial != RACIAL_TYPE_DWARF      && nRacial != RACIAL_TYPE_ELF &&  
       nRacial != RACIAL_TYPE_GNOME      && nRacial != RACIAL_TYPE_HALFLING &&  
       nRacial != RACIAL_TYPE_HALFELF    && nRacial != RACIAL_TYPE_HALFORC &&  
       nRacial != RACIAL_TYPE_HUMANOID_GOBLINOID && nRacial != RACIAL_TYPE_HUMANOID_ORC &&  
       nRacial != RACIAL_TYPE_BEAST && nRacial != RACIAL_TYPE_HUMANOID_REPTILIAN)  
    {  
        DoDebug("make_effigy: Invalid racial type for template.");  
        return;  
    }  
  
    int nBaseHD = GetHitDice(oBaseCreature);  
    int nBaseCR = FloatToInt(GetChallengeRating(oBaseCreature));  
  
    location lSpawnLoc = GetLocation(oBaseCreature);  
  
    json jBaseCreature = ObjectToJson(oBaseCreature, TRUE);  
    json jFinalCreature;  
  
//:: Apply Effigy JSON modifications (racial type -> construct, abilities, AC, CR)  
    jFinalCreature = json_MakeEffigy(jBaseCreature, nBaseCR);  
    if (jFinalCreature == JsonNull())  
    {  
        DoDebug("make_effigy: json_MakeEffigy failed.");  
        return;  
    }

	//:: Calculate HP from JSON BEFORE spawning, while HD is still trustworthy
	int nEffigyHD    = json_GetCreatureHD(jFinalCreature);   
	int nSize        = PRCGetCreatureSize(oBaseCreature);     
	int nBonusHP     = GetEffigyBonusHP(nSize);
	int nFinalHP     = (nEffigyHD * 10) + nBonusHP;          
  
    if (GetIsObjectValid(oBaseCreature))  
    {  
        AssignCommand(oBaseCreature, ClearAllActions(TRUE));  
  
        // optional fade / vanish visuals  
        effect eBlank = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);  
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlank, oBaseCreature, 6.0f);  
  
        DestroyObject(oBaseCreature, 0.1f);  
    }  
  
//:: Spawn the new Effigy creature  
    oNewCreature = JsonToObject(jFinalCreature, lSpawnLoc);  
  
//:: Apply the non-json effects (HP, DR, saves, construct immunities)  
    ApplyEffigyEffects(oNewCreature, nBaseHD, nFinalHP);  
  
//:: Update creature's name  
    SetName(oNewCreature, sBaseName + " Effigy");  
  
//:: Alignment: Always neutral — force if not already.  
    int nAlignGE = GetAlignmentGoodEvil(oNewCreature);  
    int nAlignLC = GetAlignmentLawChaos(oNewCreature);  
    if(nAlignGE != ALIGNMENT_NEUTRAL || nAlignLC != ALIGNMENT_NEUTRAL)  
    {  
        AdjustAlignment(oNewCreature, ALIGNMENT_NEUTRAL, 100, FALSE);  
    }  
  
//:: Set variables  
    SetLocalInt(oNewCreature, "TEMPLATE_EFFIGY", 1);  
}


