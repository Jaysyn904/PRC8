/*
Dread Carapace Feet Bind

While the appearance of your dread carapace is unchanged, your legs become increasingly muscular, and their shape alters slightly so that you more naturally move on just your toes and the balls of your feet.

Once per minute, you can add an enhancement bonus of +60 feet to your speed for 1 round.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    if (!GetLocalInt(oMeldshaper, "DreadCarapaceTimer"))
    {
    	SetLocalInt(oMeldshaper, "DreadCarapaceTimer", TRUE);
   		ExecuteScript("prc_speed", oMeldshaper);
   		DelayCommand(5.9, DeleteLocalInt(oMeldshaper, "DreadCarapaceTimer"));
   		DelayCommand(6.0, ExecuteScript("prc_speed", oMeldshaper));
   		SetLocalInt(oMeldshaper, "DreadCarapaceTimer", TRUE);
   		DelayCommand(60.0, DeleteLocalInt(oMeldshaper, "DreadCarapaceTimer"));
   		DelayCommand(60.0, FloatingTextStringOnCreature("You may use your Dread Carapace Feet Bind again", oMeldshaper, FALSE));
   	}	
}

