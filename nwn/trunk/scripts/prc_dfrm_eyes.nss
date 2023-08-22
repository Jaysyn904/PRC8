//////////////////////////////////////////////////////////////
/*
Deformity (Eyes) [Vile, Deformity]
You have either drilled a hole in your forehead trying to add
a third eye, or you have supernaturally scarred one of your
regular eyes.
Prerequisite: Willing Deformity.
Benefit: As a supernatural ability, you can use see invisibility
for 1 minute per day.
Special: You take a -2 penalty on Spot and Search checks.
*/
///////////////////////////////////////////////////////////////

void main()
{
        object oPC = OBJECT_SELF;
        effect eSee = SupernaturalEffect(EffectUltravision());
        
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSee, oPC, TurnsToSeconds(1));
}