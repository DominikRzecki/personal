#ifndef DB_SPEEDMETER_HPP
#define DB_SPEEDMETER_HPP
#include <time.h>
#include <iostream>

#ifdef DEBUG
	#define SM_START clock_t dbg_start_c = clock();
	#define SM_END clock_t dbg_end_c = clock();
	#define SM_TIME ((float)(dbg_end_c - dbg_start_c)/(float)CLOCKS_PER_SEC)
	#define SM_CLOCKS (dbg_end_c - dbg_start_c)
  #define SM_LOG std::clog<<"speedmeter: "<<__FUNCTION__<<":"<<__LINE__<<": time:"<<(float)(dbg_end_c - dbg_start_c)/CLOCKS_PER_SEC<<" cycles:"<<dbg_end_c - dbg_start_c<<"\n";
  #undef DEBUG_LINE
#else
	#define SM_START
	#define SM_END
	#define SM_TIME
	#define SM_CLOCKS
  #define SM_LOG
#endif
#endif
