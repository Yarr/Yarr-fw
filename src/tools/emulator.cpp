// emulator

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <semaphore.h>
#include <pthread.h>
#include <signal.h>
#include <fcntl.h>
#include <stdint.h>
#include <string.h>

#include "Fei4.h"
#include "Fei4Emu.h"
#include "EmuShm.h"

uint32_t modeBits;
Fei4 *fe;
uint32_t shift_register_buffer[21][40];

Fei4Emu g_feEmu;

int handle_globalpulse(uint32_t chipid)
{
	int didSomething = 0;

	// ignore if we get a ReadErrorReq
	if (fe->getValue(&Fei4::ReadErrorReq) == 1)
	{
		didSomething = 1;
	}

	// eventually, I should change the FE that I use based on the chipid

	// check if I need to shift the Shift Register by one
	if (fe->getValue(&Fei4::S0) == 0 && fe->getValue(&Fei4::S1) == 0 && fe->getValue(&Fei4::HitLD) == 0 && fe->getValue(&Fei4::SR_Clock) == 1)
	{
		didSomething = 1;

		// use Fei4::Colpr_Mode to determine which dc to loop over
		int dc_step = 40;
		switch (fe->getValue(&Fei4::Colpr_Mode))
		{
			case 0:
				dc_step = 40;
				break;
			case 1:
				dc_step = 4;
				break;
			case 2:
				dc_step = 8;
				break;
			case 3:
				dc_step = 1;
				break;
		}

		// loop through the 40 double columns
		for (int i = 0; i < 40 / dc_step; i++)
		{
			int dc = fe->getValue(&Fei4::Colpr_Addr) + dc_step * i % 40;

			// use these to deal with overflow bits
			uint32_t current_first_bit = 0;
			uint32_t previous_first_bit = 0;

			// shift all bits left by 1, keeping track of the overflow bits
			for (int j = 20; j >= 0; j--)
			{
				current_first_bit = shift_register_buffer[j][dc] & 1;
				shift_register_buffer[j][dc] <<= 1;
				shift_register_buffer[j][dc] += previous_first_bit;
				previous_first_bit = current_first_bit;
			}
		}
	}

	// check if we should write to the shift registers from the pixel registers
	if (fe->getValue(&Fei4::S0) == 1 && fe->getValue(&Fei4::S1) == 1 && fe->getValue(&Fei4::HitLD) == 0 && fe->getValue(&Fei4::SR_Clock) == 1)
	{
		// use Fei4::Colpr_Mode to determine which dc to loop over
		int dc_step = 40;
		switch (fe->getValue(&Fei4::Colpr_Mode))
		{
			case 0:
				dc_step = 40;
				break;
			case 1:
				dc_step = 4;
				break;
			case 2:
				dc_step = 8;
				break;
			case 3:
				dc_step = 1;
				break;
		}

		// loop through the 40 double columns
		for (int i = 0; i < 40 / dc_step; i++)
		{
			int dc = fe->getValue(&Fei4::Colpr_Addr) + dc_step * i % 40;

			// loop through the 13 double column bits
			for (int i = 0; i < 13; i++)
			{
				// if a double column bit is 1, write the contents of the corresponding pixel register to the Shift Register
				if (fe->getValue(&Fei4::Pixel_latch_strobe) & (unsigned) pow(2, i))
				{
					didSomething = 1;

					switch (i)
					{
						case 0:
							memcpy(&shift_register_buffer[0][dc], fe->En(dc).getStream(), 84);
							break;
						case 1:
							memcpy(&shift_register_buffer[0][dc], fe->TDAC(dc)[0].getStream(), 84);
							break;
						case 2:
							memcpy(&shift_register_buffer[0][dc], fe->TDAC(dc)[1].getStream(), 84);
							break;
						case 3:
							memcpy(&shift_register_buffer[0][dc], fe->TDAC(dc)[2].getStream(), 84);
							break;
						case 4:
							memcpy(&shift_register_buffer[0][dc], fe->TDAC(dc)[3].getStream(), 84);
							break;
						case 5:
							memcpy(&shift_register_buffer[0][dc], fe->TDAC(dc)[4].getStream(), 84);
							break;
						case 6:
							memcpy(&shift_register_buffer[0][dc], fe->LCap(dc).getStream(), 84);
							break;
						case 7:
							memcpy(&shift_register_buffer[0][dc], fe->SCap(dc).getStream(), 84);
							break;
						case 8:
							memcpy(&shift_register_buffer[0][dc], fe->Hitbus(dc).getStream(), 84);
							break;
						case 9:
							memcpy(&shift_register_buffer[0][dc], fe->FDAC(dc)[0].getStream(), 84);
							break;
						case 10:
							memcpy(&shift_register_buffer[0][dc], fe->FDAC(dc)[1].getStream(), 84);
							break;
						case 11:
							memcpy(&shift_register_buffer[0][dc], fe->FDAC(dc)[2].getStream(), 84);
							break;
						case 12:
							memcpy(&shift_register_buffer[0][dc], fe->FDAC(dc)[3].getStream(), 84);
							break;
						default:
							printf("why am I trying to write to pixel register %d?\n", i);
							break;
					}
				}
			}
		}
	}

	// check if we should write to the pixel registers from the shift registers
	if (fe->getValue(&Fei4::S0) == 0 && fe->getValue(&Fei4::S1) == 0 && fe->getValue(&Fei4::HitLD) == 0 && fe->getValue(&Fei4::Latch_Enable) == 1)
	{
		// use Fei4::Colpr_Mode to determine which dc to loop over
		int dc_step = 40;
		switch (fe->getValue(&Fei4::Colpr_Mode))
		{
			case 0:
				dc_step = 40;
				break;
			case 1:
				dc_step = 4;
				break;
			case 2:
				dc_step = 8;
				break;
			case 3:
				dc_step = 1;
				break;
		}

		// loop through the 40 double columns
		for (int i = 0; i < 40 / dc_step; i++)
		{
			int dc = fe->getValue(&Fei4::Colpr_Addr) + dc_step * i % 40;

			// loop through the 13 double column bits
			for (int i = 0; i < 13; i++)
			{
				// if a double column bit is 1, write the contents of the Shift Register to the corresponding pixel register
				if (fe->getValue(&Fei4::Pixel_latch_strobe) & (unsigned) pow(2, i))
				{
					didSomething = 1;

					switch (i)
					{
						case 0:
							fe->En(dc).set(&shift_register_buffer[0][dc]);
							break;
						case 1:
							fe->TDAC(dc)[0].set(&shift_register_buffer[0][dc]);
							break;
						case 2:
							fe->TDAC(dc)[1].set(&shift_register_buffer[0][dc]);
							break;
						case 3:
							fe->TDAC(dc)[2].set(&shift_register_buffer[0][dc]);
							break;
						case 4:
							fe->TDAC(dc)[3].set(&shift_register_buffer[0][dc]);
							break;
						case 5:
							fe->TDAC(dc)[4].set(&shift_register_buffer[0][dc]);
							break;
						case 6:
							fe->LCap(dc).set(&shift_register_buffer[0][dc]);
							break;
						case 7:
							fe->SCap(dc).set(&shift_register_buffer[0][dc]);
							break;
						case 8:
							fe->Hitbus(dc).set(&shift_register_buffer[0][dc]);
							break;
						case 9:
							fe->FDAC(dc)[0].set(&shift_register_buffer[0][dc]);
							break;
						case 10:
							fe->FDAC(dc)[1].set(&shift_register_buffer[0][dc]);
							break;
						case 11:
							fe->FDAC(dc)[2].set(&shift_register_buffer[0][dc]);
							break;
						case 12:
							fe->FDAC(dc)[3].set(&shift_register_buffer[0][dc]);
							break;
						default:
							printf("why am I trying to write to pixel register %d?\n", i);
							break;
					}
				}
			}
		}
	}

	if (!didSomething)
	{
		// print some info about the state of the global register
		printf("did not do anything\t");
		printf("Fei4::S0 = %x\t", fe->getValue(&Fei4::S0));
		printf("Fei4::S1 = %x\t", fe->getValue(&Fei4::S1));
		printf("Fei4::HitLD = %x\t", fe->getValue(&Fei4::HitLD));
		printf("Fei4::Colpr_Mode = %x\t", fe->getValue(&Fei4::Colpr_Mode));
		printf("Fei4::SR_Clock = %x\t", fe->getValue(&Fei4::SR_Clock));
		printf("Fei4::Latch_Enable = %x\t", fe->getValue(&Fei4::Latch_Enable));
		printf("Fei4::Pixel_latch_strobe = %x\n", fe->getValue(&Fei4::Pixel_latch_strobe));

		return 1;
	}

//	printf("did something\n");

	return 0;
}

int handle_runmode(uint32_t chipid, int command)
{
	// eventually, I should change the FE that I use based on the chipId

	// decode the modeBits from the command word
	modeBits = command & 0x3F;

	return 0;
}

int handle_wrregister(uint32_t chipid, uint32_t address, uint32_t value)
{
	// write value to address in the Global Register (of FE chipid - ignoring this part for now)
	fe->cfg[address] = value;

	return 0;
}

int handle_wrfrontend(uint32_t chipid, uint32_t bitstream[21])
{
	// write the bitstream to our Shift Register buffer (eventually, I should have one of these for every FE, and maybe every dc)
	int dc = fe->getValue(&Fei4::Colpr_Addr);
	memcpy(&shift_register_buffer[0][dc], &bitstream[0], 84);

	return 0;
}

int handle_trigger()
{
	static int cnt(0);
	std::cout << ++cnt << " -- " << __PRETTY_FUNCTION__ << std::endl;
	g_feEmu.addDataHeader(false); // No Error flags
	for (unsigned col = 1; col < fe->n_Col; col++)
	{
		for (unsigned row = 1; row < fe->n_Row; row++)
		{
			if (fe->getEn(col, row))
			{
				//printf("%d, %d enabled\n", col, row);
				g_feEmu.addDataRecord(col, row, 10, 0);
			}
			else
			{
				//printf("%d, %d disabled\n", col, row);
			}
		}
	}

	return 0;
/*
		// use Fei4::Colpr_Mode to determine which dc to loop over
		int dc_step = 40;
		switch (fe->getValue(&Fei4::Colpr_Mode))
		{
			case 0:
				dc_step = 40;
				break;
			case 1:
				dc_step = 4;
				break;
			case 2:
				dc_step = 8;
				break;
			case 3:
				dc_step = 1;
				break;
		}

		// loop through the 40 double columns
		for (int i = 0; i < 40 / dc_step; i++)
		{
			int dc = fe->getValue(&Fei4::Colpr_Addr) + dc_step * i % 40;
*/
}

int main(int argc, char *argv[])
{
	// set up the fe
	fe = new Fei4(NULL, 0);

	EmuShm *emu_shm_tx = new EmuShm(1337, 64, 0);
	emu_shm_tx->dump();

	auto emu_shm_rx = std::make_shared<EmuShm>(1338, 64, 0);
	emu_shm_rx->dump();
        g_feEmu.setRxShMem(emu_shm_rx);

	while (1)
	{
	        uint32_t command;
		uint32_t type;
		uint32_t name;
		uint32_t chipid;
		uint32_t address;

		uint32_t value;
		uint32_t bitstream[21];

		command = emu_shm_tx->read32();
                uint32_t nTriggers = 1;
                if((command & 0xFF000000) == 0x1D000000)
			nTriggers = command & 0x00FFFFFF;
		type = command >> 14;

		switch (type)
		{
			case 0x7400:
//				printf("recieved a trigger\n");
				std::cout << "Processing batch of " << nTriggers << " triggers" << std::endl;
				for(size_t i = 0 ; i < nTriggers ; ++i)
					handle_trigger();
				std::cout << "Done processing batch of " << nTriggers << " triggers" << std::endl;
				emu_shm_tx->read32();
				break;
			case 0x0168:
//				printf("recieved a slow command\n");

				name = command >> 10 & 0xF;
				chipid = command >> 6 & 0xF;
				address = command & 0x3F;

				switch (name)
				{
					case 1:
//						printf("recieved a RdRegister command\n");
						break;
					case 2:
//						printf("recieved a WrRegister command\n");
						value = emu_shm_tx->read32();
						value >>= 16; // nikola: remind me why
						handle_wrregister(chipid, address, value);
						break;
					case 4:
//						printf("recieved a WrFrontEnd command\n");
						for (int i = 0; i < 21; i++)
						{
							bitstream[i] = emu_shm_tx->read32();
						}
						handle_wrfrontend(chipid, bitstream);
						break;
					case 8:
//						printf("recieved a GlobalReset command\n");
						break;
					case 9:
//						printf("recieved a GlobalPulse command\n");
						handle_globalpulse(chipid);
						break;
					case 10:
//						printf("recieved a RunMode command\n");
						handle_runmode(chipid, command);
						break;
				}

				break;
			case 0: break;
			default:
				printf("Software Emulator: ERROR - unknown type recieved, %x\n", type);
				break;
		}

	}

	delete emu_shm_tx;

	return 0;
}