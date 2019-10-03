#ifndef STAR_CHIPS_HEADER_
#define STAR_CHIPS_HEADER_

// #################################
// # Project:
// # Description: StarChips Library
// # Comment: StarChips FrontEnd class
// ################################

#include <string>

#include "FrontEnd.h"

class TxCore;
class RxCore;

#include "StarCmd.h"
#include "StarCfg.h"

class StarChips : public StarCfg, public StarCmd, public FrontEnd {
 public:
  StarChips();
  StarChips(HwController *arg_core);
  StarChips(HwController *arg_core, unsigned arg_channel);
  StarChips(HwController *arg_core, unsigned arg_txchannel, unsigned arg_rxchannel);

  ~StarChips() {}

    void init(HwController *arg_core, unsigned arg_txChannel, unsigned arg_rxChannel) override;

  void writeNamedRegister(std::string name, uint16_t value) override;

  // Pixel specific?
  void setInjCharge(double, bool, bool) override {}
  void maskPixel(unsigned col, unsigned row) override {}

    //! configure
    //! brief configure the chip (virtual)
    void configure() override final;

    //! toFileJson
    //! brief write configuration to json (virtual)
    //! param reference to json
    void toFileJson(json&) override;

    //! fromFileJson
    //! brief read configuration from json (virtual)
    //! param reference to json
    void fromFileJson(json&) override;

  void makeGlobal() override final {
    m_hccID = 15;
  }

  void reset();
  void sendCmd(std::array<uint16_t, 9> cmd);
  void sendCmd(uint16_t cmd);

  bool writeRegisters();
  const void readRegisters();

  void setAndWriteHCCRegister(int addr, int64_t  value=-1){
    if(value>0){
      std::cout << value << std::endl;
      registerMap[0][addr]->setValue((uint32_t) value);
    }
    if(m_debug)  std::cout << "Doing HCC setAndWriteRegister with value 0x" << std::hex << std::setfill('0') << std::setw(8) << registerMap[0][addr]->getValue() <<std::dec  << " from registerMap[chipIndex=" << 0 << "][addr=" << addr << "]@" << registerMap[0][addr] << std::endl;
    sendCmd(write_hcc_register(addr, registerMap[0][addr]->getValue(), getHCCchipID()));
  }
  void setAndWriteABCRegister(int addr, int64_t  value=-1, int32_t chipIndex = 1){
    //unsigned int chipIndex = indexForABCchipID(chipID);
    if(value>0){
      std::cout << value << std::endl;
      registerMap[chipIndex][addr]->setValue((uint32_t) value);
    }
    if(m_debug)  std::cout << "Doing ABC " << chipIndex << " setAndWriteRegister with value 0x" << std::hex << std::setfill('0') << std::setw(8) << registerMap[chipIndex][addr]->getValue() <<std::dec  << std::endl;
    sendCmd(write_abc_register(addr, registerMap[chipIndex][addr]->getValue(), getHCCchipID(), m_ABCchipIDs[chipIndex-1]));

  }


  const void readHCCRegister(int addr){
    sendCmd(read_hcc_register(addr, getHCCchipID()));
  }
  const void readABCRegister(int addr, int32_t chipID = 0){
    sendCmd(read_abc_register(addr, getHCCchipID(), chipID));
  }


  void setAndWriteHCCSubRegister(std::string subRegName, uint32_t value){
    setSubRegisterValue(0, subRegName,value);
    sendCmd( write_hcc_register(getSubRegisterParentAddr(0, subRegName), getSubRegisterParentValue(0, subRegName), getHCCchipID()) );
  }
  const void readHCCSubRegister(std::string subRegName){
    sendCmd(read_hcc_register(getSubRegisterParentAddr(0, subRegName), getHCCchipID()));
  }

  void setAndWriteABCSubRegister(std::string subRegName, uint32_t value, int32_t chipID){
    unsigned int chipIndex = indexForABCchipID(chipID);
    setSubRegisterValue(chipIndex, subRegName,value);
    sendCmd( write_abc_register(getSubRegisterParentAddr(chipIndex, subRegName), getSubRegisterParentValue(chipIndex, subRegName), getHCCchipID(), chipID) );

  }
  const void readABCSubRegister(std::string subRegName, int32_t chipID){
    unsigned int chipIndex = indexForABCchipID(chipID);
    sendCmd(read_abc_register(getSubRegisterParentAddr(chipIndex, subRegName), 0xf, chipID));
  }


  const int getNumberOfAssociatedABC(){return m_nABC;}


  private:
    TxCore * m_txcore;
};

#endif
