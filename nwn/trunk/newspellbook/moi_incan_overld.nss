/*
3/1/21 by Stratovarius

Incarnum Overload (Ex): At 4th level, you can temporarily boost the maximum essentia capacity of any soulmeld, incarnum feat, or special ability that allows
essentia investment. This effect lasts for 1 round, during which the essentia capacity of the chosen soulmeld, feat, or ability increases by an amount equal to your Charisma
bonus (minimum +1). This ability is usable once per day as a free action. 

At 7th level, you can use this ability twice per day; at 10th level, you can use it three times per day
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    SetLocalInt(oMeldshaper, "IncandescentOverload", TRUE);
    FloatingTextStringOnCreature("Incandescent Overload active!", oMeldshaper, FALSE);
    DelayCommand(6.0, DeleteLocalInt(oMeldshaper, "IncandescentOverload"));
    //DelayCommand(6.0, FloatingTextStringOnCreature("Incandescent Overload ended!", oMeldshaper, FALSE));
}