#ifndef DEBUG_HPP
#define DEBUG_HPP
#define DEBUG true
#include <iostream>

#if DEBUG==true
  #define DB_LOG(x) std::clog<<"debug: "<<__FILE__<<":"<<__FUNCTION__<<":"<<__LINE__<<"# "<<x<<"\n";
  #undef DEBUG_LINE
#else
  #define DB_LOG(x)
#endif
#endif
