#include <stdio.h>

extern "C" { 
// use C linkage for C files
#include "tv/a.h"
#include "tw/a.h"
}

#include "tv/b.h"


int main(int argc, char **argv)
{
	printf("00 \\ start\n");
	do_tv_a();
	do_b();
//	do_tw_a();
	printf("99    \\ done\n");
}

