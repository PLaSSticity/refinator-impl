/*
 * ulidgen_r - generate ULID
 * (Universally Unique Lexicographically Sortable Identifier)
 *
 * To the extent possible under law, Leah Neukirchen <leah@vuxu.org>
 * has waived all copyright and related or neighboring rights to this work.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <stdio.h>

void
ulidgen_r(char ulid[27])
{
	static const char *b32alphabet = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";

	char *buf = ulid + 10;
	int same = 1;

	ulid[26] = 0;

	struct timespec tv;
	clock_gettime(CLOCK_REALTIME, &tv);
	uint64_t t = tv.tv_sec*1000 + tv.tv_nsec/1000000;

	for (int i = 9; i >= 0; i--, t /= 32)
		if (ulid[i] != b32alphabet[t % 32])
			ulid[i] = b32alphabet[t % 32], same = 0;

	if (same) {             /* increment random part in place */
		int i = 15;
		while (i >= 0 && buf[i] == 'Z')
			buf[i--] = '0';

		if (i < 0) {
                        /* restart 1ms + a bit later */
			nanosleep(&(struct timespec) { 0, 1234567 }, 0);
			ulidgen_r(ulid);
			return;
		}

		char *s = strchr(b32alphabet, buf[i]);
		if (s) {
			buf[i] = *(s+1);
			return;
		}
		/* else randomize again when we found invalid chars */
	}

	unsigned char rnd[16];  /* use 16 bytes for easier encoding */
	if (getentropy(rnd, sizeof rnd) < 0)
		abort();

	for (int i = 0; i < 16; i++)
		buf[i] = b32alphabet[rnd[i] % 32];
}

/*
 * ulidgen - generate or tag lines with ULID
 * (Universally Unique Lexicographically Sortable Identifier)
 *
 * Usage: ulidgen [-n N | -t]
 *    -n N   generate N ULID (default: 1)
 *    -t     print each line of standard input prefixed with an ULID
 *
 * To the extent possible under law, Leah Neukirchen <leah@vuxu.org>
 * has waived all copyright and related or neighboring rights to this work.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

int
main(int argc, char *argv[])
{
	char ulid[27] = { 0 };

	int c;
	long n = 1;
	int tflag = 0;
        while ((c = getopt(argc, argv, "n:t")) != -1)
	        switch (c) {
	        case 'n': n = atol(optarg); break;
	        case 't': tflag = 1; break;
	        }

	if (tflag) {
		char *line = 0;
		size_t linelen = 0;

		setvbuf(stdout, 0, _IOLBF, 0);

		while (getdelim(&line, &linelen, '\n', stdin) != -1) {
			ulidgen_r(ulid);
			printf("%s %s", ulid, line);
		}
	} else {
		for (long i = 0; i < n; i++) {
			ulidgen_r(ulid);
			puts(ulid);
		}
	}

	fflush(0);
	exit(!!ferror(stdout));
}
