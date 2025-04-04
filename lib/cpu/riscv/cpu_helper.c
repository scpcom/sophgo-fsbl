#include <mmio.h>
#include <debug.h>
#include <assert.h>
#include <bl_common.h>
#include <platform.h>
#include <cpu.h>
#include "csr.h"

#include <arch_helpers.h>

void sync_cache(void)
{
	asm volatile(
#ifdef TOOLCHAIN_NEED_XTHEADCMO1P0_XTHEADSYNC1P0
			"th.icache.iall\n"
			"th.sync.i\n"
#else
			"icache.iall\n"
			"sync.i\n"
#endif
			:
			:
			: "memory");
}

void cpu_report_exception(unsigned int exception_type)
{
}

void enable_cache(struct cache_map *map)
{
}
