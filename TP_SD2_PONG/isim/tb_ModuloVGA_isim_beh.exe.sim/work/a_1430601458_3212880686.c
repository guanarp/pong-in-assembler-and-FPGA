/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Xilinx/ProyectosVarios/TP_SD2_NaveEspacial/Controlador_salida.vhd";



static void work_a_1430601458_3212880686_p_0(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    unsigned char t8;
    unsigned char t9;
    char *t10;
    int t11;
    unsigned char t12;
    char *t13;
    int t14;
    unsigned char t15;
    unsigned char t16;
    char *t17;
    int t18;
    unsigned char t19;
    char *t20;
    int t21;
    unsigned char t22;
    unsigned char t23;
    char *t24;
    int t25;
    unsigned char t26;
    char *t27;
    int t28;
    unsigned char t29;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;
    int t36;
    int t37;

LAB0:    xsi_set_current_line(44, ng0);
    t2 = (t0 + 992U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4128);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(46, ng0);
    t4 = (t0 + 1192U);
    t10 = *((char **)t4);
    t11 = *((int *)t10);
    t12 = (t11 > 143);
    if (t12 == 1)
        goto LAB14;

LAB15:    t9 = (unsigned char)0;

LAB16:    if (t9 == 1)
        goto LAB11;

LAB12:    t8 = (unsigned char)0;

LAB13:    if (t8 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(57, ng0);
    t2 = (t0 + 7240);
    t5 = (t0 + 4240);
    t10 = (t5 + 56U);
    t13 = *((char **)t10);
    t17 = (t13 + 56U);
    t20 = *((char **)t17);
    memcpy(t20, t2, 8U);
    xsi_driver_first_trans_fast(t5);

LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1032U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(47, ng0);
    t4 = (t0 + 1192U);
    t24 = *((char **)t4);
    t25 = *((int *)t24);
    t26 = (t25 < 224);
    if (t26 == 1)
        goto LAB23;

LAB24:    t4 = (t0 + 1192U);
    t27 = *((char **)t4);
    t28 = *((int *)t27);
    t29 = (t28 > 703);
    t23 = t29;

LAB25:    if (t23 != 0)
        goto LAB20;

LAB22:    xsi_set_current_line(50, ng0);
    t2 = (t0 + 1672U);
    t4 = *((char **)t2);
    t2 = (t0 + 4240);
    t5 = (t2 + 56U);
    t10 = *((char **)t5);
    t13 = (t10 + 56U);
    t17 = *((char **)t13);
    memcpy(t17, t4, 8U);
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(54, ng0);
    t2 = (t0 + 1192U);
    t4 = *((char **)t2);
    t11 = *((int *)t4);
    t14 = (t11 - 223);
    t18 = (t14 / 15);
    t2 = (t0 + 1352U);
    t5 = *((char **)t2);
    t21 = *((int *)t5);
    t25 = (t21 - 34);
    t28 = (t25 / 15);
    t36 = (t28 * 32);
    t37 = (t18 + t36);
    t2 = (t0 + 4304);
    t10 = (t2 + 56U);
    t13 = *((char **)t10);
    t17 = (t13 + 56U);
    t20 = *((char **)t17);
    *((int *)t20) = t37;
    xsi_driver_first_trans_fast(t2);

LAB21:    goto LAB9;

LAB11:    t4 = (t0 + 1352U);
    t17 = *((char **)t4);
    t18 = *((int *)t17);
    t19 = (t18 > 34);
    if (t19 == 1)
        goto LAB17;

LAB18:    t16 = (unsigned char)0;

LAB19:    t8 = t16;
    goto LAB13;

LAB14:    t4 = (t0 + 1192U);
    t13 = *((char **)t4);
    t14 = *((int *)t13);
    t15 = (t14 < 784);
    t9 = t15;
    goto LAB16;

LAB17:    t4 = (t0 + 1352U);
    t20 = *((char **)t4);
    t21 = *((int *)t20);
    t22 = (t21 < 515);
    t16 = t22;
    goto LAB19;

LAB20:    xsi_set_current_line(48, ng0);
    t4 = (t0 + 7232);
    t31 = (t0 + 4240);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    t34 = (t33 + 56U);
    t35 = *((char **)t34);
    memcpy(t35, t4, 8U);
    xsi_driver_first_trans_fast(t31);
    goto LAB21;

LAB23:    t23 = (unsigned char)1;
    goto LAB25;

}

static void work_a_1430601458_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(62, ng0);

LAB3:    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t3 = *((int *)t2);
    t1 = (t0 + 4368);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((int *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 4144);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1430601458_3212880686_p_2(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(63, ng0);

LAB3:    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t1 = (t0 + 4432);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 8U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 4160);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_1430601458_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1430601458_3212880686_p_0,(void *)work_a_1430601458_3212880686_p_1,(void *)work_a_1430601458_3212880686_p_2};
	xsi_register_didat("work_a_1430601458_3212880686", "isim/tb_ModuloVGA_isim_beh.exe.sim/work/a_1430601458_3212880686.didat");
	xsi_register_executes(pe);
}
