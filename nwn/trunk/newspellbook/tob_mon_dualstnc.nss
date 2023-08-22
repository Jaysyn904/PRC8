// Written by Stratovarius
// Turns Dual Stance on

void main()
{
     object oInitiator = OBJECT_SELF;
     SetLocalInt(oInitiator, "MoNDualStance", TRUE);
     FloatingTextStringOnCreature("Master of Nine Dual Stance Activated", oInitiator, FALSE);
}