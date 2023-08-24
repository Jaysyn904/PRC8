//:://////////////////////////////////////////////
//:: FileName: "at_contingentreu"
/*   Purpose: This calls the "contingent_reun" script, which is the true script
        for the Contingent Reunion spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
void main()
{
    ExecuteScript("contingent_reun", GetPCSpeaker());
}
