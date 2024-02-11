/*Essentia Trap cleanup

Called from prc_npc_death to get around delay commands not working there
*/

#include "moi_inc_moifunc"

void main()
{
    object oNecro = OBJECT_SELF;
    int nEssentia = GetLocalInt(oNecro, "EssentiaTrapClean");
    //SendMessageToPC(GetFirstPC(),"NecroClean is "+GetName(oNecro));

    DelayCommand(6.0, SetTemporaryEssentia(oNecro, nEssentia * -1));
    DelayCommand(6.0, DeleteLocalInt(oNecro, "EssentiaTrapClean"));	
}
