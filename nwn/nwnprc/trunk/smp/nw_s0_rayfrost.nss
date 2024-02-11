// Empty, used for testing

// Test repel on things.
#include "PHS_INC_SPELLS"

void Test(float fDistance, object oSource);

void main()
{

    object oSource = OBJECT_SELF;

    float fDistance = 10.0;

    object oTarget = GetSpellTargetObject();

    //SpeakString("Doing Move Back: Cutscene only test: " + GetName(oTarget));
    //AssignCommand(oTarget, Test(fDistance, oSource));



    SpeakString("Setting the target via. assign command to destroyable TRUE");

    AssignCommand(oTarget, SetIsDestroyable(TRUE));



    // Move them
//    SpeakString("DOING MOVE BACK/ REPEL SPECAIL: " + GetName(oTarget));
//    AssignCommand(oTarget, PHS_ActionRepel(fDistance, oSource));

}
void Test(float fDistance, object oSource)
{
    location lSource = GetLocation(oSource);

    // Commandable?
    SpeakString("Test (CUTSCENE, 10 seconds till out): Commandable: " + IntToString(GetCommandable(OBJECT_SELF)));

    // Cutscene mdoe
    SetCutsceneMode(OBJECT_SELF, TRUE);

    if(GetCommandable() == FALSE)
    {
        SetCommandable(TRUE);
        AssignCommand(OBJECT_SELF, ActionMoveAwayFromLocation(lSource, TRUE, fDistance));
        SetCommandable(FALSE);
    }
    else
    {
        AssignCommand(OBJECT_SELF, ActionMoveAwayFromLocation(lSource, TRUE, fDistance));
    }

    DelayCommand(10.0, SetCutsceneMode(OBJECT_SELF, FALSE));
}

