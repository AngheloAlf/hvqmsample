/* Starts a segment */
#define BEGIN_SEG(name, addr) \
    _##name##SegmentStart = ADDR(.name); \
    _##name##SegmentRomStart = __romPos; \
    .name addr : AT(__romPos)

/* Ends a segment */
#define END_SEG(name) \
    _##name##SegmentEnd = ADDR(.name) + SIZEOF(.name); \
    _##name##SegmentRomEnd = __romPos + SIZEOF(.name); \
    __romPos += SIZEOF(.name);

/* Starts a noload segment which is intended to contain variables which do not have data yet. */
#define BEGIN_NOLOAD(name) \
    _##name##SegmentBssStart = ADDR(.name.noload); \
    .name.noload (NOLOAD) :

/* Ends a noload segment */
#define END_NOLOAD(name) \
    _##name##SegmentBssEnd = ADDR(.name.noload) + SIZEOF(.name.noload); \
    _##name##SegmentBssSize = SIZEOF(.name.noload);

SECTIONS
{
   __romPos = 0;

   BEGIN_SEG(boot, 0x04000000)
   {
      BUILD_DIR/asm/rom_header.o(.text); /* ROM Header */
      BUILD_DIR/boot.6102.o(.data); /* CIC 6102 bootcode */
   }
   END_SEG(boot)

   BEGIN_SEG(code, 0x80000400) SUBALIGN(16)
   {
		BUILD_DIR/asm/entry.o(.start);
      BUILD_DIR/src/main*.o(.text);

      */libgultra_rom.a:*.o(.text);
      */libhvqm2.a:*.o(.text);
      BUILD_DIR/src/libkmc*.o(.text);
      */rspboot.o(.text);
      */hvqm2sp1.o(.text);

      /* data */
      BUILD_DIR/src/main*.o(.data*);

      */libgultra_rom.a:*.o(.data*);
      */libhvqm2.a:*.o(.data*);
      BUILD_DIR/src/libkmc*.o(.data);
      */rspboot.o(.data*);
      */hvqm2sp1.o(.data*);

      /* rodata */
      BUILD_DIR/src/main*.o(.*rodata*);

      */libgultra_rom.a:*.o(.*rodata*);
      */libhvqm2.a:*.o(.*rodata*);
      BUILD_DIR/src/libkmc*.o(.*rodata*);
   }
   END_SEG(code)
   BEGIN_NOLOAD(code)
   {
      BUILD_DIR/src/main*.o(.*bss*);

      */libgultra_rom.a:*.o(COMMON);
      */libgultra_rom.a:*.o(.scommon);
      */libgultra_rom.a:*.o(.*bss*);
      */libhvqm2.a:*.o(.*bss*);
      BUILD_DIR/src/libkmc*.o(.COMMON);
      BUILD_DIR/src/libkmc*.o(.scommon);
      BUILD_DIR/src/libkmc*.o(.*bss*);
   }
   END_NOLOAD(code)

   . = 0x80040000;
   
   BEGIN_NOLOAD(hvqmwork)
   {
      BUILD_DIR/src/buffers/hvqmwork.o(.bss*);
   }
   END_NOLOAD(hvqmwork)

   . = 0x80080000;
   
   BEGIN_NOLOAD(adpcmbuf)
   {
      BUILD_DIR/src/buffers/adpcmbuf.o(.bss*);
   }
   END_NOLOAD(adpcmbuf)

   . = 0x80100000;
   
   BEGIN_NOLOAD(hvqbuf)
   {
      BUILD_DIR/src/buffers/hvqbuf.o(.bss*);
   }
   END_NOLOAD(hvqbuf)

   . = 0x801c0000;
   
   BEGIN_NOLOAD(pcmbuf)
   {
      BUILD_DIR/src/buffers/pcmbuf.o(.bss*);
   }
   END_NOLOAD(pcmbuf)

   . = 0x80200000;
   
   BEGIN_NOLOAD(cfb)
   {
      BUILD_DIR/src/buffers/cfb.o(.bss*);
   }
   END_NOLOAD(cfb)

   BEGIN_SEG(hvqmdata, __romPos)
   {
      BUILD_DIR/assets/sample.hvqm.o(.data);
   }
   END_SEG(hvqmdata)
   /* Discard everything not specifically mentioned above. */
   /DISCARD/ :
   {
      *(*);
   }
}
