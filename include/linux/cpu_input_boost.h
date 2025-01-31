/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Copyright (C) 2018-2019 Sultan Alsawaf <sultan@kerneltoast.com>.
 */
#ifndef _CPU_INPUT_BOOST_H_
#define _CPU_INPUT_BOOST_H_

#ifdef CONFIG_CPU_INPUT_BOOST
#if(CONFIG_INPUT_BOOST_DURATION_MS != 0)
extern unsigned long last_input_time;
#endif

void cpu_input_boost_kick(void);
void cpu_input_boost_kick_max(unsigned int duration_ms, bool always);
#else
static inline void cpu_input_boost_kick(void)
{
}
static inline void cpu_input_boost_kick_max(unsigned int duration_ms, bool always)
{
}
#endif

#endif /* _CPU_INPUT_BOOST_H_ */
