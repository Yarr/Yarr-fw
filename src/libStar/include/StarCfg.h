#ifndef STAR_CFG_INCLUDE
#define STAR_CFG_INCLUDE

// #################################
// # Project:
// # Description: StarChips Library
// # Comment: Star configuration class
// ################################

#include <algorithm>
#include <cmath>
#include <functional>
#include <tuple>
#include <iostream>

#include "FrontEnd.h"

#include "AbcCfg.h"
#include "HccCfg.h"

/// Represents configuration for one particular Star front-end (HCC + ABCs)
class StarCfg : public FrontEndCfg {
 public:
  StarCfg();
  ~StarCfg();

  //Function to make all Registers for the ABC
  void configure_ABC_Registers(int chipID);

  //Accessor functions
  const uint32_t getHCCRegister(HCCStarRegister addr);
  void     setHCCRegister(HCCStarRegister addr, uint32_t val);
  const uint32_t getABCRegister(ABCStarRegister addr, int32_t chipID );
  void     setABCRegister(ABCStarRegister addr, uint32_t val, int32_t chipID);
  // Overload with integer register address
  inline const uint32_t getHCCRegister(uint32_t addr) {
    return getHCCRegister(HCCStarRegister::_from_integral(addr));
  }
  inline void setHCCRegister(uint32_t addr, uint32_t val) {
    setHCCRegister(HCCStarRegister::_from_integral(addr), val);
  }
  inline const uint32_t getABCRegister(uint32_t addr, int32_t chipID ) {
    return getABCRegister(ABCStarRegister(ABCStarRegs::_from_integral(addr)), chipID);
  }
  inline void setABCRegister(uint32_t addr, uint32_t val, int32_t chipID) {
    setABCRegister(ABCStarRegister(ABCStarRegs::_from_integral(addr)), val, chipID);
  }

  unsigned int getHCCchipID(){ return m_hcc.getHCCchipID(); }
  void setHCCChipId(unsigned hccID){ m_hcc.setHCCChipId(hccID); }

  const unsigned int getABCchipID(unsigned int chipIndex) { return abcFromIndex(chipIndex).getABCchipID(); }

  void addABCchipID(unsigned int chipID) {
    m_ABCchips.push_back({});
    m_ABCchips.back().setABCChipId(chipID);
  }

  void clearABCchipIDs() { m_ABCchips.clear(); }

  void setSubRegisterValue(int chipIndex, std::string subRegName, uint32_t value) {
    if (!chipIndex && HCCStarSubRegister::_is_valid(subRegName.c_str())) { //If HCC, looking name
      return m_hcc.setSubRegisterValue(subRegName, value);
    } else if (chipIndex && ABCStarSubRegister::_is_valid(subRegName.c_str())) { //If looking for an ABC subregister enum
      return abcFromIndex(chipIndex).setSubRegisterValue(subRegName, value);
    }else {
      std::cerr << " --> Error: Could not find register \""<< subRegName << "\"" << std::endl;
    }
  }


  uint32_t getSubRegisterValue(int chipIndex, std::string subRegName) {
    if (!chipIndex && HCCStarSubRegister::_is_valid(subRegName.c_str())) { //If HCC, looking name
      return m_hcc.getSubRegisterValue(subRegName);
    } else if (chipIndex && ABCStarSubRegister::_is_valid(subRegName.c_str())) { //If looking for an ABC subregister enum
      return abcFromIndex(chipIndex).getSubRegisterValue(subRegName);
    }else {
      std::cerr << " --> Error: Could not find register \""<< subRegName << "\"" << std::endl;
    }
    return 0;
  }

  int getSubRegisterParentAddr(int chipIndex, std::string subRegName) {
    if (!chipIndex && HCCStarSubRegister::_is_valid(subRegName.c_str())) { //If HCC, looking name
      return m_hcc.getSubRegisterParentAddr(subRegName);
    } else if (chipIndex && ABCStarSubRegister::_is_valid(subRegName.c_str())) { //If looking for an ABC subregister enum
      return AbcStarRegInfo::instance()->getSubRegisterParentAddr(subRegName);
    }else {
      std::cerr << " --> Error: Could not find register \""<< subRegName << "\"" << std::endl;
    }
    return 0;
  }


  uint32_t getSubRegisterParentValue(int chipIndex, std::string subRegName) {
    if (!chipIndex && HCCStarSubRegister::_is_valid(subRegName.c_str())) { //If HCC, looking name
      return m_hcc.getSubRegisterParentValue(subRegName);
    } else if (chipIndex && ABCStarSubRegister::_is_valid(subRegName.c_str())) { //If looking for an ABC subregister enum
      return abcFromIndex(chipIndex).getSubRegisterParentValue(subRegName);
    }else {
      std::cerr << " --> Error: Could not find register \""<< subRegName << "\"" << std::endl;
    }
    return 0;
  }

  /**
   * Obtain the corresponding charge [e] from the input VCal
   */
  double toCharge(double vcal) override;

  /**
   * Obtain the corresponding charge [e] from the input VCal, small&large capacitances(?)
   * Not fully implmented yet.
   */
  double toCharge(double vcal, bool sCap, bool lCap) override;

  /// Set trim DAC based on col/row in histogram
  void setTrimDAC(unsigned col, unsigned row, int value);

  /// Get trim DAC based on col/row in histogram
  int getTrimDAC(unsigned col, unsigned row) const;


  void toFileJson(json &j) override;
  void fromFileJson(json &j) override;

  using configFuncMap = std::unordered_map<std::string, void(StarCfg::*)(const std::string&)>;
  static configFuncMap createConfigs;

  void createExampleConfig(const std::string& outputDir, const std::string& systemType) override;

  size_t numABCs() { return m_ABCchips.size(); }

  /// Iterate over ABCs, avoiding chipIndex
  void eachAbc(std::function<void (AbcCfg&)> f) {
    for(auto &abc: m_ABCchips) {
      f(abc);
    }
  }

  HccCfg &hcc() { return m_hcc; }

  int hccChannelForABCchipID(unsigned int chipID);

 protected:
  AbcCfg &abcFromChipID(unsigned int chipID) {
    return *std::find_if(m_ABCchips.begin(), m_ABCchips.end(),
                        [this, chipID](auto &it) { return it.getABCchipID() == chipID; });
  }

  uint32_t m_sn=0;//serial number set by eFuse bits

  HccCfg m_hcc;

  std::vector<AbcCfg> m_ABCchips;

  AbcCfg &abcFromIndex(int chipIndex) {
    assert(chipIndex > 0);
    assert(chipIndex <= m_ABCchips.size());
    return m_ABCchips[chipIndex-1];
  }

  const AbcCfg &abcFromIndex(int chipIndex) const {
    assert(chipIndex > 0);
    assert(chipIndex <= m_ABCchips.size());
    return m_ABCchips.at(chipIndex-1);
  }

  void createConfigSingleFE(const std::string& outputDir);
  void createConfigLSStave(const std::string& outputDir);
  void createConfigPetal(const std::string& outputDir);
};

#endif
