//::////////////////////////////////////////////////////////
//:: tmp_m_halfvamp.nss
//::
//::////////////////////////////////////////////////////////
/*
	"Half-vampire" is an inherited template that can be added to
	 any humanoid or monstrous humanoid (referred to hereafter 
	 as the base creature). The creature's size and type do not 
	 change.

	A half-vampire uses all the base creature's statistics and 
	special abilities except as noted here.

	Armor Class: A half-vampire's natural armor bonus improves 
	by 2.

	Attack: A half-vampire retains all the attacks of the base 
	creature and also gains a slam attack if it didn't already 
	have one. 

	Special Attacks: A half-vampire retains all the special 
	attacks of the base creature and gains one of those 
	described below. Saves have a DC of to + 1/2 half-vampire's 
	HD + half-vampire's Cha modifier unless otherwise noted.

	Blood Drain (Ex): Some half-vampires can suck blood from a 
	living victim with their fangs by making a successful 
	grapple check. If the half-vampire pins the foe, it drains 
	blood, dealing 1d4 points of Constitution drain each round 
	the pin is maintained. A half-vampire can't drain more 
	points of Constitution in a single hour than its 
	Constitution score. When a half-vampire drains a victim's 
	Constitution, it gains 5 temporary hit points, no matter 
	how many points it drains. Temporary hit points gained in 
	this way last for up to 1 hour. If a half-vampire has this 
	ability, it also gains the blood dependency special quality 
	described below.

	Charm Gaze (Su): Some half-vampires can charm humanoid or 
	monstrous humanoid opponents just by looking into their eyes. 
	This is similar to a gaze attack, except that the 
	half-vampire must use a standard action, and those merely 
	looking at the half-vampire are not affected. Anyone the 
	half-vampire targets must make a successful Will save or 
	fall under the half-vampire's influence as though affected 
	by a charm monster spell (caster level equal to HD). Any 
	creature that successfully saves against a half-vampire's 
	charm gaze cannot be affected by that half-vampire's charm 
	gaze for 24 hours. The ability has a range of 30 feet.

	Children of the Night (Su): Some half-vampires can command 
	the lesser creatures of the world. Once per day, a 
	half-vampire that has this special attack can call forth 1d4
	rat swarms, 1d3 bat swarms, or a pack of 1d6 wolves as a 
	standard action. These creatures arrive in 2d6 rounds and 
	serve the half-vampire for up to 1 hour.

	Special Qualities: A half-vampire retains all the special 
	qualities of the base creature and also gains those 
	described below.

	Blood Dependency (Ex): If a half-vampire does not use its 
	blood drain special attack against at least one living 
	creature each day, it must make a DC 15 Fortitude save or 
	become fatigued. Each day after the first that the 
	half-vampire does not drink blood directly from a living 
	creature, the DC increases by 1 until it fails the save and 
	becomes fatigued. After that, it must make a DC 20 Fortitude 
	save each week (with the DC increasing by 1 each week 
	thereafter) that it does not use its blood drain or become 
	exhausted.

	The fatigue or exhaustion caused by blood dependency cannot 
	be eliminated by rest (though magic can offset the condition
	until the vampire fails another save). Using its blood drain 
	ability eliminates a half-vampire's fatigue immediately, or 
	reduces exhaustion to fatigue.

	Only half-vampires with the blood drain special attack 
	(see above) gain this special quality.

	Damage Reduction (Su): A half-vampire has damage reduction 
	5/silver or magic.

	Fast Healing (Ex): A half-vampire heals 1 point of damage 
	each round so long as it has at least 1 hit point but less 
	than half its full normal hit points. As long as the vampire 
	has more than half its full normal hit points, its fast 
	healing does not function (but other forms of healing still 
	function normally).

	Resistances (Ex): A half-vampire has resistance to cold 5 and 
	electricity 5.

	Abilities: Increase from the base creature as follows: 
	Str +2, Dex +2, Cha +2.

	Skills: Half-vampires have a +2 racial bonus on Bluff, Hide, 
	Listen, Move Silently, and Spot checks. Otherwise, same as 
	the base creature.

	Feats: A half-vampire gains Improved Initiative, if the 
	base creature doesn't already have that feat.

	Environment: Any, usually same as base creature.

	Organization: Solitary.

	Challenge Rating: Same as the base creature +1

	Level Adjustment: Same as the base creature +2
*/
//::////////////////////////////////////////////////////////
#include "prc_inc_template"
#include "prc_inc_spells"
#include "prc_inc_natweap"
#include "inc_dynconv"

void ReapplyHalfVampireAbilityFeat(object oPC, object oSkin)  
{  
	int nAbility = GetPersistantLocalInt(oPC, "HVamp_AbilityChoice");  
  
    if (nAbility == 1) // Blood Drain  
	{
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_VAMPIRE_BLOOD_DRAIN), 0.0f,  
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_VAMPIRE_BLOOD_DEPENDENCY), 0.0f,  
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);			
			
	}			
    else if (nAbility == 2) // Charm Gaze  
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_VAMPIRE_CHARM_GAZE), 0.0f,  
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
    else if (nAbility == 3) // Children of the Night  
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_VAMPIRE_CHILDREN_NIGHT), 0.0f,  
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
}

void HandleHalfVampireFastHealing(object oPC)  
{  
    if (!GetHasTemplate(TEMPLATE_HALF_VAMPIRE, oPC)) 
	{
		SendMessageToPC(oPC, "Half-vampire template not found.");
		return;  
	}
  
    int nCurHP = GetCurrentHitPoints(oPC);  
    int nMaxHP = GetMaxHitPoints(oPC);  
  
    // Dead or unconscious - no fast healing  
    if (nCurHP < 1) return;  
  
    // Only functions below half normal hit points  
    if (nCurHP < (nMaxHP / 2))  
    {  
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1), oPC);  
    }  
}
 
void ApplyHalfVampireBonuses(object oPC)  
{  
    int nNWNxEE = GetPRCSwitch(PRC_NWNXEE_ENABLED);  
    int nPRCx   = GetPRCSwitch(PRC_PRCX_ENABLED);  
    int bFuncs  = (nNWNxEE && nPRCx);  
  
    int nSize = PRCGetCreatureSize(oPC);  
    string sResRef = "prc_cent_hoof_";  
    sResRef += GetAffixForSize(nSize+1);  
    AddNaturalPrimaryWeapon(oPC, sResRef, 2);  
  
    object oSkin = GetPCSkin(oPC);  
  
    if (bFuncs)  
    {  
        // Guard permanent NWNX writes only - these truly must not repeat  
        if (!GetPersistantLocalInt(oPC, "HVamp_BonusesApplied"))  
        {  
            SetPersistantLocalInt(oPC, "HVamp_BonusesApplied", TRUE);  
  
            PRC_Funcs_ModAbilityScore(oPC, ABILITY_STRENGTH, 2);  
            PRC_Funcs_ModAbilityScore(oPC, ABILITY_DEXTERITY, 2);  
            PRC_Funcs_ModAbilityScore(oPC, ABILITY_CHARISMA, 2);  
  
            PRC_Funcs_ModSkill(oPC, SKILL_BLUFF, 2);  
            PRC_Funcs_ModSkill(oPC, SKILL_LISTEN, 2);  
            PRC_Funcs_ModSkill(oPC, SKILL_MOVE_SILENTLY, 2);  
            PRC_Funcs_ModSkill(oPC, SKILL_HIDE, 2);  
            PRC_Funcs_ModSkill(oPC, SKILL_SPOT, 2);  
  
            PRC_Funcs_AddFeat(oPC, FEAT_IMPROVED_INITIATIVE);  
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_HALF_VAMPIRE_MARKER);  
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_HALF_VAMPIRE_FAST_HEALING);  
  
            PRC_Funcs_SetBaseNaturalAC(oPC, PRC_Funcs_GetBaseNaturalAC(oPC) + 2);  
  
            SetPersistantLocalInt(oPC, "NWNX_Template_hvamp", TRUE);  
        }  
  
        // Resistances/DR still need to survive rest, so still re-apply every tick  
        effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, 5);  
        effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 5);  
        effect eDR   = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);  
  
        effect eLink = EffectLinkEffects(eCold, eElec);  
        eLink = EffectLinkEffects(eLink, eDR);  
  
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, UnyieldingEffect(eLink), oPC);  
    }  
    else  
    {  
        // Runs every call - rebuilds skin bonuses wiped by ScrubPCSkin on rest  
        SetCompositeBonus(oSkin, "HVamp_STR",    2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);  
        SetCompositeBonus(oSkin, "HVamp_DEX",    2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_DEX);  
        SetCompositeBonus(oSkin, "HVamp_CHA",    2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);  
        SetCompositeBonus(oSkin, "HVamp_Bluff",  2, ITEM_PROPERTY_SKILL_BONUS,   SKILL_BLUFF);  
        SetCompositeBonus(oSkin, "HVamp_Listen", 2, ITEM_PROPERTY_SKILL_BONUS,   SKILL_LISTEN);  
        SetCompositeBonus(oSkin, "HVamp_MS",     2, ITEM_PROPERTY_SKILL_BONUS,   SKILL_MOVE_SILENTLY);  
        SetCompositeBonus(oSkin, "HVamp_Hide",   2, ITEM_PROPERTY_SKILL_BONUS,   SKILL_HIDE);  
        SetCompositeBonus(oSkin, "HVamp_Spot",   2, ITEM_PROPERTY_SKILL_BONUS,   SKILL_SPOT);  
        SetCompositeBonus(oSkin, "HVamp_AC",     2, ITEM_PROPERTY_AC_BONUS);  
  
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5), 0.0f,  
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_5), 0.0f,  
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP), 0.0f,  
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_INIT), 0.0f,  
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_VAMPIRE_MARKER), 0.0f,  
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_VAMPIRE_FAST_HEALING), 0.0f,  
            X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 

		ReapplyHalfVampireAbilityFeat(oPC, oSkin);			
    }  
  
    // Only fire the ability-selection convo once, regardless of branch  
    if (!GetPersistantLocalInt(oPC, "HVamp_AbilityConvoStarted"))  
    {  
        SetPersistantLocalInt(oPC, "HVamp_AbilityConvoStarted", TRUE);  
        DelayCommand(3.0f, StartDynamicConversation("tmp_c_halfvamp", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE));  
    }  
}

void HandleBloodDependency(object oPC)  
{  
    if (!GetHasTemplate(TEMPLATE_HALF_VAMPIRE, oPC)) return;  
    if (!GetHasFeat(FEAT_TEMPLATE_HALF_VAMPIRE_BLOOD_DRAIN, oPC)) return;  
  
    int nCurrentDay = GetCalendarDay() + GetCalendarMonth() * 28 + GetCalendarYear() * 336;  
    int nLastCheckDay = GetPersistantLocalInt(oPC, "HVamp_BloodDepLastDay");  
    if (nCurrentDay == nLastCheckDay) return;  
  
    if (GetPersistantLocalInt(oPC, "HVamp_DrankBloodToday"))  
    {  
        // Remove fatigue/exhaustion effects by tag  
        effect eCheck = GetFirstEffect(oPC);  
        while (GetIsEffectValid(eCheck))  
        {  
            string sTag = GetEffectTag(eCheck);  
            if (sTag == "PRCFatigue" || sTag == "PRCExhausted")  
                RemoveEffect(oPC, eCheck);  
            eCheck = GetNextEffect(oPC);  
        }  
  
        SetPersistantLocalInt(oPC, "HVamp_BloodDepDays", 0);  
        SetPersistantLocalInt(oPC, "HVamp_BloodDepWeeks", 0);  
        DeletePersistantLocalInt(oPC, "HVamp_BloodDepFatigued");  
        DeletePersistantLocalInt(oPC, "HVamp_BloodDepExhausted");  
        DeletePersistantLocalInt(oPC, "HVamp_DrankBloodToday");  
    }  
    else  
    {  
        int nDays = GetPersistantLocalInt(oPC, "HVamp_BloodDepDays") + 1;  
        SetPersistantLocalInt(oPC, "HVamp_BloodDepDays", nDays);  
  
        if (!GetPersistantLocalInt(oPC, "HVamp_BloodDepFatigued"))  
        {  
            int nDC = 15 + (nDays - 1);  
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC))  
            {  
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,  
                    UnyieldingEffect(EffectFatigue()), oPC);  
                SetPersistantLocalInt(oPC, "HVamp_BloodDepFatigued", TRUE);  
                SetPersistantLocalInt(oPC, "HVamp_BloodDepDays", 0);  
            }  
        }  
        else  
        {  
            int nWeeks = GetPersistantLocalInt(oPC, "HVamp_BloodDepWeeks");  
            int nDC = 20 + nWeeks;  
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC))  
            {  
                // Remove fatigue effect first  
                effect eCheck = GetFirstEffect(oPC);  
                while (GetIsEffectValid(eCheck))  
                {  
                    if (GetEffectTag(eCheck) == "PRCFatigue")  
                        RemoveEffect(oPC, eCheck);  
                    eCheck = GetNextEffect(oPC);  
                }  
  
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,  
                    UnyieldingEffect(EffectExhausted()), oPC);  
                SetPersistantLocalInt(oPC, "HVamp_BloodDepExhausted", TRUE);  
            }  
        }  
    }  
  
    SetPersistantLocalInt(oPC, "HVamp_BloodDepLastDay", nCurrentDay);  
}


void main()  
{  
    int nEvent = GetRunningEvent();  
    object oPC = OBJECT_SELF;  
  
    ApplyHalfVampireBonuses(oPC);   // runs once (guarded) + rebuilds skin each call  
    HandleBloodDependency(oPC);  
  
    // Hook onto EVENT_ONHEARTBEAT the first time this runs (nEvent == FALSE)  
    if (nEvent == FALSE && !GetPersistantLocalInt(oPC, "HVamp_HBHooked"))  
    {  
        SetPersistantLocalInt(oPC, "HVamp_HBHooked", TRUE);  
        AddEventScript(oPC, EVENT_ONHEARTBEAT, "tmp_m_halfvamp", TRUE, FALSE);  
    }  
  
    // Only run Fast Healing on the actual per-round heartbeat tick  
    if (nEvent == EVENT_ONHEARTBEAT)  
        HandleHalfVampireFastHealing(oPC);  
}
