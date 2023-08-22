/*
	tlksearch.c

	searches a xml file for free tlk entries,
	file must be formatted correctly and in order

    By: Flaming_Sword
    Created: Oct 1, 2006
    Modified: Oct 1, 2006

    Arguments (optional - default):

    nSearchStart (45000)
    nSearchEnd (55000)
    sFile (prc_consortium.tlk.xml)

	Will work if compiled in cygwin (or presumably linux)
	Windows version (from cygwin) requires cygwin1.dll
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
	int nSearchStart = 45000;
    int nSearchEnd = 255000;
	int nTemp = 0;
	int nScan = 0;
	int i;
	int nCurrent = nSearchStart;
    char *sFile = "../tlk/prc_consortium.tlk.xml";
	char *sTemp = (char *) malloc(65536 * sizeof(char));
	FILE *fp;


    if(argc > 1) nSearchStart = atoi(argv[1]);
    if(argc > 2) nSearchEnd = atoi(argv[2]);
    if(argc > 3) sFile = argv[3];

	fp = fopen(sFile, "r");

    if(fp == NULL)
    {
        printf("Error opening file");
        return 1;
    }

	//13
	//6
	while(fgets(sTemp, 65536, fp))
	{
		//nCount++;
		nScan = sscanf(sTemp, "  <entry id=%*c%d%*s", &nTemp);

		if(nScan == 1 && nTemp >= nSearchStart && nTemp <= nSearchEnd)
		{
			//printf("%s", sTemp);
			//printf("%d\n", nTemp);
			if(nTemp > nCurrent + 1)
			{
				if(nTemp > nCurrent + 2)
				{
					printf("%d-%d (%d entries)\n", nCurrent + 1, nTemp - 1, nTemp - nCurrent - 1);
				}
				else
				{
					printf("%d\n", nCurrent + 1);
				}
				/*
				for(i = nCurrent + 1; i < nTemp; i++)
					printf("%d\n", i);
				*/
			}
			nCurrent = nTemp;
		}
        else if(nTemp > nSearchEnd)
        {
            break;
        }
	}


	fclose(fp);

	free(sTemp);
	return 0;
}
