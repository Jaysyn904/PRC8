// store PC's true form - the appearance is restored by prc_onenter.nss
// for compatibility with BioWare 'horse-scripts'

#include "prc_inc_shifting"
#include "x3_inc_horse"

void main()
{
    object oPC = OBJECT_SELF;

    if(!GetIsDM(oPC) && !HorseGetIsMounted(oPC))
        StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);
}