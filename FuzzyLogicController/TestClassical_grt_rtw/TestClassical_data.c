/*
 * TestClassical_data.c
 *
 * Code generation for model "TestClassical".
 *
 * Model version              : 1.10
 * Simulink Coder version : 8.14 (R2018a) 06-Feb-2018
 * C source code generated on : Thu Aug  4 13:49:30 2022
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "TestClassical.h"
#include "TestClassical_private.h"

/* Block parameters (default storage) */
P_TestClassical_T TestClassical_P = {
  /* Mask Parameter: PIDController_I
   * Referenced by: '<S1>/Integral Gain'
   */
  8.0,

  /* Mask Parameter: PIDController_P
   * Referenced by: '<S1>/Proportional Gain'
   */
  0.6,

  /* Computed Parameter: TransferFcn_A
   * Referenced by: '<Root>/Transfer Fcn'
   */
  -12.064,

  /* Computed Parameter: TransferFcn_C
   * Referenced by: '<Root>/Transfer Fcn'
   */
  18.69,

  /* Expression: 150
   * Referenced by: '<Root>/Pulse Generator'
   */
  150.0,

  /* Computed Parameter: PulseGenerator_Period
   * Referenced by: '<Root>/Pulse Generator'
   */
  10.0,

  /* Computed Parameter: PulseGenerator_Duty
   * Referenced by: '<Root>/Pulse Generator'
   */
  1.0,

  /* Expression: 0
   * Referenced by: '<Root>/Pulse Generator'
   */
  0.0,

  /* Expression: InitialConditionForIntegrator
   * Referenced by: '<S1>/Integrator'
   */
  0.0,

  /* Computed Parameter: StateSpace_A
   * Referenced by: '<S2>/State Space'
   */
  -12.064,

  /* Computed Parameter: StateSpace_B
   * Referenced by: '<S2>/State Space'
   */
  1.0,

  /* Computed Parameter: StateSpace_C
   * Referenced by: '<S2>/State Space'
   */
  -1249.57312,

  /* Computed Parameter: StateSpace_D
   * Referenced by: '<S2>/State Space'
   */
  -2.92,

  /* Expression: X0
   * Referenced by: '<S2>/State Space'
   */
  0.00040013664826592943
};
