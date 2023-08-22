/* #UselessProgram */
/* Silencing */
#include <stdio.h>
#include <stdlib.h>
const char A[] = "Aa", B[] = "Bb", C[] = "Cc";
int main() {
	char buf[100];
	srand(arc4random());
	while (fgets(buf, sizeof(buf), stdin)) {
		for (char *c = buf; *c; ++c) {
			switch (*c) {
			case 'A': case 'a': *c = A[rand() % sizeof(A)]; break;
			case 'B': case 'b': *c = B[rand() % sizeof(B)]; break;
			case 'C': case 'c': *c = C[rand() % sizeof(C)]; break;
			default: *c = ' ';
			}
		}
		puts(buf);
	}
	return 0;
}
