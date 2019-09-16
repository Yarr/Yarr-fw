#ifndef ABC130MASK_CALEN_H
#define ABC130MASK_CALEN_H

//maybe a 3_D array to store mask for different mode?
static const uint32_t star_masks[128][8]= {
		{0xFFFFFFFc,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFF3,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFcF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFF3F,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFcFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFF3FF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFcFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFF3FFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFcFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFF3FFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFcFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFF3FFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFcFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xF3FFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xcFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0x3FFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},

		{0xFFFFFFFF,0xFFFFFFFc,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFF3,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFcF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFF3F,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFcFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFF3FF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFcFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFF3FFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFcFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFF3FFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFcFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFF3FFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFcFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xF3FFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xcFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0x3FFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},

		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFc,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFF3,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFcF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFF3F,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFcFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFF3FF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFcFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFF3FFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFcFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFF3FFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFcFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFF3FFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFcFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xF3FFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xcFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0x3FFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},

		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFc,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFF3,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFcF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFF3F,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFcFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFF3FF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFcFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFF3FFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFcFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFF3FFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFcFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFF3FFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFcFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xF3FFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xcFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0x3FFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},

		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFc,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFF3,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFcF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFF3F,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFcFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFF3FF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFcFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFF3FFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFcFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFF3FFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFcFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFF3FFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFcFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xF3FFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xcFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0x3FFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},

		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFc,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFF3,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFcF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFF3F,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFcFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFF3FF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFcFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFF3FFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFcFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFF3FFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFcFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFF3FFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFcFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xF3FFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xcFFFFFFF,0xFFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0x3FFFFFFF,0xFFFFFFFF,0xFFFFFFFF},

		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFc,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFF3,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFcF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFF3F,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFcFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFF3FF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFcFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFF3FFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFcFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFF3FFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFcFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFF3FFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFcFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xF3FFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xcFFFFFFF,0xFFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0x3FFFFFFF,0xFFFFFFFF},

		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFc},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFF3},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFcF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFF3F},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFcFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFF3FF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFcFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFF3FFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFcFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFF3FFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFcFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFF3FFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFcFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xF3FFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xcFFFFFFF},
		{0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0x3FFFFFFF}
};

static const uint32_t star_calEn[128][8]= {

				{0x00000005,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x0000000a,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000050,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x000000a0,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000500,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000a00,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00005000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x0000a000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00050000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x000a0000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00500000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00a00000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x05000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x0a000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x50000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0xa0000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},

				{0x00000000,0x00000005,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x0000000a,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000050,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x000000a0,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000500,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000a00,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00005000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x0000a000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00050000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x000a0000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00500000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00a00000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x05000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x0a000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x50000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0xa0000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},

				{0x00000000,0x00000000,0x00000005,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x0000000a,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000050,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x000000a0,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000500,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000a00,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00005000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x0000a000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00050000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x000a0000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00500000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00a00000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x05000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x0a000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x50000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0xa0000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000},

				{0x00000000,0x00000000,0x00000000,0x00000005,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x0000000a,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000050,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x000000a0,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000500,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000a00,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00005000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x0000a000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00050000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x000a0000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00500000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00a00000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x05000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x0a000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x50000000,0x00000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0xa0000000,0x00000000,0x00000000,0x00000000,0x00000000},

				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000005,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x0000000a,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000050,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x000000a0,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000500,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000a00,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00005000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x0000a000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00050000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x000a0000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00500000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00a00000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x05000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x0a000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x50000000,0x00000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0xa0000000,0x00000000,0x00000000,0x00000000},

				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000005,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x0000000a,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000050,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x000000a0,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000500,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000a00,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00005000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x0000a000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00050000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x000a0000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00500000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00a00000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x05000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x0a000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x50000000,0x00000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0xa0000000,0x00000000,0x00000000},

				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000005,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x0000000a,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000050,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x000000a0,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000500,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000a00,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00005000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x0000a000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00050000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x000a0000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00500000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00a00000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x05000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x0a000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x50000000,0x00000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0xa0000000,0x00000000},

				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000005},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x0000000a},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000050},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x000000a0},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000500},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000a00},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00005000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x0000a000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00050000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x000a0000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00500000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00a00000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x05000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x0a000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x50000000},
				{0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0xa0000000}
};


//static const uint32_t abc130_masjs[2]= {0x55555555, 0xAAAAAAAA};
//static const uint32_t abc130_cal[2]= {0xCCCCCCCC, 0x33333333};

//static const uint32_t abc130_masjs[16][8]= {
//  {0x0000000C,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00000003,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x000000C0,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00000030,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00000C00,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00000300,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x0000C000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00003000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x000C0000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00003000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00C00000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00300000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x0C000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x03000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0xC0000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x30000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 }
//};
//
//static const uint32_t abc130_cal[16][8]= {
//  {0x00000005,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x0000000A,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00000050,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x000000A0,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00000500,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00000A00,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00005000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x0000A000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00050000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x000A0000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00500000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x00A00000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x05000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x0A000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0x50000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 },
//  {0xA0000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000 }
//};
//

//wrong
//void printMask(int nthMaskStage, int initReg_, int shift1, int shift2=0){
//	int cnt_reg =0;
//	int cnt_shift = 0;
//	int cnt_step =0;
//	uint32_t initReg = 0;
//	int max = 128;
//	int nReg = 8;
//	int step =16; //to step through 32 bits register
//	for( nthMaskStage=0;nthMaskStage<max; nthMaskStage++){ //downwards
//		////if(i>nReg && i%nReg==0) cnt_reg++;
//		if(nthMaskStage>0 && nthMaskStage%step==0){
//			std::cout << std::endl;
//			cnt_step++;
//		}
//
//
//		for(int j=0;j<nReg; j++){  //towards left
//			if(j==0){std::cout << "{";}
//
//			if(j==cnt_step){
//				if(nthMaskStage%step==0){
//					initReg = initReg_; //start as 0x00000003  i.e chn 1,128
//					cnt_shift=1;
//				}
//				else{
//
//					if(shift2>0 && cnt_shift%2==0 && cnt_shift>0 ){
//						initReg=(initReg>>shift2)&0xFFFFFFFF;
//						//std::cout << "shifft " <<std::endl;
//					}
//					else {
//							initReg=(initReg<<shift1)&0xFFFFFFFF;
//
//					}
//
//					//std::cout << "{" << cnt_shift <<"} " <<std::endl;
//					if(shift2>0) cnt_shift++;
//				}
//				std::cout << "0x"<<std::setfill('0')<< std::setw(8) <<std::hex << initReg  <<std::dec << ",";
//			}
//			else std::cout << "0x00000000,";
//			if(j==7){
//							std::cout << "} " <<std::endl;
//						}
//		}
//
//
//	}
//
//
//}

#endif
