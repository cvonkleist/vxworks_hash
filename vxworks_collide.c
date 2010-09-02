// cvk/2010-08-09
#include <stdio.h>
#include <string.h>

// password settings
#define MIN_LENGTH 8
#define MAX_LENGTH 40
char *charset = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
#define CHARSET_LENGTH 95

// shortcut hash table
#define MAX_SUM 110000
char sums[MAX_SUM][MAX_LENGTH + 1];

// stage one of the hashing algorithm: the sum
unsigned long sum(char *plaintext) {
  unsigned long s = 0;
  int i;
  for (i = 0; i < strlen(plaintext); i++)
    s += (plaintext[i]) * (i + 1) ^ (i + 1);
  return s;
}

// builds a random password
void random_password(char *password) {
  int i;
  int length = rand() % (MAX_LENGTH - MIN_LENGTH) + MIN_LENGTH;
  for(i = 0; i < length; i++)
    password[i] = charset[rand() % CHARSET_LENGTH];
  password[length] = '\0';
}

// randomly creates checksums
//
// when it discovers a shorter input plaintext for a checksum that has already
// been calculated, it replaces the existing plaintext with the new, shorter
// one
void brute(int runs) {
  int i;
  char password[MAX_LENGTH + 1];
  unsigned long s;

  for(i = 0; i < runs; i++) {
    random_password(password);
    s = sum(password);
    if(s > MAX_SUM) {
      printf("error! sum too big");
      return;
    }
    if(sums[s][0] == '\0' || strlen(password) < strlen(sums[s])) {
      strcpy(sums[s], password);
    }
  }
}

// returns the number of checksums in the table
int count() {
  int i;
  int c = 0;
  for(i = 0; i < MAX_SUM; i++)
    if(sums[i][0] != '\0')
      c++;
  return c;
}

// prints discovered checksums
void dump_table() {
  int i;
  for(i = 0; i < MAX_SUM; i++)
    if(sums[i][0] != '\0')
      printf("%d\t%s\n", i, sums[i]);
}

int main(int argc, char **argv) {
  brute(1000000000);
  printf("%d checksums\n", count());
  dump_table();
}
