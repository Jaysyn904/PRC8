/*
	fileend.c

	generates switches for use with PRCGetFileEnd()

	By: Flaming_Sword
	Created: Sept 5, 2006
	Modified: June 12, 2009

	USE: Run with path to directory containing 2das to create fileends for,
	will otherwise use default relative path to 2das
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <sys/types.h>
#include <dirent.h>

//#define DEBUG

#define MIN(x, y) (x <= y) ? x : y

int main(int argc, char *argv[])
{
	char *sFile;
	char *sTemp = (char *) malloc(65536 * sizeof(char));
	char sDir[] = "../2das/";
	char *pt;
	char sName[20];
	char sPath[256];
	FILE *fp;
	DIR *dp;
	int nCount, i, add_slash = 0;
	struct dirent *ep;

	if(argc < 1) return;
    if(argc > 1)
    {
		for(i = 0; argv[1][i] != '\0'; i++)
		{
			if(argv[1][i] == '\\')
				argv[1][i] = '/';
		}
		if(argv[1][i - 1] != '/')
		{
			add_slash = 1;
		}
	}
    if(argc == 1 || argv[1] == NULL)
    {
		pt = sDir;
	}
	else
	{
		pt = argv[1];
	}
	dp = opendir(pt);

	printf("    //START AUTO-GENERATED FILEENDS\n");
	if (dp != NULL)
	{
		#ifdef DEBUG
		printf("    //found dir %s\n", sDir);
		#endif
		while (ep = readdir (dp))
		{
			memset(sPath, 0, sizeof(sPath));
			memcpy(sPath, pt, MIN(sizeof(sPath), strlen(pt)));
			if(add_slash)
			strcat(sPath, "/");
			sFile = ep->d_name;
			strcat(sPath, sFile);
			#ifdef DEBUG
			printf("//%s\n", sPath);
			#endif
			#ifdef DEBUG
			printf("//null compare\n");
			#endif
			if(strstr(sFile, ".2da") == NULL && strstr(sFile, "2DA") == NULL)
				continue;
			#ifdef DEBUG
			printf("//file open\n");
			#endif
			fp = fopen(sPath, "r");
			if(fp == NULL)
			{
				printf("    //error opening %s\n", sFile);
				continue;
			}
			nCount = 0;
			#ifdef DEBUG
			printf("//fgets\n");
			#endif
			fgets(sTemp, 65535, fp);
			#ifdef DEBUG
			printf("//comp\n");
			#endif
			if(strncmp(sTemp, "2DA", 3))
			{
				fclose(fp);
				#ifdef DEBUG
				printf("//sTemp = %s\n", sTemp);
				#endif
				continue;
			}
			nCount++;
			for(i = 0; i < 20; i++)
				sName[i] = sFile[i];
			while(fgets(sTemp, 65536, fp))
			{
				nCount++;
			}
			#ifdef DEBUG
			printf("//print\n");
			#endif
			printf("    SetPRCSwitch(%cPRC_FILE_END_%s%c, %d);\n", 34, strtok(sName, "."), 34, nCount - 4);
			fclose(fp);
		}
		(void) closedir (dp);
	}
	else
	{
		printf("Directory %s not found\n", argv[1]);
	}

	printf("    //END AUTO-GENERATED FILEENDS\n");
	free(sTemp);
	return 0;
}
