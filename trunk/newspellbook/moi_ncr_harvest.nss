/*Harvest Soul

Unlike a traditional meldshaper who
relies entirely on his own pool of soul energy to power his
soulmelds, you tap the soul energy of others for your power.
Beginning at 1st level, you can perform a short ritual to
capture the soul energy of a newly dead corpse. This ritual
requires 1 minute of uninterrupted concentration plus the
corpse of a living creature that has been dead for no longer
than 1 hour per necrocarnate level you possess. At the end
of the ritual, you gain a number of essentia points equal to
one-half your necrocarnate level (rounded up). This benefit
lasts for 24 hours. No corpse can be used for this purpose
more than once.
 At 10th level, you can perform this ritual as a full-round
action that provokes attacks of opportunity.
*/

#include "moi_inc_moifunc"

void NecroHarvest(object oMeldshaper, int nEssentia)
{
	AddNecrocarnumEssentia(oMeldshaper, nEssentia);
	FloatingTextStringOnCreature("You have gained "+IntToString(nEssentia)+" necrocarnum essentia", oMeldshaper, FALSE);
}

// Counts down a minute, then grants the essentia
void Countdown(object oMeldshaper, int nTime, int nEssentia)
{
	if (0 >= nTime)
	{
		NecroHarvest(oMeldshaper, nEssentia);
		SetCutsceneMode(oMeldshaper, FALSE);
	}
	else if (!GetIsInCombat(oMeldshaper)) // Being in combat causes this to fail
	{
		FloatingTextStringOnCreature("You have " + IntToString(nTime) +" seconds until you gain necrocarnum essentia", oMeldshaper, FALSE);
		DelayCommand(6.0, Countdown(oMeldshaper, nTime - 6, nEssentia));
		SetCutsceneMode(oMeldshaper, TRUE);
		AssignCommand(oMeldshaper, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 6.0));
	}
	else
		SetCutsceneMode(oMeldshaper, FALSE);
}

void main()
{
    object oMeldshaper = OBJECT_SELF;
    int nClass = GetLevelByClass(CLASS_TYPE_NECROCARNATE, oMeldshaper);
    // Round up rather than down
    int nEssentia = (nClass+1)/2;

	if (GetLocalInt(oMeldshaper, "NecroHarvestSoul1"))
	{
		// Use up the corpse
		DeleteLocalInt(oMeldshaper, "NecroHarvestSoul1");
		if (10 > nClass) Countdown(oMeldshaper, 60, nEssentia);
		else NecroHarvest(oMeldshaper, nEssentia);
	}
	else if (GetLocalInt(oMeldshaper, "NecroHarvestSoul2"))
	{
		// Use up the corpse
		DeleteLocalInt(oMeldshaper, "NecroHarvestSoul2");
		if (10 > nClass) Countdown(oMeldshaper, 60, nEssentia);
		else NecroHarvest(oMeldshaper, nEssentia);
	}
	else if (GetLocalInt(oMeldshaper, "NecroHarvestSoul"))
	{
		// Use up the corpse
		DeleteLocalInt(oMeldshaper, "NecroHarvestSoul3");
		if (10 > nClass) Countdown(oMeldshaper, 60, nEssentia);
		else NecroHarvest(oMeldshaper, nEssentia);
	}
	else if (GetLocalInt(oMeldshaper, "NecroHarvestSoul4"))
	{
		// Use up the corpse
		DeleteLocalInt(oMeldshaper, "NecroHarvestSoul4");
		if (10 > nClass) Countdown(oMeldshaper, 60, nEssentia);
		else NecroHarvest(oMeldshaper, nEssentia);
	}	
	else if (GetLocalInt(oMeldshaper, "NecroHarvestSoul5"))
	{
		// Use up the corpse
		DeleteLocalInt(oMeldshaper, "NecroHarvestSoul5");
		if (10 > nClass) Countdown(oMeldshaper, 60, nEssentia);
		else NecroHarvest(oMeldshaper, nEssentia);
	}	
}
