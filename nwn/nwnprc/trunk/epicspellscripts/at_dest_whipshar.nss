//:://////////////////////////////////////////////
//:: FileName: "at_dest_whipshar"
/*   Purpose: This destroys the Whip of Shar item, enabling the player to be
        rid of the No-Drop item.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank, with credit to Nron Ksr for the spell itself
//:: Last Updated On: March 17, 2004
//:://////////////////////////////////////////////
void main()
{
    object oWhip = GetLocalObject(GetPCSpeaker(), "oWhip");
    DestroyObject(oWhip);
    DeleteLocalObject(GetPCSpeaker(), "oWhip");
}
