
// Copyright (c) 2014 TJ Holowaychuk <tj@vision-media.ca>
//

#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>
#include <stdio.h>


/*
 * Protocol version.
 */

#define AMP_VERSION 1

/*
 * Message struct.
 */

typedef struct {
  short version;
  short argc;
  char *buf;
} amp_t;

// prototypes

char *
amp_encode(char **argv, int argc);

void
amp_decode(amp_t *msg, char *buf);

char *
amp_decode_arg(amp_t *msg);

static uint32_t
read_u32_be(char *buf) {
  uint32_t n = 0;
  n |= buf[0] << 24;
  n |= buf[1] << 16;
  n |= buf[2] << 8;
  n |= buf[3];
  return n;
}

/*
 * Write u32be.
 */

static void
write_u32_be(char *buf, uint32_t n) {
  buf[0] = n >> 24 & 0xff;
  buf[1] = n >> 16 & 0xff;
  buf[2] = n >> 8 & 0xff;
  buf[3] = n & 0xff;
}

/*
 * Decode the `msg` header in `buf`.
 */

void
amp_decode(amp_t *msg, char *buf) {
  msg->version = buf[0] >> 4;
  msg->argc = buf[0] & 0xf;
  msg->buf = buf + 1;
}

/*
 * Decode `msg` argument, returning a buffer
 * that must be freed by the user and progressing
 * the msg->buf cursor.
 */

char *
amp_decode_arg(amp_t *msg) {
  uint32_t len = read_u32_be(msg->buf);
  msg->buf += 4;

  char *buf = malloc(len);
  if (!buf) return NULL;

  memcpy(buf, msg->buf, len);
  msg->buf += len;
  return buf;
}

/*
 * Encode the AMP message argv.
 *
 *         0        1 2 3 4     <length>    ...
 *   +------------+----------+------------+
 *   | <ver/argc> | <length> | <data>     | additional arguments
 *   +------------+----------+------------+
 *
 */

char *
amp_encode(char **argv, int argc) {
  size_t len = 1;
  size_t lens[argc];

  // length
  for (int i = 0; i < argc; ++i) {
    len += 4;
    lens[i] = strlen(argv[i]);
    len += lens[i];
  }

  // alloc
  char *buf = malloc(len);
  char *ret = buf;
  if (!buf) return NULL;

  // ver/argc
  *buf++ = AMP_VERSION << 4 | argc;

  // encode
  for (int i = 0; i < argc; ++i) {
    size_t len = lens[i];

    write_u32_be(buf, len);
    buf += 4;

    memcpy(buf, argv[i], len);
    buf += len;
  }

  return ret;
}

int
main(){
  char *args[] = { "some", "stuff", "here" };

  // encode
  char *buf = amp_encode(args, 3);

  // header
  amp_t msg = {0};
  amp_decode(&msg, buf);
  assert(1 == msg.version);
  assert(3 == msg.argc);

  // args
  for (int i = 0; i < msg.argc; ++i) {
    char *arg = amp_decode_arg(&msg);
    switch (i) {
      case 0:
        assert(0 == strcmp("some", arg));
        break;
      case 1:
        assert(0 == strcmp("stuff", arg));
        break;
      case 2:
        assert(0 == strcmp("here", arg));
        break;
    }
  }

  printf("ok\n");

  return 0;
}
