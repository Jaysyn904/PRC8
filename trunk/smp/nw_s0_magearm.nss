/*:://////////////////////////////////////////////

    Test for:

    Wish, Timestop, and stuff like that...
    1. Can you have a timestop conversation
    2. Can you use stun with timestop.
    etc.


    If linked damage, in a tempoary effect, will actually apply the linked effects
    if the damage is made out to be 0 somehow. (most likely yes)
    (it will apply the effects, tested with stoneskin)

    Old ones:

    If invisibility + Link effects will remove all linked efffects when invis goes
    (it does)
//::////////////////////////////////////////////*/

void main()
{
    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = oCaster;

    // Create the genie
    object oGenie = CreateObject(OBJECT_TYPE_CREATURE, "wish_test", GetLocation(oCaster));

    //AssignCommand(oGenie, ActionStartConversation(oCaster, "", TRUE));
    //ActionStartConversation(oCaster, "test_wish", TRUE);

    // Apply timestop
    //effect eTime = EffectTimeStop();

    //SpeakString("Appling Time Stop and creating creature (1.5 delay), to " + GetName(oTarget));

    // Apply cutscene stuff to the PC
    //AssignCommand(oTarget, ClearAllActions());
    //SetCutsceneMode(oTarget, TRUE);
}
