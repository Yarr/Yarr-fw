#include "catch.hpp"

#include "StarCfg.h"

TEST_CASE("StarCfg", "[star][config]") {
  // Side-effect of checking it's not abstract is intentional
  StarCfg test_config;
  test_config.setHCCChipId(4);
  const int abc_id = 14;
  test_config.addABCchipID(abc_id);

  // This sets up initial values
  test_config.initRegisterMaps();

  //  REQUIRE (test_config.numABCs() == 1);
  REQUIRE (test_config.getHCCchipID() == 4);
  REQUIRE (test_config.getABCchipID(1) == abc_id);

  REQUIRE (test_config.getHCCRegister(HCCStarRegister::Delay1) == 0);
  REQUIRE (test_config.getHCCRegister(HCCStarRegister::PLL1) == 0xff3b05);

  test_config.setHCCRegister(HCCStarRegister::Delay1, 0x12345678);
  REQUIRE (test_config.getHCCRegister(HCCStarRegister::Delay1) == 0x12345678);


  test_config.setABCRegister(ABCStarRegister::CREG0, 0x87654321, abc_id);
  REQUIRE (test_config.getABCRegister(ABCStarRegister::CREG0, abc_id) == 0x87654321);

  REQUIRE (test_config.getSubRegisterParentAddr(1, "TESTPATT1") == ABCStarRegister::CREG0);

  test_config.setSubRegisterValue(1, "TESTPATT1", 0x5);
  test_config.setSubRegisterValue(1, "TESTPATT2", 0xa);
  REQUIRE (test_config.getSubRegisterValue(1, "TESTPATT1") == 0x5);

  REQUIRE (test_config.getABCRegister(ABCStarRegister::CREG0, abc_id) == 0x8a554321);
  REQUIRE (test_config.getSubRegisterParentValue(1, "TESTPATT1") == 0x8a554321);
}

TEST_CASE("StarCfgTrims", "[star][config]") {
  StarCfg test_config;
  test_config.setHCCChipId(2);
  const int abc_id = 3;
  test_config.addABCchipID(abc_id);

  test_config.initRegisterMaps();

  // Default to 15 on all strips
  // Two rows of 128 strips (odd and even)
  for(unsigned l = 0; l < 2; l++) {
    for(unsigned s = 0; s < 128; s++) {
      CAPTURE (l, s);

      // Currently expects indices base 1
      CHECK (test_config.getTrimDAC(s+1, l+1) == 15);
    }
  }

  test_config.setTrimDAC(10, 2, 18);
  REQUIRE (test_config.getTrimDAC(10, 2) == 18);

  for(unsigned r = 0; r < 40; r++) {
    CAPTURE (r);

    // Defaults
    uint32_t expected = r<32?0xffffffff:0;

    // The ones we've updated
    if (r == 32) expected = 0x00080000;
    if (r == 2) expected = 0xffff2fff;

    CHECK (test_config.getABCRegister(ABCStarRegister::TrimDAC0 + r, abc_id) == expected);
  }

  // Two rows of 128 strips (odd and even)
  for(unsigned l = 0; l < 2; l++) {
    for(unsigned s = 0; s < 128; s++) {
      CAPTURE (l, s);

      int set_trim = s%32;
      // Currently expects indices base 1
      test_config.setTrimDAC(s+1, l+1, set_trim);
      CHECK (test_config.getTrimDAC(s+1, l+1) == set_trim);
    }
  }

  for(unsigned r = 0; r < 40; r++) {
    CAPTURE (r);

    uint32_t expected = 0;
    if(r<32) {
      switch(r%4) {
      case 0: expected = 0x32321010; break;
      case 1: expected = 0x76765454; break;
      case 2: expected = 0xbaba9898; break;
      case 3: expected = 0xfefedcdc; break;
      }
    } else {
      if(r%2) expected = 0xffffffff;
    }

    CHECK (test_config.getABCRegister(ABCStarRegister::TrimDAC0 + r, abc_id) == expected);
  }

  //  test_config.setTrimDAC();
  // void setTrimDAC(unsigned col, unsigned row, int value);
  // int getTrimDAC(unsigned col, unsigned row);
}
