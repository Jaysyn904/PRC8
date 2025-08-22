//::////////////////////////////////////////////////////////
//::
/* 
	Lion’s Swiftness (Ex)
	When he reaches 7th level, a lion of Talisid can act as if
	under the effects of a haste spell for a total of 1
	round per class level per day. These rounds need not be
	consecutive
*/
//::
//::////////////////////////////////////////////////////////
#include "prc_alterations"

const string VAR_LS_REMAINING = "LION_SWIFTNESS_ROUNDS_REMAINING";
const string VAR_LS_ACTIVE = "LION_SWIFTNESS_ACTIVE";
const float ROUND_LENGTH = 6.0;

void RemoveLionSwiftness(object oPC)
{
    // Remove haste effect tag if present (custom tag for safety)
    effect eEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectTag(eEffect) == "LIONS_SWIFTNESS")
        {
            RemoveEffect(oPC, eEffect);
        }
        eEffect = GetNextEffect(oPC);
    }

    DeleteLocalInt(oPC, VAR_LS_ACTIVE);
    SendMessageToPC(oPC, "Lion's Swiftness ends.");
	int nRemaining = GetLocalInt(oPC, VAR_LS_REMAINING);
	//SendMessageToPC(oPC, "You have "+IntToString(nRemaining)+" round(s) remaining of Lion’s Swiftness for today.");
	FloatingTextStringOnCreature("You have "+IntToString(nRemaining)+" round(s) of Lion’s Swiftness remaining for today.", oPC, FALSE);
	
}

void TickLionSwiftness(object oPC)
{
    if (!GetLocalInt(oPC, VAR_LS_ACTIVE)) return;

    int nRemaining = GetLocalInt(oPC, VAR_LS_REMAINING);
    if (nRemaining <= 1)
    {
        DeleteLocalInt(oPC, VAR_LS_REMAINING);
        RemoveLionSwiftness(oPC);
        return;
    }

	effect eVis 	= EffectVisualEffect(VFX_IMP_HASTE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

    SetLocalInt(oPC, VAR_LS_REMAINING, nRemaining - 1);
    DelayCommand(ROUND_LENGTH, TickLionSwiftness(oPC));
}

void main()
{
    object oPC = OBJECT_SELF;
    int nLevel = GetLevelByClass(CLASS_TYPE_LION_OF_TALISID, oPC);
    if (nLevel <= 0) return;

    int bActive = GetLocalInt(oPC, VAR_LS_ACTIVE);

    if (bActive)
    {
        RemoveLionSwiftness(oPC);
        return;
    }

    int nRemaining = GetLocalInt(oPC, VAR_LS_REMAINING);
    if (nRemaining <= 0)
    {
        SendMessageToPC(oPC, "You have no remaining rounds of Lion’s Swiftness today.");
        return;
    }

    // Apply Haste-like effect manually
    effect eHaste 	= EffectHaste();
    eHaste 			= EffectLinkEffects(eHaste, ExtraordinaryEffect(eHaste));
	
	effect eVis 	= EffectVisualEffect(VFX_IMP_HASTE);
    
	eHaste = TagEffect(eHaste, "LIONS_SWIFTNESS");

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHaste, oPC, 9999.0);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
	
    SetLocalInt(oPC, VAR_LS_ACTIVE, TRUE);
    SendMessageToPC(oPC, "Lion's Swiftness activated.");

    // Decrement round count and continue ticking
    TickLionSwiftness(oPC);
}


/* void main()
{
    object oPC = OBJECT_SELF;
    
    if (GetHasSpellEffect(PRCGetSpellId(), oPC))
        PRCRemoveSpellEffects(PRCGetSpellId(), oPC, oPC);
    else
    {
    	int nDuel = GetLevelByClass(CLASS_TYPE_LION_OF_TALISID, oPC);
        int nAC = 2;
        if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 5) nAC++;
        if (nDuel >= 7) nAC += nDuel;
        effect eLink = EffectLinkEffects(EffectACIncrease(nAC, AC_DODGE_BONUS), EffectAttackDecrease(4));
        eLink = ExtraordinaryEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
    }    
} */