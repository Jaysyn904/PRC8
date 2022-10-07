void main()
{

 int nHD = GetHitDice(OBJECT_SELF);
 int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
 int nNewXP =GetXP(OBJECT_SELF)-6;

 if (nMinXPForLevel > nNewXP || nNewXP == 0 )
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP

        return ;

    }


 CreateItemOnObject("x1_wmgrenade005", OBJECT_SELF, 1);
 SetXP(OBJECT_SELF,nNewXP);
}
