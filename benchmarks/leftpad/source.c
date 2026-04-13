/* leftpad.c - Copyright (c) 2019, Sijmen J. Mulder (see LICENSE.md) */

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef __OpenBSD__
# include <unistd.h>
#endif


/*
 * leftpad() - pad a string to a desired length
 *
 * Writes `padding` (or spaces if NULL or empty) and `str` (if not NULL) to
 * `dest`, where `padding` is repeated or cut of as needed to make for a
 * minimum final string length of `min_len`.
 *
 * If `dest` is NULL or `dest_sz` 0, nothing is written. Otherwise, up to
 * `dest_sz` characters are written, including the \0 terminator, possibly
 * truncating the output.
 *
 * Returns the length of the output string. If less than `dest_sz`, the output
 * has not bene truncated.
 */
size_t leftpad(
    const char *str,
    const char *padding,
    size_t min_len,
    char *dest,
    size_t dest_sz);

size_t
leftpad(const char *str, const char *padding, size_t min_len, char *dest,
    size_t dest_sz)
{
	size_t i = 0;
	size_t str_len = 0;
	size_t dest_len = 0;
	size_t npad = 0;

	while (str && str[str_len])
		str_len++;
	if (!padding || !padding[0])
		padding = " ";
	if (str_len < min_len)
		npad = min_len - str_len;
	if (!dest || !dest_sz)
		return str_len + npad;
	while (dest_len < npad && dest_len < dest_sz - 1)
		if (!(dest[dest_len++] = padding[i++])) {
			dest[dest_len-1] = padding[0];
			i = 1;
		}
	for (i = 0; i < str_len && dest_len < dest_sz - 1; i++)
		dest[dest_len++] = str[i];
	dest[dest_len] = '\0';

	return dest_len;
}

int
main(int argc, char **argv)
{
	long min_len;
	const char *padding = " ";
	char *end;
	char *buf;
	size_t buf_len;

#ifdef __OpenBSD__
	if (pledge("stdio", NULL) == -1) {
		fputs("leftpad: pledge() failed\n", stderr);
		return 0;
	}
#endif

	if (argc == 4)
		padding = argv[3];
	else if (argc != 3) {
		fputs("usage: leftpad string length [padding]\n", stderr);
		return 1;
	}

	min_len = strtol(argv[2], &end, 10);
	if (!argv[2][0] || end[0] || min_len < 0) {
		fputs("leftpad: invalid length", stderr);
		return 1;
	}

	buf_len = leftpad(argv[1], padding, min_len, NULL, 0);
	if (!(buf = malloc(buf_len))) {
		fputs("leftpad: out of memory", stderr);
		return 1;
	}

	leftpad(argv[1], padding, min_len, buf, buf_len+1);
	puts(buf);
	return 0;
}
