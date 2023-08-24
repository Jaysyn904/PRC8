/*
   ----------------
   Divine Surge, Greater, Increment

   tob_dvsp_dvnsrgg
   ----------------

   05/06/07 by Stratovarius
*/ /** @file

    Divine Surge, Greater

    Devoted Spirit (Strike)
    Level: Crusader 8
    Prerequisite: Two Devoted Spirit Maneuvers
    Initiation Action: 1 Full-Round Action
    Range: Melee Attack
    Target: One Creature

    A torrent of divine energy courses through you. With supreme force of will, you channel the energy into
    a devastating attack even as it saps your mortal form.
    
    You make a single attack against an enemy. If this attack his, you deal 6d8 extra damage.
    For every point of constitution damage voluntarily taken, you gain a +1 bonus to attack and +2d8 damage.
    You can sacrifice a number of con points equal to your initiator level.
    This makes you flat-footed for the rest of the round.
*/

void main()
{

	object oPC = OBJECT_SELF;
	string nMes = "";

	int nCount = GetLocalInt(oPC, "DVGreaterSurge");
	nCount += 1;
	if (nCount > 20) nCount = 20;
	SetLocalInt(oPC, "DVGreaterSurge", nCount);	
	nMes = "Divine Surge, Greater: Constitution damage set to " + IntToString(nCount);
	FloatingTextStringOnCreature(nMes, oPC, FALSE);
}