/* #UselessProgram */
/* Touch */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
int main() {
 int x = 0;
 char old[99], new[99];
 srand(arc4random());
 while (1) {
  int y = x + rand() % 2 * 2 - 1;
  snprintf(old, 99, "%d", x);
  snprintf(new, 99, "%d", y);
  if (-1 == rename(old, new) && ENOENT == errno)
   x = y;
 }
}
