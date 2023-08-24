
#include "prc_alterations"
#include "prc_class_const"

void main()
{
object oWeapon = GetLocalObject(OBJECT_SELF, "CHOSEN_WEAPON");
int iLevel = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, OBJECT_SELF);
float fDuration = 6.0*iLevel;
int iType = GetBaseItemType(oWeapon);

        //Threat range of 1
        if(iType == BASE_ITEM_KAMA || BASE_ITEM_SHURIKEN || BASE_ITEM_LIGHTHAMMER
        || BASE_ITEM_DART || BASE_ITEM_THROWINGAXE || BASE_ITEM_SICKLE || BASE_ITEM_LIGHTMACE ||
        BASE_ITEM_HANDAXE || BASE_ITEM_SLING || BASE_ITEM_SHORTSPEAR || BASE_ITEM_CLUB
        || BASE_ITEM_BATTLEAXE || BASE_ITEM_LIGHTFLAIL || BASE_ITEM_MORNINGSTAR ||
        BASE_ITEM_QUARTERSTAFF || BASE_ITEM_SHORTBOW || BASE_ITEM_WARHAMMER || BASE_ITEM_DIREMACE
        || BASE_ITEM_DOUBLEAXE || BASE_ITEM_GREATAXE || BASE_ITEM_HALBERD || BASE_ITEM_LONGBOW ||
        BASE_ITEM_SCYTHE || BASE_ITEM_WHIP || BASE_ITEM_DWARVENWARAXE)
        {
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(1, ATTACK_BONUS_MISC),OBJECT_SELF,fDuration);
         AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyKeen(),oWeapon, fDuration);
        }

        //Threat range of 2
        if(iType == BASE_ITEM_DAGGER || BASE_ITEM_LIGHTCROSSBOW || BASE_ITEM_SHORTSWORD
        || BASE_ITEM_HEAVYCROSSBOW || BASE_ITEM_KATANA || BASE_ITEM_LONGSWORD || BASE_ITEM_BASTARDSWORD
        || BASE_ITEM_TWOBLADEDSWORD || BASE_ITEM_HEAVYFLAIL || BASE_ITEM_GREATSWORD )
        {
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(2, ATTACK_BONUS_MISC),OBJECT_SELF,fDuration);
          AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyKeen(),oWeapon, fDuration);
        }


        //Threat range of 3
        if(iType == BASE_ITEM_RAPIER || BASE_ITEM_SCIMITAR)
        {
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(3, ATTACK_BONUS_MISC),OBJECT_SELF,fDuration);
         AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyKeen(),oWeapon, fDuration);
        }

}
