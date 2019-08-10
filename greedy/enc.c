#include<stdio.h>
main(){
FILE *fp1,*fp2;
int choice;
char fname[20],temp[20]={"file.txt"},c;
//clear();
printf("\nPress 1 to Encrypt");
printf("\nPress 2 to Decrypt");
printf("\nEnter your Choice:");
scanf("%d",&choice);

switch(choice){
case 1:
printf("\nEnter the filename to Encrypt:");
scanf("%s",fname);
fp1=fopen(fname,"r+");
if(fp1==NULL) {
printf("\nThe file %s can't be open",fname);
//getch();
//exit(0);
}

fp2=fopen(temp,"w+");
if(fp2==NULL){
printf("\nThe file Temp can't be open");
//getch();
//exit(0);
}

c=fgetc(fp1);
while(c!=EOF){
fputc((c+fname[0]),fp2);
printf("%c",c+fname[0]);
//getch();
c=fgetc(fp1);
}

fclose(fp1);
fclose(fp2);
remove(fname);
rename(temp,fname);
printf("\nThe file is Encrypted:");
//getch();
break;


case 2:
printf("\nEnter the Filename to Decrypt:");
scanf("%s",fname);
fp1=fopen(fname,"r+");
fp2=fopen(temp,"w+");
c=fgetc(fp1);
while(c!=EOF){
fputc(c-fname[0],fp2);
c=fgetc(fp1);
}

fclose(fp1);
fclose(fp2);
remove(fname);
rename(temp,fname);
printf("\nThe file is decrypted:");
//getch();
}
}
