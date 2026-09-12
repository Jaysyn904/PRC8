/*
    Swiftness of the Tigress (Ex): When she reaches 8th 
	level, a celebrant of Sharness can function as though 
	affected by a haste spell. This benefit lasts for a 
	number of rounds per day equal to her celebrant of 
	Sharess level. This duration need not to be consecutive 
	- the celebrant of Sharness may break it up into 
	increments as small as 1 round if she so desires. Ending
	the effect is a free action.
*/
#include "prc_alterations"

const string VAR_TS_REMAINING = "TIGRESS_SWIFTNESS_ROUNDS_REMAINING";
const string VAR_TS_ACTIVE = "TIGRESS_SWIFTNESS_ACTIVE";
const float ROUND_LENGTH = 6.0;

void RemoveSwiftnessOfTheTigress(object oPC)
{
    // Remove haste effect tag if present (custom tag for safety)
    effect eEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectTag(eEffect) == "TIGRESS_SWIFTNESS")
        {
            RemoveEffect(oPC, eEffect);
        }
        eEffect = GetNextEffect(oPC);
    }

    DeleteLocalInt(oPC, VAR_TS_ACTIVE);
    SendMessageToPC(oPC, "Swiftness of the Tigress ends.");
	int nRemaining = GetLocalInt(oPC, VAR_TS_REMAINING);
	FloatingTextStringOnCreature("You have "+IntToString(nRemaining)+" round(s) of Swiftness of the Tigress remaining for today.", oPC, FALSE);
	
}

void TickTigressSwiftness(object oPC)
{
    if (!GetLocalInt(oPC, VAR_TS_ACTIVE)) return;

    int nRemaining = GetLocalInt(oPC, VAR_TS_REMAINING);
    if (nRemaining <= 1)
    {
        DeleteLocalInt(oPC, VAR_TS_REMAINING);
        RemoveSwiftnessOfTheTigress(oPC);
        return;
    }

	effect eVis 	= EffectVisualEffect(VFX_IMP_HASTE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

    SetLocalInt(oPC, VAR_TS_REMAINING, nRemaining - 1);
    DelayCommand(ROUND_LENGTH, TickTigressSwiftness(oPC));
}

void main()
{
    object oPC = OBJECT_SELF;
    int nLevel = GetLevelByClass(CLASS_TYPE_CELEBRANT_SHARESS, oPC);
    if (nLevel <= 0) return;

    int bActive = GetLocalInt(oPC, VAR_TS_ACTIVE);

    if (bActive)
    {
        RemoveSwiftnessOfTheTigress(oPC);
        return;
    }

    int nRemaining = GetLocalInt(oPC, VAR_TS_REMAINING);
    if (nRemaining <= 0)
    {
        SendMessageToPC(oPC, "You have no remaining rounds of Swiftness of the Tigress for today.");
        return;
    }

    // Apply Haste-like effect
    effect eHaste 	= EffectHaste();
    eHaste 			= EffectLinkEffects(eHaste, ExtraordinaryEffect(eHaste));
	
	effect eVis 	= EffectVisualEffect(VFX_IMP_HASTE);
    
	eHaste = TagEffect(eHaste, "TIGRESS_SWIFTNESS");

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHaste, oPC, 9999.0);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
	
    SetLocalInt(oPC, VAR_TS_ACTIVE, TRUE);
    SendMessageToPC(oPC, "Swiftness of the Tigress activated.");

    // Decrement round count and continue ticking
    TickTigressSwiftness(oPC);
}




/* #include "prc_class_const"  

void main()
{
	object oPC = OBJECT_SELF;
	int nClass = GetLevelByClass(CLASS_TYPE_CELEBRANT_SHARESS, oPC);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectHaste(), oPC, RoundsToSeconds(nClass));
} */
